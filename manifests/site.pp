
exec { "apt-get update":
  path => "/usr/bin",
}
Exec["apt-get update"] -> Package <| |>

package { ["git", "rbenv", "openjdk-7-jre", "build-essential"]:
    ensure => installed,
}

exec { "clone ruby-build":
    command => "/usr/bin/git clone https://github.com/sstephenson/ruby-build.git /home/vagrant/ruby-build",
    creates => "/home/vagrant/ruby-build",
    require => Package["git"]
}

exec { "install jruby":
    command => "/home/vagrant/ruby-build/bin/ruby-build jruby-1.7.4 /home/vagrant/.rbenv/versions/jruby-1.7.4",
    creates => "/home/vagrant/.rbenv/versions/jruby-1.7.4",
    require => [Package["rbenv", "openjdk-7-jre", "build-essential"], Exec["clone ruby-build"]],
}

exec { "/usr/bin/rbenv global jruby-1.7.4":
    require => Exec["install jruby"],
}

file { "/etc/profile.d/rbenv.sh":
    content => "export PATH=\"/home/vagrant/.rbenv/shims:\${PATH}\""
}

exec { "install jpi":
    command => "/home/vagrant/.rbenv/shims/gem install jpi",
    onlyif  => "/usr/bin/test ! -d /home/vagrant/.rbenv/versions/jruby-1.7.4/lib/ruby/gems/shared/gems/jpi-*/",
}

