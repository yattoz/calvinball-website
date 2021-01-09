#!/usr/bin/env ruby

require_relative 'parse_rss_itunes'
require_relative 'parse_rss_wordpress'
require 'optparse'

recommande = {
    :url => "https://recommande.duckdns.org/episodes.mp3.rss",
    :separator => "-",
    :usual_author => "Yattoz",
    :always_people => {"yattoz" => "Yattoz"},
    :podcast_key => "recommande",
    :cover_keep_orig => true,
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

# oddly enough MJEE has itunes tags.
mjee = {
    :url => "https://mjee.fr/category/episodes/feed/",
    :separator => "–",
    :usual_author => "Zali Falcam, JoK",
    :always_people => {"zalifalcam" => "Zali Falcam", "jok" => "JoK"},
    :podcast_key => "mjee"
}

calweebball = {
    :url => "https://calvinballradio.wordpress.com/category/calweeb-ball/feed",
    :separator => "–",
    :usual_author => "Zali Falcam",
    :always_people => {"zalifalcam" => "Zali Falcam", "pegase" => "Pegase"},
    :podcast_key => "calweebball",
    :resources_download => true

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
    :podcast_key => "lesreglesdujeu",
    :cover_keep_orig => true,
    :audio_download => false,
    :resources_download => true
}

ludographie = {
    :url => "https://ludographiepodcast.wordpress.com/category/episodes-de-ludographie/feed",
    :separator => "–",
    :usual_author => "Mathieu Goux",
    :always_people => {"mathieugoux" => "Mathieu Goux"},
    :podcast_key => "ludographie"
}

options = {}
OptionParser.new do |opt|
    opt.on('--clean') { |o| options[:clean] = true }
    opt.on('--clean-only') { |o| options[:clean_only] = true }
    opt.on('--override') { |o| options[:override] = true }
    opt.on('--clean-only') { |o| options[:clean_only] = true }
    opt.on('--dry-run') { |o| options[:dry_run] = true }
    opt.on('--dev') { |o| options[:dev] = true}
end.parse!

force_clean = options[:clean] != nil
force_clean_only = options[:clean_only] != nil
force_override = options[:override] != nil
force_dry_run = options[:dry_run] != nil
force_dev = options[:dev] != nil

puts "this script should be run from within the git repo."
git_dir = `git rev-parse --show-toplevel`.gsub("\n", "")
Dir.chdir(git_dir)
homedir = Dir.pwd # to split things up in directories nicely for serving
homedir = "#{Dir.pwd}/docs/.vuepress/public" if force_dev # dev mode

monitor_itunes = Array.new
monitor_wordpress = Array.new

monitor_itunes.push(mjee, recommande, calvinball, capycast, lebestiairedesbesties, ksdd)
monitor_wordpress.push(calweebball, lappeldekathulu, leretourdujeudi, lesreglesdujeu, ludographie)

if force_clean || force_clean_only then
    monitor_itunes.each do |unit|
        podcast_clean(homedir, unit[:podcast_key])
    end

    monitor_wordpress.each do |unit|
        podcast_clean(homedir, unit[:podcast_key])
    end
end

if !force_dry_run && !force_clean_only then
    monitor_wordpress.each do |unit|
        parse_rss_wordpress(homedir, unit, force_override)
    end
    
    monitor_itunes.each do |unit|
        parse_rss_itunes(homedir, unit, force_override)
    end
end

Dir.chdir("#{git_dir}/scripts")
require_relative 'generate_rss'
