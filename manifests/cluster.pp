#This defined type is used to create a cluster.  At present, a cluster name must be unique per puppet node it is applied to.  If this is not the case, resources will be declared twice with the same name and error.
#asadmin - path to asadmin
#gfuser - user that owns the glassfish install.  This user will also be used when the services are created.
#cluster_name - name of the cluster
#instances - array of instances to create
#multicast_ip - IP that Group Management Service (GMS) listens on for events
#multicast_port - port that GMS listens on for events
#is_das - boolean: is this going to be the das server
#das_host - hostname or IP of the das server for this cluster
#das_port - port the das admin runs on for this cluster

define glassfish::cluster (
  $asadmin,
  $gfuser = 'glassfish',
  $cluster_name = $name,
  $instances,
  $multicast_ip = ' ',
  $multicast_port = ' ',
  $is_das = false,
  $das_host,
  $das_port,
){
  
  #FLOW
  #Install GF on DAS host and nodes before this type is used

  #Is DAS?
   #Start domain
   #Enable secure admin
   #Restart domain
   #create cluster with options
  #Else
   #create-local-instance with existing cluster
   #start local instance (get services on these guys!)
   #use template to generate multimode scripts for asadmin...


  Exec {
    provider  => 'shell',
    user      => $gfuser,
    logoutput => true,
  }

  if($is_das){
    #Start the domain
    exec {"start-domain-${name}":
      command => "${asadmin} start-domain",
    }

    #Enable secure admin
    exec {"enable-secure-${name}":
      command => "${asadmin} enable-secure-admin",
      require => Exec["start-domain-${name}"],
    }

    if($multicast_ip and $multicast_port){
      $multicastcmd = "--multicastip ${multicast_ip} --multicastport ${multicast_port}"
    }else{
      $multicastcmd = ''
      notify{"Multicast settings not completely specified. Using default multicast settings.":}
    }
    #Create the cluster
    exec {"create-cluster-${name}":
      command => "${asadmin} create-cluster $multicastcmd $cluster_name",
      require => Exec["enable-secure-${name}"],
    }

    #Create the services in init.d
    exec {"create-services-${name}":
      require  => Exec["create-cluster-${name}"],
      user     => 'root',
      command  => "${asadmin} create-service --serviceuser ${gfuser}",
    }

  } else {

    #Multimode asadmin file to create the instances on this 'node'
    file {"/tmp/cluster-${name}.gf":
      ensure   => file,
      template => ('clustermm.erb'),
    }

    #Create the instances on this node using the generated template
    exec {"create-local-instance-${name}":
      require => File['/tmp/cluster-${name}.gf'],
      command => "sh ${asadmin} --host ${das_host} ${das_port} multimode --file /tmp/multimode.gf"
    }

    #Create the services for these instances
    exec {"create-services-${name}":
      require => Exec["create-local-instance-${name}"],
      user    => 'root',
      command => "sh ${asadmin} create-service --serviceuser ${gfuser}",
    }

  }
}


