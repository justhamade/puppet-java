# /etc/puppet/modules/java/manifests/init.pp

class java {

	require java::params
	
        file {"$java::params::java_base":
		ensure => "directory",
		owner => "root",
		group => "root",
		alias => "java-base"
	}
        
	file { "${java::params::java_base}/jdk${java::params::java_version}-${java::params::architecture}.tar.gz":
		mode => 0644,
		owner => root,
		group => root,
		source => "puppet:///modules/java/jdk${java::params::java_version}-${java::params::architecture}.tar.gz",
		alias => "java-source-tgz",
		before => Exec["untar-java"],
		require => File["java-base"]
	}
	
	exec { "untar jdk${java::params::java_version}-${java::params::architecture}.tar.gz":
		command => "tar -zxf jdk${java::params::java_version}-${java::params::architecture}.tar.gz",
		cwd => "${java::params::java_base}",
		creates => "${java::params::java_base}/jdk${java::params::java_version}-${java::params::architecture}",
		alias => "untar-java",
		refreshonly => true,
		subscribe => File["java-source-tgz"],
		before => File["java-app-dir"]
	}
	
	file { "${java::params::java_base}/jdk${java::params::java_version}-${java::params::architecture}":
		ensure => "directory",
		mode => 0644,
		owner => root,
		group => root,
		alias => "java-app-dir"
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
