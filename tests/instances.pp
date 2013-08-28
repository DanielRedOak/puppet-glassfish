glassfish::cluster {'test_cluster':
  asadmin      => '/u01/glassfish/glassfish/bin/asadmin',
  instances    => ['instance1', 'instance2'],
  gfuser       => 'glassfish',
  cluster_name => 'testCluster',
  das_host     => '172.16.225.135',
  das_port     => '4848',
  das_pass     => 'helloworld',
  multicast_ip => '228.9.242.21',
  multicast_port => '27745',
}
