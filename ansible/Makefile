#!/usr/bin/make
# WARN: gmake syntax
########################################################
# Makefile for Ansible
#
# useful targets:
#   make sdist ---------------- produce a tarball
#   make rpm  ----------------- produce RPMs
#   make deb ------------------ produce a DEB
#   make docs ----------------- rebuild the manpages (results are checked in)
#   make tests ---------------- run the tests
#   make pyflakes, make pep8 -- source code checks

########################################################
# variable section

NAME = "ansible"
OS = $(shell uname -s)

# Manpages are currently built with asciidoc -- would like to move to markdown
# This doesn't evaluate until it's called. The -D argument is the
# directory of the target file ($@), kinda like `dirname`.
MANPAGES := docs/man/man1/ansible.1 docs/man/man1/ansible-playbook.1 docs/man/man1/ansible-pull.1 docs/man/man1/ansible-doc.1
ifneq ($(shell which a2x 2>/dev/null),)
ASCII2MAN = a2x -D $(dir $@) -d manpage -f manpage $<
ASCII2HTMLMAN = a2x -D docs/html/man/ -d manpage -f xhtml
else
ASCII2MAN = @echo "ERROR: AsciiDoc 'a2x' command is not installed but is required to build $(MANPAGES)" && exit 1
endif

PYTHON=python
SITELIB = $(shell $(PYTHON) -c "from distutils.sysconfig import get_python_lib; print get_python_lib()")

# VERSION file provides one place to update the software version
VERSION := $(shell cat VERSION)

# Get the branch information from git
ifneq ($(shell which git),)
GIT_DATE := $(shell git log -n 1 --format="%ai")
endif

ifeq ($(OS), FreeBSD)
DATE := $(shell date -j -f "%Y-%m-%d %H:%M:%s"  "$(GIT_DATE)" +%Y%m%d%H%M)
else
ifeq ($(OS), Darwin)
DATE := $(shell date -j -f "%Y-%m-%d %H:%M:%S"  "$(GIT_DATE)" +%Y%m%d%H%M)
else
DATE := $(shell date --utc --date="$(GIT_DATE)" +%Y%m%d%H%M)
endif
endif

# RPM build parameters
RPMSPECDIR= packaging/rpm
RPMSPEC = $(RPMSPECDIR)/ansible.spec
RPMDIST = $(shell rpm --eval '%dist')
RPMRELEASE = 1
ifeq ($(OFFICIAL),)
    RPMRELEASE = 0.git$(DATE)
endif
RPMNVR = "$(NAME)-$(VERSION)-$(RPMRELEASE)$(RPMDIST)"

########################################################

all: clean python

tests:
	PYTHONPATH=./lib nosetests -d -v

# To force a rebuild of the docs run 'touch VERSION && make docs'
docs: $(MANPAGES) modulepages

authors:
	sh hacking/authors.sh

# Regenerate %.1.asciidoc if %.1.asciidoc.in has been modified more
# recently than %.1.asciidoc.
%.1.asciidoc: %.1.asciidoc.in
	sed "s/%VERSION%/$(VERSION)/" $< > $@

# Regenerate %.1 if %.1.asciidoc or VERSION has been modified more
# recently than %.1. (Implicitly runs the %.1.asciidoc recipe)
%.1: %.1.asciidoc VERSION
	$(ASCII2MAN)

loc:
	sloccount lib library bin

pep8:
	@echo "#############################################"
	@echo "# Running PEP8 Compliance Tests"
	@echo "#############################################"
	-pep8 -r --ignore=E501,E221,W291,W391,E302,E251,E203,W293,E231,E303,E201,E225,E261,E241 lib/ bin/
	-pep8 -r --ignore=E501,E221,W291,W391,E302,E251,E203,W293,E231,E303,E201,E225,E261,E241 --filename "*" library/

