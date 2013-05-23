Jenkins::Plugin::Specification.new do |plugin|
  plugin.name = "docker"
  plugin.display_name = "Docker Plugin"
  plugin.version = '0.0.1'
  plugin.description = 'Build Docker containers with Jenkins'

  plugin.url = 'https://wiki.jenkins-ci.org/display/JENKINS/Docker+Plugin'
  plugin.developed_by "georgebashi", "George Bashi <george@bashi.co.uk>"
  plugin.uses_repository :github => "georgebashi/jenkins-docker-plugin"
  plugin.depends_on 'ruby-runtime', '0.10'
end
