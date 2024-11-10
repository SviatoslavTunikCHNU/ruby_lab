require 'json'
require 'csv'
require 'yaml'
require_relative 'item_container'

module MyApplicationTunik
  class ItemCollection
    include ItemContainer
    include Enumerable

    attr_accessor :items

    def self.logger
      MyApplicationTunik::LoggerManager
    end

    def initialize
      @items = []
    end

    def each(&block)
      @items.each(&block)
    end

    def save_to_file(filename = 'items')

      File.open("files/#{filename}.txt", 'w') do |file|
        @items.each { |item| file.puts(item.to_s) }
      end
      self.class.logger.log_processed_file("Saved items to #{filename}")
    end

    def save_to_json(filename = 'items')
      File.write("files/#{filename}.json", @items.to_json)
      self.class.logger.log_processed_file("Saved items to #{filename} in JSON format")
    end

    def save_to_csv(filename = 'items')
      CSV.open("files/#{filename}.csv", 'w') do |csv|
        csv << @items.first.keys if @items.any?
        @items.each { |item| csv << item.values }
      end
      self.class.logger.log_processed_file("Saved items to #{filename} in CSV format")
    end

    def generate_test_items(count)
      count.times do |i|
        item = { name: "Item #{i}", author: "author #{i}", author_chord: "author_chord #{i}", content: "content #{i}",
                 image_path: "content #{i}" }
        add_item(item)
      end
    end

    def save_to_yml
      @items.each_with_index do |item, index|
        File.write("files/item_#{index}.yml", item.to_yaml)
        self.class.logger.log_processed_file("Saved item ##{index} in YAML format")
      end
    end

    # Enumerable methods
    def find_by_condition(&block)
      find(&block)
    end

    def select_by_condition(&block)
      select(&block)
    end

    def reject_by_condition(&block)
      reject(&block)
    end

    def all_match_condition?(&block)
      all?(&block)
    end

    def any_match_condition?(&block)
      any?(&block)
    end

    def none_match_condition?(&block)
      none?(&block)
    end

    def count_by_condition(&block)
      count(&block)
    end

    def map_items(&block)
      map(&block)
    end

    def sort_items(&block)
      sort(&block)
    end

    def unique_items
      uniq
    end
  end
end
