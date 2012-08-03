# /etc/puppet/modules/java/manifests/init.pp
class java {
  require java::params
  file { "${java::params::java_base}/jdk${java::params::java_version}-${java::params::architecture}.tar.gz":
    mode     => 0644,
    owner    => root,
    group    => root,
    source   => "puppet:///modules/java/jdk${java::params::java_version}-${java::params::architecture}.tar.gz",
    alias    => "java-tar",
  }
  exec { "untar jdk${java::params::java_version}-${java::params::architecture}.tar.gz":
    command     => "/bin/tar zxf jdk${java::params::java_version}-${java::params::architecture}.tar.gz",
    cwd         => "${java::params::java_base}",
    creates     => "${java::params::java_base}/jdk${java::params::java_version}-${java::params::architecture}",
    alias       => "untar-java",
    require     => File["java-tar"]
  }
  file { "${java::params::java_base}/jdk${java::params::java_version}-${java::params::architecture}":
    ensure    => "directory",
    mode      => 0644,
    owner     => root,
    group     => root,
    alias     => "java-app-dir",
    require   => Exec["untar-java"],
  }
  file { "/usr/local/java":
    ensure => "link",
    target => "${java::params::java_base}/jdk${java::params::java_version}-${java::params::architecture}",
  }
  file { "/etc/profile.d/set_java_home.sh":
    ensure => present,
    source => "puppet:///modules/java/set_java_home.sh"
  }
}
