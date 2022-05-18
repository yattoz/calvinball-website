#!/usr/bin/env ruby

# this env can't be reached with systemd but it's manually called bu the dbus watcher

require 'optparse'
require 'fileutils'
require_relative 'puts_verbose'

class Location
    LOCAL = "local"
    RSS_WORDPRESS = "wordpress"
    RSS_ITUNES = "itunes"
end

recommande = {
    :url => "https://recommande.duckdns.org/episodes.mp3.rss",
    :separator => "-",
    :usual_author => "Yattoz",
    :always_people => {"yattoz" => "Yattoz"},
    :podcast_key => "recommande",
    :location => Location::LOCAL,
    :audio_download => true,
    :resources_download => true
}

crousti = {
    :url => "",
    :separator => "-",
    :usual_author => "Framboise",
    :always_people => {"framboise" => "Framboise"},
    :podcast_key => "crousti",
    :location => Location::LOCAL,
    :audio_download => true,
    :resources_download => true
}


variantepourdeux = {
    :url => "",
    :separator => "-",
    :usual_author => "Ttol",
    :always_people => {"ttol" => "Ttol"},
    :podcast_key => "variantepourdeux",
    :location => Location::LOCAL,
    :audio_download => true,
    :resources_download => true
}


calvinball = {
    :url => "https://feeds.soundcloud.com/users/soundcloud:users:290809321/sounds.rss",
    :separator => "-",
    :usual_author => "Zali Falcam",
    :always_people => {"zalifalcam" => "Zali Falcam"},
    :podcast_key => "calvinball",
    :location => Location::RSS_ITUNES,
    :audio_download => true,
    :resources_download => true
}

capycast = {
    :url => "https://hearthis.at/capycec/podcast/",
    :separator => "-",
    :usual_author => "Capycec",
    :always_people => {"capycec" => "Capycec"},
    :podcast_key => "capycast",
    :location => Location::RSS_ITUNES,
    :audio_download => true,
    :resources_download => true
}

lebestiairedesbesties = {
    :url => "https://hearthis.at/bestiaire-des-besties/podcast/",
    :separator => "-",
    :usual_author => "Capycec",
    :always_people => {"capycec" => "Capycec", "lucile" => "Lucile"},
    :podcast_key => "lebestiairedesbesties",
    :location => Location::RSS_ITUNES,
    :audio_download => true,
    :resources_download => true
}

ksdd = {
    :url => "https://hearthis.at/anshiki/podcast/",
    :separator => ":",
    :usual_author => "Ashki",
    :always_people => {"ashki" => "Ashki"},
    :podcast_key => "ksdd",
    :location => Location::RSS_ITUNES,
    :audio_download => true,
    :resources_download => true
}

lesfrancobelges = {
    :url => "https://feeds.radiokawa.com/podcast_les-franco-belges.xml",
    :separator => "",
    :usual_author => "Lyonsbanner",
    :always_people => {"lyonsbanner" => "Lyonsbanner", "sonneper" => "SonnePer"},
    :podcast_key => "lesfrancobelges",
    :location => Location::LOCAL,
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
    :location => Location::LOCAL,
    :audio_download => true,
    :resources_download => true
}

calweebball = {
    :url => "https://calvinballradio.wordpress.com/category/calweeb-ball/feed",
    :separator => "–",
    :usual_author => "Zali Falcam",
    :always_people => {"zalifalcam" => "Zali Falcam", "pegase" => "Pegase"},
    :podcast_key => "calweebball",
    :location => Location::LOCAL,
    :audio_download => true,
    :resources_download => true
}

lappeldekathulu = {
    :url => "https://kathulupodcast.wordpress.com/category/episodes-de-kathulu/feed/",
    :separator => "–",
    :usual_author => "Zali Falcam, Bob",
    :always_people => {"zalifalcam" => "Zali Falcam", "bob" => "Bob"},
    :podcast_key => "lappeldekathulu",
    :location => Location::LOCAL,
    :audio_download => true,
    :resources_download => true
}

leretourdujeudi = {
    :url => "https://retourdujeudi.wordpress.com/category/podcast/feed",
    :separator => "",
    :usual_author => "Kalkulmatriciel, Juuniper",
    :always_people => {"kalkulmatriciel" => "Kalkulmatriciel", "juuniper" => "Juuniper"},
    :podcast_key => "leretourdujeudi",
    :location => Location::LOCAL,
    :audio_download => true,
    :resources_download => true
}

lesreglesdujeu = {
    :url => "https://lesreglesdujeupodcast.wordpress.com/category/les-regles-du-jeu/feed",
    :separator => "",
    :usual_author => "JoK",
    :always_people => {"jok" => "JoK"},
    :podcast_key => "lesreglesdujeu",
    :location => Location::LOCAL,
    :audio_download => true,
    :resources_download => true
}

