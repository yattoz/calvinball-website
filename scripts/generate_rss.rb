#!/usr/bin/env ruby
require 'safe_yaml' ## needed for front_matter_parser to parse Date in YAML.
require 'front_matter_parser'
require 'kramdown' # Markdown-to-html renderer
require 'liquid'   # liquid tags parser for template filling
require 'optparse'

options = {}
OptionParser.new do |opt|
    # opt.on('--dev') { |o| options[:dev] = true}
    opt.on('--git-dir GIT_DIR') { |o| options[:git_dir] = o }
end.parse!

git_dir = `git rev-parse --show-toplevel`.gsub("\n", "") if options[:git_dir] == nil
git_dir = options[:git_dir] if options[:git_dir] != nil
Dir.chdir(git_dir)

website_url = "https://www.calvinballconsortium.fr"

rss_template = Liquid::Template.parse(File.open("template.rss").read)
rss_item_template = Liquid::Template.parse(File.open("template_item.rss").read)

Dir.chdir('docs')
podcasts = Dir.glob("podcasts/**").select{|unit| not unit.include? "README.md" }

puts "Generate RSS."
# parse the podcast page front matter, build template
podcasts.each do |podcast|
  
  md_files = Dir.glob(File.join(podcast, "/episodes/*.md"))
  rss_item_render = Array.new
  rss_full_hash = FrontMatterParser::Parser.parse_file(File.join(podcast, "/README.md")).front_matter

  next if rss_full_hash["feed"].start_with? "http" #remote feed, don't create a local one
  puts podcast

  rss_full_hash["image"] = "#{website_url}#{rss_full_hash["image"]}" # rss_full_hash already starts with "/"
  rss_full_hash["website_url"] = website_url
  rss_full_hash["rss_url"] = "#{website_url}/#{podcast}/feed.rss"
  rss_full_hash["language"] = "fr" #If ONE DAY we need to change that, we'll change it.
  rss_full_hash["last_build_date"] = Time.now.rfc822 
  
  rss_full_hash["is_explicit"] = rss_full_hash["is_explicit"] ? "yes" : "no"
  # parse each episode page front matter, build each template
  md_files.each do |filename|
    # puts filename
    parsed = FrontMatterParser::Parser.parse_file(filename)
    content = parsed.content.gsub("$frontmatter.", "").gsub(/{{\s*\$/, "{{ ") # TODO: fix internal links # .gsub("](/", "](#{website_url}/").gsub("](/", "](#{website_url}/")
    front_matter = parsed.front_matter
    content_template = Liquid::Template.parse(content)
    md_render = content_template.render(front_matter)

    html = Kramdown::Document.new(md_render).to_html.gsub(/<PodcastHeader\s*\/\>/, "")
 
    ## add variables to a new hash with front_matter already in it
    item_hash = front_matter
    item_hash["episode_description_html"] = html
    item_hash["episode_url"] = "#{website_url}/#{filename.gsub(/.md$/, ".html").gsub("&", "&amp;")}"
    item_hash["podlove_episode_url"] = item_hash["episode_url"].gsub("&", "&amp;") #TODO: put podlove url for nice embed on twitter and stuff
    item_hash["episode_mp3"] = "#{website_url}#{item_hash["episode_mp3"]}"
    item_hash["image"] = "#{(item_hash["image"].start_with?("http") ? "" : website_url)}#{item_hash["image"].gsub("&", "&amp;")}"
    item_hash["image"] = item_hash["image"].gsub("/thumbnail/", "/full/") if item_hash["image"].include? "/thumbnail/"
    item_hash["podcast_url"] = "#{website_url}/#{podcast}"

    item_hash["date"] = item_hash["date"].rfc822 #pubDate must be in format RFC822 for podcasts RSS feeds.
    item_hash["is_explicit"] = item_hash["is_explicit"] ? "yes" : "no"
    rss_item_render.push(rss_item_template.render(item_hash))
    # puts item_hash
    # puts rss_item_render.last

  end
  rss_full_item_render = rss_item_render.join(" ") # join with spaces cuz why not
  rss_full_hash["items"] = "#{rss_full_item_render}"
  rss_render = rss_template.render(rss_full_hash)
  # puts rss_render
  File.open(".vuepress/public/#{podcast}/feed.rss", "w") { |f| f.write rss_render }
end
