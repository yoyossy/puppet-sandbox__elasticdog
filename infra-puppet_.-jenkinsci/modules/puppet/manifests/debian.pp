class puppet::debian($ensure = 'installed') {
  include apt

  apt::source { 'puppetlabs':
    location   => 'https://apt.puppetlabs.com',
    repos      => 'main',
    key        => '4BD6EC30',
    key_server => 'pgp.mit.edu',
  }

  package {
    'puppet' :
      ensure  => $ensure,
      require => [
                  Package['puppet-common'],
                  Apt::Source[puppetlabs]];

    'puppet-common' :
      ensure => $ensure,
      require => Apt::Source[puppetlabs];
  }
}
