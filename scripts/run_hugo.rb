
require 'fileutils'


def print_loop()
    k = 0
    while true do
      print "."
      sleep 1
      k = k + 1
      if k > 50 then
        print "\n"
        k = 0
      end
    end
end



def run_hugo(homedir, generation_token_path, force_dev, force_rebuild, force_localserve)

  backup_thread = nil 

  new_token = "#{generation_token_path}/token"
    FileUtils.rm new_token if File.exist?(new_token)
    update_token = "#{generation_token_path}/mise_a_jour_en_cours"
    FileUtils.touch update_token if not File.exist?(update_token)
    thread = nil
    start = Time.now
    output_dist = ""
    print "Rebuilding hugo site."
    output_dist = "#{homedir}/.hugo/dist"
    hugo_command = "hugo"
    if force_dev then
      hugo_command = hugo_command + " --config dev.config.toml --buildFuture --buildDrafts" #  --buildFuture --buildDrafts # unneeded, it's in the config
    elsif force_localserve then
      hugo_command = hugo_command + " --config localserve.config.toml --buildFuture --buildDrafts"
    end
    thread = Thread.new { print_loop() }
    `cd #{homedir} && #{hugo_command}`
    thread.exit
    totime = Time.now - start
    puts "Rebuild took #{totime.to_i / 60} mn #{totime.to_i % 60} s."

    if force_dev then
      `cp -a #{output_dist}/* #{homedir}/dev.dist/`
    elsif force_localserve then
      FileUtils.mkdir_p "#{homedir}/dist"
      FileUtils.cp_r Dir.glob("#{output_dist}/*"), "#{homedir}/dist", :remove_destination => true
    else
      tmp_dir = "#{homedir}/tmp.dist"
      `rm -r #{tmp_dir}`  if File.directory?(tmp_dir)
      `mkdir #{tmp_dir}`
      `cp -a #{output_dist}/* #{tmp_dir}`
      `mv #{homedir}/dist #{homedir}/dist.old`
      `mv #{tmp_dir} #{homedir}/dist`
      `mv #{homedir}/dist.old #{tmp_dir}`
    end
    FileUtils.rm update_token if File.exist?(update_token)
    if File.exist? "#{homedir}/backup_to_nas.sh" then
      backup_thread = Thread.new { `#{homedir}/backup_to_nas.sh` }
    else
      puts "WARN: no backup_to_nas.sh found. Please fill the template."
    end
    return backup_thread
end
