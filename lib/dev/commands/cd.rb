require 'dev'

module Dev
  module Commands
    FZY = begin
      basename = RUBY_PLATFORM =~ /darwin/ ? 'fzy_darwin' : 'fzy_linux'
      File.expand_path("vendor/#{basename}", ROOT)
    end
    GITHUB_ROOT = '~/src/github.com'

    class Cd < Dev::Command
      def call(args, _name)
        raise(Abort, 'one arg required') unless args.size == 1
        arg = args.first
        scores, stat = CLI::Kit::System.capture2(FZY, '--show-matches', arg, stdin_data: avail.values.join("\n"))
        raise(Abort, 'fzy failed') unless stat.success?

        matching_repo = scores.lines.first.strip
        matching_owner = avail.select { |owner, repos| repos.include?(matching_repo) }.keys.first

        target = File.expand_path(File.join(GITHUB_ROOT, matching_owner, matching_repo))
        IO.new(9).puts("chdir:#{target}")
      end

      def avail
        owners = Dir.entries(File.expand_path(GITHUB_ROOT)) - %w(. ..)
        owners = owners.select do |f|
          File.directory?(File.join(File.expand_path(GITHUB_ROOT), f))
        end

        owners.each_with_object({}) do |owner, hash|
          repos = Dir.entries(File.expand_path(File.join(GITHUB_ROOT, owner))) - %w(. ..)
          repos = repos.select do |f|
            File.directory?(File.join(File.expand_path(File.join(GITHUB_ROOT, owner)), f))
          end

          hash[owner] = repos
        end
      end

      def self.help
        'TODO'
      end
    end
  end
end
