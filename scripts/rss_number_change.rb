
class NbEpsChecker
    @old_number_of_episodes = -1
    @new_number_of_episodes = 0
    
    def has_rss_number_changed(homedir, podcast_key, _new_number_of_episodes)
        FileUtils.mkpath "#{homedir}/remote_feeds_nbeps/" if not Dir.exists? "#{homedir}/remote_feeds_nbeps/"
        @old_number_of_episodes = -1
        @new_number_of_episodes = _new_number_of_episodes
        local_hash_path = "#{homedir}/remote_feeds_nbeps/#{podcast_key}.nbep"
        if File.exists? local_hash_path
            File.open(local_hash_path, "r") { |f| @old_number_of_episodes = f.read.to_i }
        end

        # puts "#{podcast_key} (file_read) #{old_number_of_episodes} / (remote_rss) #{new_number_of_episodes}"
        return @old_number_of_episodes != @new_number_of_episodes
    end

    def update_rss_number_changed(homedir, podcast_key)
        local_hash_path = "#{homedir}/remote_feeds_nbeps/#{podcast_key}.nbep"
        if @old_number_of_episodes != @new_number_of_episodes
            File.open(local_hash_path, "w") { |f| f.write @new_number_of_episodes }
        end
    end
end