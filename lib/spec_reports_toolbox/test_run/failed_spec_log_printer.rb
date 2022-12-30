# frozen_string_literal: true

require "json"
require "colorize"

class FailedSpecsLogPrinter
  def initialize(test_run)
    @test_run = test_run
    @overall_summary = test_run.spec_reports.overall_summary
    @spec_reports = test_run.spec_reports.artifact_manager.files
    raise "Error: No spec reports discovered!" if @spec_reports.empty?
  end

  def run
    if @overall_summary["failure_count"] > 0
      puts "Printing readable logs from nodes with failed specs:".bold
      report_summary
      print_logs_explainer_message unless ENV["TRIM_EXPLAINER"]
      pp_logs_from_failures
      exit 1
    else
      puts "No failures on this run"
      exit 0
    end
  end

  def print_failed_spec_and_file_name
    failed_specs.each do |spec|
      puts "\t#{spec["id"]} -- #{spec["file"]}"
    end
  end

  def report_summary
    puts "Summary".underline
    print "Total number of failed specs: ".italic; puts "#{failed_specs.count}".red.bold
    print_failed_spec_and_file_name
    puts "\n"
  end

  def pp_logs_from_failures
    puts "Printing logs from failed Knapsack Nodes:\n".underline
    failed_specs.map { |spec| spec["file"] }.uniq.sort.each do |file|
      knapsack_node = file.to_path.split("/").last.split("_").last.split(".").first
      log_file_path = "knapsack_node_#{knapsack_node}.log"

      puts log_file_path.green.underline.bold

      puts "Failed specs on this node:"
      puts failed_specs.select { |specs| specs["file"] == file }.map { |spec| "\t#{spec["id"]}" }.map(&:red)

      puts "::group::🔎 Summary log from #{log_file_path}"
      puts "## Knapsack node #{knapsack_node}"

      file = Dir.glob("#{@test_run.spec_artifacts.artifact_manager.dir.to_s}/**/#{log_file_path}").first
      puts File.read(file).split("Knapsack Pro Queue finished!").last.strip
      puts "::endgroup::\n\n"
    end
  end

  def failed_specs
    @spec_reports.flat_map do |file|
      JSON.parse(File.read(file))
        .fetch("examples")
        .select { |spec| spec["status"] == "failed" }
        .each { |spec| spec.merge!("file" => file) }
    end
  end

  def print_logs_explainer_message
    # rubocop:disable Layout/LineLength
    puts "::group:: What is this?"
    puts %{
      Many spec processes run on a single instance leading to the normal logs being an interwoven mix of many rspec processes.
      These are hard (impossible) to read if you want to know what a single rspec process was doing.

      Each rspec process does however output its own log to log/knapsack_node_<ID>.log
      These are downloadable as the 'test-suite-logs' artifacts
      (We also upload them to S3 because they are overwritten by Actions on re-run. Ask Dev P if you ever need these logs)

      We'll now print only the failure section of the detangled logs from each Knapsack node that has failed, making it easier to read the failures on this run:
    }.italic

    puts "::endgroup::\n\n"
    # rubocop:enable Layout/LineLength
  end
end
