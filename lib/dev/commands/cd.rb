require 'dev'

module Dev
  module Commands
    FZY = begin
      basename = RUBY_PLATFORM =~ /darwin/ ? 'fzy_darwin' : 'fzy_linux'
      File.expand_path("vendor/#{basename}", ROOT)
    end

    class Cd < Dev::Command
      def call(args, _name)
        raise(Abort, 'one arg required') unless args.size == 1
        arg = args.first
        scores, stat = CLI::Kit::System.capture2(FZY, '--show-matches', arg, stdin_data: avail.join("\n"))
        raise(Abort, 'fzy failed') unless stat.success?

        target = File.expand_path(File.join(Dev::Default.github_root, scores.lines.first))
        IO.new(9).puts("chdir:#{target}")
      end

      def avail
        owners = Dir.entries(File.expand_path(Dev::Default.github_root)) - %w(. ..)
        owners = owners.select do |f|
          File.directory?(File.join(File.expand_path(Dev::Default.github_root), f))
        end

        owners.flat_map do |owner|
          repos = Dir.entries(File.expand_path(File.join(Dev::Default.github_root, owner))) - %w(. ..)
          repos = repos.select do |f|
            File.directory?(File.join(File.expand_path(File.join(Dev::Default.github_root, owner)), f))
          end

          repos.map { |r| File.join(owner, r) }
        end
      end

      def self.help
        'TODO'
      end
    end
  end
end
