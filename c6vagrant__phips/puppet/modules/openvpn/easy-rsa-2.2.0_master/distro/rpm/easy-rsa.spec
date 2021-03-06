#
#  Easy-RSA -- This is a small RSA key management package, based on the openssl
#              command line tool, that can be found in the easy-rsa subdirectory
#              of the OpenVPN distribution.  While this tool is primary concerned
#              with key management for the SSL VPN application space, it can also
#              be used for building web certificates.
#
#  Copyright (C) 2002-2010 OpenVPN Technologies, Inc. <sales@openvpn.net>
#  Copyright (C) 2006-2012 Alon Bar-Lev <alon.barlev@gmail.com>
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License version 2
#  as published by the Free Software Foundation.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program (see the file COPYING included with this
#  distribution); if not, write to the Free Software Foundation, Inc.,
#  59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#

Summary:	Easy-RSA
Name:		easy-rsa
Version:	2.2.0_master
Release:	1
License:	GPL-2
Group:		Security/Cryptography
Source:		%{name}-%{version}.tar.gz
Packager:	OpenVPN Technologies, Inc. <sales@openvpn.net>
Vendor:		OpenVPN Technologies, Inc.
URL:		http://openvpn.net
BuildRoot:	%{_tmppath}/%{name}-buildroot
BuildArch:	noarch
Requires:	openssl
%description
This is a small RSA key management package, based on the openssl
command line tool, that can be found in the easy-rsa subdirectory
of the OpenVPN distribution.  While this tool is primary concerned
with key management for the SSL VPN application space, it can also
be used for building web certificates.

%prep
%setup -q

%build
%configure -q -docdir="%{_docdir}/%{name}-%{version}"
%{__make}

%install
rm -rf "${RPM_BUILD_ROOT}"
%{__make} install DESTDIR="${RPM_BUILD_ROOT}"

%clean
rm -rf "${RPM_BUILD_ROOT}"

%files

%defattr(-,root,root)
%{_datadir}/easy-rsa
%{_docdir}
 
%changelog
* Fri Feb 24 2012 Alon Bar-Lev <alon.barlev@gmail.com>
- Created initial spec file
