class wordpress::app (
  $install_dir,
  $install_url,
  $version,
  $db_name,
  $db_host,
  $db_user,
  $db_password,
  $wp_owner,
  $wp_group,
  $wp_lang,
  $wp_plugin_dir,
  $wp_additional_config,
  $wp_table_prefix,
  $wp_proxy_host,
  $wp_proxy_port,
  $wp_multisite,
  $wp_site_domain,
) {
  validate_string($install_dir,$install_url,$version,$db_name,$db_host,$db_user,$db_password,$wp_owner,$wp_group, $wp_lang, $wp_plugin_dir,$wp_additional_config,$wp_table_prefix,$wp_proxy_host,$wp_proxy_port,$wp_site_domain)
  validate_bool($wp_multisite)
  validate_absolute_path($install_dir)

  if $wp_multisite and ! $wp_site_domain {
    fail('wordpress class requires `wp_site_domain` parameter when `wp_multisite` is true')
  }

  ## Resource defaults
  File {
    owner  => $wp_owner,
    group  => $wp_group,
    mode   => '0644',
  }
  Exec {
    path      => ['/bin','/sbin','/usr/bin','/usr/sbin'],
    cwd       => $install_dir,
    logoutput => 'on_failure',
    user      => $wp_owner,
    group     => $wp_group,
  }

  ## Installation directory
  if ! defined(File[$install_dir]) {
    file { $install_dir:
      ensure  => directory,
      recurse => true,
    }
  } else {
    notice("Warning: cannot manage the permissions of ${install_dir}, as another resource (perhaps apache::vhost?) is managing it.")
  }

  ## Download and extract
  exec { 'Download wordpress':
    command => "wget ${install_url}/wordpress-${version}.tar.gz",
    creates => "${install_dir}/wordpress-${version}.tar.gz",
    require => File[$install_dir],
  }
  -> exec { 'Extract wordpress':
    command => "tar zxvf ./wordpress-${version}.tar.gz --strip-components=1",
    creates => "${install_dir}/index.php",
  }
  ~> exec { 'Change ownership':
    command     => "chown -R ${wp_owner}:${wp_group} ${install_dir}",
    refreshonly => true,
  }

  ## Configure wordpress
  #
  # Template uses no variables
  file { "${install_dir}/wp-keysalts.php":
    ensure  => present,
    content => template('wordpress/wp-keysalts.php.erb'),
    replace => false,
    require => Exec['Extract wordpress'],
  }
  concat { "${install_dir}/wp-config.php":
    owner   => $wp_owner,
    group   => $wp_group,
    mode    => '0755',
    require => Exec['Extract wordpress'],
  }
  concat::fragment { 'wp-config.php keysalts':
    target  => "${install_dir}/wp-config.php",
    source  => "${install_dir}/wp-keysalts.php",
    order   => '10',
    require => File["${install_dir}/wp-keysalts.php"],
  }
  # Template uses: $db_name, $db_user, $db_password, $db_host, $wp_proxy, $wp_proxy_host, $wp_proxy_port, $wp_multisite, $wp_site_domain
  concat::fragment { 'wp-config.php body':
    target  => "${install_dir}/wp-config.php",
    content => template('wordpress/wp-config.php.erb'),
    order   => '20',
  }
}
