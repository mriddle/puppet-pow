class pow {
  package { "pow": }

  $home = "/Users/${::luser}"

  file { "${home}/.powconfig":
    ensure => present
  }->
  file_line { "make pow work with rbenv":
    line    => "export PATH=$(rbenv root)/shims:$(rbenv root)/bin:$PATH",
    path    => "${home}/.powconfig",
    require => Package["pow"]
  }
}

