class TestRun
  class SpecArtifacts
    attr_reader :test_run

    def initialize(test_run, options = {})
      @test_run = test_run
      @options = options
    end

    def fetch!
    end
  end
end
