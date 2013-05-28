#
# site.pp - defines defaults for vagrant provisioning
#

# use run stages for minor vagrant environment fixes
stage { 'pre': before    => Stage['main'] }
class { 'mirrors': stage => 'pre' }
class { 'vagrant': stage => 'pre' }

class { 'puppet': }
class { 'networking': }

if $hostname == 'puppet' {
  class { 'puppet::server': }

# http://augeasproviders.com/documentation/examples.html#sysctl_provider
sysctl { "net.ipv4.ip_forward":
  ensure  => present,
  value   => "1",
  comment => "test",
}

openvpn::server { 'winterthur':
    country      => "CH",
    province     => "ZH",
    city         => "Winterthur",
    organization => "example.org",
    email        => "root@example.org",
    
    server       => '10.200.200.0 255.255.255.0'
  }
# define clients
 openvpn::client { 'client1':
    server => 'winterthur'
  }
openvpn::client { 'client2':
   server   => 'winterthur'
  }

openvpn::client_specific_config { 'client1':
    server => 'winterthur',
    ifconfig => '10.200.200.50 255.255.255.0'
  }

  
}

