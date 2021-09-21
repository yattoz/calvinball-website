require 'pry'
require 'nokogiri'
require 'chronic'
require 'open-uri'
require 'sanitize'

require_relative 'episode_page'
require_relative 'rss_number_change'

=begin
This parser should read itunes-specific metadata to convert the pages.
Normally, hear.this and Recommandé should be processed by that one, and Calvinball (Soundcloud) too
=end

def parse_rss_itunes(homedir, unit, force_override=false)
    url, separator, usual_author, always_people, podcast_key = unit[:url], unit[:separator], unit[:usual_author], unit[:always_people], unit[:podcast_key]
    cover_keep_orig = (unit[:cover_keep_orig].nil? ? false : unit[:cover_keep_orig])
    audio_download = (unit[:audio_download].nil? ? false : unit[:audio_download])
    force_override = (unit[:force_override].nil? ? force_override : unit[:force_override])
    resources_download = (unit[:resources_download].nil? ? false : unit[:resources_download])

    # let's do some magic
    rss_file = URI.open(url)
    doc = Nokogiri::XML(rss_file)
    items = doc.css("item")

    checker = NbEpsChecker.new
    is_updated = checker.has_rss_number_changed(homedir, podcast_key, items.size)
    if not is_updated then
        puts "#{podcast_key} hasn't changed from last check. Skipping..."
        return 0
    end

    episodes = Array.new
    podcast_image = "/podcast_covers/#{podcast_key}.jpg"
    items.each do |item|
        title = item.css("title").first.text

        main_title = title.gsub("\"", "\\\"")
        subtitle = ""

        mp3_link = item.css("enclosure").first["url"]
        mp3_duration = item.css("itunes|duration").text
        date = DateTime.parse(item.css("pubDate").text)
        image = item.css("itunes|image")
        image = image.first["href"] if not image.empty?
        image = podcast_image if image.empty? # if you forgot to put a cover for the podcast, use podcast cover...
        is_explicit = item.css("itunes|explicit")
        is_explicit = "no" if is_explicit.empty?

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
        # subtitle = Nokogiri::HTML(description).text.gsub("\n", " ")
        # puts "#{main_title} === #{subtitle}"
        # puts "\t mp3=#{mp3_link}" 
        # puts "\t date=#{date}"
        # puts "\t image=#{image}"
        author = usual_author
        people_link = always_people
        guid = item.css("guid").text
        is_explicit = item.css("itunes|explicit").text == "yes"
        episode = EpisodePage.new(podcast_key, main_title, subtitle, image, mp3_link, date, description, author, people_link, is_explicit, guid, mp3_duration)
        episodes.push(episode)
    end
    puts "#{podcast_key} - #{episodes.size} episodes"

    episodes.each do |episode|
        episode.download_resources(homedir, force = force_override) if resources_download
        episode.download_image(homedir, force = force_override)
        episode.download_audio(homedir, force = force_override) if audio_download
        episode.write(force = force_override)
    end

    checker.update_rss_number_changed(homedir, podcast_key)

    return items.size
end

