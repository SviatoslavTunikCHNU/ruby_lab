module MyApplicationTunik
  class AppConfigLoader
    attr_reader :config_data
    def initialize
      @config_data = {}
      @loaded_files = []
    end
  
    def config(main_config_path, additional_dir_path)
      @config_data.merge!(load_default_config(main_config_path))
  
      @config_data.merge!(load_config(additional_dir_path))
  
      if block_given?
        yield @config_data
      end
  
      @config_data
    end
  
    def pretty_print_config_data
      puts JSON.pretty_generate(@config_data)
    end

    def load_libs
      system_libs = ['date', 'yaml', 'json', 'erb']
  
      system_libs.each do |lib|
        require lib
      end
  
      Dir.glob(File.expand_path(File.dirname(__FILE__)) + '/*.rb').each do |file|
        next if @loaded_files.include?(file)
        require_relative file
        @loaded_files << file
      end
    end
  
    private
  
    def load_default_config(path)
      content = File.read(path)
      erb_result = ERB.new(content).result
      YAML.safe_load(erb_result) || {}
    end
  
    def load_config(directory)
      config_data = {}
  
      Dir.glob("#{directory}/*.yaml").each do |file|
        config_data.merge!(YAML.safe_load(File.read(file)) || {})
      end
  
      config_data
    end
  end  
end