pyflakes:
	pyflakes lib/ansible/*.py bin/*

clean:
	@echo "Cleaning up distutils stuff"
	rm -rf build
	rm -rf dist
	@echo "Cleaning up byte compiled python stuff"
	find . -type f -regex ".*\.py[co]$$" -delete
	@echo "Cleaning up editor backup files"
	find . -type f \( -name "*~" -or -name "#*" \) -delete
	find . -type f \( -name "*.swp" \) -delete
	@echo "Cleaning up manpage stuff"
	find ./docs/man -type f -name "*.xml" -delete
	find ./docs/man -type f -name "*.asciidoc" -delete
	find ./docs/man/man3 -type f -name "*.3" -delete
	@echo "Cleaning up output from test runs"
	rm -rf test/test_data
	@echo "Cleaning up RPM building stuff"
	rm -rf MANIFEST rpm-build
	@echo "Cleaning up Debian building stuff"
	rm -rf debian
	rm -rf deb-build
	rm -rf docs/json
	rm -rf docs/js
	@echo "Cleaning up authors file"
	rm -f AUTHORS.TXT

python:
	$(PYTHON) setup.py build

install:
	$(PYTHON) setup.py install

sdist: clean docs
	$(PYTHON) setup.py sdist -t MANIFEST.in

rpmcommon: sdist
	@mkdir -p rpm-build
	@cp dist/*.gz rpm-build/
	@sed -e 's#^Version:.*#Version: $(VERSION)#' -e 's#^Release:.*#Release: $(RPMRELEASE)%{?dist}#' $(RPMSPEC) >rpm-build/$(NAME).spec

srpm: rpmcommon
	@rpmbuild --define "_topdir %(pwd)/rpm-build" \
	--define "_builddir %{_topdir}" \
	--define "_rpmdir %{_topdir}" \
	--define "_srcrpmdir %{_topdir}" \
	--define "_specdir $(RPMSPECDIR)" \
	--define "_sourcedir %{_topdir}" \
	-bs rpm-build/$(NAME).spec
	@rm -f rpm-build/$(NAME).spec
	@echo "#############################################"
	@echo "Ansible SRPM is built:"
	@echo "    rpm-build/$(RPMNVR).src.rpm"
	@echo "#############################################"

rpm: rpmcommon
	@rpmbuild --define "_topdir %(pwd)/rpm-build" \
	--define "_builddir %{_topdir}" \
	--define "_rpmdir %{_topdir}" \
	--define "_srcrpmdir %{_topdir}" \
	--define "_specdir $(RPMSPECDIR)" \
	--define "_sourcedir %{_topdir}" \
	--define "_rpmfilename %%{NAME}-%%{VERSION}-%%{RELEASE}.%%{ARCH}.rpm" \
	--define "__python `which $(PYTHON)`" \
	-ba rpm-build/$(NAME).spec
	@rm -f rpm-build/$(NAME).spec
	@echo "#############################################"
	@echo "Ansible RPM is built:"
	@echo "    rpm-build/$(RPMNVR).noarch.rpm"
	@echo "#############################################"

debian: sdist
deb: debian
	cp -r packaging/debian ./
	chmod 755 debian/rules
	fakeroot debian/rules clean
	fakeroot dh_install
	fakeroot debian/rules binary

# for arch or gentoo, read instructions in the appropriate 'packaging' subdirectory directory

modulepages:
	PYTHONPATH=./lib $(PYTHON) hacking/module_formatter.py -A $(VERSION) -t man -o docs/man/man3/ --module-dir=library --template-dir=hacking/templates

modulejson:
	mkdir -p docs/json
	PYTHONPATH=./lib $(PYTHON) hacking/module_formatter.py -A $(VERSION) -t json -o docs/json --module-dir=library --template-dir=hacking/templates

modulejs:
	mkdir -p docs/js
	make modulejson
	PYTHONPATH=./lib $(PYTHON) hacking/module_formatter.py -A $(VERSION) -t js -o docs/js --module-dir=docs/json --template-dir=hacking/templates

# because this requires Sphinx it is not run as part of every build, those building the RPM and so on can ignore this

webdocs:
	(cd docsite; make docs)

# just for quick testing of all the module docs
webdocs2:
	(cd docsite; make modules)
