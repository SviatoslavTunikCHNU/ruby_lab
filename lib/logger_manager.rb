require 'logger'
require 'yaml'

module MyApplicationTunik
  class LoggerManager
    class << self
      attr_reader :logger

      def initialize_logger(config)
        log_directory = config['directory'] || 'logs'
        log_level = parse_log_level(config['level'] || 'INFO')
        log_files = config['files'] || { 'application_log' => 'application.log', 'error_log' => 'error.log' }

        Dir.mkdir(log_directory) unless Dir.exist?(log_directory)

        @logger = {
          application: Logger.new(File.join(log_directory, log_files['application_log'])),
          error: Logger.new(File.join(log_directory, log_files['error_log']))
        }

        @logger[:application].level = log_level
        @logger[:error].level = Logger::ERROR
      end

      def log_processed_file(file_name)
        @logger[:application].info("File processed: #{file_name}")
      end

      def log_error(error_message)
        @logger[:error].error("Error occurred: #{error_message}")
      end

      private

      def parse_log_level(level)
        case level.upcase
        when 'DEBUG'
          Logger::DEBUG
        when 'INFO'
          Logger::INFO
        when 'WARN'
          Logger::WARN
        when 'ERROR'
          Logger::ERROR
        else
          Logger::INFO
        end
      end
    end
  end
end
