# frozen_string_literal: true

RSpec.describe TestRun::SpecReports do
  let(:test_run) { TestRun.new(123, 1) }
  let(:spec_reports) { TestRun::SpecReports.new(test_run) }

  before do
    allow(ENV)
      .to receive(:fetch).with("SPEC_REPORTS_TOOLBOX_ARTIFACTS_DIR")
      .and_return("spec/fixtures")
  end

  describe "#initialize" do
    it "has a test_run" do
      expect(spec_reports.test_run).to eq test_run
    end
  end

  describe "#overall_summary" do
    it "reads all the files to get the overall summary" do
      expected = {
        "duration" => 224.079857726,
        "example_count" => 54237,
        "failure_count" => 0,
        "pending_count" => 3,
      }

      expect(spec_reports.overall_summary).to eq(expected)
    end
  end

  describe "fetch!" do
    it "fetches from s3 by default" do
      expect(spec_reports).to receive(:fetch_from_s3!)
      spec_reports.fetch!
    end

    context "fetch_source is :github" do
      let(:spec_reports) { TestRun::SpecReports.new(test_run, {fetch_source: :github}) }
      it "calls fetch_from_github!" do
        expect(spec_reports).to receive(:fetch_from_github!)
        spec_reports.fetch!
      end
    end
    
    context "fetch_source is :unknown" do
      let(:spec_reports) { TestRun::SpecReports.new(test_run, {fetch_source: :unknown}) }
      it "calls fetch_from_github!" do
        expect { spec_reports.fetch! }
          .to raise_error(NotImplementedError)
          .with_message("Fetch source for artifacts from 'unknown' not implemented")
      end
    end
  end
end
