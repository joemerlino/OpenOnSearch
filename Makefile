include theos/makefiles/common.mk

TWEAK_NAME = OpenOnSearch
OpenOnSearch_FILES = Tweak.xm
OpenOnSearch_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 backboardd"

SUBPROJECTS += oosprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
