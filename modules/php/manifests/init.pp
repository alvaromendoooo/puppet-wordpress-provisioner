class php {

  package { [
    'php', 
    'libapache2-mod-php',
    'php-curl',
    'php-mysqli',
    'php-gd',
    'php-xml',
    'php-mbstring',
    'php-zip',
    'php-intl'
  ]:
    ensure  => installed,
    require => Package['apache2'],
    notify  => Service['apache2'],
  }
}
