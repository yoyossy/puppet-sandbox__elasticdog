Ansible Changes By Release
==========================

1.1 "Mean Street" -- Release pending

* added 'with_random_choice' filter plugin
* added --check option for "dry run" mode
* added --diff option to show how templates change, or might change
* service status 4 is also 'not running'
* stderr shown when commands fail to parse
* uses yaml.safe_dump in filter plugins
* authentication Q&A no longer happens before --syntax-check
* ability to get hostvars data for nodes not in the setup cache yet
* able to specify a different hg repo to pull from than the original set
* SSH timeout now correctly passed to native SSH connection plugin
* supervisorctl restart fix
* raise an error when multiple when_ statements are provided
* --list-hosts applies host limit selections better
* (internals) template engine specifications to use template_ds everywhere
* rabbit_mq plugin module
* rabbit_mq user module
* rabbit_mq vhost module
* mongodb_user module
* increased error handling for ec2 module
* can recursively set permissions on directories
* change to the way AMI tags are handled
* better error message when your host file can't be found
* --list-tasks for the playbook will list the tasks without running them
* block device facts for the setup module
* cron module can now also manipulate cron.d files
* virtualenv module can now inherit system site packages (or not)
* able to set the environment by setting "environment:" as a dictionary on any task (go proxy support!)
* added ansible_ssh_user and ansible_ssh_pass for per-host/group username and password

1.0 "Eruption" -- Feb 1 2013

New modules:

* new sysctl module
* new pacman module (Arch linux)
* new apt_key module
* hg module now in core
* new ec2_facts module
* added pkgin module for Joyent SmartOS

New config settings:

* sudo_exe parameter can be set in config to use sudo alternatives
* sudo_flags parameter can alter the flags used with sudo

New playbook/language features:

* added when_failed and when_changed
* task includes can now be of infinite depth
* when_set and when_unset can take more than one var (when_set: $a and $b and $c)
* added the with_sequence lookup plugin
* can override "connection:" on an indvidual task
* parameterized playbook includes can now define complex variables (not just all on one line)
* making inventory variables available for use in vars_files paths
* messages when skipping plays are now more clear
* --extra-vars now has maximum precedence (as intended)

Module fixes and new flags:

* ability to use raw module without python on remote system
* fix for service status checking on Ubuntu
* service module now responds to additional exit code for SERVICE_UNAVAILABLE
* fix for raw module with '-c local'
* various fixes to git module
* ec2 module now reports the public DNS name
* can pass executable= to the raw module to specify alternative shells
* fix for postgres module when user contains a "-"
* added additional template variables -- $template_fullpath and $template_run_date
* raise errors on invalid arguments used with a task include statement
* shell/command module takes a executable= parameter to specify a different shell than /bin/sh
* added return code and error output to the raw module
* added support for @reboot to the cron module
* misc fixes to the pip module
* nagios module can schedule downtime for all services on the host
* various subversion module improvements
* various mail module improvements
* SELinux fix for files created by authorized_key module
* "template override" ??
* get_url module can now send user/password authorization
* ec2 module can now deploy multiple simultaneous instances
* fix for apt_key modules stalling in some situations
* fix to enable Jinja2 {% include %} to work again in template
* ec2 module is now powered by Boto
* setup module can now detect if package manager is using pacman
* fix for yum module with enablerepo in use on EL 6

Core fixes and new behaviors:

* various fixes for variable resolution in playbooks
* fixes for handling of "~" in some paths
* various fixes to DWIM'ing of relative paths
* /bin/ansible now takes a --list-hosts just like ansible-playbook did
* various patterns can now take a regex vs a glob if they start with "~" (need docs on which!) - also /usr/bin/ansible
* allow intersecting host patterns by using "&" ("webservers:!debian:&datacenter1")
* handle tilde shell character for --private-key
* hash merging policy is now selectable in the config file, can choose to override or merge
* environment variables now available for setting all plugin paths (ANSIBLE_CALLBACK_PLUGINS, etc)
* added packaging file for macports (not upstreamed yet)
* hacking/test-module script now uses /usr/bin/env properly
* fixed error formatting for certain classes of playbook syntax errors
* fix for processing returns with large volumes of output

