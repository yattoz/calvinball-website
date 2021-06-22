#!/usr/bin/env ruby

require 'optparse'
require 'fileutils'

recommande = {
    :url => "https://recommande.duckdns.org/episodes.mp3.rss",
    :separator => "-",
    :usual_author => "Yattoz",
    :always_people => {"yattoz" => "Yattoz"},
    :podcast_key => "recommande",
    :audio_download => true,
    :resources_download => true
}

calvinball = {
    :url => "https://feeds.soundcloud.com/users/soundcloud:users:290809321/sounds.rss",
    :separator => "-",
    :usual_author => "Zali Falcam",
    :always_people => {"zalifalcam" => "Zali Falcam"},
    :podcast_key => "calvinball"
}

capycast = {
    :url => "https://hearthis.at/capycec/podcast/",
    :separator => "-",
    :usual_author => "Capycec",
    :always_people => {"capycec" => "Capycec"},
    :podcast_key => "capycast"
}

lebestiairedesbesties = {
    :url => "https://hearthis.at/bestiaire-des-besties/podcast/",
    :separator => "-",
    :usual_author => "Capycec",
    :always_people => {"capycec" => "Capycec", "lucile" => "Lucile"},
    :podcast_key => "lebestiairedesbesties"
}

ksdd = {
    :url => "https://hearthis.at/anshiki/podcast/",
    :separator => ":",
    :usual_author => "Ashki",
    :always_people => {"ashki" => "Ashki"},
    :podcast_key => "ksdd"
}

lesfrancobelges = {
    :url => "https://feeds.radiokawa.com/podcast_les-franco-belges.xml",
    :separator => "",
    :usual_author => "Lyonsbanner",
    :always_people => {"lyonsbanner" => "Lyonsbanner", "sonneper" => "SonnePer"},
    :podcast_key => "lesfrancobelges",
    :audio_download => true,
    :resources_download => true
}

# oddly enough MJEE has itunes tags.
mjee = {
    :url => "https://mjee.fr/category/episodes/feed/",
    :separator => "–",
    :usual_author => "Zali Falcam, JoK",
    :always_people => {"zalifalcam" => "Zali Falcam", "jok" => "JoK"},
    :podcast_key => "mjee",
    :audio_download => false
}

calweebball = {
    :url => "https://calvinballradio.wordpress.com/category/calweeb-ball/feed",
    :separator => "–",
    :usual_author => "Zali Falcam",
    :always_people => {"zalifalcam" => "Zali Falcam", "pegase" => "Pegase"},
    :podcast_key => "calweebball",
    :resources_download => false,
    :audio_download => false
}

lappeldekathulu = {
    :url => "https://kathulupodcast.wordpress.com/category/episodes-de-kathulu/feed/",
    :separator => "–",
    :usual_author => "Zali Falcam, Bob",
    :always_people => {"zalifalcam" => "Zali Falcam", "bob" => "Bob"},
    :podcast_key => "lappeldekathulu",
    :audio_download => true
}

leretourdujeudi = {
    :url => "https://retourdujeudi.wordpress.com/category/podcast/feed",
    :separator => "",
    :usual_author => "Kalkulmatriciel, Juuniper",
    :always_people => {"kalkulmatriciel" => "Kalkulmatriciel", "juuniper" => "Juuniper"},
    :podcast_key => "leretourdujeudi",
    :audio_download => true
}

lesreglesdujeu = {
    :url => "https://lesreglesdujeupodcast.wordpress.com/category/les-regles-du-jeu/feed",
    :separator => "",
    :usual_author => "JoK",
    :always_people => {"jok" => "JoK"},
    :podcast_key => "lesreglesdujeu",
    :audio_download => true,
    :resources_download => true
}

ludographie = {
    :url => "https://ludographiepodcast.wordpress.com/category/episodes-de-ludographie/feed",
    :separator => "–",
    :usual_author => "Mathieu Goux",
    :always_people => {"mathieugoux" => "Mathieu Goux"},
    :podcast_key => "ludographie",
    :audio_download => true
}

options = {}
OptionParser.new do |opt|
    opt.on('--cleanall')
    opt.on("--clean KEY", Array)
    opt.on('--cleanonly')
    opt.on('--force')
    opt.on('--clean-only')
    opt.on('--dryrun')
    opt.on('--dev')
    opt.on('--gitdir GIT_DIR')
end.parse!(into: options)


puts options
puts Time.now

force_clean = options[:cleanall] != nil
force_clean_only = options[:cleanonly] != nil
force_override = options[:force] != nil
force_dry_run = options[:dryrun] != nil
force_dev = options[:dev] != nil

puts "Generate pages."
git_dir = `git rev-parse --show-toplevel`.gsub("\n", "") if options[:git_dir] == nil
git_dir = options[:git_dir] if options[:git_dir] != nil
Dir.chdir(git_dir)

