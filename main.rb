require_relative "lib/app_config_loader.rb"

begin
  loader = MyApplicationTunik::AppConfigLoader.new
  loader.load_libs

  loader.config("default_config.yaml", File.expand_path(File.dirname(__FILE__)) + "/config")

  loader.pretty_print_config_data

  MyApplicationTunik::LoggerManager.initialize_logger(loader.config_data['logging'])

  MyApplicationTunik::LoggerManager.log_processed_file('test.file')

  MyApplicationTunik::LoggerManager.log_error('An unexpected error occurred')
rescue => e
  puts "Помилка: #{e.message}"
  puts e.backtrace.join("\n")
end