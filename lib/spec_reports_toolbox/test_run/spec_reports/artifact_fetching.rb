require "pathname"

class TestRun
  class SpecReports
    module ArtifactFetching
      def artifacts_base_dir
        Pathname.new("/tmp") || ENV.fetch("SPEC_REPORTS_TOOLBOX_ARTIFACTS_DIR")
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
