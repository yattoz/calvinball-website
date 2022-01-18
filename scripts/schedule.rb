require 'chronic'
require 'safe_yaml' ## needed for front_matter_parser to parse Date in YAML.
require 'front_matter_parser'

def read_schedule()
  current_jobs = `at -l`
  queue = "x"
  current_jobs = current_jobs.split("\n").filter {|x| x.include? queue }
  jobs_chronic_hash = {}
  current_jobs.each do |job|
    split = job.split(/[\t,#{queue}]/)
    # let's parse the stupid date format
    # example : Fri Aug 27 06:42:00 2021
    id = split[0]
    date = split[1].split(/\s+/)
    date = "#{date[2]} #{date[1]} #{date[4]} #{date[3]}"
    puts date
    chronic = Chronic.parse(date)
    # now : 27 Aug 2021 06:42:00, should be Chronic-parsable 
    jobs_chronic_hash["#{id}"] = chronic
  end
  return jobs_chronic_hash
end

def new_schedule(git_dir, time)
  local_time = time.localtime
  at_time = "#{local_time.year}#{local_time.month.to_s.rjust(2, "0")}#{local_time.day.to_s.rjust(2, "0")}#{local_time.hour.to_s.rjust(2, "0")}#{local_time.min.to_s.rjust(2,"0")}.00"
  res = `at -q x -f #{File.join(git_dir, "scripts", "rebuild.sh")} -M -t #{at_time}`
  puts res if res != ""
  `$HOME/.local/bin/ring calvinballconsortium "Schedule set at #{local_time}"`
end

def clear_all_schedule() 
  all_jobs = read_schedule()
  all_jobs.values.each do |time|
    delete_schedule(time)
  end
end

def delete_schedule(time)
  schedule = read_schedule()
  schedule.each do |id, sched_time|
    if sched_time == time then
      `at -d #{id}`
      puts "deleted id #{id} at date #{sched_time}"
    end
  end
end


def diff_schedule(git_dir, times_list)
  times_list = times_list.uniq.map { |t| t.floor - t.sec } # removing seconds because at doesn't use them.
  current_schedule = read_schedule()
  current_times_list = current_schedule.values
  times_to_add = times_list - current_times_list
  times_to_remove = current_times_list - times_list
  puts "adding #{times_to_add.size} times"
  puts "deleting #{times_to_remove.size} times"
  times_to_remove.each do |time|
    delete_schedule(time)
  end
  times_to_add.each do |time|
    new_schedule(git_dir, time)
  end
end

def read_podcast_dates(git_dir, podcast_key)
  sched_times = []    
  md_files = Dir.glob(File.join(git_dir, "docs/podcasts", podcast_key, "episodes/*.md"))
  frontmatters = md_files.map { |filename| FrontMatterParser::Parser.parse_file(filename) }
  return frontmatters.map { |fm| fm["date"] }
end

def filter_future_times(times)
  return times.filter { |t| t > Time.now}
end

def populate()
  # for debug only
  for i in 1..5 do
    t = Time.now + 7200*i
    new_schedule("/home/yattoz/calvinball-website/scripts", t)
  end
end
