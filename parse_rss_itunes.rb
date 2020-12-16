require 'pry'
require 'nokogiri'
require 'chronic'
require 'open-uri'
require 'sanitize'

require_relative 'episode_page'

=begin
This parser should read itunes-specific metadata to convert the pages.
Normally, hear.this and Recommandé should be processed by that one.
=end

# url = "https://kathulupodcast.wordpress.com/feed/"
url = "https://recommande.duckdns.org/episodes.mp3.rss"
separator = "-"
usual_author = "Yattoz"
always_people = {"yattoz" => "Yattoz"}
podcast_key = "recommande"



website_url = "https://calvinball-poc.netlify.app"


# let's do some magic
doc = Nokogiri::XML(URI.open(url))
items = doc.css("item")
episodes = Array.new
items.each do |item|
    title = item.css("title").first.text.split(/\s#{separator}\s/)
    main_title = title[0]
    subtitle = title[1]
    subtitle = "" if subtitle == nil
    mp3_link = item.css("enclosure").first["url"]
    mp3_duration = item.css("itunes|duration").text
    date = Date.parse(item.css("pubDate").text)
    image = item.css("itunes|image")
    image = image.first["href"] if not image.empty?
    
    # image = item.css("media|content").first["url"] if image.empty? # if you forgot to put a cover for the podcast, use wordpress icon...
    raw_description = item.css("content|encoded")
    raw_description = item.css("description") if raw_description == nil
    raw_description = item.css("itunes|summary")  if raw_description == nil

    # raw_description = raw_description.text.gsub(/\n/, "<br/>")
    
    description = Sanitize.fragment(raw_description, \
        Sanitize::Config.merge(Sanitize::Config::BASIC, :elements => ["img", "tr", "td", "a", "br", "p", "h4", "h5", "h6", "ul", "li"], :attributes => {
            'a'          => ['href', 'title'],
            'blockquote' => ['cite'],
            'img'        => ['alt', 'src', 'title']
          })) # could be BASIC to remove images as well.
    puts "#{main_title} === #{subtitle}"
    puts "\t mp3=#{mp3_link}" 
    puts "\t date=#{date}"
    puts "\t image=#{image}"
    author = usual_author
    people_link = always_people
    episode = EpisodePage.new(main_title, subtitle, image, mp3_link, date, description, author, people_link, mp3_duration)
    episodes.push(episode)
    # binding.pry
end

puts "#{episodes.size} episodes"
# binding.pry

# don't get duration from bitrate, it's not even constant.
=begin
    bitrate = 192 # for the experiment, assume bitrate
    mp3_duration_hours = (mp3_duration_raw)/(bitrate*1000/8) / 3600
    mp3_duration_minutes = ((mp3_duration_raw)/(bitrate*1000/8)  - mp3_duration_hours * 3600) / 60
    mp3_duration_seconds = ((mp3_duration_raw)/(bitrate*1000/8)  - mp3_duration_hours * 3600 - mp3_duration_minutes * 60)
    mp3_duration_string = "%02d:%02d:%02d" % [mp3_duration_hours, mp3_duration_minutes, mp3_duration_seconds]
=end



episodes.each do |episode|
    episode.write(podcast_key)
end

