require 'nokogiri'
require 'open-uri'

class ArtistPageParser
  attr_reader :artist_url, :songs_data, :configurator, :yaml_configs, :item_collection, :artist_name

  def initialize(artist_url, configurator, yaml_configs)
    @configurator = configurator
    @yaml_configs = yaml_configs
    @artist_url = yaml_configs['web_scraping']['start_page'] + artist_url
    @item_collection = MyApplicationTunik::ItemCollection.new
  end

  def parse
    parse_main_page
  end

  private

  def parse_main_page
    document = load_page(@artist_url)

    song_author = document.css(yaml_configs['web_scraping']['author_song_selector'])

    song_author.each do |song_author_text|
      @artist_name = song_author_text.children.first.text.strip
    end

    song_links = document.css(yaml_configs['web_scraping']['song_url_link_selector'])

    song_links.each do |link|
      song_url = link['href']
      parse_song_page(song_url)
    end

    if configurator.config[:run_save_to_file] == 1
      @item_collection.save_to_file
    end
    if configurator.config[:run_save_to_json] == 1
      @item_collection.save_to_json
    end
    if configurator.config[:run_save_to_csv] == 1
      @item_collection.save_to_csv
    end
    if configurator.config[:run_save_to_yaml] == 1
      @item_collection.save_to_yml
    end

  end

  def parse_song_page(song_url)
    song_url = yaml_configs['web_scraping']['start_page'] + song_url
    song_page = load_page(song_url)

    name = song_page.at_css(yaml_configs['web_scraping']['name_song_selector'])&.text
    name = name.gsub(name + " - ", '').strip

    author_chord = song_page.at_css(yaml_configs['web_scraping']['author_chord_selector'])&.text

    content = song_page.at_css(yaml_configs['web_scraping']['content_song_selector'])&.text

    song = MyApplicationTunik::Song.new(name: name, author: @artist_name, author_chord: author_chord, content: content)
    item_collection.add_item(song)

  end

  def load_page(url)
    puts "loading #{url}"
    Nokogiri::HTML(URI.open(url))
  rescue OpenURI::HTTPError => e
    puts "Помилка завантаження сторінки: #{e.message}"
    nil
  end
end
