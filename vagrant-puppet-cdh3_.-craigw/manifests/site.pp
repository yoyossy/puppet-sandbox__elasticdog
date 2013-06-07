node base {
  exec { "disable iptables":
    command => "/sbin/iptables -F"
  }
}

node default inherits base {
  crit "$fqdn has not been configured"
}

node /^primary-namenode-\d{3}\.hadoop\.dev$/ inherits base {
  include hadoop::namenode
}

node /^job-tracker-\d{3}\.hadoop\.dev$/ inherits base {
  include hadoop::jobtracker
}

node /^datanode-\d{3}\.hadoop\.dev$/ inherits base {
  include hadoop::datanode
  include hadoop::tasktracker
}

class java::install {
  package { "java-1.6.0-openjdk": ensure => installed }
}

class hadoop::params {
  #_ INSTALLATION _#
  $repo_base_url = "http://archive.cloudera.com/redhat/6/x86_64/cdh/3u5/"
  $repo_gpgkey_url = "http://archive.cloudera.com/redhat/6/x86_64/cdh/RPM-GPG-KEY-cloudera"
  $base_package_name = "hadoop-0.20"
  $namenode_package_name = "hadoop-0.20-namenode"
  $datanode_package_name = "hadoop-0.20-datanode"
  $jobtracker_package_name = "hadoop-0.20-jobtracker"
  $tasktracker_package_name = "hadoop-0.20-tasktracker"

  #_ SERVICES _#
  $namenode_service_name = "hadoop-0.20-namenode"
  $datanode_service_name = "hadoop-0.20-datanode"
  $jobtracker_service_name = "hadoop-0.20-jobtracker"
  $tasktracker_service_name = "hadoop-0.20-tasktracker"

  #_ GENERIC _#
  $cluster_name = "dev"
  $config_root = "/etc/hadoop-0.20"

  #_ CORE SITE _#
  $fs_default_name                = 'hdfs://primary-namenode-001.hadoop.dev:8020'
  $hadoop_tmp_dir                 = '/tmp/hadoop'
  $fs_trash_interval              = '15'
  $topology_script_file_name      = "${hadoop::params::config_root}/conf/rack.sh"
  $local_cache_size               = '1073741824'
  $io_compression_codecs          = 'org.apache.hadoop.io.compress.GzipCodec,org.apache.hadoop.io.compress.DefaultCodec,org.apache.hadoop.io.compress.BZip2Codec,org.apache.hadoop.io.compress.SnappyCodec'
  $io_compression_codec_lzo_class = 'com.hadoop.compression.lzo.LzoCodec'
  $io_file_buffer_size            = '65536'
  $io_sort_factor                 = '64'
  $io_sort_mb                     = '256'
  $hadoop_proxyuser               = { 'oozie' => ['hosts', '*', 'groups', '*'] }
  $webinterface_private_actions   = 'true'

  #_ CLUSTER HOSTS _#
  $cluster_dfs_hosts            = [ 'datanode-001.hadoop.dev', 'datanode-002.hadoop.dev', 'datanode-003.hadoop.dev', 'datanode-004.hadoop.dev', 'datanode-005.hadoop.dev', 'datanode-006.hadoop.dev' ]
  $cluster_dfs_hosts_exclude    = [ '' ]
  $cluster_mapred_hosts         = [ 'datanode-001.hadoop.dev', 'datanode-002.hadoop.dev', 'datanode-003.hadoop.dev', 'datanode-004.hadoop.dev', 'datanode-005.hadoop.dev', 'datanode-006.hadoop.dev' ]
  $cluster_mapred_hosts_exclude = [ '' ]

  #_ HDFS SITE _#
  $dfs_replication                       = '2'
  $dfs_permissions                       = 'false'
  $dfs_datanode_failed_volumes_tolerated = '0'
  $dfs_hosts                             = "${hadoop::params::config_root}/conf/dfs.hosts"
  $dfs_hosts_exclude                     = "${hadoop::params::config_root}/conf/dfs.hosts.exclude"
  $dfs_datanode_du_reserved              = '10737418240'
  $dfs_namenode_handler_count            = '64'
  $dfs_datanode_handler_count            = '10'
  $dfs_block_size                        = '134217728'
  $dfs_datanode_socket_write_timeout     = '0'
  $dfs_datanode_max_xcievers             = '4096'
  $dfs_balance_bandwidthpersec           = '104857600'
  $dfs_namenode_plugins                  = 'org.apache.hadoop.thriftfs.NamenodePlugin'
  $dfs_datanode_plugins                  = 'org.apache.hadoop.thriftfs.DatanodePlugin'
  $dfs_thrift_address                    = '0.0.0.0:9090'

