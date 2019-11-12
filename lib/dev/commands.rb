require 'dev'

module Dev
  module Commands
    Registry = CLI::Kit::CommandRegistry.new(
      default: 'help',
      contextual_resolver: ContextualResolver
    )

    def self.register(const, cmd, path)
      autoload(const, path)
      Registry.add(->() { const_get(const) }, cmd)
    end

    autoload(:Contextual, 'dev/commands/contextual')

    register(:Cd,    'cd',    'dev/commands/cd')
    register(:Clone, 'clone', 'dev/commands/clone')
    register(:Help,  'help',  'dev/commands/help')
    register(:Init,  'init',  'dev/commands/init')
    register(:Up,    'up',    'dev/commands/up')
  end
end
