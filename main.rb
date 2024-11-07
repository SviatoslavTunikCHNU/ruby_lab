require_relative "lib/app_config_loader.rb"

begin
  loader = MyApplicationTunik::AppConfigLoader.new
  loader.load_libs

  loader.config("default_config.yaml", File.expand_path(File.dirname(__FILE__)) + "/config")

  MyApplicationTunik::LoggerManager.initialize_logger(loader.config_data['logging'])

  song = MyApplicationTunik::Song.new(name: "Назва", author: "Автор") do |i|
    i.author_chord = "Автор розбору"
    i.content = "Текст і акорди"
  end
  puts song.to_s
  puts song.to_h
  
  song.update do |i|
    i.name = "Нова назва"
    i.author = "Новий виконавець"
  end
  puts song.info
  
  fake_song = MyApplicationTunik::Song.generate_fake
  puts fake_song.inspect
rescue => e
  puts "Помилка: #{e.message}"
  puts e.backtrace.join("\n")
end