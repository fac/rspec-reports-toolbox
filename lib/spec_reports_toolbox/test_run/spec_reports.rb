require "spec_reports_toolbox/test_run/spec_reports/artifact_fetching"
require "json"

class TestRun
  class SpecReports
    include ArtifactFetching
    
    attr_reader :test_run
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

    def fetch_spec_data(key)
      files.flat_map do |file|
        JSON.parse(File.read(file)).fetch(key)
      end
    end

    def overall_summary
      result = {
        "duration" => 0,
        "example_count" => 0,
        "failure_count" => 0,
        "pending_count" => 0,
      }
  
      summaries = fetch_spec_data("summary")
  
      summaries.each do |summary|
        result["duration"] += summary["duration"]
        result["example_count"] += summary["example_count"]
        result["failure_count"] += summary["failure_count"]
        result["pending_count"] += summary["pending_count"]
      end
  
      result
    end
  end
end
