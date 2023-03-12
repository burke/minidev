require 'cli/ui'
require 'cli/kit'

CLI::UI::StdoutRouter.enable

module Dev
  extend CLI::Kit::Autocall

  TOOL_NAME = 'dev'
  ROOT      = File.expand_path('../..', __FILE__)
  LOG_FILE  = '/tmp/dev.log'

  Abort = CLI::Kit::Abort
  AbortSilent = CLI::Kit::AbortSilent

  autoload(:EntryPoint,         'dev/entry_point')
  autoload(:Commands,           'dev/commands')
  autoload(:ContextualResolver, 'dev/contextual_resolver')
  autoload(:Project,            'dev/project')
  autoload(:Default,            'dev/default')

  autocall(:Config)  { CLI::Kit::Config.new(tool_name: TOOL_NAME) }
  autocall(:Command) { CLI::Kit::BaseCommand }

  autocall(:Executor) { CLI::Kit::Executor.new(log_file: LOG_FILE) }
  autocall(:Resolver) do
    CLI::Kit::Resolver.new(
      tool_name: TOOL_NAME,
      command_registry: Dev::Commands::Registry
    )
  end

  autocall(:ErrorHandler) do
    CLI::Kit::ErrorHandler.new(
      log_file: LOG_FILE,
      exception_reporter: nil
    )
  end
end
