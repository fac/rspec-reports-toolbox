require "spec_reports_toolbox/test_run/spec_reports"

class TestRun
  attr_reader :run_id, :run_attempt

  def initialize(run_id, run_attempt = 1)
    @run_id = run_id
    @run_attempt = run_attempt
  end

  def spec_reports
    @spec_reports = TestRun::SpecReports.new(self)
  end
end
