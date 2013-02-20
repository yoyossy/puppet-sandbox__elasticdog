class sshd {
  class {
    'sshd::setup' : ;
  }

  Class['sshd::setup'] -> Class['sshd']

  define config($value) {
    sshd_config {
      $name :
        value   => $value,
        notify  => Service['sshd'];
    }
  }
}
