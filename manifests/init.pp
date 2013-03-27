class pow inherits dnsmasq {
  package { "pow": }

  $home = "/Users/${::luser}"

  file { "${home}/.pow":
    target  => "${home}/Library/Application Support/Pow/Hosts",
    ensure  => "link",
    require => Package["pow"]
  }

  # Set up firewall
  file { "/etc/resolver/dev":
    source  => "puppet://modules/pow/resolver",
    user    => "root",
    unless  => "test -f /etc/resolver/dev",
    require => Package["pow"]
  }->
  file { "/Library/LaunchDaemons/cx.pow.firewall.plist":
    source  => "puppet:///modules/pow/firewall.plist",
    user    => "root",
    unless  => "test -f /Library/LaunchDaemons/cx.pow.firewall.plist",
  }->
  exec { "enable firewall launchd":
    command => "launchctl load -w /Library/LaunchDaemons/cx.pow.firewall.plist",
    user    => "root"
  }

  # launch at login
  file { "${home}/Library/LaunchAgents/cx.pow.powd.plist":
    source  => "puppet:///modules/pow/powd.plist",
    unless  => "test -f /Library/LaunchDaemons/cx.pow.powd.plist",
    require => Package["pow"]
  }->
  exec { "enable login launchd":
    command => "launchctl load -w ${home}/Library/LaunchAgents/cx.pow.powd.plist"
  }
}

