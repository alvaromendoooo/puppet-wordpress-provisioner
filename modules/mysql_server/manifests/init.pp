class mysql_server {
  
  Exec {
    path     => '/usr/bin',
    provider => shell,
  }

  package { 'mysql-server':
    ensure => installed,
  }

  service { 'mysql':
    ensure   => running,
    enable   => true,
    require => Package['mysql-server'],
  }

  exec { 'create_wordpress_db':
    command => "mysql -e \"CREATE DATABASE ${db_name} CHARACTER SET utf8mb4;\"",
    unless  => "mysql -e \"USE ${db_name};\"",
    require => Service['mysql'],
  }

  exec { 'create_wordpress_user':
    command => "mysql -e \"CREATE USER '${db_username}'@'localhost' IDENTIFIED BY '${db_password}';\"",
    unless  => "mysql -e \"SELECT 1 FROM mysql.user WHERE user='${db_username}'\" | grep -q 1",
    require => Exec['create_wordpress_db'],
  }

  exec { 'grant_wp_user':
    command => "mysql -e \"GRANT ALL PRIVILEGES ON ${db_name}.* TO '${db_username}'@'localhost';\"",
    unless  => "mysql -e \"SHOW GRANTS FOR '${db_username}'@'localhost'\" | grep -qF 'ON \`${db_name}\`.*'",
    require => Exec['create_wordpress_user'],
  }
}
