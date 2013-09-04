#This requires java 6 or 7.  The install will not choose packages for you but will fail without an installation.
#target - installation target
#provider - currently the only available option is 'custom' which uses the .sh self-installer provided by $installfile
#installfile - absolute path of the install sh file.
#domain - the domain created at install time
#asminuser - username of the administrator
#adminpass - password of the adminuser
#httpport - http port
#jdk - absolute path to the jdk directory
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
  $user = 'glassfish',
  $group = 'glassfish',
  $secureadmin = true,
  $startdomain = true,
){

  $asadmin = "${target}/glassfish/bin/asadmin"

  Exec {
   provider  => 'shell',
   user      => $user,
   logoutput => true,
  }


  #Install GF
  if ($provider == 'custom') {
    if $installfile == undef {
      fail('glassfish needs installfile argument when using custom provider')
    }
    file {$target :
      ensure => directory,
      group  => $group,
      owner  => $user,
    }
    file {'/tmp/silent.txt':
      content => template('glassfish/silent.txt.erb'),
    }
    exec {'install_glassfish':
      command      => "${installfile} -j ${jdk} -a /tmp/silent.txt -s",
      path         => '/bin/:/usr/bin/',
      creates      => "${target}/glassfish",
      require      => [File['/tmp/silent.txt'], File[$target]],
      user         => $user,
      group        => $group,
      #refreshonly => true,
      logoutput    => true,
    }

    if ($startdomain) {
      #start the domain
      exec {"start-gfdomain":
        command     => "${asadmin} start-domain",
        require     => Exec['install_glassfish'],
        subscriber  => Exec['install_glassfish'],
        refreshonly => true,
        notify      => Exec["enable-secure-admin"],
      } 
    }
    if ($startdomain and $secureadmin) {
    #Enable secure admin
      exec {"enable-secure-admin":
       command     => "${asadmin} enable-secure-admin",
       require     => Exec["start-gfdomain"],
       refreshonly => true,
       notify      => Exec['restart-gfdomain'],
      }
      exec {"restart-gfdomain":
        command     => "${asadmin} restart-domain",
        require     => Exec['enable-secure-admin'],
        refreshonly => true,
      }
    } elsif ($secureadmin) {
      fail('the domain must be started to enable secure admin')
    } 

  } else {
    fail('you must specify a provider to install glassfish')
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
