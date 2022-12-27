class TestRun
  attr_reader :run_id, :run_attempt
  def initialize(run_id, run_attempt)
    @run_id = run_id
    @run_attempt = run_attempt
  end
end

