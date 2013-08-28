#This is used for cluster administration

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
  $cluster_name,
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
    exec {"create-cluster-$name":
      command => "${asadmin} create-cluster --multicastaddress $multicase_ip --multicastport $multicast_port $clustername",
      user    => "admin",
    }
  } else {
    
    file {'/tmp/multimode.gf':
      ensure   => file,
      template => ('multimode.erb'),
    }

    exec {"create-local-instance":
      require => File['/tmp/multimode.gf'],
      command => "${asadmin} --host ${das_host} ${das_port} multimode --file /tmp/multimode.gf"
    }

    exec {"create-services":
      require => Exec["create-local-instance"],
      user    => 'root',
      command => "${asadmin}",
    }

  }
}


