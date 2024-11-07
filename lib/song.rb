require 'faker'  

module MyApplicationTunik
  class Song
    attr_accessor :name, :author, :author_chord, :content, :image_path

    def self.logger
      MyApplicationTunik::LoggerManager
    end

    def initialize(attributes = {})
      @name = attributes.fetch(:name, "Unknown")
      @author = attributes.fetch(:author, "Unknown")
      @author_chord = attributes.fetch(:author_chord, "Unknown")
      @content = attributes.fetch(:content, "")
      @image_path = attributes.fetch(:image_path, "default_image.jpg")

      self.class.logger.log_processed_file("Created new Song: #{@name}")

      yield self if block_given?
    end

    alias_method :info, :to_s

    def to_s
      "Name: #{@name}, Author: #{@author}, Author chord: #{@author_chord}, Content: #{@content}, Шлях до зображення: #{@image_path}"
    end

    def to_h
      instance_variables.each_with_object({}) do |var, hash|
        hash[var.to_s.delete("@")] = instance_variable_get(var)
      end
    end

    def inspect
      "#<Item name=#{@name.inspect}, Author=#{@author.inspect}, Author chord=#{@author_chord.inspect}, Content=#{@content.inspect}, image_path=#{@image_path.inspect}>"
    end

    def update
      yield self if block_given?
      self.class.logger.log_processed_file("Song updated: #{@name}")
    rescue => e
      self.class.logger.log_error(e.message)
    end

    def self.generate_fake
      new(
        name: Faker::Lorem.word,
        author: Faker::Artist.name,
        author_chord: Faker::Name.name,
        content: Faker::Lorem.sentence,
        image_path: "fake_image.jpg"
      ).tap do |item|
        logger.log_processed_file("Created face Song: #{item.name}")
      end
    end

    def <=>(other)
      author <=> other.author
    end

  end
end