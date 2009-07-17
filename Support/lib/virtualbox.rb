# Copyright:
#   (c) 2009 Libin Pan
#   Visit me at http://blog.libinpan.com/
# Author: Libin Pan (libin.pan@gmail.com)

module VirtualBox
  class <<self
    def launch_palm_emulator
      if vboxmanager = `which VBoxManage`
        vboxmanager.gsub! /\n/, ''
        installed_vms = `#{vboxmanager} list vms`
        palm_vm = installed_vms[/"Palm Emulator \(.+\)"/]
        if palm_vm
          running_vms = `#{vboxmanager} list runningvms`
          unless running_vms =~ /"Palm Emulator \(.+\)"/
            puts `#{vboxmanager} startvm #{palm_vm}`
          end
          activate
        else
          puts 'Can not locate Palm Emulator VM, have you installed it yet?'
        end
      else
        puts 'Can not locate VirtualBox Application, have you installed it yet?'
      end
    end
    
    def activate
      `osascript &>/dev/null -e 'tell app "VirtualBoxVM" to activate' &`
    end
  end
end