#!/usr/bin/env bash
# This bootstraps Puppet on CentOS 6.x
# It has been tested on CentOS 6.4 64bit

set -e

REPO_URL="http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm"

if [ "$EUID" -ne "0" ]; then
  echo "This script must be run as root." >&2
  exit 1
fi

if which openvpn > /dev/null 2>&1; then
  echo "OPENVPN is already installed."
  exit 0
fi

# Install openvpn labs repo
echo -n "Adding EPEL yum repo..."
rpm -ivh ${REPO_URL} >/dev/null 2>&1
echo "done"

# Install Openvpn...
echo -n "Installing openvpn..."
yum install -y openvpn >/dev/null 2>&1
echo "done"


