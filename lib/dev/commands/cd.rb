require 'dev'

module Dev
  module Commands
    FZY = File.expand_path('vendor/fzy', ROOT)

    class Cd < Dev::Command
      def call(args, _name)
        raise(Abort, 'one arg required') unless args.size == 1
        arg = args.first
        scores, stat = CLI::Kit::System.capture2(FZY, '--show-matches', arg, stdin_data: avail.join("\n"))
        raise(Abort, 'fzy failed') unless stat.success?

        target = File.expand_path("~/src/github.com/#{scores.lines.first}")
        IO.new(9).puts("chdir:#{target}")
      end

      def avail
        owners = Dir.entries(File.expand_path("~/src/github.com")) - %w(. ..)
        owners.flat_map do |owner|
          repos = Dir.entries(File.expand_path("~/src/github.com/#{owner}")) - %w(. ..)
          repos.map { |r| File.join(owner, r) }
        end
      end

      def self.help
        'TODO'
      end
    end
  end
end
