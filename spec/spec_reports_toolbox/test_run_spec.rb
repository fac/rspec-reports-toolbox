# frozen_string_literal: true

RSpec.describe TestRun do
  let(:test_run) { TestRun.new(123, 1) }

  describe "#initialize" do
    it "has a run_id" do
      expect(test_run.run_id).to eq 123
    end

    it "has a run_attempt" do
      expect(test_run.run_attempt).to eq 1
    end
  end

  describe "#spec_reports" do
    it "creates a spec reports instance" do
      expect(test_run.spec_reports).to be_kind_of TestRun::SpecReports
    end
  end

  describe "#spec_artifacts" do
    it "creates a spec artifacts instance" do
      expect(test_run.spec_artifacts).to be_kind_of TestRun::SpecArtifacts
    end
  end
end