  #_ MAPRED SITE _#
  $mapred_job_tracker                                  = 'job-tracker-001.hadoop.dev:8021'
  $mapred_hosts                                        = "${hadoop::params::config_root}/conf/mapred.hosts"
  $mapred_hosts_exclude                                = "${hadoop::params::config_root}/conf/mapred.hosts.exclude"
  $mapred_output_compression_codec                     = 'org.apache.hadoop.io.compress.BZip2Codec'
  $mapred_output_compression_type                      = 'BLOCK'
  $mapred_output_compress                              = 'false'
  $mapred_map_output_compression_codec                 = 'org.apache.hadoop.io.compress.BZip2Codec'
  $mapreduce_jobtracker_tasktracker_maxblacklists      = '4'
  $mapreduce_job_maxtaskfailures_per_tracker           = '4'
  $mapred_compress_map_output                          = 'false'
  $mapred_child_java_opts                              = '-Xms1024m -Xmx1024m'
  $mapred_child_ulimit                                 = '5242880'
  $tasktracker_http_threads                            = '80'
  $mapred_reduce_slowstart_completed_maps              = '0.60'
  $mapred_map_tasks_speculative_execution              = 'false'
  $mapred_reduce_tasks_speculative_execution           = 'false'
  $mapreduce_tasktracker_cache_local_numberdirectories = '200'
  $mapred_fairscheduler_allocation_file                = "${hadoop::params::config_root}/conf/fair-scheduler.xml"
  $mapred_fairscheduler_poolnameproperty               = 'user.name'
  $mapred_fairscheduler_preemption                     = 'true'
  $mapred_fairscheduler_sizebasedweight                = 'false'
  $mapred_fairscheduler_weightadjuster                 = 'org.apache.hadoop.mapred.NewJobWeightBooster'
  $mapred_newjobweightbooster_factor                   = '3'
  $mapred_newjobweightbooster_duration                 = '300000'
  $mapred_job_reuse_jvm_num_tasks                      = '1'
  $hadoop_job_history_user_location                    = 'none'
  $mapred_jobtracker_completeuserjobs_maximum          = '15'
  $mapred_job_tracker_handler_count                    = '64'
  $mapred_tasktracker_map_tasks_maximum                = '2'
  $mapred_submit_replication                           = '2'
  $mapred_tasktracker_reduce_tasks_maximum             = '2'
  $mapred_userlog_retain_hours                         = '8'
  $mapred_reduce_parallel_copies                       = '10'
  $jobtracker_thrift_address                           = '0.0.0.0:9290'
  $mapred_jobtracker_plugins                           = 'org.apache.hadoop.thriftfs.ThriftJobTrackerPlugin'
  $mapred_jobtracker_taskscheduler                     = 'org.apache.hadoop.mapred.FairScheduler'

  #_ CAPACITY SCHEDULER _#
  $mapred_capacity_scheduler_default_supports_priority                 = 'false'
  $mapred_capacity_scheduler_default_minimum_user_limit_percent        = '100'
  $mapred_capacity_scheduler_default_maximum_initialized_jobs_per_user = '2'
  $mapred_capacity_scheduler_init_poll_interval                        = '5000'
  $mapred_capacity_scheduler_init_worker_threads                       = '5'

  #_ CAPACITY SCHEDULER QUEUES _#
  $capacity_queues = { 'default' => [ 'capacity', '100', 'supports-priority', 'false', 'minimum-user-limit-percent', '100', 'maximum-initialized-jobs-per-user', '2'] }

  #_ FAIR SCHEDULER _#
  $poolmaxjobsdefault               = '150'
  $usermaxjobsdefault               = '150'
  $defaultminsharepreemptiontimeout = '600'
  $fairsharepreemptiontimeout       = '600'

