require 'dev'

module Dev
  module Commands
    class Config < Dev::Command
      def call(args, _name)
        case args.size
        when 0
          print_config
        when 1, 2 # get, get <key>, unset
          case args.first
          when 'get'
            print_config(*split_key(args[1]))
            nil
          when 'unset'
            record_config(*split_key!(args[1]), nil)
          else
            print_usage
          end
        when 3 # set key value
          case args.first
          when 'set'
            record_config(*split_key!(args[1]), args[2])
          else
            print_usage
          end
        end
      end

      private

      def split_key(section_and_key)
        section_and_key&.split('.', 2)
      end

      def split_key!(section_and_key)
        split_key(section_and_key).tap do |_section, key|
          raise(Dev::Abort, "Key must contain a \".\"") unless key
        end
      end

      def print_config(section = nil, key = nil)
        if key
          val = Dev::Config.get(section, key)
          raise(Dev::AbortSilent) unless val
          puts val
        elsif section
          section_hash = Dev::Config.get_section(section)
          raise(Dev::AbortSilent) if section_hash.empty?
          puts section_hash.map { |k, v| "#{k} = #{v}" }
        else
          puts Dev::Config.to_s
        end
      end

      def print_usage
        STDERR.puts "This was not the correct usage of the `config` command"
        STDERR.puts "Please see below for the correct usage:\n\n"
        Dev::Commands::Help.call(%w(config), 'help')
      end

      def record_config(section, key, value)
        puts "Setting config with key #{section}.#{key} to #{value.inspect}"
        Dev::Config.set(section, key, value)
      end
    end
  end
end
