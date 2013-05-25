file { "/etc/apt/sources.list.d/jenkins-docker-plugin.list":
    content => "deb http://ppa.launchpad.net/dotcloud/lxc-docker/ubuntu precise main",
}

exec { "ppa key":
    command     => "/usr/bin/apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 63561DC6",
    subscribe   => File["/etc/apt/sources.list.d/jenkins-docker-plugin.list"],
    refreshonly => true,
}

exec { "apt-get update":
  path    => "/usr/bin",
  require => File["/etc/apt/sources.list.d/jenkins-docker-plugin.list"],
}

Exec["apt-get update"] -> Package <| |>

package { ["git", "rbenv", "openjdk-7-jre", "build-essential", "lxc-docker", "linux-image-generic-lts-raring"]:
    ensure => installed,
}

exec { "clone ruby-build":
    command => "/usr/bin/git clone https://github.com/sstephenson/ruby-build.git /home/vagrant/ruby-build",
    creates => "/home/vagrant/ruby-build",
    require => Package["git"]
}

exec { "install jruby":
    command => "/home/vagrant/ruby-build/bin/ruby-build jruby-1.7.3 /home/vagrant/.rbenv/versions/jruby-1.7.3",
    creates => "/home/vagrant/.rbenv/versions/jruby-1.7.3",
    require => [Package["rbenv", "openjdk-7-jre", "build-essential"], Exec["clone ruby-build"]],
}

exec { "/usr/bin/rbenv global jruby-1.7.3":
    require => Exec["install jruby"],
}

file { "/etc/profile.d/rbenv.sh":
    content => "export PATH=\"/home/vagrant/.rbenv/shims:\${PATH}\""
}

exec { "install jpi":
    command => "/home/vagrant/.rbenv/shims/gem install jpi",
    onlyif  => "/usr/bin/test ! -d /home/vagrant/.rbenv/versions/jruby-1.7.3/lib/ruby/gems/shared/gems/jpi-*/",
}

