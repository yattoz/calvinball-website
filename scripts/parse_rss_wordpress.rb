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

def parse_rss_wordpress(homedir, assets_dir, unit, force_override=false, force_nodownload=false)
    url, separator, usual_author, always_people, podcast_key = unit[:url], unit[:separator], unit[:usual_author], unit[:always_people], unit[:podcast_key]
    cover_keep_orig = (unit[:cover_keep_orig].nil? ? false : unit[:cover_keep_orig])
    audio_download = (unit[:audio_download].nil? ? false : unit[:audio_download])
    resources_download = (unit[:resources_download].nil? ? false : unit[:resources_download])
    
    print "parsing RSS for: #{unit[:podcast_key]}... "

    # let's do some magic
    rss_file = URI.open(url)
    doc = Nokogiri::XML(rss_file)
    items = doc.css("item")

    checker = NbEpsChecker.new

    is_updated = checker.has_rss_number_changed(homedir, podcast_key, items.size)
    if not is_updated then
        print "no new episode found.\n"
        return 0
    end

    episodes = Array.new
    items.each do |item|
        css_title = item.css("title").first.text
        subtitle = ""
        title = css_title.gsub("\"", "\\\"")
        begin
            mp3_link = item.css("enclosure").first["url"]
        rescue
            mp3_link = ""
            next
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
        # subtitle = Nokogiri::HTML(description).text.gsub("\n", " ")

        # puts "#{title} === #{subtitle}"
        # puts "\t mp3=#{mp3_link}" 
        # puts "\t date=#{date}"
        # puts "\t image=#{image}"
        author = usual_author
        people_link = always_people
        guid = item.css("guid").text
        is_explicit = item.xpath("//itunes:explicit", "itunes" => "http://www.itunes.com/dtds/podcast-1.0.dtd").text == "yes"
        episode = EpisodePage.new(podcast_key, title, subtitle, image, mp3_link, date, description, author, people_link, is_explicit, guid, mp3_duration)
        episodes.push(episode)
    end
    puts "#{podcast_key} - #{episodes.size} episodes"

    episodes.each do |episode|
        episode.download_resources(assets_dir, force = force_override) if (resources_download and not force_nodownload)
        episode.download_image(assets_dir, force = force_override, cover_keep_orig)
        episode.download_audio(assets_dir, force = force_override) if (audio_download and not force_nodownload)
        episode.write(assets_dir, force = force_override)
    end

    checker.update_rss_number_changed(homedir, podcast_key)

    return items.size
end