homedir = Dir.pwd # to split things up in directories nicely for serving
homedir = "#{Dir.pwd}/docs/.vuepress/public" if force_dev # dev mode
generation_token_path = "#{homedir}/generation_token"
dist_path = "#{homedir}/dist"
FileUtils.mkpath generation_token_path if not Dir.exists? generation_token_path
FileUtils.mkpath dist_path if not Dir.exists? dist_path

require_relative 'parse_rss_itunes'
require_relative 'parse_rss_wordpress'

monitor_itunes = Array.new
monitor_wordpress = Array.new
local_shows = Array.new         # on these local shows we can process things like thumbnailizing etc.

monitor_itunes.push(mjee, calvinball, capycast, lebestiairedesbesties, ksdd, lesfrancobelges, recommande)
monitor_wordpress.push(calweebball, lappeldekathulu, leretourdujeudi, lesreglesdujeu, ludographie)
local_shows.push(recommande)

if options[:clean] != nil then
    options[:clean].each do |key_to_clean|
        if (local_shows.map { |unit| unit[:podcast_key] }).include? key_to_clean then
          puts "don't clean local shows! next."
          next
        end
        monitor_itunes.each do |unit|
            podcast_clean(homedir, unit[:podcast_key]) if unit[:podcast_key] == key_to_clean
        end

        monitor_wordpress.each do |unit|
            podcast_clean(homedir, unit[:podcast_key]) if unit[:podcast_key] == key_to_clean
        end
        FileUtils.rm_r "#{homedir}/remote_feeds_nbeps/#{key_to_clean}.nbep" if File.exists? "#{homedir}/remote_feeds_nbeps/#{key_to_clean}.nbep"
    end
end

if force_clean || force_clean_only then
    monitor_itunes.each do |unit|
        podcast_clean(homedir, unit[:podcast_key])
    end

    monitor_wordpress.each do |unit|
        podcast_clean(homedir, unit[:podcast_key])
    end
    FileUtils.rm_r generation_token_path if Dir.exists? generation_token_path
    FileUtils.rm_r "#{homedir}/remote_feeds_nbeps/" if Dir.exists? "#{homedir}/remote_feeds_nbeps/"
end

is_new_episode = 0

if !force_dry_run && !force_clean_only then
    monitor_wordpress.each do |unit|
        is_new_episode = is_new_episode + parse_rss_wordpress(homedir, unit, force_override)
    end
    
    monitor_itunes.each do |unit|
        is_new_episode = is_new_episode + parse_rss_itunes(homedir, unit, force_override)
    end
end

def thumbnailize(homedir, show, force=false)
    image_dir =      "#{homedir}/images/#{show[:podcast_key]}/thumbnail"
    image_full_dir = "#{homedir}/images/#{show[:podcast_key]}/full"

    image_thumbnail_list = Dir["#{image_dir}/*.jpg"]
    image_full_list = Dir["#{image_full_dir}/*.jpg"]
    puts "#{image_dir} -> #{image_full_dir}"
    puts "#{image_thumbnail_list.size} -> #{image_full_list.size}"

    image_thumbnail_list_old = image_thumbnail_list.map { |unit| unit.gsub("/thumbnail/", "/full/") } 
    new_images = image_full_list - image_thumbnail_list_old 
    puts "Gotta generate thumbnails for: #{new_images}"
    
    new_images.each do |image_name_jpg|
        begin
            i = Magick::Image.read("#{image_name_jpg}").first
        rescue
            i = nil
            next
        end
        i.format = 'JPEG'
        # resize
        image_size_side = 300
        i.resize!(image_size_side, image_size_side)
        # convert to progressive JPEG with quality 80
        i.write("#{image_name_jpg.gsub("/full/", "/thumbnail/")}") { self.quality = 70; self.interlace = Magick::PlaneInterlace }
        # @image = "/images/#{@podcast_key}/thumbnail/#{image_name_jpg}" if File.exists? "#{image_dir}/#{image_name_jpg}"
    end
end

# check if there are thumbnails to generate.
puts "Thumbnail generation."
local_shows.each do |unit|
    thumbnailize(homedir, unit, force_override)
end

require_relative 'generate_rss'

# you can rebuild manually if needed. seems like it's not very interesting though, you could just remove remote_feeds_nbeps
new_token = "#{generation_token_path}/token"

if (is_new_episode > 0 || File.exists?(new_token)) then
    FileUtils.rm new_token if File.exists?(new_token)
    puts "rebuilding vuepress app."
   `npm run build`
   `cp -a #{homedir}/docs/.vuepress/dist/* #{homedir}/dist/` if not force_dev
end

puts "done."

