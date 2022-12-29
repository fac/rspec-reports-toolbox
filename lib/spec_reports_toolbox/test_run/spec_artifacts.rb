require "spec_reports_toolbox/test_run/artifact_manager"

class TestRun
  class SpecArtifacts
    attr_reader :test_run

    def initialize(test_run, options = {})
      @test_run = test_run
      @options = options
      @artifact_manager = TestRun::ArtifactManager.new(@test_run, "log-folder")
    end

    def fetch!
    end
  end
end
