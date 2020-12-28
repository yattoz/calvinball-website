require 'pry'
require 'nokogiri'
require 'chronic'
require 'open-uri'
require 'sanitize'

require_relative 'episode_page'

=begin
This parser should read itunes-specific metadata to convert the pages.
Normally, hear.this and Recommandé should be processed by that one, and Calvinball (Soundcloud) too
=end

def parse_rss_itunes(homedir, url, separator, usual_author, always_people, podcast_key, website_url, force_override=false)
    # let's do some magic
    doc = Nokogiri::XML(URI.open(url))
    items = doc.css("item")
    episodes = Array.new
    podcast_image = "#{website_url}/podcast_covers/#{podcast_key}.jpg"
    items.each do |item|
        title = item.css("title").first.text.split(/\s#{separator}\s/)

        main_title = ""
        subtitle = ""
        if title.length > 1 then
            if podcast_key == "lebestiairedesbesties" then
                main_title = title[0..title.length-2].join(" ")
                subtitle =  title[title.length-1]
            else
                main_title = title[0]
                subtitle =  title[1..title.length-1].join(separator)
            end
        else
            main_title =  title[title.length - 1]
            subtitle = ""
        end
        main_title = main_title.gsub("\"", "\\\"")
        subtitle = subtitle.gsub("\"", "\\\"")
    

        mp3_link = item.css("enclosure").first["url"]
        mp3_duration = item.css("itunes|duration").text
        date = DateTime.parse(item.css("pubDate").text)
        image = item.css("itunes|image")
        image = image.first["href"] if not image.empty?
        image = podcast_image if image.empty? # if you forgot to put a cover for the podcast, use podcast cover...

        raw_description_arr = Array.new
        begin
            raw_description_arr.push(item.css("content|encoded").text)
        rescue
        end
        begin
            raw_description_arr.push(item.css("description").text)
        rescue
        end
        begin
            raw_description_arr.push(item.css("itunes|summary").text)
        rescue
        end
        raw_description = raw_description_arr.max_by(&:length)

        ## sometimes you need, sometimes you don't, I think it's relative to hearthis
        raw_description.gsub!(/\n/, "<br/>") if url.include?("soundcloud")

        description = Sanitize.fragment(raw_description, \
            Sanitize::Config.merge(Sanitize::Config::BASIC, :elements => ["img", "tr", "td", "a", "br", "p", "h4", "h5", "h6", "ul", "li"], :attributes => {
                'a'          => ['href', 'title'],
                'blockquote' => ['cite'],
                'img'        => ['alt', 'src', 'title']
            }))
        # puts "#{main_title} === #{subtitle}"
        # puts "\t mp3=#{mp3_link}" 
        # puts "\t date=#{date}"
        # puts "\t image=#{image}"
        author = usual_author
        people_link = always_people
        episode = EpisodePage.new(podcast_key, main_title, subtitle, image, mp3_link, date, description, author, people_link, mp3_duration)
        episodes.push(episode)
    end
    puts "#{podcast_key} - #{episodes.size} episodes"

    episodes.each do |episode|
        episode.download_image(homedir, force = force_override)
        episode.download_audio(homedir, force = force_override) if podcast_key == "capycast"
        episode.write(force = force_override)
    end
end

