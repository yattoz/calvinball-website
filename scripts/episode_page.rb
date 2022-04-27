require 'open-uri'
require 'liquid'   # liquid tags parser for template filling
require 'rmagick'

class EpisodePage 

    @title
    @subtitle
    @episode_mp3
    @date
    @image
    @description
    @author
    @people_link
    @duration
    @podcast_key
    @guid
    @md_template

    attr_reader :title
    attr_reader :subtitle
    attr_reader :episode_mp3
    attr_reader :image
    attr_reader :date
    attr_reader :description
    attr_reader :author
    attr_reader :duration
    attr_reader :people_link
    attr_writer :people_link
    attr_reader :guid
    attr_writer :guid


    def initialize(podcast_key, title, subtitle, image, mp3_link, date, description, author, people_link, is_explicit, guid, duration=0)
        @podcast_key = podcast_key
        @title = title
        @subtitle = subtitle
        @image = image
        @episode_mp3 = mp3_link
        @date = date
        @description = description
        @duration = duration
        @author = author
        @people_link = people_link
        @is_explicit = is_explicit
        @guid = guid
        @md_template = Liquid::Template.parse(File.open("episode_website_template.md").read)
    end

    def to_hash
        hash = {}
        instance_variables.each { |var| hash[var.to_s.delete('@')] = instance_variable_get(var) }
        return hash
    end

    def episode_name
        return "#{@date.iso8601.gsub(/[^\w]/,"-")}_#{@title.scan(/\w/).join}"
    end

    def thumbnailize(homedir, force=false)
        
        image_name_jpg = "#{self.episode_name}.jpg" 
        image_dir =      "#{homedir}/images/#{@podcast_key}/thumbnail"
        image_full_dir = "#{homedir}/images/#{@podcast_key}/full"
            
        if ((File.exists? "#{image_full_dir}/#{image_name_jpg}") and (force or !File.exists? "#{image_dir}/#{image_name_jpg}")) then
            begin
              i = Magick::Image.read("#{image_full_dir}/#{image_name_jpg}").first
            rescue
                require pry
              binding.pry
              i = nil
            end

            i.format = 'JPEG'
            # resize
            image_size_side = 300
            i.resize!(image_size_side, image_size_side)
            # convert to progressive JPEG with quality 80
            i.write("#{image_dir}/#{image_name_jpg}") { |image| image.quality = 70; image.interlace = Magick::PlaneInterlace }
        end

        @image = "/images/#{@podcast_key}/thumbnail/#{image_name_jpg}" if File.exists? "#{image_dir}/#{image_name_jpg}"
    end

    # download images and store them as thumbnails.
    # you should also keep the original
    def download_image(homedir, force=false, keep_orig=true)
        # SOME THUGS GIVE THE SAME NAME TO ALL THEIR PICTURES
        # SO I DOWNLOAD THEM ALL
        # GRMBL GRMBL
        # find image extension:
        extension = @image.scan(/\.\w\w\w/).last.gsub(".", "")
        if @image.include? "gravatar" then
            extension = "jpg"
        end
        no_image_extension = ["com", "fr", "org", "net", nil] #if the URL is malformed (no image extension but TLD instead), or there's no url at all
        if no_image_extension.include? extension then
            # if the image link is unreachable, fallback to podcast cover.
            @image = "/podcast_covers/#{@podcast_key}.jpg"
            return
        end
        #create unique image name
        image_name = "#{self.episode_name}.#{extension}"
        image_name_jpg = "#{self.episode_name}.jpg" 
        image_dir = "#{homedir}/images/#{@podcast_key}/thumbnail"
        image_full_dir = "#{homedir}/images/#{@podcast_key}/full"


        FileUtils.mkpath image_dir unless Dir.exists? image_dir
        FileUtils.mkpath image_full_dir unless Dir.exists? image_full_dir

        if (force or (not File.exists? "#{image_full_dir}/#{image_name_jpg}")) && !@image.start_with?("/podcast_covers/")  then
            URI.open(@image) do |im|
                File.open("#{image_full_dir}/#{image_name}", "wb") do |file|
                    file.write(im.read)
                end
            end
            begin
              if extension == "png" then
                i = nil
                puts "extension is PNG, don't even try to read these, leave them to PNGQuant"
              else
                i = Magick::Image.read("#{image_full_dir}/#{image_name}").first
              end
            rescue
              i = nil
            end
            # convert to JPG if it's something else
            if i == nil then
                # oddly enough sometimes PNG are too weird to be read by imagemagick
                # seems like another lib like the one in pngquant is good enough to convert it to a "normal" PNG?
                if extension == "png" then
                    is_written = false
                    quality = 99
                    puts "weird PNG found: #{image_name}. Trying to read it with pngquant..."
                    while (not is_written) && (quality > 0)
                        puts "\tquality #{quality}"
                        is_written = system("pngquant --quality #{quality} --ext .png.new '#{image_full_dir}/#{image_name}'")
                        quality = quality - 3
                    end
                    puts "\tpngquant got through!"
                    # FileUtils.mv "#{image_full_dir}/#{image_name}", "#{image_full_dir}/#{image_name}.no"
                    FileUtils.rm "#{image_full_dir}/#{image_name}"
                    FileUtils.mv "#{image_full_dir}/#{image_name}.new", "#{image_full_dir}/#{image_name}"
                    i = Magick::Image.read("#{image_full_dir}/#{image_name}").first
                    puts "\tnew PNG read successfully by rmagick"
                end
            end
            if force or !File.exists? "#{image_full_dir}/#{image_name_jpg}" then
                i.format = 'JPEG'
                i.write("#{image_full_dir}/#{image_name_jpg}") { self.quality = 100; self.interlace = Magick::PlaneInterlace }
                if extension != 'jpg'
                    FileUtils.rm  "#{image_full_dir}/#{image_name}"
                end
            end

            # for the moment, set image as full. We'll thumbnailize later on.        
            @image = "/images/#{@podcast_key}/full/#{image_name_jpg}" if File.exists? "#{image_dir}/#{image_name_jpg}"
        end
        thumbnailize(homedir, force=false)
    end

    # Download audio to store them locally (for podcast migration)
    def download_audio(homedir, force=false)
        audio_dir = "#{homedir}/audio/#{@podcast_key}"
        extension = @episode_mp3.scan(/\.\w\w\w/).last.gsub(".", "")
        audio_name = "#{self.episode_name}.#{extension}"

        FileUtils.mkpath audio_dir unless Dir.exists? audio_dir
        if force or (not File.exists? "#{audio_dir}/#{audio_name}") then
            puts "Downloading audio: #{@episode_mp3}"
            URI.open(@episode_mp3) do |au|
                File.open("#{audio_dir}/#{audio_name}", "wb") do |file|
                    file.write(au.read)
                end
            end
        end
        @episode_mp3 = "/audio/#{@podcast_key}/#{audio_name}" if File.exists? "#{audio_dir}/#{audio_name}"
    end

    # Download images from inside the description to store them locally (for podcast migration)
    def download_resources(homedir, force=false)
        episode_name = "#{self.episode_name}"
        ep_resources_dir = "#{homedir}/resources/#{@podcast_key}/#{self.episode_name}"
        FileUtils.mkpath ep_resources_dir unless Dir.exists? ep_resources_dir
        embed_images = Nokogiri::HTML.parse(@description)
        embed_images.css("img").each do |embed_im|
            puts "found img: #{embed_im}"
            embed_im_name = embed_im[:src].gsub(/.*\//, "").scan(/.*\.\w\w\w/).join # find image name
            if force or (not File.exists? "#{ep_resources_dir}/#{embed_im}") then
                URI.open(embed_im[:src]) do |im|
                    File.open("#{ep_resources_dir}/#{embed_im_name}", "wb") do |file|
                        file.write(im.read)
                    end
                end
                local_src = "/resources/#{@podcast_key}/#{self.episode_name}/#{embed_im_name}"
                @description = @description.gsub(embed_im[:src], local_src)
            end
        end
        embed_images.xpath('//a[substring(@href, string-length(@href)-string-length("pdf")+1, string-length("pdf"))="pdf"]').each do |embed_pdf|
            puts "found pdf: #{embed_pdf}"
            embed_pdf_name = embed_pdf[:href].gsub(/.*\//, "").scan(/.*\.\w\w\w/).join # find image name
            if force or (not File.exists? "#{ep_resources_dir}/#{embed_pdf}") then
                URI.open(embed_pdf[:href]) do |pdf|
                    File.open("#{ep_resources_dir}/#{embed_pdf_name}", "wb") do |file|
                        file.write(pdf.read)
                    end
                end
                local_src = "/resources/#{@podcast_key}/#{self.episode_name}/#{embed_pdf_name}"
                @description = @description.gsub(embed_pdf[:href], local_src)
            end
        end
    end


    def write(force=false)
        filename = "#{self.episode_name}.md"
        episodes_dir = "docs/podcasts/#{@podcast_key}/episodes"
        if (force) then
            FileUtils.rm "#{episodes_dir}/#{filename}" if Dir.exists? "#{episodes_dir}/#{filename}"
        end
        FileUtils.mkpath episodes_dir unless Dir.exists? episodes_dir or File.symlink? episodes_dir

        people_link_string = ""
        @people_link.keys.each do |key|
            people_link_string = people_link_string + "  - name: #{@people_link[key]}\n    key: #{key}\n"
        end
        @people_link = people_link_string
        md_render = @md_template.render(self.to_hash)
        if not File.exists? filename then
            begin
                File.open("#{episodes_dir}/#{filename}", "w") { |f| f.write md_render }
            rescue
                puts "can't write file #{filename}, skipping (symlink may not be resolved when developing)"
            end
        end
    end
end

def podcast_clean(homedir, podcast_key)
    episodes_dir = "docs/podcasts/#{podcast_key}/episodes/"
    images_dir = "#{homedir}/images/#{podcast_key}/"
    audio_dir = "#{homedir}/audio/#{podcast_key}/"
    eps_resources_dir = "#{homedir}/resources/#{podcast_key}/"
    directories = [episodes_dir, images_dir, eps_resources_dir, audio_dir]
    directories.each do |path|
      begin
        FileUtils.rm_r path if Dir.exists? path
      rescue
        begin
          `rm -r #{path}*`
        rescue
          puts "clean #{podcast_key} path: #{path} manually!!! or maybe it's already empty."
        end
      end
    end
    puts "#{podcast_key} cleaned"
end


def podcast_clean_docs(homedir, podcast_key)
    episodes_dir = "docs/podcasts/#{podcast_key}/episodes/"
    images_dir = "#{homedir}/images/#{podcast_key}/"
    audio_dir = "#{homedir}/audio/#{podcast_key}/"
    eps_resources_dir = "#{homedir}/resources/#{podcast_key}/"
    directories = [episodes_dir]
    directories.each do |path|
      begin
        FileUtils.rm_r path if Dir.exists? path
      rescue
        begin
          `rm -r #{path}*`
        rescue
          puts "clean #{podcast_key} path: #{path} manually!!! or maybe it's already empty."
        end
      end
    end
    puts "#{podcast_key} cleaned"
end
