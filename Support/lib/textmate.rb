# Copyright:
#   (c) 2009 Libin Pan
#   Visit me at http://blog.libinpan.com/
# Author: Libin Pan (libin.pan@gmail.com)

module TextMate
  class <<self
    def rescan_project
        `osascript &>/dev/null \
	        -e 'tell app "SystemUIServer" to activate'; \
	        osascript &>/dev/null \
	        -e 'tell app "TextMate" to activate' &`
    end
  end
end