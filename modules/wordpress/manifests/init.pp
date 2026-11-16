class wordpress {
  
  Exec {
    path     => ['/usr/local/bin', '/usr/bin', '/bin', '/usr/sbin', '/sbin'],
    provider => shell,
  }

  file { '/srv/www':
    ensure => directory,
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  exec { 'installation-directory':
    command => 'curl -sSL https://wordpress.org/latest.tar.gz | tar zx -C /srv/www',
    creates => '/srv/www/wordpress/wp-settings.php',
    require => File['/srv/www'],
  }

  exec { 'wordpress-permissions':
    command     => 'chown -R www-data:www-data /srv/www/wordpress',
    refreshonly => true,
    subscribe   => Exec['installation-directory'],
  }

  Exec['installation-directory']
  -> Exec['wordpress-permissions']
  -> File['/srv/www/wordpress/wp-config.php']

  file { '/srv/www/wordpress/wp-config.php':
    ensure  => file,
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0640',
    content => template('wordpress/wp-config.php.erb'),
    require => Exec['installation-directory'],
  }

  file { '/etc/apache2/sites-available/wordpress.conf':
    ensure  => file,
    content => template('wordpress/wordpress-conf.erb'),
    require => Package['apache2'],
    notify  => Service['apache2'],
  }

  exec { 'enable-wordpress-site':
    command => 'a2ensite wordpress',
    creates => '/etc/apache2/sites-enabled/wordpress.conf',
    require => [
      Package['apache2'],
      File['/etc/apache2/sites-available/wordpress.conf'],
    ],
    notify  => Service['apache2'],
  }

  exec { 'enable-apache-rewrite':
    command => 'a2enmod rewrite',
    creates => '/etc/apache2/mods-enabled/rewrite.load',
    require => Package['apache2'],
    notify  => Service['apache2'],
  }

  exec { 'install-wp-cli':
    command => 'curl -sSLo /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod 0755 /usr/local/bin/wp',
    creates => '/usr/local/bin/wp',
    require => Package['php']
  }

  exec { 'wordpress-install':
    user    => 'www-data',
    command => "wp core install --url=${wp_url} --title=wp-cli --admin_user=${wp_admin_user} --admin_password=${wp_admin_pass} --admin_email=admin@example.com --path='/srv/www/wordpress'",
    unless  => 'wp core is-installed',
    require => Exec['install-wp-cli'],
  }
}
