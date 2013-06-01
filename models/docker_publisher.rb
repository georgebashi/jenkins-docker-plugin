
class DockerPublisher < Jenkins::Tasks::Publisher
  display_name "Push docker container to registry"

  attr_accessor :tag

  def initialize attrs
    @tag = attrs["tag"]
  end

  def prebuild build, listener
  end

  def perform build, launcher, listener
    build.abort "Please specify container tag in docker publisher config!" if @tag.nil? || @tag.empty?

    cmd = %w{docker push}
    cmd << @tag
      if launcher.execute(*cmd.join(' '), { :out => listener }) != 0
        build.abort "push failed (try running docker login first!)"
      end
  end
end
