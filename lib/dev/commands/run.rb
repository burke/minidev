class Run < Dev::Command
  def call(args, _name)
    help_flags = ['--help', '-h']
    args = args - help_flags
    full_key = args.join(":")

    cmd = root_namespace.tree[full_key]

    if cmd.nil?
      puts "Command not found: #{full_key}"
      puts
      root_namespace.help!

    elsif (args & help_flags).any?
      cmd.help!
    else
      cmd.run!
    end
  end

  def root_namespace
    @commands ||= Command.parse_yaml
  end

  private

  class Command < Struct.new(:parents, :key, :run, :syntax, :help, :subcommands)
    def initialize(parents, key, run, syntax: nil, help: nil, subcommands: [])
      super(parents, key, run, syntax, help, subcommands || [])
    end

    def self.parse_node(parents, key, node, help: nil)
      run = (node.is_a?(String) ? node : node['run'])
      syntax = node.is_a?(Hash) ? node['syntax'] : nil
      help = node.is_a?(Hash) ? node['desc'] : nil
      subcommands = if node.is_a?(Hash) && node['subcommands']
        namespace = parents + [key]
        parse_namespace(namespace, node['subcommands'])
      end

      Command.new(parents, key, run, syntax: syntax, help: help, subcommands: subcommands)
    end

    def self.parse_namespace(parents, namespace)
      namespace.map do |key, value|
        parse_node(parents, key, value)
      end
    end

    def self.parse_yaml
      subcommands = if commands = Dev::Project.current.config['commands']
        parse_namespace([], commands)
      else
        []
      end

      Command.new([], nil, nil, subcommands: subcommands)
    end

    def visible?
      if subcommands.length > 0
        return true
      end
      [key, help, run].join.size > 1
    end

    def run!
      if run.to_s != ""
        cmd = run.gsub("\'", "\\\'")
        system("bash -c \'#{cmd}\'")
      else
        help!
      end
    end

    def full_key
      [parents, key].flatten.join(":")
    end

    def tree(commands = {})
      if visible?
        commands[full_key] = self
      end
      if subcommands.any?
        subcommands.each do |cmd|
          cmd.tree(commands)
        end
      end
      commands
    end

    def help!
      puts
      puts "Available commands:"
      puts
      tree.each do |key, node|
        indent = node.parents.length + 1
        puts "  " * indent + "#{key}"
      end
    end
  end



  def self.help
    root_namespace.help!
  end
end
