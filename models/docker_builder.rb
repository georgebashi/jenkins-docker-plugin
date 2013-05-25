
class DockerBuilder < Jenkins::Tasks::Builder

    attr_accessor :dockerfile_path

    display_name "Docker builder"

    # Invoked with the form parameters when this extension point
    # is created from a configuration screen.
    def initialize(attrs = {})
        @dockerfile_path = attrs["dockerfile_path"]
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
      launcher.execute("docker", "build", "#{workspace}/#@dockerfile_path", { :out => listener })
    end

end
