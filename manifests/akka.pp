# == Class: typesafe::akka
# Installs akka framework
# Goes into manifests/akka.pp


class typesafe::akka ($version="2.2.4", $user="vagrant", $group="vagrant", $local_installer="false") {
	# Install akka
	if $local_installer == "true" {
		file { "/home/${user}/akka-${version}.zip":
			ensure => present,
			path   => "/home/${user}/akka-${version}.zip",
			source => "puppet:///files/akka-${version}.zip",
			before => Exec['typesafe-akka'],
		}
	}
	else {
		exec { "typesafe-akka-installer":
			cwd     => "/home/${user}",
			command => "wget http://download.akka.io/downloads/akka-${version}.zip",
			creates => "/home/${user}/akka-${version}.zip",
			before  => Exec['typesafe-akka'],
			timeout => 900,
		}
	}
	exec { "typesafe-akka":
		cwd     => "/home/${user}",
		user    => $user,
		group   => $group,
		command => "unzip akka-${version}.zip",
		creates => "/home/${user}/akka-${version}",
		before  => File["/etc/profile.d/set_akka.sh"],
		require => [File['/usr/bin/scala'], Package['unzip']],
	}

	# Create akka profile
	file {"/etc/profile.d/set_akka.sh":
		ensure  => present,
		owner   => root,
		group   => root,
		mode    => 0644,
		content => template("typesafe/akka.options"),
	}
}