  #_ FAIR SCHEDULER QUEUES _#
  $fair_pool_queues = { 'pool1' => [ 'minMaps', '10', 'minReduces', '5', 'maxRunningJobs', '10', 'minSharePreemptionTimeout', '300', 'weight', '1.0' ] }
  $fair_user_queues = { 'user1' => [ 'maxRunningJobs', '10' ] }

  #_ QUEUE ACLS _#
  $hadoop_queues_acl = { 'default' => [ 'acl-submit-job', '', 'acl-administer-jobs', '' ] }

  #_ HADOOP ENVIRONMENT _#
  $java_home                     = '/usr/lib/jvm/java-1.6.0-openjdk-1.6.0.0.x86_64/jre/'
  $hadoop_home                   = '/usr/lib/hadoop'
  $hadoop_classpath              = [ '${HADOOP_CLASSPATH}:$HADOOP_HOME/lib/hadoop-lzo-0.4.10.jar:/etc/hbase/conf:/usr/lib/hbase/hbase-0.92.1.jar:/usr/lib/hbase/lib/zookeeper-3.4.3.jar' ]
  $java_library_path             = [ '$HADOOP_HOME/lib/native/Linux-amd64-64' ]
  $hadoop_heapsize               = '2048'
  $hadoop_opts                   = [ '-server -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false' ]
  $hadoop_namenode_opts          = [ '-Dcom.sun.management.jmxremote $HADOOP_NAMENODE_OPTS -Dcom.sun.management.jmxremote.port=8004' ]
  $hadoop_secondarynamenode_opts = [ '-Dcom.sun.management.jmxremote $HADOOP_SECONDARYNAMENODE_OPTS -Dcom.sun.management.jmxremote.port=8015' ]
  $hadoop_datanode_opts          = [ '-Dcom.sun.management.jmxremote $HADOOP_DATANODE_OPTS -Dcom.sun.management.jmxremote.port=8006' ]
  $hadoop_balancer_opts          = [ '-Dcom.sun.management.jmxremote $HADOOP_BALANCER_OPTS -Dcom.sun.management.jmxremote.port=8007' ]
  $hadoop_jobtracker_opts        = [ '-Dcom.sun.management.jmxremote $HADOOP_JOBTRACKER_OPTS -Dcom.sun.management.jmxremote.port=8008' ]
  $hadoop_tasktracker_opts       = [ '-Dcom.sun.management.jmxremote.port=8009' ]
  $env_include                   = [ 'RUN_COMMAND=$(echo $HADOOP_LOGFILE|cut -d"-" -f3|tr "[a-z]" "[A-Z]")', 'eval RUN_USER=\"\$HADOOP_${RUN_COMMAND}_USER\"', 'JMX_SUFFIX="${RUN_USER:+.}$RUN_USER"' ]

  #_ METRICS _#
  $dfs_class      = 'org.apache.hadoop.hbase.metrics.file.TimeStampingFileContext'
  $dfs_period     = '60'
  $dfs_opts       = { 'dfs.fileName' => '/var/log/hadoop/dfs-metrics.out' }
  $mapred_class   = 'org.apache.hadoop.hbase.metrics.file.TimeStampingFileContext'
  $mapred_period  = '60'
  $mapred_opts    = { 'mapred.fileName' => '/var/log/hadoop/mapred-metrics.out' }
  $jvm_class      = 'org.apache.hadoop.hbase.metrics.file.TimeStampingFileContext'
  $jvm_period     = '60'
  $jvm_opts       = { 'jvm.fileName' => '/var/log/hadoop/jvm-metrics.out'}
  $rpc_class      = 'org.apache.hadoop.hbase.metrics.file.TimeStampingFileContext'
  $rpc_period     = '60'
  $rpc_opts       = { 'rpc.fileName' => '/var/log/hadoop/rpc-metrics.out' }

