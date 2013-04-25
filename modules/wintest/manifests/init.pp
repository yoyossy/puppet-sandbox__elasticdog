class wintest { 

  file {'C:/temp':
  ensure => 'directory'}

  file{'C:/temp/pup':
  ensure => 'directory',
  require => File['C:/temp']}

  file{ 'C:/temp/pup/et':
  ensure => 'present',
  content => 'look at me',
  require => File['C:/temp/pup']}



  file { 'c:/temp/hello.txt': 
  ensure => 'present',
  content => 'Hello master!' } 
}