require('dev')

module Dev
  class ContextualResolver
    DEFAULT_COMMANDS = %w(build console server test style)
    DEFAULT_ALIASES = {'b' => 'build', 'c' => 'console', 't' => 'test', 's' => 'server'}

    def self.command_names
      cfg = Project.current.config
      a = cfg['commands']&.keys || []
      b = DEFAULT_COMMANDS.select { |f| cfg.key?(f) }
      (a + b).uniq
    rescue Dev::Project::NoProject
      []
    end

    def self.aliases
      a = DEFAULT_ALIASES.clone
      cfg = Project.current.config
      DEFAULT_COMMANDS.each do |name|
        aliases = cfg[name]&.[]('aliases') || []
        aliases.each { |al| a[al] = name }
      end
      cfg['commands']&.each do |name, cmdcfg|
        aliases = cmdcfg['aliases'] || []
        aliases.each { |al| a[al] = name }
      end
      a
    rescue Dev::Project::NoProject
      {}
    end

    def self.command_class(name)
      Dev::Commands::Contextual
    end
  end
end
