$ar_databases = ['activerecord_unittest', 'activerecord_unittest2']

# Make sure apt-get -y update runs before anything else.
stage { 'preinstall':
  before => Stage['main']
}

class apt_get_update {
  exec { '/usr/bin/apt-get -y update':
    user => 'root'
  }
}
class { 'apt_get_update':
  stage => preinstall
}

class install_sqlite3 {
  package { 'sqlite3':
    ensure => installed;
  }

  package { 'libsqlite3-dev':
    ensure => installed;
  }
}
class { 'install_sqlite3': }

class install_mysql {
  class { 'mysql': }

  class { 'mysql::server':
    config_hash => { 'root_password' => '' }
  }

  database { $ar_databases:
    ensure  => present,
    charset => 'utf8',
    require => Class['mysql::server'] 
  }

  database_user { 'rails@localhost':
    ensure  => present,
    require => Class['mysql::server'] 
  }

  database_grant { ['rails@localhost/activerecord_unittest', 'rails@localhost/activerecord_unittest2']:
    privileges => ['all'],
    require    => Database_user['rails@localhost']
  }

  package { 'libmysqlclient15-dev':
    ensure => installed
  }
}
class { 'install_mysql': }

class install_postgres {
  class { 'postgresql': }

  class { 'postgresql::server': }

  pg_database { $ar_databases:
    ensure   => present,
    encoding => 'UTF8',
    require  => Class['postgresql::server']
  }

  pg_user { 'rails':
    ensure  => present,
    require => Class['postgresql::server'] 
  }

  pg_user { 'vagrant':
    ensure    => present,
    superuser => true,
    require   => Class['postgresql::server']
  }

  package { 'libpq-dev':
    ensure => installed
  }
}
class { 'install_postgres': }

class install_core_packages {
  if !defined(Package['build-essential']) {
    package { 'build-essential':
      ensure => installed
    }
  }

  if !defined(Package['git-core']) {
    package { 'git-core':
      ensure => installed
    }
  }
}
class { 'install_core_packages': }

class install_ruby {
  package { 'ruby1.9.3':
    ensure => installed
  }

  exec { '/usr/bin/gem install bundler --no-rdoc --no-ri':
    unless  => '/usr/bin/gem list | grep bundler',
    user    => 'root',
    require => Package['ruby1.9.3']
  }
}
class { 'install_ruby': }

class install_nokogiri_dependencies {
  package { ['libxml2', 'libxml2-dev', 'libxslt1-dev']:
    ensure => installed
  }
}
class { 'install_nokogiri_dependencies': }

class install_execjs_runtime {
  package { 'nodejs':
    ensure => installed
  }
}
class { 'install_execjs_runtime': }

class { 'memcached': }
#class { 'puppet': }
#class { 'networking': }
#class { 'puppet::server': }



openvpn::server {
    "server1":
        country      => "CH",
        province     => "ZH",
        city         => "Winterthur",
        organization => "example.org",
        email        => "root@example.org";
}

# configure server
openvpn::option {
    "dev server1":
        key    => "dev",
        value  => "tun0",
        server => "server1";
    "script-security server1":
        key    => "script-security",
        value  => "3",
        server => "server1";
    "daemon server1":
        key    => "daemon",
        server => "server1";
    "keepalive server1":
        key    => "keepalive",
        value  => "10 60",
        server => "server1";
    "ping-timer-rem server1":
        key    => "ping-timer-rem",
        server => "server1";
    "persist-tun server1":
        key    => "persist-tun",
        server => "server1";
    "persist-key server1":
        key    => "persist-key",
        server => "server1";
#    "proto server1":
#        key    => "proto",
#        value  => "tcp-server",
#        server => "server1";
    "cipher server1":
        key    => "cipher",
        value  => "BF-CBC",
        server => "server1";
    "local server1":
        key    => "local",
        value  => $ipaddress,
        server => "server1";
    "tls-server server1":
        key    => "tls-server",
        server => "server1";
    "server server1":
        key    => "server",
        value  => "10.10.10.0 255.255.255.0",
        server => "server1";
    "lport server1":
        key    => "lport",
        value  => "1194",
        server => "server1";
    "management server1":
        key    => "management",
        value  => "/var/run/openvpn-server1.sock unix",
        server => "server1";
#    "comp-lzo server1":
#        key    => "comp-lzo",
#        server => "server1";
    "topology server1":
        key    => "topology",
        value  => "subnet",
        server => "server1";
    "client-to-client server1":
        key    => "client-to-client",
        server => "server1";
}

# define clients
openvpn::client {
    [ "client1.example.org", "client2.example.org" ]:
        server      => "server1";
}

# add options to the client-config-dir file
openvpn::option {
    "iroute server1 client1.example.org home network":
        key    => "iroute",
        value  => "192.168.0.0 255.255.255.0",
        client => "client1.example.org",
        server => "server1",
        csc    => true;
}

# add an option to the client config
openvpn::option {
    "ifconfig server1 client2.example.org":
        key    => "ifconfig-push",
        value  => "10.10.10.2 255.255.255.0",
        client => "client2.example.org",
        server => "server1";
}
