#!/usr/bin/env bash
# This bootstraps Puppet on CentOS 6.x
# It has been tested on CentOS 6.4 64bit

set -e

# When this option is on, if a simple command fails 
# for any of the reasons listed in Consequences of Shell Errors 
# or returns an exit status value >0, and is not part of the compound list 
# following a while, until, or if keyword, and is not a part of an AND or OR list, 
# and is not a pipeline preceded by the ! reserved word, then the shell shall immediately exit.

#  Starting shell scripts with set -e is considered a best practice, 
#  since it is usually safer to abort the script if some error occurs. 

REPO_URL="https://yum.puppetlabs.com/el/6/products/x86_64/puppetlabs-release-6-7.noarch.rpm"

if [ "$EUID" -ne "0" ]; then
  echo "This script must be run as root." >&2
  exit 1
fi

if which puppet > /dev/null 2>&1; then
  echo "Puppet is already installed."
  exit 0
fi

# Install puppet labs repo
echo -n "Adding puppetlabs yum repo..."
rpm -ivh ${REPO_URL} >/dev/null 2>&1
echo "done"

# Install Puppet...
echo -n "Installing puppet..."
yum install -y puppet >/dev/null 2>&1
echo "done"


