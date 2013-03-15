# Set up pow to work with rbenv
class pow::rbenv {

  $home = "/Users/${::luser}"

  file { "${home}/.powconfig":
    source  => "puppet:///modules/pow/powconfig",
    require => [Package["pow"], Package["rbenv"]]
  }

  file { "${home}/.rbenv":
    target => "`rbenv root`",
    ensure => "link"
  }
}

