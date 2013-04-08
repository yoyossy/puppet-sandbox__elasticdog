# -*- mode: ruby -*-
# vi: set ft=ruby :

domain = 'example.com'

puppet_nodes = [
  {:hostname => 'puppet',  :ip => '172.16.32.10', :box => 'precise64_begolu_2013_02', :fwdhost => 8140, :fwdguest => 8140, :ram => 512},
  {:hostname => 'client1', :ip => '172.16.32.11', :box => 'precise64_begolu_2013_02'},
  {:hostname => 'client2', :ip => '172.16.32.12', :box => 'precise64_begolu_2013_02'},
]

Vagrant.configure("1") do |config|
# Vagrant::Config.run do |config|
  puppet_nodes.each do |node|
    config.vm.define node[:hostname] do |node_config|
      node_config.vm.box = node[:box]
      node_config.vm.box_url = 'https://bitbucket.org/begolu/boxes/downloads/' + node_config.vm.box + '.box'
      node_config.vm.host_name = node[:hostname] + '.' + domain
      node_config.vm.network :hostonly, node[:ip]
      node_config.vm.share_folder "HG_SVN",  "/HG_SVN", "M:/HG_SVN"

      if node[:fwdhost]
        node_config.vm.forward_port(node[:fwdguest], node[:fwdhost])
      end

      memory = node[:ram] ? node[:ram] : 256;
      node_config.vm.customize [
        'modifyvm', :id,
        '--name', node[:hostname],
        '--memory', memory.to_s
      ]

      node_config.vm.provision :puppet do |puppet|
        puppet.manifests_path = 'provision/manifests'
        puppet.module_path = 'provision/modules'
      end
    end
  end


  config.vm.define :client3 do |client_config|
    client_config.vm.box = 'timhuegdon.com_.-vagrant-boxes_.-ubuntu-11.10.box'
    client_config.vm.box_url = 'http://timhuegdon.com/vagrant-boxes/ubuntu-11.10.box'
#    client_config.vm.box_url = 'http://files.vagrantup.com/lucid32.box'
    client_config.vm.host_name = "client3.#{domain}"
#    client_config.vm.network :bridged
    client_config.vm.network :hostonly, '172.16.32.13'
    client_config.vm.provision :shell, :path => "apt-get_update.sh"
  end
  
  config.vm.define :rails_master do |rails_master_config|
    rails_master_config.vm.box       = 'precise32_2013_02'
    rails_master_config.vm.box_url   = 'http://files.vagrantup.com/precise32.box'
    rails_master_config.vm.host_name = "master.#{domain}"
    rails_master_config.vm.network :bridged
    rails_master_config.vm.network :hostonly, '172.16.32.110'
    rails_master_config.vm.forward_port 3000, 3000
    rails_master_config.vm.customize [
        'modifyvm', :id,
        '--name', 'rails_master',
        '--memory', 256
      ]
    rails_master_config.vm.provision :puppet,
      :manifests_path => 'rails_master_puppet/manifests',
      :module_path    => 'rails_master_puppet/modules',
      :manifest_file  => 'rails_master.pp'
  end 

  config.vm.define :python_master do |python_master_config|
    python_master_config.vm.box       = 'precise32_2013_02'
    python_master_config.vm.box_url   = 'http://files.vagrantup.com/precise32.box'
    python_master_config.vm.host_name = "master.#{domain}"
    python_master_config.vm.network :bridged
    python_master_config.vm.network :hostonly, '172.16.32.120'
    python_master_config.vm.forward_port 80, 12080
    python_master_config.vm.forward_port 8000, 8120
    python_master_config.vm.customize [
        'modifyvm', :id,
        '--name', 'python_master',
        '--memory', 256
      ]
    python_master_config.vm.provision :puppet,
      :manifests_path => 'my-vagrant-puppet-python_.-jas0nkim/manifests',
      :module_path    => 'my-vagrant-puppet-python_.-jas0nkim/modules',
      :manifest_file  => 'python_master.pp'
  end 


end
