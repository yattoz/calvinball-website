#!/usr/bin/env ruby
require 'dbus'


service_name = "fr.calvinballconsortium.service"
object_path = "/fr/calvinballconsortium/runner"
bus = DBus::SystemBus.instance
service = bus.request_service(service_name)

class Test < DBus::Object
  # Create an interface.
  dbus_interface "fr.calvinballconsortium.interface" do
    # Create a hello method in that interface.
    dbus_method :hello, "in name:s, in msg:s" do |name, msg|
      `echo #{name}-#{msg} > /opt/calvinball-website/podcast_resources.log`
    end
    dbus_method :run, "in mode:s, in user:s" do |mode, user|
      puts "mode called: #{mode}"
      command  = "cd /opt/calvinball-website && echo \"$(date)\" > start.log && bundle exec ruby scripts/podcast_resources.rb --user #{user}"
      command_out = "> podcast_resources.log"
      if mode == "regen" then
        `#{command} #{command_out}`
      elsif (mode == "rebuild" or mode == "dev" or mode == "localserve") then
        `#{command} --#{mode} #{command_out}`
      elsif mode == "exit" then
        exit
      end
    end

  end
end

exported_obj = Test.new(object_path)
service.export(exported_obj)
puts "service exported" 
loop = DBus::Main.new
loop << bus
loop.run



