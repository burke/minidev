require('dev')
require('fileutils')

module Dev
  module Commands
    class Clone < Dev::Command
      def call(args, _name)
        raise(Abort, 'one arg required') unless args.size == 1
        arg = args.first
        raise(Abort, 'owner/repo both required in minidev') unless arg =~ %r{.*/.*}
        target = File.expand_path("~/src/github.com/#{arg}")
        FileUtils.mkdir_p(File.dirname(target))
        stat = CLI::Kit::System.system('git', 'clone', "https://github.com/#{arg}", target)
        raise(Abort, "clone failed") unless stat.success?
        IO.new(9).puts("chdir:#{target}")
      end

      def self.help
        'TODO'
      end
    end
  end
end
