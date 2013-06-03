#
# nodes.pp - defines all puppet nodes
#

# self-manage the puppet master server
node 'puppet' { }

##### CLIENTS

node 'client1' {
  class { 'helloworld': }

package { ['lftp', 'createrepo','rsync','pyOpenSSL',
# 'rhn-client-tools',
'mrepo'
]:
    ensure  => present,
  }

}

node 'client2' { 
  class { 'helloworld': }
package { ['lftp', 'createrepo','rsync','pyOpenSSL',
# 'rhn-client-tools',
'mrepo'
]:
    ensure  => present,
  }
}

node 'idea' {
 class { 'net_share':  }
 class { 'wintest': }
 class { 'win_desktop_shortcut': }
}
node 'asusxs' {
  class { 'wintest': }
}
node 'asusxsmaison' {
  class { 'wintest': }
}
