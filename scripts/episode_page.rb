require 'mp3info'
require 'open-uri'
require 'liquid'   # liquid tags parser for template filling

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


    def initialize(main_title, subtitle, image, mp3_link, date, description, author, people_link, duration=0)
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

    def write(podcast_key)
        if not(Dir.pwd.include? "docs/podcasts/#{podcast_key}/episodes")
            Dir.chdir("docs/podcasts/#{podcast_key}/episodes/")
        end
        people_link_string = ""
        @people_link.keys.each do |key|
            people_link_string = people_link_string + "  - name: #{@people_link[key]}\n    key: #{key}\n"
        end
        @people_link = people_link_string
        md_render = @md_template.render(self.to_hash)
        filename = "#{@main_title.scan(/\w/).join}.md"
        if not File.exists? filename then
            File.open("./#{filename}", "w") { |f| f.write md_render }
        end
    end
end