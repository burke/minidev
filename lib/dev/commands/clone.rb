require('dev')
require('fileutils')

module Dev
  module Commands
    class Clone < Dev::Command
      def call(args, _name)
        raise(Abort, 'one arg required') unless args.size == 1
        arg = args.first
        repo = if arg =~ %r{.*/.*}
          arg
        else
          "#{Dev::Default.account}/#{arg}"
        end
        target = File.expand_path("#{Dev::Default.github_root}/#{repo}")
        if File.directory?(target)
          IO.new(9).puts("chdir:#{target}")
          return
        end
        FileUtils.mkdir_p(File.dirname(target))
        stat = CLI::Kit::System.system('git', 'clone', "https://github.com/#{repo}", target)
        raise(Abort, "clone failed") unless stat.success?
        IO.new(9).puts("chdir:#{target}")
      end

      def self.help
        'TODO'
      end
    end
  end
end
