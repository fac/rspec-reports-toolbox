require "pathname"

class TestRun
  class ArtifactManager
    def initialize(test_run, artifact_name)
      @run_id = test_run.run_id
      @run_attempt = test_run.run_attempt
      @artifact_name = artifact_name
    end

    def artifacts_base_dir
      artifact_download_location = ENV["SPEC_REPORTS_TOOLBOX_ARTIFACTS_DIR"] || "/tmp"
      Pathname.new(artifact_download_location + "/#{@run_id}/#{@run_attempt}")
    end

    def has_artifacts?
      files.any?
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
      puts "Fetching #{@artifact_name} artifacts from S3"
      output_directory = dir.to_path
      cmd = "aws-vault exec fa-ci-prod -- aws s3 cp --recursive --include '*' s3://raw-test-suite-data-fa-ci-prod/#{@artifact_name}/#{@run_id}/#{@run_attempt} #{output_directory}"
      system(cmd)
    end
  end
end
