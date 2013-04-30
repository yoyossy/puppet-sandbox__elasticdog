#
# nodes.pp - defines all puppet nodes
#

# self-manage the puppet master server
node 'puppet' { }

##### CLIENTS

node 'client1' {
  class { 'helloworld': }
}

node 'client2' { }

node 'idea' {
 class { 'net_share':  }
 class { 'wintest': }
 class { 'win_desktop_shortcut': }
}
node 'asusxs' {
  class { 'wintest': }
}
