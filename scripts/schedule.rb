require 'chronic'
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
    puts date
    date = "#{date[2]} #{date[1]} #{date[4]} #{date[3]}"
    chronic = Chronic.parse(date)
    # now : 27 Aug 2021 06:42:00, should be Chronic-parsable 
    jobs_chronic_hash["#{id}"] = chronic
  end
  return jobs_chronic_hash
end

def new_schedule(time)
  at_time = "#{time.year}#{time.month.to_s.rjust(2, "0")}#{time.day.to_s.rjust(2, "0")}#{time.hour.to_s.rjust(2, "0")}#{time.min.to_s.rjust(2,"0")}.00"
  `at -q x -f ./touch_the_token.sh -M -t #{at_time}`
end

def clear_all_schedule() 
  all_jobs = read_schedule()
  all_jobs.keys.each do |id|
    delete_schedule(id)
  end
end


def delete_schedule(id)
  `at -d #{id}`
end