ludographie = {
    :url => "https://ludographiepodcast.wordpress.com/category/episodes-de-ludographie/feed",
    :separator => "–",
    :usual_author => "Mathieu Goux",
    :always_people => {"mathieugoux" => "Mathieu Goux"},
    :podcast_key => "ludographie",
    :location => Location::LOCAL,
    :audio_download => true,
    :resources_download => true
}

ludographiecomparee = {
    :url => "https://ludographiepodcast.wordpress.com/category/ludographie-comparee/feed", # "https://mjee.fr/wp-content/ludographie-comparee/podcast_ludographie-comparee.xml",
    :separator => "–",
    :usual_author => "Mathieu Goux",
    :always_people => {"mathieugoux" => "Mathieu Goux"},
    :podcast_key => "ludographiecomparee",
    :location => Location::LOCAL,
    :audio_download => true,
    :resources_download => true
}


options = {}
OptionParser.new do |opt|
    opt.on('--cleanall')
    opt.on("--clean KEY", Array)
    opt.on('--cleanonly')
    opt.on('--force')
    opt.on('--clean-only')
    opt.on('--clean-docs')
    opt.on('--cleandocs')
    opt.on('--dryrun')
    opt.on('--dev')
    opt.on('--rebuild')
    opt.on('--gitdir GIT_DIR')
    opt.on('--user USERNAME')
end.parse!(into: options)


puts options
puts Time.now

calling_user = options[:USERNAME]
if calling_user == nil
  calling_user = `echo $USER`
end

force_clean = options[:cleanall] != nil
force_clean_only = options[:cleanonly] != nil
force_override = options[:force] != nil
force_dry_run = options[:dryrun] != nil
force_dev = options[:dev] != nil
force_rebuild = options[:rebuild] != nil
force_clean_docs = options[:cleandocs]
# git_dir = `git rev-parse --show-toplevel`.gsub("\n", "") if options[:git_dir] == nil
git_dir = "#{__dir__}/.."
git_dir = options[:git_dir] if options[:git_dir] != nil
Dir.chdir(git_dir)
homedir = Dir.pwd # to split things up in directories nicely for serving
# homedir = "#{Dir.pwd}/docs/.vuepress/public" if force_dev # dev mode

# enable dev mode if token is "test"
#
generation_token_path = "#{homedir}/generation_token"
new_test_token = "#{generation_token_path}/test"

if (File.exists?(new_test_token)) then
    FileUtils.rm new_test_token if File.exists?(new_test_token)
    force_dev = true
end



puts "Generate pages"
puts "(dev mode enabled with either --dev of test token)" if force_dev



# create .lock file to avoid multiple overlapping calls

dist_path = "#{homedir}/dist" if not force_dev
dist_path = "#{homedir}/dev.dist" if force_dev
FileUtils.mkpath generation_token_path if not Dir.exists? generation_token_path
FileUtils.mkpath dist_path if not Dir.exists? dist_path

# create .lock file if a process has already spawned
lockfile_path = File.join(generation_token_path, ".lock")

total_wait_time = 10*60 # 10 minutes
while File.exists?(lockfile_path) && total_wait_time > 0 do
    ping_period = 10 + (rand*20).floor #seconds
    total_wait_time = total_wait_time - ping_period 
    puts "Still waiting for #{total_wait_time/60} minutes #{total_wait_time%60} seconds for other process to finish..."
    sleep(ping_period)
end
if total_wait_time <= 0 then
    puts "Timeout: another script was running for more than 10 minutes. Something must be broken."
    FileUtils.rm lockfile_path if File.exists?(lockfile_path)
    # `killall node`
    `killall ruby`
    exit
end
FileUtils.touch lockfile_path if not File.exists?(lockfile_path)
File.open(lockfile_path, "w") do |lockfile|
  lockfile.puts(Time.now)
end

require_relative 'parse_rss_itunes'
require_relative 'parse_rss_wordpress'

all_podcasts = Array.new
all_podcasts.push(mjee, calvinball, capycast, lebestiairedesbesties, ksdd, lesfrancobelges, calweebball, lappeldekathulu, leretourdujeudi, lesreglesdujeu, ludographie, recommande, crousti, variantepourdeux, ludographiecomparee)

monitor_itunes = all_podcasts.filter { |unit| unit[:location] == Location::RSS_ITUNES}
monitor_wordpress = all_podcasts.filter { |unit| unit[:location] == Location::RSS_WORDPRESS}
local_podcasts = all_podcasts.filter { |unit| unit[:location] == Location::LOCAL }

if options[:clean] != nil then
    options[:clean].each do |key_to_clean|
        if (local_podcasts.map { |unit| unit[:podcast_key] }).include? key_to_clean then
          puts "don't clean local show #{key_to_clean}! next."
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

if force_clean_docs then
    monitor_itunes.each do |unit|
        podcast_clean_docs(homedir, unit[:podcast_key])
    end

    monitor_wordpress.each do |unit|
        podcast_clean_docs(homedir, unit[:podcast_key])
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

