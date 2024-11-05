begin

require 'nokogiri'
require 'open-uri'
puts "hi bitch"
doc = Nokogiri::HTML(URI.open('https://mychords.net/uk/chubaj-taras/171850-skryabin-ked-mi-prijshla-karta.html').read, nil, 'UTF-8')
doc.css('.w-words__text').each do |text|
  puts text.text
end
rescue => e
  puts "Помилка: #{e.message}"
end