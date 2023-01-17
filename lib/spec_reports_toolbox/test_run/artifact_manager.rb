require "pathname"
require "colorize"

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
      dir.glob("**/*").any?
    end

    def files
      dir.glob("**/*.json")
    end

    def exist?
      dir.exist?
    end

    def delete_dir!
      dir.rmtree
    end

    def dir
      artifacts_base_dir + @artifact_name
    end

    def fetch_from_s3!(options = {})
      puts "Artifacts have previously been fetched - #{dir} exists".blue if exist?
      puts "Directory has no files".blue if exist? && !has_artifacts?

      if options[:force]
        puts "Deleting existing directory at: #{dir} because --force was passed".yellow
        delete_dir!
      end

      if !exist?
        puts "Fetching #{@artifact_name} artifacts from S3"
        output_directory = dir.to_path
        cmd = "aws-vault exec fa-ci-prod -- aws s3 cp --recursive --include '*' s3://raw-test-suite-data-fa-ci-prod/#{@artifact_name}/#{@run_id}/#{@run_attempt} #{output_directory}"
        system(cmd)
      end
    end
  end
end
