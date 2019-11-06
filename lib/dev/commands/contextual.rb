require 'dev'

module Dev
  module Commands
    class Contextual < Dev::Command
      DEFAULT_COMMANDS = Dev::ContextualResolver::DEFAULT_COMMANDS

      def call(args, name)
        cfg = Project.current.config

        script = if DEFAULT_COMMANDS.include?(name) && cfg.key?(name)
          configstr_run(cfg[name])
        else
          configstr_run(cfg['commands'][name])
        end

        puts("\x1b[1;34mexecuting #{script}\x1b[0m")
        exec('/bin/bash', '-c', script)
      end

      def configstr_run(x)
        case x
        when Hash
          x['run']
        when String
          x
        else
          raise(Abort, "idk")
        end
      end

      def self.help
        'TODO'
      end
    end
  end
end
