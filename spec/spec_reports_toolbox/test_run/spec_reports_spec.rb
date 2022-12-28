# frozen_string_literal: true

RSpec.describe TestRun::SpecReports do
  let(:test_run) { TestRun.new(123, 1) }
  let(:spec_reports) { TestRun::SpecReports.new(test_run) }

  describe "#initialize" do
    it "has a test_run" do
      expect(spec_reports.test_run).to eq test_run
    end
  end
end
