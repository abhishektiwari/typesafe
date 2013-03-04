# == Class: typesafe::play
# Installs play framework
# Goes into manifests/play.pp

class typesafe::play ($version="2.1.0", $user="vagrant", $group="vagrant", $local_installer="false") {
	# Install play
	if $local_installer == "true" {
		file { "/home/${user}/play-${version}.zip":
			ensure => present,
			path   => "/home/${user}/play-${version}.zip",
			source => "puppet:///files/play-${version}.zip",
			before => Exec['typesafe-play'],
		}
	}
	else {
		exec { "typesafe-play-installer":
			cwd     => "/home/${user}",
			command => "wget http://downloads.typesafe.com/play/${version}/play-${version}.zip",
			creates => "/home/${user}/play-${version}.zip",
			before  => Exec['typesafe-play'],
			timeout => 900,
		}
	}
	exec { "typesafe-play":
		cwd     => "/home/${user}",
		user    => $user,
		group   => $group,
		command => "unzip play-${version}.zip",
		creates => "/home/${user}/play-${version}",
		before  => File["/etc/profile.d/set_play.sh"],
		require => [File['/usr/bin/scala'], Package['unzip']],
	}

	# Create play profile
	file {"/etc/profile.d/set_play.sh":
		ensure  => present,
		owner   => root,
		group   => root,
		mode    => 0644,
		content => template("typesafe/play.options"),
	}
}