class pow {
  package { "pow": }

  $home = "/Users/${::luser}"

  file { "${home}/.pow":
    target  => "${home}/Library/Application Support/Pow/Hosts",
    ensure  => "link",
    require => Package["pow"]
  }

  # Set up firewall
  exec { "set up firewall rules":
    command => "pow --install-system",
    user    => "root",
    unless  => "test -f /Library/LaunchDaemons/cx.pow.firewall.plist"
  }->
  exec { "enable firewall launchd":
    command => "launchctl load -w /Library/LaunchDaemons/cx.pow.firewall.plist",
    user    => "root",
    unless  => "test -f /Library/LaunchDaemons/cx.pow.firewall.plist"
  }

  # launch at login
  exec { "set up to start at login":
    command => "pow --install-local,
    unless  => "test -f ${home}/Library/LaunchAgents/cx.pow.powd.plist"
  }->
  exec { "enable login launchd":
    command => "launchctl load -w ${home}/Library/LaunchAgents/cx.pow.powd.plist",
    unless  => "test -f ${home}/Library/LaunchAgents/cx.pow.powd.plist"
  }
}

