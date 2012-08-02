# /etc/puppet/modules/java/manifests/params.pp

class java::params {

        $architecture = $::hostname ? {
            default	=> "x64",
        }
        $java_version = $::hostname ? {
            default	=> "6u31",
        }
        $java_base = $::hostname ? {
            default     => "/usr/local/java",
        }
}
