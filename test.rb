
require 'chronic'
require 'safe_yaml' ## needed for front_matter_parser to parse Date in YAML.
require 'front_matter_parser'
require 'kramdown' # Markdown-to-html renderer
require 'liquid'   # liquid tags parser for template filling

Dir.chdir('docs')
md_files = Dir.glob(File.join("**", "*.md")).select{ |unit| unit.include? "/episodes/" }

md_files.each do |filename|
  parsed = FrontMatterParser::Parser.parse_file(filename)
  content = parsed.content.gsub("$frontmatter.", "").gsub(/{{\s*\$/, "{{ ")
  content_template = Liquid::Template.parse(content)
  md_render = content_template.render(parsed.front_matter)
  html = Kramdown::Document.new(md_render).to_html

  puts "FILENAME: #{filename}"
  puts parsed.front_matter
  puts html
  show = filename.gsub("podcasts/", "").gsub(/\/episodes\/.*/, "")
  # print html
  binding.pry
end
