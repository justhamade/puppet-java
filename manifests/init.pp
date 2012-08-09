# /etc/puppet/modules/java/manifests/init.pp
class java (  $base_dir                = $java::params::java_base,
              $version                 = $java::params::java_version,
              $architecture            = $java::params::architecture,
             ) inherits tomcat6::params {
  file { "${base_dir}/jdk${version}-${architecture}.tar.gz":
    mode     => 0644,
    owner    => root,
    group    => root,
    source   => "puppet:///modules/java/jdk${version}-${architecture}.tar.gz",
    alias    => "java-tar",
  }

  archive::extract { "jdk${version}-${architecture}":
    ensure  => present,
    target  => ${base_dir},
    src_target => ${base_dir},
    require => File["java-tar"],
    notify  => File["java-app-dir"],
  }
  file { "${base_dir}/jdk${version}-${architecture}":
    ensure    => "directory",
    mode      => 0644,
    owner     => root,
    group     => root,
    alias     => "java-app-dir",
    require   => Exec["untar-java"],
  }
  file { "/usr/local/java":
    ensure => "link",
    target => "${base_dir}/jdk${version}-${architecture}",
  }
  file { "/etc/profile.d/set_java_home.sh":
    ensure => present,
    source => "puppet:///modules/java/set_java_home.sh"
  }
}
