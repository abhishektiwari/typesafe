# == Class: typesafe::scala
# Install Scala 2.10.0
# Goes into manifests/scala.pp

class typesafe::scala ($version="2.10.0", $local_installer="false") {
	# Install scala
	if $local_installer == "true" {
		file { "/usr/share/scala-${version}.tgz":
			ensure => present,
			path   => "/usr/share/scala-${version}.tgz",
			source => "puppet:///files/scala-${version}.tgz",
			before => Exec['typesafe-scala'],
		}
	}
	else {
		exec { "/usr/share/scala-${version}.tgz":
			cwd     => '/usr/share',
			command => "wget http://www.scala-lang.org/downloads/distrib/files/scala-${version}.tgz",
			creates => "/usr/share/scala-${version}.tgz",
			before  => Exec['typesafe-scala'],
			timeout => 1500,
		}
	}
	exec { "typesafe-scala":
			cwd     => '/usr/share',
			command => "tar -xvf scala-${version}.tgz",
			creates => "/usr/share/scala-${version}",
			before  => File["/etc/profile.d/set_scala.sh", "/usr/bin/scala", "/usr/bin/scalac", "/usr/bin/fsc"],
			require => Package['typesafe-stack'],
	}
	# Create symlink
	file { '/usr/bin/scala':
			ensure => link,
			target => "/usr/share/scala-${version}/bin/scala",
	}
	file { '/usr/bin/scalac':
			ensure => link,
			target => "/usr/share/scala-${version}/bin/scalac",
	}
	file { '/usr/bin/fsc':
			ensure => link,
			target => "/usr/share/scala-${version}/bin/fsc",
	}	    

	# Create scala profile
	file {"/etc/profile.d/set_scala.sh":
		ensure  => present,
		owner   => root,
		group   => root,
		mode    => 0644,
		content => template("typesafe/scala.options"),
	}
}