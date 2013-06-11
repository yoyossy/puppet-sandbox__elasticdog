# A Virtual Machine for Melang Development

## Introduction

This project automates the setup of a development environment for [Melang](https://github.com/ent-io/melang). This is the easiest way to build a box with everything ready to start hacking on your pull request, all in an isolated virtual machine.

## Requirements

* [VirtualBox](https://www.virtualbox.org)
* [Vagrant](http://vagrantup.com)

## How To Build The Virtual Machine

* Download and install the VirtualBox binary [for your environment](https://www.virtualbox.org/wiki/Downloads).

Building the virtual machine is this easy:

    host $ git clone --recursive https://github.com/ent-io/melang-dev-box.git
    host $ cd melang-dev-box
    host $ bundle install
    host $ bundle exec vagrant up

That's it.

If the base box is not present that command fetches it first. After the installation has finished, you can access the virtual machine with

    host $ bundle exec vagrant ssh
    Welcome to Ubuntu 12.04 LTS (GNU/Linux 3.2.0-23-generic-pae i686)
    ...
    vagrant@melang-dev-box:~$

Port 3000 in the host computer is forwarded to port 3000 in the virtual machine. Thus, applications running in the virtual machine can be accessed via localhost:3000 in the host computer.

## What's In The Box

* Git

* Ruby 1.9.3

* Bundler

* SQLite3, MySQL, and Postgres

* System dependencies for nokogiri, sqlite3, mysql, mysql2, and pg

* Databases and users needed to run the Active Record test suite

* Node.js for the asset pipeline

* Memcached

## Recommended Workflow

The recommended workflow is

* edit in the host computer and

* test within the virtual machine.

Just clone your Melang fork in the very directory of the Melang development box in the host computer:

    host $ pwd
    Gemfile  README.md  Vagrantfile  puppet
    host $ git clone git@github.com:<your username>/melang.git

Vagrant mounts that very directory as _/vagrant_ within the virtual machine:

    vagrant@melang-dev-box:~$ ls /vagrant
    Gemfile  README.md  Vagrantfile  melang  puppet

so we are ready to go to edit in the host, and test in the virtual machine.

    vagrant@melang-dev-box:~$ cd /vagrant/melang
    vagrant@melang-dev-box:~$ bundle install
    vagrant@melang-dev-box:~$ cp config/database.yml.example config/database.yml
    vagrant@melang-dev-box:~$ bundle exec rake db:migrate
    vagrant@melang-dev-box:~$ bundle exec rake db:test:prepare
    vagrant@melang-dev-box:~$ bundle exec guard

This workflow is convenient because in the host computer one normally has his editor of choice fine-tuned, Git configured, and SSH keys in place.

## Virtual Machine Management

When done just log out with `^D` and suspend the virtual machine

    host $ vagrant suspend

then, resume to hack again

    host $ vagrant resume

Run

    host $ vagrant halt

to shutdown the virtual machine, and

    host $ vagrant up

to boot it again.

You can find out the state of a virtual machine anytime by invoking

    host $ vagrant status

Finally, to completely wipe the virtual machine from the disk **destroying all its contents**:

    host $ vagrant destroy # DANGER: all is gone

Please check the [Vagrant documentation](http://vagrantup.com/v1/docs/index.html) for more information on Vagrant.
