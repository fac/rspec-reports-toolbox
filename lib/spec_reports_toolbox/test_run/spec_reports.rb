class TestRun
  class SpecReports
    attr_reader :test_run

    def initialize(test_run)
      @test_run = test_run
    end

    def test_suite_json_reports_folder
      artifact_dir + 'test_suite_json_reports'
    end

    def test_suite_json_reports_files
      test_suite_json_reports_folder.glob("**/*.json")
    end

    def fetch_test_suite_json_reports_from_s3!
      output_directory = test_suite_json_reports_folder.to_path

      puts `aws-vault exec fa-ci-prod-github-run-artifacts -- aws s3 cp \
        --recursive \
        --include "*" \
        "s3://raw-test-suite-data-fa-ci-prod/test-suite-json-reports/#{@run_id}/#{@run_attempt}" "#{output_directory}"`
    end

    def has_test_suite_json_reports?
      test_suite_json_reports_folder.exist?
    end

    def delete_test_suite_json_reports_folder!
      puts "no implimented"
    end

    def artifact_dir
      Pathname.new("/tmp")
    end
  end
end