  #_ HADOOP SECURITY POLICY _#
  $security_client_protocol_acl          = '*'
  $security_client_datanode_protocol_acl = '*'
  $security_datanode_protocol_acl        = '*'
  $security_inter_datanode_protocol_acl  = '*'
  $security_namenode_protocol_acl        = '*'
  $security_inter_tracker_protocol_acl   = '*'
  $security_job_submission_protocol_acl  = '*'
  $security_task_umbilical_protocol_acl  = '*'
  $security_refresh_policy_protocol_acl  = '*'

  #_ DATA VOLUMES _#
  # NOTE: If data_volumes is empty, then this will assign it to '/var/lib/hadoop-0.20/cache'
  if !($data_volumes) { $data_volumes = '/var/lib/hadoop-0.20/cache' }
}

class hadoop::hosts {
  host { "primary-namenode-001.hadoop.dev":
    ip => "192.168.33.101",
    host_aliases => "primary-namenode-001"
  }

  host { "job-tracker-001.hadoop.dev":
    ip => "192.168.33.111",
    host_aliases => "job-tracker-001"
  }

  host { "datanode-001.hadoop.dev":
    ip => "192.168.33.121",
    host_aliases => "datanode-001"
  }

  host { "datanode-002.hadoop.dev":
    ip => "192.168.33.122",
    host_aliases => "datanode-002"
  }

  host { "datanode-003.hadoop.dev":
    ip => "192.168.33.123",
    host_aliases => "datanode-003"
  }

  host { "datanode-004.hadoop.dev":
    ip => "192.168.33.124",
    host_aliases => "datanode-004"
  }

  host { "datanode-005.hadoop.dev":
    ip => "192.168.33.125",
    host_aliases => "datanode-005"
  }

  host { "datanode-006.hadoop.dev":
    ip => "192.168.33.126",
    host_aliases => "datanode-006"
  }

  host { "datanode-007.hadoop.dev":
    ip => "192.168.33.127",
    host_aliases => "datanode-007"
  }

  host { "datanode-008.hadoop.dev":
    ip => "192.168.33.128",
    host_aliases => "datanode-008"
  }

  host { "datanode-009.hadoop.dev":
    ip => "192.168.33.129",
    host_aliases => "datanode-009"
  }

  host { "datanode-010.hadoop.dev":
    ip => "192.168.33.130",
    host_aliases => "datanode-010"
  }

  host { "datanode-011.hadoop.dev":
    ip => "192.168.33.131",
    host_aliases => "datanode-011"
  }

  host { "datanode-012.hadoop.dev":
    ip => "192.168.33.132",
    host_aliases => "datanode-012"
  }

  host { "datanode-013.hadoop.dev":
    ip => "192.168.33.133",
    host_aliases => "datanode-013"
  }

  host { "datanode-014.hadoop.dev":
    ip => "192.168.33.134",
    host_aliases => "datanode-014"
  }

  host { "datanode-015.hadoop.dev":
    ip => "192.168.33.135",
    host_aliases => "datanode-015"
  }

  host { "datanode-016.hadoop.dev":
    ip => "192.168.33.136",
    host_aliases => "datanode-016"
  }

  host { "datanode-017.hadoop.dev":
    ip => "192.168.33.137",
    host_aliases => "datanode-017"
  }

  host { "datanode-018.hadoop.dev":
    ip => "192.168.33.138",
    host_aliases => "datanode-018"
  }

  host { "datanode-019.hadoop.dev":
    ip => "192.168.33.139",
    host_aliases => "datanode-019"
  }

  host { "datanode-020.hadoop.dev":
    ip => "192.168.33.140",
    host_aliases => "datanode-020"
  }

  host { "datanode-021.hadoop.dev":
    ip => "192.168.33.141",
    host_aliases => "datanode-021"
  }

  host { "datanode-022.hadoop.dev":
    ip => "192.168.33.142",
    host_aliases => "datanode-022"
  }

  host { "datanode-023.hadoop.dev":
    ip => "192.168.33.143",
    host_aliases => "datanode-023"
  }

  host { "datanode-024.hadoop.dev":
    ip => "192.168.33.144",
    host_aliases => "datanode-024"
  }

  host { "datanode-025.hadoop.dev":
    ip => "192.168.33.145",
    host_aliases => "datanode-025"
  }

