require 'cli/ui'
require 'cli/kit'

CLI::UI::StdoutRouter.enable

module Dev
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

  Config = CLI::Kit::Config.new(tool_name: TOOL_NAME)
  Command = CLI::Kit::BaseCommand

  Executor = CLI::Kit::Executor.new(log_file: LOG_FILE)
  Resolver = CLI::Kit::Resolver.new(
    tool_name: TOOL_NAME,
    command_registry: Dev::Commands::Registry
  )

  ErrorHandler = CLI::Kit::ErrorHandler.new(
    log_file: LOG_FILE,
    exception_reporter: nil
  )
end
