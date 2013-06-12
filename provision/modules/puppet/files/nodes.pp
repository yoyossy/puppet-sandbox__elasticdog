#
# nodes.pp - defines all puppet nodes
#

# self-manage the puppet master server

node 'puppet' { }

##### CLIENTS

node 'client1' {
  class { 'helloworld': }
network::if::static { 'eth2':
  ensure       => 'up',
  ipaddress    => '10.53.213.11',
  netmask      => '255.255.255.0',
#  gateway      => '10.53.213.254',
#  macaddress   => '08:00:27:FC:7E:E0',
#  mtu          => '1500',
#  ethtool_opts => 'speed 1000 duplex full autoneg off',
}
package { ['lftp', 'createrepo','rsync','pyOpenSSL',
# 'rhn-client-tools',
'mrepo'
]:
    ensure  => present,
  }

}
##############################################
node 'client2' { 
  class { 'helloworld': }
network::if::static { 'eth2':
  ensure       => 'up',
  ipaddress    => '10.53.213.12',
  netmask      => '255.255.255.0',
#  gateway      => '10.53.213.254',
#  macaddress   => '08:00:27:FC:7E:E0',
#  mtu          => '1500',
#  ethtool_opts => 'speed 1000 duplex full autoneg off',
}

package { ['lftp', 'createrepo','rsync','pyOpenSSL',
# 'rhn-client-tools',
'mrepo'
]:
    ensure  => present,
  }
}
##########################################
node 'idea' {
 class { 'net_share':  }
 class { 'wintest': }
 class { 'win_desktop_shortcut': }
}
node 'asusxs' {
  class { 'wintest': }
}
##########################################
node 'asusxsmaison' {
  class { 'wintest': }
}
##########################################
node 'vento' {
#exec { 'yum update':
#        path=>'/usr/bin/'
#}

  class { 'helloworld': }
  class { 'networking': }

  network::if::static { 'eth1':
  ensure       => 'up',
  ipaddress    => '192.168.0.110',
  netmask      => '255.255.255.0',
  gateway      => '192.168.0.254',
#  macaddress   => '08:00:27:FC:7E:E0',
#  mtu          => '1500',
#  ethtool_opts => 'speed 1000 duplex full autoneg off',
}
  network::if::static { 'eth2':
  ensure       => 'up',
  ipaddress    => '10.53.213.110',
  netmask      => '255.255.255.0',
#  gateway      => '10.53.213.254',
#  macaddress   => '08:00:27:FC:7E:E0',
#  mtu          => '1500',
#  ethtool_opts => 'speed 1000 duplex full autoneg off',
}

sysctl { "net.ipv4.ip_forward":
    ensure  => present,
    value   => "1",
    comment => "net.ipv4.ip_forward 1", 
  }
 resources { "firewall":
    purge => true
  }

  firewall {
    '000 accept all icmp ' :
      proto => 'icmp',
      action => 'accept';

    '001 accept inbound ssh ' :
      proto => 'tcp',
      port => 22,
      action => 'accept';

    '002 accept local traffic' :
    # traffic within localhost is OK
      iniface => 'lo',
      action => 'accept';

    '003 allow established connections':
      proto   => 'all',
      # this is needed to make outbound connections work, such as database connection
      state => ['RELATED','ESTABLISHED'],
      action => 'accept';

    '100 accept inbound http' :
      proto => 'tcp',
      port => 80,
      action => 'accept';

    '101 accept inbound https ' :
      proto => 'tcp',
      port => 443,
      action => 'accept';

    '200 accept inbound ftp ' :
      proto => 'tcp',
      port => 21,
      action => 'accept';

 }    

include user-lio


  class { 'vsftpd':
  anonymous_enable  => 'NO',
  local_enable            => 'YES',
  write_enable      => 'YES',
  ftpd_banner       => 'Vento FTP Server',
  chroot_local_user => 'NO',
  chroot_list_enable      => 'NO',
  anon_upload_enable => 'YES',
  anon_mkdir_write_enable => 'YES',
#  local_umask => '077',
}
exec { 'setsebool -P ftp_home_dir on':
        path=>'/usr/sbin/'
}
class { 'selinux':
  mode => 'enforcing'
}

exec { 'rpm -Uvh --replacepkgs http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm':
        path=>'/bin/'
}
exec { 'yum -y update':
        path=>'/usr/bin/'
}

package { 'fuse':
        provider=>'yum',
        ensure=>'installed'
}
package { 'ntfs-3g':
        provider=>'yum',
        ensure=>'installed'
}


}
#############################
node 'dv7' {
  class { 'helloworld': }
  class { 'networking': }

  network::if::static { 'eth0':
  ensure       => 'up',
  ipaddress    => '10.53.213.111',
  netmask      => '255.255.255.0',
  gateway      => '10.53.213.254',
#  macaddress   => '08:00:27:FC:7E:E0',
#  mtu          => '1500',
#  ethtool_opts => 'speed 1000 duplex full autoneg off',
}

sysctl { "net.ipv4.ip_forward":
    ensure  => present,
    value   => "1",
    comment => "net.ipv4.ip_forward 1", 
  }
 resources { "firewall":
    purge => true
  }

  firewall {
    '000 accept all icmp ' :
      proto => 'icmp',
      action => 'accept';

    '001 accept inbound ssh ' :
      proto => 'tcp',
      port => 22,
      action => 'accept';

    '002 accept local traffic' :
    # traffic within localhost is OK
      iniface => 'lo',
      action => 'accept';

    '003 allow established connections':
      proto   => 'all',
      # this is needed to make outbound connections work, such as database connection
      state => ['RELATED','ESTABLISHED'],
      action => 'accept';

    '100 accept inbound http' :
      proto => 'tcp',
      port => 80,
      action => 'accept';

    '101 accept inbound https ' :
      proto => 'tcp',
      port => 443,
      action => 'accept';

    '200 accept inbound ftp ' :
      proto => 'tcp',
      port => 21,
      action => 'accept';

 }     
  class { 'vsftpd':
  anonymous_enable  => 'NO',
  local_enable            => 'YES',
  write_enable      => 'YES',
  ftpd_banner       => 'Marmotte FTP Server',
  chroot_local_user => 'NO',
  chroot_list_enable      => 'NO',
  anon_upload_enable => 'YES',
  anon_mkdir_write_enable => 'YES',
  local_umask => '077',
}
}


##################################
node 'centos64vb' {
  class { 'helloworld': }
  class { 'networking': }

  network::if::static { 'eth2':
  ensure       => 'up',
  ipaddress    => '10.53.213.210',
  netmask      => '255.255.255.0',
  gateway      => '10.53.213.254',
#  macaddress   => '08:00:27:FC:7E:E0',
#  mtu          => '1500',
#  ethtool_opts => 'speed 1000 duplex full autoneg off',
}

sysctl { "net.ipv4.ip_forward":
    ensure  => present,
    value   => "1",
    comment => "net.ipv4.ip_forward 1",
  }




  }