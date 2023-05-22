#!/usr/bin/env ruby

require 'rufus-scheduler'
require 'optparse'
require 'fileutils'

def schedule_release(time)
  puts "scheduling at #{time}"

  scheduler = Rufus::Scheduler.new
  scheduler.at time do
    git_dir = `git rev-parse --show-toplevel`.gsub("\n", "")
    Dir.chdir(git_dir)
    homedir = Dir.pwd # to split things up in directories nicely for serving
    puts homedir
    generation_token_path = "#{homedir}/generation_token"
    new_token = "#{generation_token_path}/token"
    FileUtils.touch new_token if not File.exist?(new_token)
    puts "Scheduler created token #{new_token} at #{time}"
    exit
  end
  scheduler.join
end

options = {}
OptionParser.new do |opt|
    opt.on("--testtime", String)
    opt.on('--test')
end.parse!(into: options)
if options[:test] != nil then
  later = Time.new() + 10 #secs.
  schedule_release(later.to_s)
end
