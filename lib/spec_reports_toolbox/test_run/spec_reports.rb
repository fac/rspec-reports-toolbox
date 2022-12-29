require "spec_reports_toolbox/test_run/spec_reports/artifact_manager"

require "json"
require "terminal-table"

class TestRun
  class SpecReports
    attr_reader :test_run

    def initialize(test_run, options = {})
      @test_run = test_run
      @options = options
      @artifact_manager = ArtifactManager.new(@test_run)
    end

    def fetch!
      @artifact_manager.fetch_from_s3!
    end

    def fetch_spec_data(key)
      @artifact_manager.files.flat_map do |file|
        JSON.parse(File.read(file)).fetch(key)
      end
    end

    def per_dir_summary
      # examples grouped by path
      grouped = fetch_spec_data("examples").group_by do |example|
        example["file_path"].split("/").first(3).last(2)
      end

      result = {}
      grouped.each_key do |key|
        duration = grouped[key].map { |ex| ex["run_time"] }.sum
        status_counts = grouped[key].map { |ex| ex["status"] }.tally

        result[key.join("/")] = {
          "example_count" => grouped[key].count,
          "failure_count" => status_counts["failed"] || 0,
          "pending_count" => status_counts["pending"] || 0,
          "duration" => (duration / 60).round(2),
        }
      end

      result
    end

    def overall_summary
      result = {
        "duration" => 0,
        "example_count" => 0,
        "failure_count" => 0,
        "pending_count" => 0,
      }

      summaries = fetch_spec_data("summary")

      summaries.each do |summary|
        result["duration"] += summary["duration"]
        result["example_count"] += summary["example_count"]
        result["failure_count"] += summary["failure_count"]
        result["pending_count"] += summary["pending_count"]
      end

      result
    end

    def to_table
      headings = ["directory"] + overall_summary.keys
      main_app_suite_data = [["**All tests**"] + overall_summary.values.map { |v| v.round(2) }]
      per_dir_rows = per_dir_summary.map do |dir_spec|
        [
          dir_spec.first,
          dir_spec.last["duration"],
          dir_spec.last["example_count"],
          dir_spec.last["failure_count"],
          dir_spec.last["pending_count"],
        ]
      end

      rows = main_app_suite_data + per_dir_rows

      rows.sort_by! { |data| -data[1] } # sort by duration

      Terminal::Table.new(
        headings: headings,
        rows: rows,
        style: { border: :markdown },
      )
    end
  end
end
