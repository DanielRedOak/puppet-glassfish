glassfish::cluster {'test_cluster':
  gfbase         => '/u01/glassfish',
  gfdomain       => 'domain1',
  asadmin        => '/u01/glassfish/glassfish/bin/asadmin',
  instances      => ['instance1', 'instance2'],
  is_das         => true,
  gfuser         => 'glassfish',
  cluster_name   => 'testCluster',
  das_host       => 'localhost',
  das_port       => '4848',
  das_pass       => 'password',
  multicast_port => '1234',
  multicast_ip   => '123.456.789.000',
}

