require 'pry'
require 'nokogiri'
require 'chronic'
require 'open-uri'
require 'sanitize'

require_relative 'episode_page'


def parse_rss_wordpress(homedir, url, separator, usual_author, always_people, podcast_key, website_url)
    # let's do some magic
    doc = Nokogiri::XML(URI.open(url))
    items = doc.css("item")
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

        mp3_link = item.css("enclosure").first["url"]
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
        episode.download_image(homedir, force = true)
        episode.write(force = true)
    end
end

def podcast_clean(podcast_key)
    episodes_dir = "docs/podcasts/#{podcast_key}/episodes"
    FileUtils.rm_r "#{episodes_dir}" if Dir.exists? "#{episodes_dir}"
    puts "#{podcast_key} cleaned"
end

monitor = Array.new

calweebball = {
    :url => "https://calvinballradio.wordpress.com/category/calweeb-ball/feed",
    :separator => "–",
    :usual_author => "Zali Falcam",
    :always_people => {"zalifalcam" => "Zali Falcam", "pegase" => "Pegase"},
    :podcast_key => "calweebball"
}

lappeldekathulu = {
    :url => "https://kathulupodcast.wordpress.com/category/episodes-de-kathulu/feed/",
    :separator => "–",
    :usual_author => "Zali Falcam, Bob",
    :always_people => {"zalifalcam" => "Zali Falcam", "bob" => "Bob"},
    :podcast_key => "lappeldekathulu"
}

leretourdujeudi = {
    :url => "https://retourdujeudi.wordpress.com/category/podcast/feed",
    :separator => "",
    :usual_author => "Kalkulmatriciel, Juuniper",
    :always_people => {"kalkulmatriciel" => "Kalkulmatriciel", "juuniper" => "Juuniper"},
    :podcast_key => "leretourdujeudi"
}

lesreglesdujeu = {
    :url => "https://lesreglesdujeupodcast.wordpress.com/category/les-regles-du-jeu/feed",
    :separator => "",
    :usual_author => "JoK",
    :always_people => {"jok" => "JoK"},
    :podcast_key => "lesreglesdujeu"
}

ludographie = {
    :url => "https://ludographiepodcast.wordpress.com/category/episodes-de-ludographie/feed",
    :separator => "–",
    :usual_author => "Mathieu Goux",
    :always_people => {"mathieugoux" => "Mathieu Goux"},
    :podcast_key => "ludographie"
}

website_url = "https://calvinball-poc.netlify.app"

monitor.push(calweebball, lappeldekathulu, leretourdujeudi, lesreglesdujeu, ludographie)

puts "this script should be run from the scripts directory. If not, fix your path."
Dir.chdir("..")
homedir = Dir.pwd

monitor.each do |unit|
    podcast_clean(unit[:podcast_key])
    parse_rss_wordpress(homedir, unit[:url], unit[:separator], unit[:usual_author], unit[:always_people], unit[:podcast_key], website_url)
end

