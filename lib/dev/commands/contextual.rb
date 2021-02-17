require 'dev'

module Dev
  module Commands
    class Contextual < Dev::Command
      DEFAULT_COMMANDS = Dev::ContextualResolver::DEFAULT_COMMANDS

      def call(args, name)
        cfg = Project.current.config

        sh, args = if DEFAULT_COMMANDS.include?(name) && cfg.key?(name)
          configstr_run(cfg[name], args)
        else
          configstr_run(cfg['commands'][name], args)
        end

        puts("\x1b[1;34mexecuting #{sh}\x1b[0m")

        sh.concat(' "$@"') if sh.lines.size == 1 && sh !~ /\$[@\*]/
        sh = %Q{runcmd() {\n#{sh}\n}\nruncmd "$@"}
        exec('/bin/bash', '-c', sh, '--', *args)
      end

      def configstr_run(x, args)
        case x
        when Hash
          if x['subcommands']&.include?(args[0])
            [x['subcommands'][args.shift]['run'], args]
          else
            [x['run'], args]
          end
        when String
          [x, args]
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
