$document_root = '/apache_puppet'
$db_name          = lookup('mysql_server::db_name')
$db_username      = lookup('mysql_server::db_username')
$db_password      = lookup('mysql_server::db_password')
$auth_key         = lookup('wordpress::auth_key')
$secure_auth_key  = lookup('wordpress::secure_auth_key')
$logged_in_key    = lookup('wordpress::logged_in_key')
$nonce_key        = lookup('wordpress::nonce_key')
$auth_salt        = lookup('wordpress::auth_salt')
$secure_auth_salt = lookup('wordpress::secure_auth_salt')
$logged_in_salt   = lookup('wordpress::logged_in_salt')
$nonce_salt       = lookup('wordpress::nonce_salt')
$wp_url           = lookup('wordpress::wp_url')
$wp_admin_user    = lookup('wordpress::wp_admin_user')
$wp_admin_pass    = lookup('wordpress::wp_admin_pass')

include common
include apache
include mysql_server
include php
include wordpress


$ipv4_address = $facts['networking']['ip']
notify { 'Showing machine Facts':
  message => "Machine with ${::memory['system']['total']} of memory and ${::processorcount} processor/s.
              Please check access to http://${ipv4_address}",
}
