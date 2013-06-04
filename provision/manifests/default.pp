#
# site.pp - defines defaults for vagrant provisioning
#

# use run stages for minor vagrant environment fixes
stage { 'pre': before    => Stage['main'] }
class { 'mirrors': stage => 'pre' }
class { 'vagrant': stage => 'pre' }

class { 'puppet': }
class { 'networking': }
################################
if $::is_vagrant {
    $data_center = 'vagrant'
} else {
    $data_center = 'amazon'
}

include role::ui
#############################
if $hostname == 'puppet' {

  class { 'puppet::server': }

  # http://augeasproviders.com/documentation/examples.html#sysctl_provider
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

    '1001 accept puppet' :
      proto => 'tcp',
      port => 8140,
      action => 'accept';
  }
# https://forge.puppetlabs.com/razorsedge/network
network::if::static { 'eth2':
  ensure       => 'up',
  ipaddress    => '10.53.213.218',
  netmask      => '255.255.255.0',
  gateway      => '10.53.213.254',
#  macaddress   => '08:00:27:FC:7E:E0',
#  mtu          => '1500',
#  ethtool_opts => 'speed 1000 duplex full autoneg off',
}

}