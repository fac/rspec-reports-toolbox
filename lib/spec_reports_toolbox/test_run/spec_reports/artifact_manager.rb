require "pathname"

class TestRun
  class SpecReports
    class ArtifactManager
      def initialize(test_run)
        @run_id = test_run.run_id
        @run_attempt = test_run.run_attempt
      end
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
        puts "Fetching artifacts from S3"

        output_directory = dir.to_path
        
        puts `aws-vault exec fa-ci-prod-github-run-artifacts -- aws s3 cp \
        --recursive \
        --include "*" \
        "s3://raw-test-suite-data-fa-ci-prod/test-suite-json-reports/#{@run_id}/#{@run_attempt}" "#{output_directory}" --verbose`
      end
    end
  end
end
