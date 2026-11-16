class apache {

    package { 'apache2':
        ensure => installed,
    }

    file { '/etc/apache2/sites-enabled/000-default.conf':
        ensure  => absent,
        require => Package['apache2'],
    }

    service { 'apache2':
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        restart    => '/usr/sbin/apachectl configtest && /usr/sbin/service apache2 reload',
        require    => Package['apache2']
    }
}
