require 'mp3info'
require 'open-uri'

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
    end

    def to_hash
        hash = {}
        instance_variables.each { |var| hash[var.to_s.delete('@')] = instance_variable_get(var) }
        hash
    end
end