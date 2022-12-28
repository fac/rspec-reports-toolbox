require "spec_reports_toolbox/test_run/spec_reports/artifact_fetching"

class TestRun
  class SpecReports
    attr_reader :test_run

    include ArtifactFetching

    def initialize(test_run, options = {fetch_source: :s3})
      @test_run = test_run
      @options = options
    end
    
    def fetch!
      fetch_source = @options.dig(:fetch_source)

      case fetch_source
      when :s3
        fetch_from_s3!
      when :github
        fetch_from_github!
      else
        raise NotImplementedError.new(
          "Fetch source for artifacts from '#{fetch_source}' not implemented"
        )
      end
    end

    def files
      dir.glob("**/*.json")
    end

    def exist?
      dir.exist?
    end

    def delete_dir!
      raise NotImplementedError
    end

    def dir
      artifacts_base_dir + 'test_suite_json_reports'
    end
  end
end
