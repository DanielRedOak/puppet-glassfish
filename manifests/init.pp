#This requires java 6 or 7.  The install will not choose packages for you but will fail without an installation.
#target - installation target
#provider - currently the only available option is 'custom' which uses the .sh self-installer provided by $installfile
#installfile - absolute path of the install sh file.
#domain - the domain created at install time
#asminuser - username of the administrator
#adminpass - password of the adminuser
#httpport - http port
#jdk - absolute path to the jdk directory
#nodes - used in the future for adding an array of nodes to the cluster
#user - user that will own the install files.  Must already exist on the system
#group - group that will own the install files.  Must already exist on the system

class glassfish (
  $target = '/u01/glassfish',
  $provider,
  $installfile,
  $domain,
  $adminuser = 'admin',
  $adminpass,
  $adminport = '4848',
  $httpport = '8080',
  $jdk,
  $nodes,
  $user = 'glassfish',
  $group = 'glassfish',
){

  #Install GF
  if ($provider == 'custom') {
    if $installfile == undef {
      fail('glassfish needs installfile argument when using custom provider')
    }
    file {$target :
      ensure => directory,
    }
    file {'/tmp/silent.txt':
      content => template('glassfish/silent.txt.erb'),
    }
    exec {'install_glassfish':
      command     => "${installfile} -j ${jdk} -a /tmp/silent.txt -s",
      path        => '/bin/:/usr/bin/',
      creates     => "${target}/glassfish",
      require     => File['/tmp/silent.txt'],
      user        => $user,
      group       => $group,
      #refreshonly => true,
      logoutput   => true,
    }

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
