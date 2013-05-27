# simple apache based web server with php and mysql

include augeasproviders
include sysctl
include java
include jenkins
include users-core

# defaults
Exec        { path => '/usr/sbin:/sbin:/bin:/usr/bin' }
Sshd_config { notify => Service[ 'sshd' ] }
User        { managehome => true }

$packages = [ 'httpd', 'mysql-server', 'php', 'php-mysql', 'php-pear',
              'xorg-x11-xauth',
              'xorg-x11-fonts-misc',
              'xorg-x11-fonts-Type1',   
              'vim-X11','git',
              'gstreamer','gstreamer-plugins-good'  ]

package { $packages:
    ensure => installed,
}

file { '/etc/profile.d/aliases.sh':
    owner  => 'root', group => 'root', mode => '0644',
    source => 'puppet:///modules/configs/aliases.sh',
    tag    => 'setup',
}

firewall {
    '000 accept all icmp requests' :
      proto => 'icmp',
      action => 'accept';

    '001 accept inbound ssh requests' :
      proto => 'tcp',
      port => 22,
      action => 'accept';


    '002 accept local traffic' :
# traffic within localhost is OK
      iniface => 'lo',
      action => 'accept';

    '003 allow established connections':
# this is needed to make outbound connections work, such as database connection
      state => ['RELATED','ESTABLISHED'],
      action => 'accept';

    '100 accept inbound http requests' :
      proto => 'tcp',
      port => 80,
      action => 'accept';

    '101 accept inbound https requests' :
      proto => 'tcp',
      port => 443,
      action => 'accept';

    '102 accept inbound jenkins requests' :
      proto => 'tcp',
      port => 8080,
      action => 'accept';

    '103 accept inbound gunicorn requests' :
      proto => 'tcp',
      port => 8000,
      action => 'accept';

    '104 accept inbound flask requests' :
      proto => 'tcp',
      port => 5000,
      action => 'accept';

  }

service { 'sshd':
    ensure => 'running',
    enable => 'true',
}

service { 'httpd':
    ensure  => 'running',
    enable  => true,
    require => Package[ [ 'httpd', 'php' ] ],
}


# sshd config
#
sshd_config { 'LoginGraceTime':
    value  => '30s',
}

sshd_config { 'AllowTcpForwarding':
    value => 'yes',
}

sshd_config { 'PermitRootLogin':
    value  => 'yes',
}

sshd_config { 'AllowUsers':
    value  => [ 'root', 'vagrant' ],
}

sshd_config { 'MaxAuthTries':
    value  => '3',
}

sshd_config { 'PasswordAuthentication':
    value  => 'yes',
}

# Setup sudo
file { 'sudo_wheel':
    tag     => 'setup',
    path    => '/etc/sudoers.d/99_wheel',
    owner   => 'root', group => 'root', mode => '0440',
    content => "%wheel ALL = (ALL) ALL\n",
}

augeas { 'sudo_include_dir':
    tag     => 'setup',
    context => '/files/etc/sudoers',
    changes => 'set #includedir "/etc/sudoers.d"',
}

# make 'service httpd ...' work properly
file { '/etc/sysconfig/httpd':
    owner   => 'root', group => 'root', mode => '0644',
    content => "PIDFILE=/var/run/httpd/httpd.pid\nDAEMON_COREFILE_LIMIT=unlimited\n",
    require => Package[ 'httpd' ],
}

# exec {
#    "some-exec" :
#        require => Class["jenkins::package"],
#        command => "echo JENKINS"
# }

class { "python::dev":
      #    version => "26" 
      }

class { "python::venv": 
  owner => "vagrant", 
#  group => "www-mgr" 
#    version => "26" 
  }

python::venv::isolate { "/usr/local/venv/example1": 
requirements => "/vagrant/example1/requirements.txt",
}
