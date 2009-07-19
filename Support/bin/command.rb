#!/usr/bin/env ruby

# Copyright:
#   (c) 2009 Libin Pan
#   Visit me at http://blog.libinpan.com/
# Author: Libin Pan (libin.pan@gmail.com)

require 'rubygems'
require 'json'
require ENV['TM_SUPPORT_PATH'] + '/lib/textmate'
require ENV['TM_SUPPORT_PATH'] + '/lib/ui'

require File.dirname(__FILE__) + "/../lib/textmate"
require File.dirname(__FILE__) + "/../lib/virtualbox"
require File.dirname(__FILE__) + "/../lib/palminspector"

appinfo_file = "#{ENV['TM_PROJECT_DIRECTORY']}/appinfo.json"
unless File.exists?(appinfo_file)
  puts "Can not locate appinfo.json file.\nPlease open a Palm Mojo Project, or create new one using 'palm-generate'."
  exit
end
appinfo = File.new(appinfo_file, 'r')
appinfo_json = JSON.parse(appinfo.read)
app_id = appinfo_json['id']
unless app_id
  puts 'Can not find id from appinfo.json file, please check.'
  exit
end

palmsdk_dir = ENV['TM_PALMSDK_DIR'] || '/opt/PalmSDK/Current'

device = ARGV[0] =~ /tcp/ ? 'tcp' : 'usb'
case ARGV[0]
when 'launch:emulator'
  VirtualBox.launch_palm_emulator
when 'generate:new:scene'
  selection = TextMate::UI.request_string(
    :title => 'Create new scene',
    :default => 'name:First',
    :prompt => 'Parameters for new scene:',
    :button1 => 'Create'
  )
  puts `#{palmsdk_dir}/bin/palm-generate -t new_scene -p "#{selection}" #{ENV['TM_PROJECT_DIRECTORY']}`
  TextMate.rescan_project
when 'package'
  puts `#{palmsdk_dir}/bin/palm-package -o #{ENV['TM_PROJECT_DIRECTORY']} #{ENV['TM_PROJECT_DIRECTORY']}`
  TextMate.rescan_project
when 'install:tcp', 'install:usb'
  if ENV['TM_SELECTED_FILE'] =~ /.*\.ipk$/
    puts `#{palmsdk_dir}/bin/palm-install -d #{device} #{ENV['TM_SELECTED_FILE']}`
  else
    puts 'Select your package file in the Project Panel, please...'
  end
when 'uninstall:tcp', 'uninstall:usb'
  puts `#{palmsdk_dir}/bin/palm-install -d #{device} -r #{app_id}`
when 'list:tcp', 'list:usb'
  puts `#{palmsdk_dir}/bin/palm-install -d #{device} -l`
when 'launch:tcp', 'launch:usb'
  puts `#{palmsdk_dir}/bin/palm-launch -d #{device} #{app_id}`
  VirtualBox.activate
when 'close:tcp', 'close:usb'
  puts `#{palmsdk_dir}/bin/palm-launch -d #{device} -c #{app_id}`
when 'relaunch:tcp', 'relaunch:usb'
  puts `#{palmsdk_dir}/bin/palm-launch -d #{device} -f #{app_id}`
  VirtualBox.activate
when 'launch:tcp:inspector', 'launch:usb:inspector'
  puts `#{palmsdk_dir}/bin/palm-launch -d #{device} -i #{app_id}`
  VirtualBox.activate
  PalmInspector.launch
else
  puts "I don't know how to #{ARGV[0]} yet, can you help me?"
end