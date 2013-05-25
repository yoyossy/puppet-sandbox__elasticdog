# CentOS 6 Vagrant setup with Puppet

A basic Apache+PHP install on top of a 
[@core CentOS6 Vagrant Box](http://vntx-box.s3.amazonaws.com/centos6.box).
LT2013-05-20 Ne fonctionne pas
remplacée par "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130427.box"

Look at [bootstrap.pp](http://github.com/phips/c6vagrant/blob/master/puppet/manifests/bootstrap.pp) to see what Puppet is doing to the base CentOS6 [box](http://docs.vagrantup.com/v2/virtualbox/boxes.html).

AJOUT DE       
              'xorg-x11-xauth',
              'xorg-x11-fonts-Type1',  
              'emacs',
 #             'gvim',
              'gstreamer','gstreamer-plugins-good'  

            dans bootstrap.pp


INSTALLATION manuelle de OPERA

wget http://www.opera.com/download/get/?id=35757&location=382&nothanks=yes&sub=marine
sudo rpm -Uvh opera-12*.rpm