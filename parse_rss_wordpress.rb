require 'pry'
require 'nokogiri'
require 'chronic'
require 'open-uri'
require 'sanitize'

# url = "https://kathulupodcast.wordpress.com/feed/"
url = "https://calvinballradio.wordpress.com/category/calweeb-ball/feed"
separator = "–"
usual_author = "Zali Falcam"
always_people = {"zalifalcam" => "Zali Falcam", "bob" => "Bob"}
bitrate = 192 # for the experiment, assume bitrate



doc = Nokogiri::XML(URI.open(url))
items = doc.css("item")
items.each do |item|
    title = item.css("title").first.text.split(/\s#{separator}\s/)
    main_title = title[0]
    subtitle = title[1]
    mp3_link = item.css("enclosure").first["url"]
    mp3_duration_raw = item.css("enclosure").first["length"].to_i # size in Bytes

# don't get duration from bitrate, it's not even constant.
=begin
    mp3_duration_hours = (mp3_duration_raw)/(bitrate*1000/8) / 3600
    mp3_duration_minutes = ((mp3_duration_raw)/(bitrate*1000/8)  - mp3_duration_hours * 3600) / 60
    mp3_duration_seconds = ((mp3_duration_raw)/(bitrate*1000/8)  - mp3_duration_hours * 3600 - mp3_duration_minutes * 60)
    mp3_duration_string = "%02d:%02d:%02d" % [mp3_duration_hours, mp3_duration_minutes, mp3_duration_seconds]
=end
    date = Date.parse(item.css("pubDate").text)
    image = item.css("media|thumbnail")
    image = image.first["url"] if not image.empty?
    image = item.css("media|content").first["url"] if image.empty? # if you forgot to put a cover for the podcast, use wordpress icon...

    description = Sanitize.fragment(item.children.css("content|encoded").text, Sanitize::Config.merge(Sanitize::Config::RELAXED, :remove_content => ["audio"] )) # could be BASIC to remove images as well.
    puts "#{main_title} === #{subtitle}"
    puts "\t mp3=#{mp3_link}" 
    puts "\t date=#{date}"
    puts "\t image=#{image}"  
    # puts "\t description=#{description}"
    # puts "\t duration=#{mp3_duration_string}"
end