Inventory files/scripts:

* hostname patterns in the inventory file can now use alphabetic ranges
* whitespace is now allowed around group variables in the inventory file
* inventory scripts can now define groups of groups and group vars (need example for docs?)

0.9 "Dreams" -- Nov 30 2012

Highlighted core changes:

* various performance tweaks, ansible executes dramatically less SSH ops per unit of work
* close paramiko SFTP connections less often on copy/template operations (speed increase)
* change the way we use multiprocessing (speed/RAM usage improvements)
* able to set default for asking password & sudo password in config file
* ansible now installs nicely if running inside a virtualenv
* flag to allow SSH connection to move files by scp vs sftp (in config file)
* additional RPM subpackages for easily installing fireball mode deps (server and node)
* group_vars/host_vars now available to ansible, not just playbooks
* native ssh connection type (-c ssh) now supports passwords as well as keys
* ansible-doc program to show details

Other core changes:

* fix for template calls when last character is '$'
* if ansible_python_interpreter is set on a delegated host, it now works as intended
* --limit can now take "," as seperator as well as ";" or ":"
* msg is now displaced with newlines when a task fails
* if any with_ plugin has no results in a list (empty list for with_items, etc), the task is now skipped
* various output formatting fixes/improvements
* fix for Xen dom0/domU detection in default facts
* 'ansible_domain' fact now available (ex value: example.com)
* configured remote temp file location is now always used even for root
* 'register'-ed variables are not recorded for skipped hosts (for example, using only_if/when)
* duplicate host records for the same host can no longer result when a host is listed in multiple groups
* ansible-pull now passes --limit to prevent running on multiple hosts when used with generic playbooks
* remote md5sum check fixes for Solaris 10
* ability to configure syslog facility used by remote module calls
* in templating, stray '$' characters are now handled more correctly

Playbook changes:

* relative paths now work for 'first_available_file'
* various templating engine fixes
* 'when' is an easier form of only if
* --list-hosts on the playbook command now supports multiple playbooks on the same command line
* playbook includes can now be parameterized

Module additions:

* (addhost) new module for adding a temporary host record (used for creating new guests)
* (group_by) module allows partitioning hosts based on group data
* (ec2) new module for creating ec2 hosts
* (script) added 'script' module for pushing and running self-deleting remote scripts
* (svr4pkg) solaris svr4pkg module

Module changes:

* (authorized key) module uses temp file now to prevent failure on full disk
* (fetch) now uses the 'slurp' internal code to work as you would expect under sudo'ed accounts
* (fetch) internal usage of md5 sums fixed for BSD
* (get_url) thirsty is no longer required for directory destinations
* (git) various git module improvements/tweaks
* (group) now subclassed for various platforms, includes SunOS support
* (lineinfile) create= option on lineinfile can create the file when it does not exist
* (mysql_db) module takes new grant options
* (postgresql_db) module now takes role_attr_flags
* (service) further upgrades to service module service status reporting
* (service) tweaks to get service module to play nice with BSD style service systems (rc.conf)
* (service) possible to pass additional arguments to services
* (shell) and command module now take an 'executable=' flag for specifying an alternate shell than /bin/sh
* (user) ability to create SSH keys for users when using user module to create users
* (user) atomic replacement of files preserves permissions of original file
* (user) module can create SSH keys
* (user) module now does Solaris and BSD
* (yum) module takes enablerepo= and disablerepo=
* (yum) misc yum module fixing for various corner cases

Plugin changes:

* EC2 inventory script now produces nicer failure message if AWS is down (or similar)
* plugin loading code now more streamlined
* lookup plugins for DNS text records, environment variables, and redis
* added a template lookup plugin $TEMPLATE('filename.j2')
* various tweaks to the EC2 inventory plugin 
* jinja2 filters are now pluggable so it's easy to write your own (to_json/etc, are now impl. as such)

0.8 "Cathedral" -- Oct 19, 2012

Highlighted Core Changes:

* fireball mode -- ansible can bootstrap a ephemeral 0mq (zeromq) daemon that runs as a given user and expires after X period of time.  It is very fast.
* playbooks with errors now return 2 on failure.  1 indicates a more fatal syntax error.  Similar for /usr/bin/ansible
* server side action code (template, etc) are now fully pluggable
* ability to write lookup plugins, like the code powering "with_fileglob" (see below)

