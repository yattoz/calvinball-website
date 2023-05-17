require "open-uri"
require "json"
require "pry"
require "optparse"
require "logger" 

def google_sheets_read(homedir)

  logger = Logger.new(STDOUT)
  logger.formatter = proc { |severity, datetime, progname, msg| "#{severity}, #{datetime}, #{msg}\n" }

  if File.exists? "#{homedir}/scripts/credentials.rb" then
    require_relative 'credentials'
  else
    logger.warn "No file 'credentials.rb'. Please copy template and fill in the credentials.\n\tMJEE table won't be displayed."
    return
  end


  include SheetsToken

  if "#{SPREADSHEET_ID}" == "" or API_KEY == "" then
    logger.warn "credentials.rb found but SPREADSHEET_ID or API_KEY is missing.\n\tMJEE table won't be displayed."
    return
  end
  
  # sheets_token.rb should define variables SPREADSHEET_ID and API_KEY as constants in a module called SheetsToken

  options = {}
  OptionParser.new do |opt|
    # opt.on('--dev') { |o| options[:dev] = true}
    opt.on('--git-dir GIT_DIR') { |o| options[:git_dir] = o }
  end.parse!


  git_dir = `git rev-parse --show-toplevel`.gsub("\n", "") if options[:git_dir] == nil
  git_dir = options[:git_dir] if options[:git_dir] != nil
  Dir.chdir(git_dir)


  url = "https://sheets.googleapis.com/v4/spreadsheets/#{SPREADSHEET_ID}/values/A1:E600?key=#{API_KEY}"
  # puts url
  read_data = URI.open(url).read
  res = JSON.parse(read_data)
  res = res["values"]
  css = "
  "
  html_table = "<table>"
  # binding.pry
  html_class = ""
  res.each_with_index do |unit, index|
    case unit[4]
    when /TIER TURBO/
      html_class = "turbo"
    when /TIER DIVIN/
      html_class = "divin"
    when /TIER PREMIUM/
      html_class = "premium"
    when /TIER DE LA HAUTE QUALITER/
      html_class = "qualiter"
    when /TIER DU BON RESPECT/
      html_class = "respect"
    when /TIER DU 14\/10 CACHE DANS TON BACKLOG/
      html_class = "14_10"
    when /TIER POUR TOUS LES GOUTS/
      html_class = "gouts"
    when /TIER INEGAL/
      html_class = "inegal"
    when /TIER A VOS RISQUES ET PERILS/
      html_class = "risques_perils"
    when /TIER DE TRAVIOLE/
      html_class = "traviole"
    when /TIER DES DEUX PIEDS DANS LA BOUE/
      html_class = "boue"
    when /TIER NAZE/
      html_class = "naze"
    when /TIER GRIPPE INTESTINALE/
      html_class = "grippe"
    when /TIER CONFINEMENT AVEC BLANQUER DANS UN STUDIO/
      html_class = "confinement"
    when /TIER INTERDIT/
      html_class = "interdit"
    when /TIER DU DERNIER CERCLE DES ENFERS/
      html_class = "enfer"
    end
    html_table = "#{html_table}<tr class=\"#{html_class}\">"
    # binding.pry
    unit.each do |value|
      html_table = "#{html_table}<td>#{value}</td>"
    end
    html_table = "#{html_table}</tr>"
  end
  html_table = "#{html_table}</body></table>"

  header = "
---
title: Le classement des Meilleurs Jeux Electroniques Ever
description: Le bien beau tableau de tous les jeux mentionnés dans MJEE, classés scientifiquement.
layout: simple-text
date: #{Time.now}
---

  "

  html_table = "#{header}#{html_table}"

  file = File.open("#{git_dir}/docs/podcasts/mjee/ranking.md", "w"){ |f| f.write html_table }

end

