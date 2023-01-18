FreeAgent::Devkit::App.desc "Poke CI builds and artifacts"

commands = Proc.new do |cmd|
  cmd.desc "Interact with spec reports"
  cmd.command :reports do |reports|
    reports.action do |_g_opts, _opts|
      puts "Investigating spec reports"
    end
  end

  cmd.desc "Interact with spec artifacts"
  cmd.command :artifacts do |artifacts|
    artifacts.action do |_g_opts, _opts|
      puts "Investigating spec artifacts"
    end
  end
end

FreeAgent::Devkit::App.command :ci do |c|
  commands.call(c)
end
