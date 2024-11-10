require_relative "lib/app_config_loader.rb"

begin
  loader = MyApplicationTunik::AppConfigLoader.new
  loader.load_libs

  loader.config("default_config.yaml", File.expand_path(File.dirname(__FILE__)) + "/config")

  MyApplicationTunik::LoggerManager.initialize_logger(loader.config_data['logging'])

  # song = MyApplicationTunik::Song.new(name: "Назва", author: "Автор") do |i|
  #   i.author_chord = "Автор розбору"
  #   i.content = "Текст і акорди"
  # end
  # puts song.to_s
  # puts song.to_h
  
  # song.update do |i|
  #   i.name = "Нова назва"
  #   i.author = "Новий виконавець"
  # end
  # puts song.info
  
  # fake_song = MyApplicationTunik::Song.generate_fake
  # puts fake_song.inspect

  # item_collection = MyApplicationTunik::ItemCollection.new
  #
  # item_collection.generate_test_items(5)
  #
  # item_collection.each { |item| puts item }
  # puts item_collection.map_items
  # puts item_collection.select_by_condition
  # puts item_collection.all_match_condition?
  # puts item_collection.count_by_condition
  #
  # item_collection.save_to_file
  # item_collection.save_to_json
  # item_collection.save_to_csv
  # item_collection.save_to_yml

  configurator = MyApplicationTunik::Configurator.new
  puts "Start settings: #{configurator.config}"

  configurator.configure(
    run_website_parser: 1,
    run_save_to_csv: 1,
    run_save_to_yaml: 1,
    run_save_to_sqlite: 1
  )

  puts "Updated settings: #{configurator.config}"

  puts "Available methods: #{MyApplicationTunik::Configurator.available_methods}"


rescue => e
  puts "Помилка: #{e.message}"
  puts e.backtrace.join("\n")
end