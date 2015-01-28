#export THEOS_DEVICE_IP=10.202.24.80
export THEOS_DEVICE_IP=192.168.0.114
ARCHS = armv7 armv7s arm64
CFLAGS = -fobjc-arc
TARGET = iphone:clang:latest:latest

include theos/makefiles/common.mk

TWEAK_NAME = opincall
opincall_FILES = Tweak.x
opincall_FRAMEWORKS = UIKit Foundation CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
