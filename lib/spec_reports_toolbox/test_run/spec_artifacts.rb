require "spec_reports_toolbox/test_run/artifact_manager"
require "spec_reports_toolbox/test_run/failed_spec_log_printer"

class TestRun
  class SpecArtifacts
    class MissingSpecArtifacts < StandardError; end

    attr_reader :test_run, :artifact_manager

    def initialize(test_run, options = {})
      @test_run = test_run
      @options = options
      @artifact_manager = TestRun::ArtifactManager.new(@test_run, "log-folder")
    end

    def fetch!(options = {})
      @artifact_manager.fetch_from_s3!(options)
    end

    def ensure_spec_artifact_files!
      raise MissingSpecArtifacts unless @artifact_manager.has_artifacts?
    end

    def display_logs(options = {})
      ensure_spec_artifact_files!
      if @artifact_manager.has_artifacts?
        FailedSpecsLogPrinter.new(@test_run, options).run
      else
        puts "No spec artifacts found for this test run, if the run passed, there won't be any artifacts."
      end
    end
  end
end