def to_jpg(homedir, show, force=false)
    image_full_dir = "#{homedir}/images/#{show[:podcast_key]}/full"
    image_full_list = Dir["#{image_full_dir}/*.*"]
    image_full_list_nojpg = image_full_list.filter { |unit| not unit.end_with? ".jpg" }
    puts_verbose "must convert to jpg: #{image_full_list_nojpg}"

    image_full_list_nojpg.each do |image_name|
        begin
            i = Magick::Image.read("#{image_name}").first
        rescue
            i = nil
            next
        end
        i.format = 'JPEG'
        # convert to progressive JPEG with quality 90
        i.write("#{image_name.gsub(File.extname(image_name), ".jpg")}") { self.quality = 90; self.interlace = Magick::PlaneInterlace }
        # @image = "/images/#{@podcast_key}/thumbnail/#{image_name_jpg}" if File.exists? "#{image_dir}/#{image_name_jpg}"
    end
    image_full_list_nojpg.each do |image_name|
        FileUtils.rm image_name
    end
end

def thumbnailize(homedir, show, force=false)
    image_dir =      "#{homedir}/images/#{show[:podcast_key]}/thumbnail"
    image_full_dir = "#{homedir}/images/#{show[:podcast_key]}/full"

    image_thumbnail_list = Dir["#{image_dir}/*.jpg"]
    image_full_list = Dir["#{image_full_dir}/*.jpg"]

    puts_verbose "#{image_dir} -> #{image_full_dir}"
    puts_verbose "#{image_thumbnail_list.size} -> #{image_full_list.size}"

    image_thumbnail_list_old = image_thumbnail_list.map { |unit| unit.gsub("/thumbnail/", "/full/") } 
    new_images = image_full_list - image_thumbnail_list_old 
    if new_images.size > 0 then
      puts "Gotta generate thumbnails for: #{new_images}"
    end
    
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
local_podcasts.each do |unit|
    puts_verbose "Thumbnail generation for #{unit[:podcast_key]}"
    to_jpg(homedir, unit, force_override)
    thumbnailize(homedir, unit, force_override)
end

# check for future dates for publishing, and schedule them
require_relative 'schedule'
future_times = []
local_podcasts.each do |unit|
    podcast_key = unit[:podcast_key]
    puts_verbose podcast_key
    times = read_podcast_dates(git_dir, podcast_key)
    future_times_for_podcast = filter_future_times(times)
    if future_times_for_podcast.size > 0 then
        puts "future times detected for #{podcast_key}: #{future_times_for_podcast}"
    end
    future_times = future_times + future_times_for_podcast
end
diff_schedule(git_dir, future_times)
File.open("next_schedule.log", "w") { |file| 
    at_chronic_hash = read_schedule()
    at_dates_str = at_chronic_hash.values().map { |x| "#{x.strftime('%d/%m/%Y, %R')}" }
    at_dates_str.each do |unit|
        file.puts("#{unit}")
    end
}
`at -l > last_schedule.txt` #flemme de faire mieux


print "Generate RSS"
thread = Thread.new { require_relative 'generate_rss' }
k = 0
while thread.status != false do
  print "."
  sleep 1
  k = k + 1
  if k > 50 then
    print "\n"
    k = 0
  end
end
print "\n"


# you can rebuild manually if needed. 
# Alternatively you could just remove remote_feeds_nbeps
new_token = "#{generation_token_path}/token"

if (is_new_episode > 0 || File.exists?(new_token) || force_dev || force_rebuild) then
    FileUtils.rm new_token if File.exists?(new_token)
    update_token = "#{generation_token_path}/mise_a_jour_en_cours"
    FileUtils.touch update_token if not File.exists?(update_token)
    puts "Rebuilding vuepress app. (This takes 3 to 5 minutes) "
    start = Time.now
    thread = Thread.new {`npm run build`}
    k = 0
    while thread.status != false do
      print "."
      sleep 1
      k = k + 1
      if k > 50 then
        print "\n"
        k = 0
      end
    end
    totime = Time.now - start
    print "\n"
    puts "Rebuild took #{totime.to_i / 60} mn #{totime.to_i % 60} s."
    if not force_dev then
        tmp_dir = "#{homedir}/tmp.dist"
        `rm -r #{tmp_dir}`  if File.directory?(tmp_dir)
        `mkdir #{tmp_dir}`
        `cp -a #{homedir}/docs/.vuepress/dist/* #{tmp_dir}`
        `mv #{homedir}/dist #{homedir}/dist.old`
        `mv #{tmp_dir} #{homedir}/dist`
        `mv #{homedir}/dist.old #{tmp_dir}`
    end
    `cp -a #{homedir}/docs/.vuepress/dist/* #{homedir}/dev.dist/` if force_dev
    FileUtils.rm update_token if File.exists?(update_token)
    `/home/yattoz/.local/bin/ring "ruby" "site updated:\n#{Time.now}\n#{options}\nCalled from: #{calling_user}"`

end

puts "done."
FileUtils.rm lockfile_path if File.exists?(lockfile_path)
puts "======== Update finished successfully. ========"