  host { "datanode-026.hadoop.dev":
    ip => "192.168.33.146",
    host_aliases => "datanode-026"
  }

  host { "datanode-027.hadoop.dev":
    ip => "192.168.33.147",
    host_aliases => "datanode-027"
  }

  host { "datanode-028.hadoop.dev":
    ip => "192.168.33.148",
    host_aliases => "datanode-028"
  }

  host { "datanode-029.hadoop.dev":
    ip => "192.168.33.149",
    host_aliases => "datanode-029"
  }

  host { "datanode-030.hadoop.dev":
    ip => "192.168.33.150",
    host_aliases => "datanode-030"
  }

  host { "datanode-031.hadoop.dev":
    ip => "192.168.33.151",
    host_aliases => "datanode-031"
  }

  host { "datanode-032.hadoop.dev":
    ip => "192.168.33.152",
    host_aliases => "datanode-032"
  }

  host { "datanode-033.hadoop.dev":
    ip => "192.168.33.153",
    host_aliases => "datanode-033"
  }

  host { "datanode-034.hadoop.dev":
    ip => "192.168.33.154",
    host_aliases => "datanode-034"
  }

  host { "datanode-035.hadoop.dev":
    ip => "192.168.33.155",
    host_aliases => "datanode-035"
  }

  host { "datanode-036.hadoop.dev":
    ip => "192.168.33.156",
    host_aliases => "datanode-036"
  }

  host { "datanode-037.hadoop.dev":
    ip => "192.168.33.157",
    host_aliases => "datanode-037"
  }

  host { "datanode-038.hadoop.dev":
    ip => "192.168.33.158",
    host_aliases => "datanode-038"
  }

  host { "datanode-039.hadoop.dev":
    ip => "192.168.33.159",
    host_aliases => "datanode-039"
  }

  host { "datanode-040.hadoop.dev":
    ip => "192.168.33.160",
    host_aliases => "datanode-040"
  }

  host { "datanode-041.hadoop.dev":
    ip => "192.168.33.161",
    host_aliases => "datanode-041"
  }

  host { "datanode-042.hadoop.dev":
    ip => "192.168.33.162",
    host_aliases => "datanode-042"
  }

  host { "datanode-043.hadoop.dev":
    ip => "192.168.33.163",
    host_aliases => "datanode-043"
  }

  host { "datanode-044.hadoop.dev":
    ip => "192.168.33.164",
    host_aliases => "datanode-044"
  }

  host { "datanode-045.hadoop.dev":
    ip => "192.168.33.165",
    host_aliases => "datanode-045"
  }

  host { "datanode-046.hadoop.dev":
    ip => "192.168.33.166",
    host_aliases => "datanode-046"
  }

  host { "datanode-047.hadoop.dev":
    ip => "192.168.33.167",
    host_aliases => "datanode-047"
  }

  host { "datanode-048.hadoop.dev":
    ip => "192.168.33.168",
    host_aliases => "datanode-048"
  }

  host { "datanode-049.hadoop.dev":
    ip => "192.168.33.169",
    host_aliases => "datanode-049"
  }

  host { "datanode-050.hadoop.dev":
    ip => "192.168.33.170",
    host_aliases => "datanode-050"
  }

  host { "datanode-051.hadoop.dev":
    ip => "192.168.33.171",
    host_aliases => "datanode-051"
  }

  host { "datanode-052.hadoop.dev":
    ip => "192.168.33.172",
    host_aliases => "datanode-052"
  }

  host { "datanode-053.hadoop.dev":
    ip => "192.168.33.173",
    host_aliases => "datanode-053"
  }

  host { "datanode-054.hadoop.dev":
    ip => "192.168.33.174",
    host_aliases => "datanode-054"
  }

  host { "datanode-055.hadoop.dev":
    ip => "192.168.33.175",
    host_aliases => "datanode-055"
  }

  host { "datanode-056.hadoop.dev":
    ip => "192.168.33.176",
    host_aliases => "datanode-056"
  }

  host { "datanode-057.hadoop.dev":
    ip => "192.168.33.177",
    host_aliases => "datanode-057"
  }

  host { "datanode-058.hadoop.dev":
    ip => "192.168.33.178",
    host_aliases => "datanode-058"
  }

