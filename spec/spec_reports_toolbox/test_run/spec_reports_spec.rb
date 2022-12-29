# frozen_string_literal: true

RSpec.describe TestRun::SpecReports do
  let(:test_run) { TestRun.new(3702976218, 1) }
  let(:spec_reports) { TestRun::SpecReports.new(test_run) }

  before do
    stub_const("ENV", { "SPEC_REPORTS_TOOLBOX_ARTIFACTS_DIR" => "./spec/fixtures" })
  end

  describe "#initialize" do
    it "has a test_run" do
      expect(spec_reports.test_run).to eq test_run
    end
  end

  describe "#overall_summary" do
    it "reads all the files to get the overall summary" do
      expected = {
        "duration" => 387.367279796,
        "example_count" => 54147,
        "failure_count" => 1,
        "pending_count" => 3,
      }

      expect(spec_reports.overall_summary).to eq(expected)
    end
  end

  describe "#per_dir_summary" do
    it "reads all the files to get the per dir summary" do
      per_dir_summary = spec_reports.per_dir_summary
      expect(per_dir_summary).to be_kind_of(Hash)
      expect(per_dir_summary.count).to eq 32
      expect(per_dir_summary.keys).to include("spec/freeagent")

      expected_dir_summary = {
        "example_count" => 2528,
        "failure_count" => 0,
        "pending_count" => 0,
        "duration" => 7.56,
      }

      expect(per_dir_summary.fetch("spec/freeagent")).to eq(expected_dir_summary)
    end
  end

  describe "#fetch!" do
    let(:artifact_manager_double) { double(TestRun::ArtifactManager) }

    before do
      allow(TestRun::ArtifactManager).to receive(:new).with(test_run, "test-suite-json-reports").and_return(artifact_manager_double)
    end

    it "calls fetch_from_s3!" do
      expect(artifact_manager_double).to receive(:fetch_from_s3!)
      spec_reports.fetch!
    end
  end

  describe "#to_table" do
    it "returns a table" do
      expect(spec_reports.to_table).to be_kind_of(Terminal::Table)
    end
  end
end
