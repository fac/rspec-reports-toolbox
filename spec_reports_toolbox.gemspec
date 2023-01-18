# frozen_string_literal: true

require_relative "lib/spec_reports_toolbox/version"

Gem::Specification.new do |spec|
  spec.name = "SpecReportsToolbox"
  spec.version = SpecReportsToolbox::VERSION
  spec.authors = ["Peter Singh"]
  spec.email = ["peter.singh@freeagent.com"]

  spec.summary = "Spec Reports Toolbox"
  spec.description = "A toolbox for fetching, viewing and interacting with spec reports at FreeAgent"
  spec.homepage    = "https://www.github.com/fac"
  spec.required_ruby_version = ">= 3.0.0"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.pkg.github.com/fac"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://www.github.com/fac"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "colorize"
  spec.add_runtime_dependency "ox"
  spec.add_runtime_dependency "gli"
  spec.add_runtime_dependency "terminal-table"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rake"
  spec.add_development_dependency "guard-rspec"



  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