  host { "datanode-059.hadoop.dev":
    ip => "192.168.33.179",
    host_aliases => "datanode-059"
  }

  host { "datanode-060.hadoop.dev":
    ip => "192.168.33.180",
    host_aliases => "datanode-060"
  }
}

class hadoop::install {
  package { $hadoop::params::base_package_name:
    ensure => installed
  }

  exec { "create data volumes cache root":
    command => "/bin/mkdir -p $hadoop::params::data_volumes",
    creates => $hadoop::params::data_volumes
  }

  file { [ "/tmp/hadoop", $hadoop::params::data_volumes ]:
    ensure => directory,
    mode => 0777,
    owner => 'hdfs',
    group => 'hdfs',
    recurse => true,
    require => [ Exec["create data volumes cache root"], Package[$hadoop::params::base_package_name] ]
  }

  exec { "create data volumes mapreduce root":
    command => "/bin/mkdir -p {/tmp,${hadoop::params::data_volumes}}/hadoop/mapred/local",
    creates => "${hadoop::params::data_volumes}/hadoop/mapred/local",
  }

  file { [ "/tmp/hadoop/mapred/local", "${hadoop::params::data_volumes}/hadoop/mapred/local" ]:
    ensure => directory,
    owner => "mapred",
    group => "hadoop",
    mode => 0777,
    require => [ Exec["create data volumes mapreduce root"], Package[$hadoop::params::base_package_name] ]
  }

  file { "${hadoop::params::config_root}/conf.${hadoop::params::cluster_name}":
    ensure => directory,
    require => Package[$hadoop::params::base_package_name]
  }
}

class hadoop::configure {
  include hadoop::hosts
  include hadoop::install

  Class["hadoop::install"] -> Class["hadoop::configure"]