Other Core Changes:

* ansible config file can also go in '.ansible.cfg' in cwd in addition to ~/.ansible.cfg and /etc/ansible/ansible.cfg
* fix for inventory hosts at API level when hosts spec is a list and not a colon delimited string
* ansible-pull example now sets up logrotate for the ansible-pull cron job log
* negative host matching (!hosts) fixed for external inventory script usage
* internals: os.executable check replaced with utils function so it plays nice on AIX
* Debian packaging now includes ansible-pull manpage
* magic variable 'ansible_ssh_host' can override the hostname (great for usage with tunnels)
* date command usage in build scripts fixed for OS X
* don't use SSH agent with paramiko if a password is specified
* make output be cleaner on multi-line command/shell errors
* /usr/bin/ansible now prints things when tasks are skipped, like when creates= is used with -m command and /usr/bin/ansible
* when trying to async a module that is not a 'normal' asyncable module, ansible will now let you know
* ability to access inventory variables via 'hostvars' for hosts not yet included in any play, using on demand lookups
* merged ansible-plugins, ansible-resources, and ansible-docs into the main project
* you can set ANSIBLE_NOCOWS=1 if you want to disable cowsay if it is installed.  Though no one should ever want to do this!  Cows are great!
* you can set ANSIBLE_FORCECOLOR=1 to force color mode even when running without a TTY
* fatal errors are now properly colored red.
* skipped messages are now cyan, to differentiate them from unchanged messages.
* extensive documentation upgrades
* delegate_action to localhost (aka local_action) will always use the local connection type

Highlighted playbook changes:

* is_set is available for use inside of an only_if expression:  is_set('ansible_eth0').  We intend to further upgrade this with a 'when'
  keyword providing better options to 'only_if' in the next release.   Also is_unset('ansible_eth0')
* playbooks can import playbooks in other directories and then be able to import tasks relative to them
* FILE($path) now allows access of contents of file in a path, very good for use with SSH keys
* similarly PIPE($command) will run a local command and return the results of executing this command
* if all hosts in a play fail, stop the playbook, rather than letting the console log spool on by
* only_if using register variables that are booleans now works in a boolean way like you'd expect
* task includes now work with with_items (such as: include: path/to/wordpress.yml user=$item)
* when using a $list variable with $var or ${var} syntax it will automatically join with commas
* setup is not run more than once when we know it is has already been run in a play that included another play, etc
* can set/override sudo and sudo_user on individual tasks in a play, defaults to what is set in the play if not present
* ability to use with_fileglob to iterate over local file patterns
* templates now use Jinja2's 'trim_blocks=True' to avoid stray newlines, small changes to templates may
be required in rare cases.

Other playbook changes:

* to_yaml and from_yaml are available as Jinja2 filters
* $group and $group_names are now accessible in with_items
* where 'stdout' is provided a new 'stdout_lines' variable (type == list) is now generated and usable with with_items
* when local_action is used the transport is automatically overridden to the local type
* output on failed playbook commands is now nicely split for stderr/stdout and syntax errors
* if local_action is not used and delegate_to was 127.0.0.1 or localhost, use local connection regardless
* when running a playbook, and the statement has changed, prints 'changed:' now versus 'ok:' so it is obvious without colored mode
* variables now usable within vars_prompt (just not host/group vars)
* setup facts are now retained across plays (dictionary just gets updated as needed)
* --sudo-user now works with --extra-vars
* fix for multi_line strings with only_if

New Modules:

* ini_file module for manipulating INI files
* new LSB facts (release, distro, etc)
* pause module -- (pause seconds=10) (pause minutes=1) (pause prompt=foo) -- it's an action plugin
* a module for adding entries to the main crontab (though you may still wish to just drop template files into cron.d)
* debug module can be used for outputing messages without using 'shell echo'
* a fail module is now available for causing errors, you might want to use it with only_if to fail in certain conditions

Other module Changes, Upgrades, and Fixes:

