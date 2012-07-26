# /etc/puppet/modules/java/manifests/params.pp

class java::params {

        $architecture = $::hostname ? {
            default	=> "x64",
        }
        $java_version = $::hostname ? {
            default	=> "1.6.0_31",
        }
        $java_base = $::hostname ? {
            default     => "/usr/local",
        }
}