  file { "${hadoop::params::config_root}/conf.${hadoop::params::cluster_name}/hdfs-site.xml":
    content => template('hadoop/hdfs-site.xml.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644'
  }

  file { "${hadoop::params::config_root}/conf.${hadoop::params::cluster_name}/dfs.hosts":
    content => template('hadoop/dfs.hosts.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644'
  }

  file { "${hadoop::params::config_root}/conf.${hadoop::params::cluster_name}/dfs.hosts.exclude":
    content => template('hadoop/dfs.hosts.exclude.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644'
  }

  file { "${hadoop::params::config_root}/conf.${hadoop::params::cluster_name}/mapred.hosts":
    content => template('hadoop/mapred.hosts.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644'
  }

  file { "${hadoop::params::config_root}/conf.${hadoop::params::cluster_name}/mapred.hosts.exclude":
    content => template('hadoop/mapred.hosts.exclude.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644'
  }

  file { "${hadoop::params::config_root}/conf.${hadoop::params::cluster_name}/rack.sh":
    content => template('hadoop/rack.sh.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0755'
  }

  file { "${hadoop::params::config_root}/conf.${hadoop::params::cluster_name}/core-site.xml":
    content => template('hadoop/core-site.xml.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644'
  }

  file { "${hadoop::params::config_root}/conf.${hadoop::params::cluster_name}/mapred-site.xml":
    content => template('hadoop/mapred-site.xml.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644'
  }

  file { "${hadoop::params::config_root}/conf.${hadoop::params::cluster_name}/capacity-scheduler.xml":
    content => template('hadoop/capacity-scheduler.xml.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644'
  }

  file { "${hadoop::params::config_root}/conf.${hadoop::params::cluster_name}/fair-scheduler.xml":
    content => template('hadoop/fair-scheduler.xml.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644'
  }

  file { "${hadoop::params::config_root}/conf.${hadoop::params::cluster_name}/hadoop-env.sh":
    content => template('hadoop/hadoop-env.sh.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644'
  }

  file { "${hadoop::params::config_root}/conf.${hadoop::params::cluster_name}/hadoop-metrics.properties":
    content => template('hadoop/hadoop-metrics.properties.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644'
  }

  file { "${hadoop::params::config_root}/conf.${hadoop::params::cluster_name}/hadoop-policy.xml":
    content => template('hadoop/hadoop-policy.xml.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644'
  }

  file { "${hadoop::params::config_root}/conf.${hadoop::params::cluster_name}/mapred-queue-acls.xml":
    content => template('hadoop/mapred-queue-acls.xml.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644'
  }

  file { "${hadoop::params::config_root}/conf":
    ensure => link,
    target => "${hadoop::params::config_root}/conf.${hadoop::params::cluster_name}"
  }
}

class hadoop::base {
  include java::install
  include hadoop::params
  include hadoop::configure

  yumrepo { cloudera-cdh3:
    baseurl  => $hadoop::params::repo_base_url,
    descr    => "Cloudera Distribution for Hadoop, Version 4",
    enabled  => 1,
    priority => 1,
    gpgcheck => 1,
    gpgkey => $hadoop::params::repo_gpgkey_url;
  }

  Package <||> { require => Yumrepo["cloudera-cdh3"] }
  Service <||> { require => [ Class["hadoop::hosts"], Class["hadoop::configure"], Class["java::install"] ] }
}

class hadoop::namenode {
  include hadoop::base

  include hadoop::namenode::install
  include hadoop::namenode::configure
  include hadoop::namenode::service

  Class["hadoop::base"] -> Class["hadoop::namenode"]
  Class["hadoop::namenode::install"] -> Class["hadoop::namenode::configure"]
  Class["hadoop::namenode::configure"] -> Class["hadoop::namenode::service"]
}

class hadoop::namenode::install {
  package { $hadoop::params::namenode_package_name:
    ensure => installed
  }
}

class hadoop::namenode::configure {
  exec { "format namenode":
    command => "/usr/bin/hadoop namenode -format",
    subscribe => Package[$hadoop::params::namenode_package_name],
    require => Class["hadoop::configure"],
    refreshonly => true,
    user => "hdfs"
  }
}

class hadoop::namenode::service {
  service { $hadoop::params::namenode_service_name:
    require => Package[$hadoop::params::namenode_package_name],
    enable  => true,
    ensure => running
  }
}

class hadoop::jobtracker {
  include hadoop::base

  include hadoop::jobtracker::install
  include hadoop::jobtracker::service

  Class["hadoop::base"] -> Class["hadoop::jobtracker"]
  Class["hadoop::jobtracker::install"] -> Class["hadoop::jobtracker::service"]
}

class hadoop::jobtracker::install {
  package { $hadoop::params::jobtracker_package_name:
    ensure => installed
  }
}

class hadoop::jobtracker::service {
  service { $hadoop::params::jobtracker_service_name:
    require => Package[$hadoop::params::jobtracker_package_name],
    enable  => true,
    ensure => running
  }
}

class hadoop::datanode {
  include hadoop::base

  include hadoop::datanode::install
  include hadoop::datanode::service

  Class["hadoop::base"] -> Class["hadoop::datanode"]
  Class["hadoop::datanode::install"] -> Class["hadoop::datanode::service"]
}

class hadoop::datanode::install {
  file { "/tmp/hadoop/dfs":
    ensure => directory,
    owner => "hdfs",
    group => "hadoop"
  }

  file { "/tmp/hadoop/dfs/data":
    ensure => directory,
    owner => "hdfs",
    group => "hadoop",
    require => File["/tmp/hadoop/dfs"]
  }

  package { $hadoop::params::datanode_package_name:
    ensure => installed
  }
}

class hadoop::datanode::service {
  service { $hadoop::params::datanode_service_name:
    require => Package[$hadoop::params::datanode_package_name],
    enable  => true,
    ensure => running
  }
}

class hadoop::tasktracker {
  include hadoop::base

  include hadoop::tasktracker::install
  include hadoop::tasktracker::service

  Class["hadoop::base"] -> Class["hadoop::tasktracker"]
  Class["hadoop::tasktracker::install"] -> Class["hadoop::tasktracker::service"]
}

class hadoop::tasktracker::install {
  package { $hadoop::params::tasktracker_package_name:
    ensure => installed
  }
}

class hadoop::tasktracker::service {
  service { $hadoop::params::tasktracker_service_name:
    require => Package[$hadoop::params::tasktracker_package_name],
    enable  => true,
    ensure => running
  }
}
