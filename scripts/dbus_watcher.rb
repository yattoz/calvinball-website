#!/usr/bin/env ruby
require 'dbus'


service_name = "fr.calvinballconsortium.service"
object_path = "fr/calvinballconsortium/runner"
bus = DBus::SystemBus.instance
service = bus.request_service(service_name)

class Test < DBus::Object
  # Create an interface.
  dbus_interface "fr.calvinballconsortium.interface" do
    # Create a hello method in that interface.
    dbus_method :hello, "in name:s, in name2:s" do |name, name2|
      puts "hello(#{name}, #{name2})"
    end
    dbus_method :run, "in mode:s" do |mode|
      puts "mode called: #{mode}"
      if mode == "regen" then
        `cd /home/yattoz/calvinball-website && echo "$(date)" > start.log && bundle2.7 exec ruby scripts/podcast_resources.rb 2>&1 > podcast_resources.log`
      elsif mode == "rebuild" then
        `cd /home/yattoz/calvinball-website && echo "start" > start.log && bundle2.7 exec ruby scripts/podcast_resources.rb --rebuild 2>&1 > podcast_resources.log`
      elsif mode == "dev" then
        `cd /home/yattoz/calvinball-website && echo "start" > start.log && bundle2.7 exec ruby scripts/podcast_resources.rb --dev 2>&1 > podcast_resources.log`
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



