require "pathname"

class TestRun
  class SpecReports
    module ArtifactFetching
      def artifacts_base_dir
        Pathname.new("/tmp")
      end
      
      def fetch_from_s3!
        output_directory = dir.to_path
        
        puts `aws-vault exec fa-ci-prod-github-run-artifacts -- aws s3 cp \
        --recursive \
        --include "*" \
        "s3://raw-test-suite-data-fa-ci-prod/test-suite-json-reports/#{@run_id}/#{@run_attempt}" "#{output_directory}"`
      end
      
      def fetch_from_github!
        raise NotImplementedError
      end
    end
  end
end
