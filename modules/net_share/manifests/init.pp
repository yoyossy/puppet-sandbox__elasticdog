class net_share {
net_share {'PuppetTest':
  ensure        => present,
  path          => 'c:\temp',
  remark        => 'PuppetTest',
  maximumusers  => unlimited,
  cache         => none,
}
}
