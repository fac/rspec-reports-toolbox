# frozen_string_literal: true

RSpec.describe TestRun::SpecReports do
  let(:test_run) { TestRun.new(123, 1) }
  let(:spec_reports) { TestRun::SpecReports.new(test_run) }

  describe "#initialize" do
    it "has a test_run" do
      expect(spec_reports.test_run).to eq test_run
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
