require "spec_reports_toolbox/test_run/artifact_manager"

class TestRun
  class SpecArtifacts
    attr_reader :test_run, :artifact_manager

    def initialize(test_run, options = {})
      @test_run = test_run
      @options = options
      @artifact_manager = TestRun::ArtifactManager.new(@test_run, "log-folder")
    end

    def fetch!
      @artifact_manager.fetch_from_s3!
    end

    def ensure_spec_artifact_files!
      unless @artifact_manager.has_artifacts?
        raise "No spec artifacts found for #{@test_run.run_id} attempt #{@test_run.run_attempt}"
      end
    end
  end
end
