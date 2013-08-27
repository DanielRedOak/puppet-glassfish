class {glassfish:
  target      => '/u01/glassfish',
  provider    => 'custom',
  installfile => '/tmp/glassfish-3.1.2.2-unix.sh',
  domain      => 'test_domain1',
  adminuser   => 'admin',
  adminpass   => 'helloworld',
  adminport   => '4848',
  httpport    => '8080',
  jdk         => '/u01/java',
}
