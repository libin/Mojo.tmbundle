# Copyright:
#   (c) 2009 Libin Pan
#   Visit me at http://blog.libinpan.com/
# Author: Libin Pan (libin.pan@gmail.com)

module PalmInspector
  class <<self
    def  launch
      puts `open /Applications/Palm\\ Inspector.app/`
    end
  end
 end