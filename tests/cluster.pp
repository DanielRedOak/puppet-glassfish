glassfish::cluster {'test_cluster':
  asadmin      => '/u01/glassfish/glassfish/bin/asadmin',
  instances    => ['instance1', 'instance2'],
  is_das       => true,
  gfuser       => 'glassfish',
  cluster_name => 'testCluster',
}

