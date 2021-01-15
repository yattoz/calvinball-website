require 'pry'
require 'nokogiri'
require 'chronic'
require 'open-uri'
require 'sanitize'

require_relative 'episode_page'
require_relative 'rss_number_change'

=begin
This parser should read wordpress-specific metadata to convert the pages.
=end

def parse_rss_wordpress(homedir, unit, force_override=false)
    url, separator, usual_author, always_people, podcast_key = unit[:url], unit[:separator], unit[:usual_author], unit[:always_people], unit[:podcast_key]
    cover_keep_orig = (unit[:cover_keep_orig].nil? ? false : unit[:cover_keep_orig])
    audio_download = (unit[:audio_download].nil? ? false : unit[:audio_download])
    resources_download = (unit[:resources_download].nil? ? false : unit[:resources_download])
    
    # let's do some magic
    rss_file = URI.open(url)
    doc = Nokogiri::XML(rss_file)
    items = doc.css("item")

    is_updated = has_rss_number_changed(homedir, podcast_key, items.size)
    if not is_updated then
        puts "#{podcast_key} hasn't changed from last check. Skipping..."
        return 0
    end

    episodes = Array.new
    items.each do |item|
        title = item.css("title").first.text.split(/\s#{separator}\s/)

        main_title = ""
        subtitle = ""
        if title.length > 1 then
            if podcast_key == "lebestiairedesbesties" then ## copy-pasted from the itunes counterpart. Not used, but should be okay nonetheless
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
        begin
	mp3_link = item.css("enclosure").first["url"]
	rescue
	mp3_link = ""
	end
        mp3_duration = 0 #Wordpress doesn't give any duration
        date = DateTime.parse(item.css("pubDate").text)
        image = item.css("media|thumbnail")
        image = image.last["url"] if not image.empty?
        image = item.css("media|content").last["url"] if image.empty? # if you forgot to put a cover for the podcast, use wordpress icon...
        image = image.gsub(/\?*$/, "")
        description = Sanitize.fragment(item.children.css("content|encoded").text, \
            Sanitize::Config.merge(Sanitize::Config::BASIC, :elements => ["img", "tr", "td", "a", "br", "p"], :attributes => {
                'a'          => ['href', 'title'],
                'blockquote' => ['cite'],
                'img'        => ['alt', 'src', 'title']
            })) # could be BASIC to remove images as well.

        # remove wp-content MP3 links that Zali used to put in his descriptions... grmbl.
        description.gsub!(/\"https:\/\/.*\/wp-content\/.*\.mp3\"/, "\"\"")
        description.gsub!(/https:\/\/.*\/wp-content\/.*\.mp3/, "")

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
        episode.download_resources(homedir, force = force_override) if resources_download
        episode.download_image(homedir, force = force_override, cover_keep_orig)
        episode.download_audio(homedir, force = force_override) if audio_download
        episode.write(force = force_override)
    end

    return items.size
end


