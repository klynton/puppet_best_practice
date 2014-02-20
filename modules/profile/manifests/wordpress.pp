class profile::wordpress {

  $domain = hiera('profiles::wordpress::domain')
  $docroot = hiera('profiles::wordpress::docroot')
  
  host { $domain:
    ip => $::ipaddress,
  }

  #- Configuration of php-enabled webserver
  class { 'apache':
    mpm_module => 'prefork',
  }
  include apache::mod::php
  apache::vhost { $domain:
    port    => '80',
    docroot => $docroot,
  }
  #- Configuration MySQL server
  class { 'mysql::server':
    root_password => 'password',
  }
  #- PHP 5.3 or greater
  class { 'mysql::bindings':
    php_enable => 'true',
  }
  class { 'wordpress':
    install_dir => $docroot,
    }
}
