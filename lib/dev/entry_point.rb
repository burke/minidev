require 'dev'

module Dev
  module EntryPoint
    def self.call(args)
      cmd, command_name, args = Dev::Resolver.call(args)
      Dev::Executor.call(cmd, command_name, args)
    end
  end
end
