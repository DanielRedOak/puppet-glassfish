#This requires java 6 or 7.  The install will not choose packages for you but will fail without an installation.
#target - installation target
#installfile - location of the install sh file. 

class glassfish (
  $target = '/u01/glassfish',
  $provider,
  $installfile,
  $domain,
  $adminuser = 'admin',
  $adminpassword,
  $adminport = '4848',
  $httpport = '8080',
  $jdk,
  $nodes,
){

  #Install GF
  if ($provider == 'custom') {
    if $installfile == undef {
      fail('glassfish needs installfile argument when using custom provider')
    }
    #We are going to place a file out there to track the install w/o tracking the whole deal
    file {"${target}/.glassfish_install":
      ensure  => file,
      content => 'PUPPET MANAGED: Remove this file to initiate a puppet reinstall',
      mode    => '0644',
      replace => false,
    }
    file {'/tmp/silent.txt':
      content => template('glassfish/silent.txt.erb'),
    }
    exec {'install_glassfish':
      command     => "${installfile} -a /tmp/silent.txt -s",
      path        => '/bin/:/usr/bin/',
      subscribe   => File["/${target}/.glassfish_install"],
      refreshonly => true,
      logoutput   => true,
    }

}


    #
    #We need to m
  #Create domain
  #Start domain
  #Create node agent (on servers that host instances)
  #Start node agent
  #Create cluster
  #Create instances
  #Deploy apps to domain
  #Start cluster
