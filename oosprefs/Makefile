include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = oosprefs
oosprefs_FILES = OOSRootListController.m
oosprefs_INSTALL_PATH = /Library/PreferenceBundles
oosprefs_FRAMEWORKS = UIKit
oosprefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/oosprefs.plist$(ECHO_END)
