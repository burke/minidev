require('dev')
require('yaml')

module Dev
  class Project
    NoProject = Class.new(Abort)

    def self.current(dir = Dir.pwd)
      raise(NoProject, "no project") if dir == '/'
      return new(dir) if File.exist?("#{dir}/dev.yml")
      current(File.expand_path(File.dirname(dir)))
    end

    def initialize(dir)
      @dir = dir
    end

    def config
      @config ||= YAML.load_file("#{@dir}/dev.yml")
    end
  end
end