* removes= exists on command just like creates=
* postgresql modules now take an optional port= parameter
* /proc/cmdline info is now available in Linux facts
* public host key detection for OS X
* lineinfile module now uses 'search' not exact 'match' in regexes, making it much more intuitive and not needing regex syntax most of the time
* added force=yes|no (default no) option for file module, which allows transition between files to directories and so on
* additional facts for SunOS virtualization
* copy module is now atomic when used across volumes
* url_get module now returns 'dest' with the location of the file saved
* fix for yum module when using local RPMs vs downloading
* cleaner error messages with copy if destination directory does not exist
* setup module now still works if PATH is not set
* service module status now correct for services with 'subsys locked' status
* misc fixes/upgrades to the wait_for module
* git module now expands any "~" in provided destination paths
* ignore stop error code failure for service module with state=restarted, always try to start
* inline documentation for modules allows documentation source to built without pull requests to the ansible-docs project, among other things
* variable '$ansible_managed' is now great to include at the top of your templates and includes useful information and a warning that it will be replaced
* "~" now expanded in command module when using creates/removes
* mysql module can do dumps and imports
* selinux policy is only required if setting to not disabled
* various fixes for yum module when working with packages not in any present repo

0.7 "Panama" -- Sept 6 2012

Module changes:

* login_unix_socket option for mysql user and database modules (see PR #781 for doc notes)
* new modules -- pip, easy_install, apt_repository, supervisorctl
* error handling for setup module when SELinux is in a weird state
* misc yum module fixes
* better changed=True/False detection in user module on older Linux distros
* nicer errors from modules when arguments are not key=value
* backup option on copy (backup=yes), as well as template, assemble, and lineinfile
* file module will not recurse on directory properties
* yum module now workable without having repoquery installed, but doesn't support comparisons or list= if so
* setup module now detects interfaces with aliases
* better handling of VM guest type detection in setup module
* new module boilerplate code to check for mutually required arguments, arguments required together, exclusive args
* add pattern= as a paramter to the service module (for init scripts that don't do status, or do poor status)
* various fixes to mysql & postresql modules
* added a thirsty= option (boolean, default no) to the get_url module to decide to download the file every time or not
* added a wait_for module to poll for ports being open
* added a nagios module for controlling outage windows and alert statuses
* added a seboolean module for getsebool/setsebool type operations
* added a selinux module for controlling overall SELinux policy
* added a subversion module
* added lineinfile for adding and removing lines from basic files
* added facts for ARM-based CPUs
* support for systemd in the service module
* git moduleforce reset behavior is now controllable
* file module can now operate on special files (block devices, etc)

Core changes:

* ansible --version will now give branch/SHA information if running from git
* better sudo permissions when encountering different umasks
* when using paramiko and SFTP is not accessible, do not traceback, but return a nice human readable msg
* use -vvv for extreme debug levels. -v gives more playbook output as before
* -vv shows module arguments to all module calls (and maybe some other things later)
* don not pass "--" to sudo to work on older EL5
* make remote_md5 internal function work with non-bash shells
* allow user to be passed in via --extra-vars (regression)
* add --limit option, which can be used to further confine the pattern given in ansible-playbooks
* adds ranged patterns like dbservers[0-49] for usage with patterns or --limit
* -u and user: defaults to current user, rather than root, override as before
* /etc/ansible/ansible.cfg and ~/ansible.cfg now available to set default values and other things
* (developers) ANSIBLE_KEEP_REMOTE_FILES=1 can be used in debugging (envrionment variable)
* (developers) connection types are now plugins
* (developers) callbacks can now be extended via plugins
* added FreeBSD ports packaging scripts
* check for terminal properties prior to engaging color modes
* explicitly disable password auth with -c ssh, as it is not used anyway

Playbooks:

* YAML syntax errors detected and show where the problem is
* if you ctrl+c a playbook it will not traceback (usually)
* vars_prompt now has encryption options (see examples/playbooks/prompts.yml)
* allow variables in parameterized task include parameters (regression)
* add ability to store the result of any command in a register (see examples/playbooks/register_logic.yml)
* --list-hosts to show what hosts are included in each play of a playbook
* fix a variable ordering issue that could affect vars_files with selective file source lists
* adds 'delegate_to' for a task, which can be used to signal outage windows and load balancers on behalf of hosts
* adds 'serial' to playbook, allowing you to specify how many hosts can be processing a playbook at one time (default 0=all)
* adds 'local_action: <action parameters>' as an alias to 'delegate_to: 127.0.0.1'

0.6 "Cabo" -- August 6, 2012

playbooks:

* support to tag tasks and includes and use --tags in playbook CLI
* playbooks can now include other playbooks (example/playbooks/nested_playbooks.yml)
* vars_files now usable with with_items, provided file paths don't contain host specific facts
* error reporting if with_items value is unbound
* with_items no longer creates lots of tasks, creates one task that makes multiple calls
* can use host_specific facts inside with_items (see above)
* at the top level of a playbook, set 'gather_facts: no' to skip fact gathering
* first_available_file and with_items used together will now raise an error
* to catch typos, like 'var' for 'vars', playbooks and tasks now yell on invalid parameters
* automatically load (directory_of_inventory_file)/group_vars/groupname and /host_vars/hostname in vars_files
* playbook is now colorized, set ANSIBLE_NOCOLOR=1 if you do not like this, does not colorize if not a TTY
* hostvars now preserved between plays (regression in 0.5 from 0.4), useful for sharing vars in multinode configs
* ignore_errors: yes on a task can be used to allow a task to fail and not stop the play
* with_items with the apt/yum module will install/remove/update everything in a single command

inventory:

* groups variable available as a hash to return the hosts in each group name
* in YAML inventory, hosts can list their groups in inverted order now also (see tests/yaml_hosts)
* YAML inventory is deprecated and will be removed in 0.7
* ec2 inventory script
* support ranges of hosts in the host file, like www[001-100].example.com (supports leading zeros and also not)

modules:

* fetch module now does not fail a system when requesting file paths (ex: logs) that don't exist
* apt module now takes an optional install-recommends=yes|no (default yes)
* fixes to the return codes of the copy module
* copy module takes a remote md5sum to avoid large file transfer
* various user and group module fixes (error handling, etc)
* apt module now takes an optional force parameter
* slightly better psychic service status handling for the service module
* fetch module fixes for SSH connection type
* modules now consistently all take yes/no for boolean parameters (and DWIM on true/false/1/0/y/n/etc)
* setup module no longer saves to disk, template module now only used in playbooks
* setup module no longer needs to run twice per playbook
* apt module now passes DEBIAN_FRONTEND=noninteractive
* mount module (manages active mounts + fstab)
* setup module fixes if no ipv6 support
* internals: template in common module boilerplate, also causes less SSH operations when used
* git module fixes
* setup module overhaul, more modular
* minor caching logic added to inventory to reduce hammering of inventory scripts.
* MySQL and PostgreSQL modules for user and db management
* vars_prompt now supports private password entry (see examples/playbooks/prompts.yml)
* yum module modified to be more tolerant of plugins spewing random console messages (ex: RHN)

internals:

* when sudoing to root, still use /etc/ansible/setup as the metadata path, as if root
* paramiko is now only imported if needed when running from source checkout
* cowsay support on Ubuntu
* various ssh connection fixes for old Ubuntu clients
* ./hacking/test-module now supports options like ansible takes and has a debugger mode
* sudoing to a user other than root now works more seamlessly (uses /tmp, avoids umask issues)

0.5 "Amsterdam" ------- July 04, 2012

* Service module gets more accurate service states when running with upstart
* Jinja2 usage in playbooks (not templates), reinstated, supports %include directive
* support for --connection ssh (supports Kerberos, bastion hosts, etc), requires ControlMaster
* misc tracebacks replaced with error messages
* various API/internals refactoring
* vars can be built from other variables
* support for exclusion of hosts/groups with "!groupname"
* various changes to support md5 tool differences for FreeBSD nodes & OS X clients
* "unparseable" command output shows in command output for easier debugging
* mktemp is no longer required on remotes (not available on BSD)
* support for older versions of python-apt in the apt module
* a new "assemble" module, for constructing files from pieces of files (inspired by Puppet "fragments" idiom)
* ability to override most default values with ANSIBLE_FOO environment variables
* --module-path parameter can support multiple directories seperated with the OS path seperator
* with_items can take a variable of type list
* ansible_python_interpreter variable available for systems with more than one Python
* BIOS and VMware "fact" upgrades
* cowsay is used by ansible-playbook if installed to improve output legibility (try installing it)
* authorized_key module
* SELinux facts now sourced from the python selinux library
* removed module debug option -D
* added --verbose, which shows output from successful playbook operations
* print the output of the raw command inside /usr/bin/ansible as with command/shell
* basic setup module support for Solaris
* ./library relative to the playbook is always in path so modules can be included in tarballs with playbooks

0.4 "Unchained" ------- May 23, 2012

Internals/Core
* internal inventory API now more object oriented, parsers decoupled
* async handling improvements
* misc fixes for running ansible on OS X (overlord only)
* sudo improvements, now works much more smoothly
* sudo to a particular user with -U/--sudo-user, or using 'sudo_user: foo' in a playbook
* --private-key CLI option to work with pem files

Inventory
* can use -i host1,host2,host3:port to specify hosts not in inventory (replaces --override-hosts)
* ansible INI style format can do groups of groups [groupname:children] and group vars [groupname:vars]
* groups and users module takes an optional system=yes|no on creation (default no)
* list of hosts in playbooks can be expressed as a YAML list in addition to ; delimited

Playbooks
* variables can be replaced like ${foo.nested_hash_key.nested_subkey[array_index]}
* unicode now ok in templates (assumes utf8)
* able to pass host specifier or group name in to "hosts:" with --extra-vars
* ansible-pull script and example playbook (extreme scaling, remediation)
* inventory_hostname variable available that contains the value of the host as ansible knows it
* variables in the 'all' section can be used to define other variables based on those values
* 'group_names' is now a variable made available to templates
* first_available_file feature, see selective_file_sources.yml in examples/playbooks for info
* --extra-vars="a=2 b=3" etc, now available to inject parameters into playbooks from CLI

Incompatible Changes
* jinja2 is only usable in templates, not playbooks, use $foo instead
* --override-hosts removed, can use -i with comma notation (-i "ahost,bhost")
* modules can no longer include stderr output (paramiko limitation from sudo)

Module Changes
* tweaks to SELinux implementation for file module
* fixes for yum module corner cases on EL5
* file module now correctly returns the mode in octal
* fix for symlink handling in the file module
* service takes an enable=yes|no which works with chkconfig or updates-rc.d as appropriate
* service module works better on Ubuntu
* git module now does resets and such to work more smoothly on updates
* modules all now log to syslog
* enabled=yes|no on a service can be used to toggle chkconfig & updates-rc.d states
* git module supports branch=
* service fixes to better detect status using return codes of the service script
* custom facts provided by the setup module mean no dependency on Ruby, facter, or ohai
* service now has a state=reloaded
* raw module for bootstrapping and talking to routers w/o Python, etc

Misc Bugfixes
* fixes for variable parsing in only_if lines
* misc fixes to key=value parsing
* variables with mixed case now legal
* fix to internals of hacking/test-module development script


0.3 "Baluchitherium" -- April 23, 2012

* Packaging for Debian, Gentoo, and Arch
* Improvements to the apt and yum modules
* A virt module
* SELinux support for the file module
* Ability to use facts from other systems in templates (aka exported
resources like support)
* Built in Ansible facts so you don't need ohai, facter, or Ruby
* tempdir selections that work with noexec mounted /tmp
* templates happen locally, not remotely, so no dependency on
python-jinja2 for remote computers
* advanced inventory format in YAML allows more control over variables
per host and per group
* variables in playbooks can be structured/nested versus just a flat namespace
* manpage upgrades (docs)
* various bugfixes
* can specify a default --user for playbooks rather than specifying it
in the playbook file
* able to specify ansible port in ansible host file (see docs)
* refactored Inventory API to make it easier to write scripts using Ansible
* looping capability for playbooks (with_items)
* support for using sudo with a password
* module arguments can be unicode
* A local connection type, --connection=local,  for use with cron or
in kickstarts
* better module debugging with -D
* fetch module for pulling in files from remote hosts
* command task supports creates=foo for idempotent semantics, won't run if file foo already exists

0.0.2 and 0.0.1

* Initial stages of project

