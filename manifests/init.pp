# == Class: typesafe
# Installs typesafe stack
# Goes into manifest.pp

class typesafe {
	# Set typesafe-repo
	exec { "typesafe-repo":
		cwd     => '/var/tmp',
		command => "wget http://apt.typesafe.com/repo-deb-build-0002.deb && sudo dpkg -i repo-deb-build-0002.deb",
		notify  => Exec['apt-update'],
		creates => "/var/tmp/repo-deb-build-0002.deb",
	}

	# Install typesafe stack, sbt and g8 only
	package { "typesafe-stack":
		ensure => present,
		require => Package['oracle-java7-installer'],
	}
}