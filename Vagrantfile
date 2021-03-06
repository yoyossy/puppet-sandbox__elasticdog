# -*- mode: ruby -*-
# vi: set ft=ruby :

domain = 'example.com'

puppet_nodes = [
  {:hostname => 'puppet',  :ip => '192.168.10.10', :box => 'centos64_x64', :fwdhost => 8140, :fwdguest => 8140, :ram => 512},
  {:hostname => 'client1', :ip => '192.168.10.11', :box => 'centos64_x64'},
  {:hostname => 'client2', :ip => '192.168.10.12', :box => 'centos64_x64'},
]

Vagrant.configure("2") do |config|
# Vagrant::Config.run do |config|
  puppet_nodes.each do |node|
    config.vm.define node[:hostname] do |node_config|
      node_config.vm.box = node[:box]
#      node_config.vm.box_url = 'http://files.vagrantup.com/' + node_config.vm.box + '.box'
      node_config.vm.box_url = 'https://bitbucket.org/begolu/boxes/downloads/' + node_config.vm.box + '.box'
      node_config.vm.hostname = node[:hostname] + '.' + domain
      node_config.vm.network :private_network, ip: node[:ip]
      #########################################################
      ##   Attention - il faut un serveur DHCP quelque part !
      node_config.vm.network :public_network
      #########################################################
      node_config.vm.synced_folder "../../ESPs",  "/ESPs"
      node_config.vm.synced_folder "../../BINs",  "/BINs"
      node_config.vm.synced_folder "../../HG_SVN",  "/HG_SVN"
      node_config.vm.synced_folder "../../MMs",  "/MMs"
      memory = node[:ram] ? node[:ram] : 256;
      node_config.vm.provider :virtualbox do |v|
        v.customize [
          'modifyvm', :id,
          '--name', node[:hostname],
          '--memory', memory.to_s,
#          '--nic2', "intnet"    
        ]
      end 

      if node[:fwdhost]
        node_config.vm.network :forwarded_port, guest: (node[:fwdguest]), host: (node[:fwdhost])
      end
      
      if node[:box]=='centos64_x64'
        node_config.vm.provision :shell, :inline => 'if [ ! -f puppetlabs-release-6-7.noarch.rpm ]; then wget -q https://yum.puppetlabs.com/el/6/products/x86_64/puppetlabs-release-6-7.noarch.rpm; fi'
        node_config.vm.provision :shell, :inline => 'if [ ! -f rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm ]; then wget -q http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm; fi'
        node_config.vm.provision :shell, :inline => 'rpm -ivh --replacepkgs rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm'
        node_config.vm.provision :shell, :inline => 'rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-dag'
        node_config.vm.provision :shell, :inline => 'rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-fabian'
#        node_config.vm.provision :shell, :inline => 'rpm -ivh --replacepkgs http://pkgs.repoforge.org/mrepo/mrepo-0.8.8-0.pre1.el6.rft.noarch.rpm'
        node_config.vm.provision :shell, :inline => 'iptables --list-rules'
      end
      
      node_config.vm.provision :puppet do |puppet|
        if node[:hostname]=='puppet'
          puppet.options = "--hiera_config hiera.yaml"
          puppet.facter = {
            ## tells default.pp that we're running in Vagrant
            "is_vagrant" => true,
          }
        end
        if node[:hostname]=='client1'
          puppet.options = "--hiera_config hiera.yaml"
          puppet.facter = {
            ## tells default.pp that we're running in Vagrant
            "is_vagrant" => true,
          }
        end
        if node[:hostname]=='client2'
          puppet.options = "--hiera_config hiera.yaml"
          puppet.facter = {
            ## tells default.pp that we're running in Vagrant
            "is_vagrant" => true,
          }
        end
        

        puppet.manifests_path = 'provision/manifests'
        puppet.module_path = 'provision/modules'
      end
    end
  end
end  

Vagrant.configure("2") do |config|

  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--memory", 512]
  end

  config.vm.define :client3 do |client_config|
    client_config.vm.box = "std-precise32"
    client_config.vm.box_url = "http://files.vagrantup.com/precise32.box"
#    client_config.vm.box = 'timhuegdon.com_.-vagrant-boxes_.-ubuntu-11.10.box'
#    client_config.vm.box_url = 'http://timhuegdon.com/vagrant-boxes/ubuntu-11.10.box'
#    client_config.vm.box_url = 'http://files.vagrantup.com/lucid32.box'


    client_config.vm.hostname = "client3.#{domain}"
#    client_config.vm.network :bridged
    client_config.vm.network :private_network, ip:  '192.168.10.13'
    client_config.vm.provision :shell, :path => File.join("./varying-vagrant-vagrants_.-10up/provision","provision.sh" )
    client_config.vm.synced_folder "varying-vagrant-vagrants_.-10up/database/", "/srv/database"
    client_config.vm.synced_folder "varying-vagrant-vagrants_.-10up/database/data/", "/var/lib/mysql", :extra => 'dmode=777,fmode=777'
    client_config.vm.synced_folder "varying-vagrant-vagrants_.-10up/config/", "/srv/config"
    client_config.vm.synced_folder "varying-vagrant-vagrants_.-10up/config/nginx-config/sites/", "/etc/nginx/custom-sites"
    client_config.vm.synced_folder "varying-vagrant-vagrants_.-10up/www/", "/srv/www/", :owner => "www-data"
  end
end

Vagrant.configure("1") do |config|  
  config.vm.define :rails_master do |rails_master_config|
    rails_master_config.vm.box       = 'precise64'
    rails_master_config.vm.box_url   = 'http://files.vagrantup.com/precise64.box'
    rails_master_config.vm.host_name = "master.#{domain}"
    rails_master_config.vm.network :bridged
    rails_master_config.vm.network :hostonly, '192.168.10.110'
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
    python_master_config.vm.network :hostonly, '192.168.10.120'
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
