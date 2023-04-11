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
          "#{default_account}/#{arg}"
        end
        target = File.expand_path("~/src/github.com/#{repo}")
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

      def default_account
        account = Dev::Config.get('default', 'account')
        raise(Abort, 'account/repo both required unless default.account is set in config') unless account
        account
      end
    end
  end
end
