require "pathname"

class TestRun
  class ArtifactManager
    def initialize(test_run, artifact_name)
      @run_id = test_run.run_id
      @run_attempt = test_run.run_attempt
      @artifact_name = artifact_name
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
      artifacts_base_dir + @artifact_name
    end

    def fetch_from_s3!
      puts "Fetching artifacts from S3"

      output_directory = dir.to_path

      puts `aws-vault exec fa-ci-prod-github-run-artifacts -- aws s3 cp \
        --recursive \
        --include "*" \
        "s3://raw-test-suite-data-fa-ci-prod/#{@artifact_name}/#{@run_id}/#{@run_attempt}" "#{output_directory}" --verbose`
    end
  end
end
