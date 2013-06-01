
class DockerBuilder < Jenkins::Tasks::Builder
    display_name "Build docker container from Dockerfile"

    attr_accessor :dockerfile_path
    attr_accessor :tag

    # Invoked with the form parameters when this extension point
    # is created from a configuration screen.
    def initialize(attrs = {})
        @dockerfile_path = attrs["dockerfile_path"]
        @tag = attrs["tag"]
    end

    ##
    # Runs before the build begins
    #
    # @param [Jenkins::Model::Build] build the build which will begin
    # @param [Jenkins::Model::Listener] listener the listener for this build.
    def prebuild(build, listener)
      # do any setup that needs to be done before this build runs.
    end

    ##
    # Runs the step over the given build and reports the progress to the listener.
    #
    # @param [Jenkins::Model::Build] build on which to run this step
    # @param [Jenkins::Launcher] launcher the launcher that can run code on the node running this build
    # @param [Jenkins::Model::Listener] listener the listener for this build.
    def perform(build, launcher, listener)
      workspace = build.send(:native).workspace.to_s

      # actually perform the build step
      cmd_path = @dockerfile_path.gsub(/\/Dockerfile$/, '') # docker build wants path, not filename
      cmd = %w{docker build}
      cmd << "-t #@tag" unless @tag.nil? || @tag.empty?
      cmd << "\'#{workspace}/#{cmd_path}\'"
      if launcher.execute(*cmd.join(' '), { :out => listener }) != 0
        build.abort "docker build failed"
      end
    end

end
