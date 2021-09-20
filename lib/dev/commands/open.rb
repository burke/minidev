require('dev')

module Dev
  module Commands
    GITHUB_URL = 'https://github.com'

    class Open < Dev::Command
      def call(args, _name)
        raise(Abort, 'one arg required') unless args.size == 1

        arg = args.first
        case arg
        when 'pr'
          origin, _err, stat = CLI::Kit::System.capture3('git', 'remote', 'get-url', 'origin')
          raise(Abort, 'failed to get url for remote origin') unless stat.success?

          branch, _err, stat = CLI::Kit::System.capture3('git', 'branch', '--show-current')
          raise(Abort, 'failed to get current branch') unless stat.success?

          pull_request_url = "#{origin_to_url(origin)}/pull/new/#{branch}"
          CLI::Kit::System.system("open #{pull_request_url}")
        end
      end

      def self.help
        'TODO'
      end

      def origin_to_url(origin)
        _, owner, repo = origin.match(%r{(https://|git@)github.com[:/](.+)/([\w\-]+)(\.git)?}).captures
        "#{GITHUB_URL}/#{owner}/#{repo}"
      end
    end
  end
end
