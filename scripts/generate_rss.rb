#!/usr/bin/env ruby
require 'safe_yaml' ## needed for front_matter_parser to parse Date in YAML.
require 'front_matter_parser'
require 'kramdown' # Markdown-to-html renderer
require 'nokogiri'
require 'liquid'   # liquid tags parser for template filling
require 'optparse'
require 'cgi' # should be shipped by ruby but it's cleaner to mention it

require_relative 'puts_verbose'

options = {}
OptionParser.new do |opt|
    # opt.on('--dev') { |o| options[:dev] = true}
    opt.on('--git-dir GIT_DIR') { |o| options[:git_dir] = o }
end.parse!

git_dir = `git rev-parse --show-toplevel`.gsub("\n", "") if options[:git_dir] == nil
git_dir = options[:git_dir] if options[:git_dir] != nil
Dir.chdir(git_dir)

website_url = "https://www.calvinballconsortium.fr"
website_podtrac_url = "https://dts.podtrac.com/redirect.mp3/www.calvinballconsortium.fr"

rss_template = Liquid::Template.parse(File.open("template.rss").read)
rss_item_template = Liquid::Template.parse(File.open("template_item.rss").read)

Dir.chdir('docs')
podcasts = Dir.glob("podcasts/**").select{|unit| not unit.include? "_index.md" }

# parse the podcast page front matter, build template
podcasts.each do |podcast|
  
  md_files = Dir.glob(File.join(podcast, "/episodes/*.md"))
  rss_item_render = Array.new
  rss_full_hash = FrontMatterParser::Parser.parse_file(File.join(podcast, "/_index.md")).front_matter

  # next if rss_full_hash["feed"].start_with? "http" #remote feed, don't create a local one
  puts_verbose podcast
  
  rss_full_hash["description"] =  CGI.escape_html(Nokogiri::HTML.parse(rss_full_hash["description"]).text) 

  rss_full_hash["image"] = "#{website_url}#{rss_full_hash["image"].gsub("/thumbnail/", "/")}" # rss_full_hash already starts with "/"
  rss_full_hash["website_url"] = website_url
  rss_full_hash["rss_url"] = "#{website_url}/#{podcast}/feed.xml"
  rss_full_hash["language"] = "fr" #If ONE DAY we need to change that, we'll change it.
  rss_full_hash["last_build_date"] = Time.now.rfc822 
  rss_full_hash["itunes_new_feed_tag"] = ""
  if rss_full_hash["is_new_feed"] then
    rss_full_hash["itunes_new_feed_tag"] = "<itunes:new-feed-url>#{rss_full_hash["rss_url"]}</itunes:new-feed-url>"
  end
  is_podtrac = rss_full_hash["is_podtrac"]
  
  rss_full_hash["is_explicit"] = rss_full_hash["is_explicit"] ? "yes" : "no"
  # check if a partial episode-footer exists, if so, read it, so that we can append it to every episode
  episode_footer_partial = "layouts/partials/episode-footer/#{rss_full_hash["key"]}.html"
  episode_footer_html = ""
  if File.exists? episode_footer_partial then
    episode_footer_html = File.open(episode_footer_partial).read
  end

  # parse each episode page front matter, build each template
  md_files.reverse.each do |filename|
    # puts filename
    parsed = FrontMatterParser::Parser.parse_file(filename)
    content = parsed.content.gsub("$frontmatter.", "").gsub(/{{\s*\$/, "{{ ") # TODO: fix internal links # .gsub("](/", "](#{website_url}/").gsub("](/", "](#{website_url}/")
    front_matter = parsed.front_matter
    content_template = Liquid::Template.parse(content)
    md_render = content_template.render(front_matter)

    html = Kramdown::Document.new(md_render).to_html.gsub(/<PodcastHeader\s*\/\>/, "")
    html = html.gsub("img src=\"/", "img src=\"#{website_url}/").gsub("href=\"/", "href=\"#{website_url}/")
 
    ## add variables to a new hash with front_matter already in it
    item_hash = front_matter

    ## Let's skip the episode if it's scheduled for later
    next if item_hash["date"] > Time.new
    next if item_hash["draft"] == true
    # puts filename
    item_hash["episode_description_html"] = "#{html}\n#{episode_footer_html}"
    item_hash["title"] = CGI.escape_html(Nokogiri::HTML.parse(item_hash["title"]).text)
    item_hash["episode_description_raw"] = CGI.escape_html(Nokogiri::HTML.parse(html).text)
    item_hash["episode_description_truncated"] = "#{item_hash["episode_description_raw"][0, 250]}..."

    item_hash["episode_url"] = "#{website_url}/#{filename.gsub(/.md$/, ".html").gsub("&", "&amp;")}"

    if is_podtrac
        item_hash["episode_mp3"] = "#{website_podtrac_url}#{item_hash["episode_mp3"]}"
    else
        item_hash["episode_mp3"] = "#{website_url}#{item_hash["episode_mp3"]}"
    end
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
  File.open("#{git_dir}/docs/.vuepress/public/#{podcast}/feed.xml", "w") { |f| f.write rss_render }
end
