require 'dev'

module Dev
  module Commands
    class Up < Dev::Command
      def call(args, _name)
        Dev::Project.current.config['up'].each do |task|
          puts "no idea how to run this task:"
          puts "  #{task.inspect}"
        end
        raise(AbortSilent)
      end

      def self.help
        'TODO'
      end
    end
  end
end
