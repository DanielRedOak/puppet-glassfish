puppet-glassfish
================

A puppet module for installing Glassfish, including support for clustering.

##Notes
This is the initial release of the Glassfish module.  Some flexibility is already built into the module, more will be added down the line. Ex. providers for the install only includes 'custom' at the moment.  In later releases, the installer might take in a version number and pull the official release from the web.  As always, contributions are welcome!

##Requirements
Java JDK is required to be installed prior to installing Glassfish using this module.
The user and group specified must exist.  

##Usage

Install Glassfish using a provided linux sh installer

    class {glassfish:
      target      => '/u01/glassfish',
      provider    => 'custom',
      installfile => '/tmp/glassfish-3.1.2.2-unix.sh',
      domain      => 'testDomain',
      adminuser   => 'admin',
      adminpass   => 'helloworld',
      adminport   => '4848',
      httpport    => '8080',
      jdk         => '/u01/java',
      user        => 'glassfish',
      group       => 'glassfish',
    }

Create the Glassfish DAS setup and create the cluster.  If multicast_ip and multicast_port are not specified, Glassfish will choose them for you.

    glassfish::cluster {'test_cluster':
      asadmin      => '/u01/glassfish/glassfish/bin/asadmin',
      is_das       => true,
      gfuser       => 'glassfish',
      cluster_name => 'testCluster',
      das_host     => 'localhost',
      das_port     => '4848',
      das_user     => 'admin',
      das_pass     => 'password',
}


Create local-instances on a node and add it to the cluster 'testCluster'.

    glassfish::cluster {'test_cluster':
      asadmin      => '/u01/glassfish/glassfish/bin/asadmin',
      instances    => ['instance1', 'instance2'],
      gfuser       => 'glassfish',
      cluster_name => 'testCluster',
      das_host     => '172.16.225.135',
      das_port     => '4848',
      das_user     => 'admin',
      das_pass     => 'helloworld',
      multicast_ip => '228.9.242.21',
      multicast_port => '27745',
}

