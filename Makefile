
TARGET := iphone:clang:latest:14.0
ARCHS := arm64 arm64e

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = Welcome

Welcome_FILES = Main.m
Welcome_FRAMEWORKS = UIKit
Welcome_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/library.mk
