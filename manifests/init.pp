class pow {
  package { "pow": }

  $home = "/Users/${::luser}"

  file { ["${home}/Library/Application Support/Pow", "${home}/Library/Application Support/Pow/Hosts"]:
    ensure  => "directory",
    require => Package["pow"]
  }->
  file { "${home}/.pow":
    target  => "${home}/Library/Application Support/Pow/Hosts",
    ensure  => "link",
  }

  file { '/etc/resolver':
    ensure => directory,
    group  => 'wheel',
    owner  => 'root'
  }

  # Set up firewall
  file { '/etc/resolver/dev':
    content => "nameserver 127.0.0.1\nport 20559",
    group   => 'wheel',
    owner   => 'root',
    require => File['/etc/resolver']
  }

  file { "/Library/LaunchDaemons/cx.pow.firewall.plist":
    source  => "puppet:///modules/pow/firewall.plist",
    owner   => "root",
    group   => "wheel",
    require => Package["pow"]
  }->
  exec { "enable firewall launchd":
    command => "launchctl load -w /Library/LaunchDaemons/cx.pow.firewall.plist",
    user    => "root"
  }

  # launch at login
  file { "${home}/Library/LaunchAgents/cx.pow.powd.plist":
    source  => "puppet:///modules/pow/powd.plist",
    require => Package["pow"]
  }->
  exec { "enable login launchd":
    command => "launchctl load -w ${home}/Library/LaunchAgents/cx.pow.powd.plist"
  }
}

