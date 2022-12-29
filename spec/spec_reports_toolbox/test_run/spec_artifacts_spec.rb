# frozen_string_literal: true

RSpec.describe TestRun::SpecArtifacts do
  let(:test_run) { TestRun.new(123, 1) }
  let(:spec_artifacts) { TestRun::SpecArtifacts.new(test_run) }

  before do
    allow(ENV).to receive(:fetch).with("SPEC_artispec_artifacts_TOOLBOX_ARTIFACTS_DIR")
                    .and_return("spec/fixtures")
  end

  describe "#initialize" do
    it "has a test_run" do
      expect(spec_artifacts.test_run).to eq test_run
    end
  end

  describe "#fetch!" do
    let(:artifact_manager_double) { double(TestRun::ArtifactManager) }

    before do
      allow(TestRun::ArtifactManager).to receive(:new).with(test_run, "log-folder").and_return(artifact_manager_double)
    end

    it "calls fetch_from_s3!" do
      expect(artifact_manager_double).to receive(:fetch_from_s3!)
      spec_artifacts.fetch!
    end
  end
end
