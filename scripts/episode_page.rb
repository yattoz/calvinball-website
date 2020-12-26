require 'mp3info'
require 'open-uri'
require 'liquid'   # liquid tags parser for template filling
require 'rmagick'

class EpisodePage 

    @main_title
    @subtitle
    @episode_mp3
    @date
    @image
    @description
    @author
    @people_link
    @duration
    @podcast_key
    @md_template

    attr_reader :main_title
    attr_reader :subtitle
    attr_reader :episode_mp3
    attr_reader :image
    attr_reader :date
    attr_reader :description
    attr_reader :author
    attr_reader :duration
    attr_reader :people_link
    attr_writer :people_link


    def initialize(podcast_key, main_title, subtitle, image, mp3_link, date, description, author, people_link, duration=0)
        @podcast_key = podcast_key
        @main_title = main_title
        @subtitle = subtitle
        @image = image
        @episode_mp3 = mp3_link
        @date = date
        @description = description
        @duration = duration
        @author = author
        @people_link = people_link
        @md_template = Liquid::Template.parse(File.open("episode_website_template.md").read)
    end

    def to_hash
        hash = {}
        instance_variables.each { |var| hash[var.to_s.delete('@')] = instance_variable_get(var) }
        return hash
    end

    def download_image(homedir, force=false)
        # SOME THUGS GIVE THE SAME NAME TO ALL THEIR PICTURES
        # SO I DOWNLOAD THEM ALL
        # GRMBL GRMBL
        # find image extension:
        extension = @image.scan(/\.\w\w\w/).last.gsub(".", "")
        if @image.include? "gravatar" then
            extension = "jpg"
        end
        if extension == nil then
            return
        end
        #create unique image name
        image_name = "#{date.iso8601.gsub(/[^\w]/,"-")}_#{@main_title.scan(/\w/).join}.#{extension}" # @image.gsub(/.*\//, "")
        image_name_jpg = "#{date.iso8601.gsub(/[^\w]/,"-")}_#{@main_title.scan(/\w/).join}.jpg" 

        image_dir = "#{homedir}/docs/.vuepress/public/media/#{@podcast_key}"

        FileUtils.mkpath image_dir unless Dir.exists? image_dir
        if force or (not File.exists? "#{image_dir}/#{image_name_jpg}") then
            URI.open(@image) do |im|
                File.open("#{image_dir}/#{image_name}", "wb") do |file|
                    file.write(im.read)
                end
            end
            i = Magick::Image.read("#{image_dir}/#{image_name}").first
            # convert to JPG if it's something else
            FileUtils.rm_r "#{image_dir}/#{image_name}"
            i.format = 'JPEG'
            # resize
            image_size_side = 300
            i.resize!(image_size_side, image_size_side)
            # convert to progressive JPEG with quality 80
            i.write("#{image_dir}/#{image_name_jpg}") { self.quality = 70; self.interlace = Magick::PlaneInterlace }
            @image = "/media/#{@podcast_key}/#{image_name_jpg}"
        end
    end

    def write(force=false)

        filename = "#{date.iso8601.gsub(/[^\w]/,"-")}_#{@main_title.scan(/\w/).join}.md"
        episodes_dir = "docs/podcasts/#{@podcast_key}/episodes"
        if (force) then
            FileUtils.rm "#{episodes_dir}/#{filename}" if Dir.exists? "#{episodes_dir}/#{filename}"
        end
        FileUtils.mkpath episodes_dir unless Dir.exists? episodes_dir

        people_link_string = ""
        @people_link.keys.each do |key|
            people_link_string = people_link_string + "  - name: #{@people_link[key]}\n    key: #{key}\n"
        end
        @people_link = people_link_string
        md_render = @md_template.render(self.to_hash)
        if not File.exists? filename then
            File.open("#{episodes_dir}/#{filename}", "w") { |f| f.write md_render }
        end
    end
end