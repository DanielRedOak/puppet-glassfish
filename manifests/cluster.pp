#This defined type is used to create a cluster.  At present, a cluster name must be unique per puppet node it is applied to.  If this is not the case, resources will be declared twice with the same name and error.
#asadmin - path to asadmin
#cluster_name - name of the cluster
#instances - array of instances to create
#multicast_ip - IP that Group Management Service (GMS) listens on for events
#multicast_port - port that GMS listens on for events
#is_das - boolean: is this going to be the das server
#das_host - hostname or IP of the das server for this cluster
#das_port - port the das admin runs on for this cluster

define glassfish::cluster (
  $asadmin,
  $cluster_name = $name,
  $instances,
  $multicast_ip,
  $multicast_port,
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

  if($is_das){
    #Create the cluster
    #TODO Does this need to only be done on one node or all of them in the cluster? Nope
    exec {"create-cluster-${name}":
      command => "${asadmin} create-cluster --multicastaddress $multicase_ip --multicastport $multicast_port $clustername",
      user    => 'root',
    }

    exec {"create-services-${name}":
      require => Exec["create-cluster-${name}"],
      user    => 'root',
      command => "${asadmin}",
    }

  } else {
    
    file {"/tmp/cluster-${name}.gf":
      ensure   => file,
      template => ('clustermm.erb'),
    }

    exec {"create-local-instance-${name}":
      require => File['/tmp/cluster-${name}.gf'],
      command => "${asadmin} --host ${das_host} ${das_port} multimode --file /tmp/multimode.gf"
    }

    exec {"create-services-${name}":
      require => Exec["create-local-instance-${name}"],
      user    => 'root',
      command => "${asadmin}",
    }

  }
}


