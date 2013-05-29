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


}