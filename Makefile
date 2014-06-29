OS ?= LINUX
#OS ?= WINDOWS
#OS ?= MACOSX
#OS ?= BSD

ifeq ($(OS), LINUX)  # also works on FreeBSD
CC ?= gcc
CFLAGS ?= -O2 -Wall

# libusb version assignment
# default is libusb version 0.1x
# Some systems use libusb-1.x
# either add "LIBUSB_VERSION=1" to the make command line, or
# uncomment the following setting.
# LIBUSB_VERSION := 1

ifeq ($(LIBUSB_VERSION),0)
# Force major version 0
LIBUSB_NAME ?= usb-0.1
LIBUSB_VERSION := 0
else ifeq ($(LIBUSB_VERSION),1)
LIBUSB_NAME := usb-1.0
LIBUSB_VERSION := 1
else
# Default if nothing else is known
LIBUSB_NAME ?= usb
LIBUSB_VERSION := 0
endif

teensy_loader_cli: teensy_loader_cli.c
	$(CC) $(CFLAGS) -s -DUSE_LIBUSB -DLIBUSB_VERSION=$(LIBUSB_VERSION) -o teensy_loader_cli teensy_loader_cli.c -l$(LIBUSB_NAME)


else ifeq ($(OS), WINDOWS)
CC = i586-mingw32msvc-gcc
CFLAGS ?= -O2 -Wall
teensy_loader_cli.exe: teensy_loader_cli.c
	$(CC) $(CFLAGS) -s -DUSE_WIN32 -o teensy_loader_cli.exe teensy_loader_cli.c -lhid -lsetupapi


else ifeq ($(OS), MACOSX)
CC ?= gcc
SDK ?= /Developer/SDKs/MacOSX10.5.sdk
CFLAGS ?= -O2 -Wall
teensy_loader_cli: teensy_loader_cli.c
	$(CC) $(CFLAGS) -DUSE_APPLE_IOKIT -isysroot $(SDK) -o teensy_loader_cli teensy_loader_cli.c -Wl,-syslibroot,$(SDK) -framework IOKit -framework CoreFoundation


else ifeq ($(OS), BSD)  # works on NetBSD and OpenBSD
CC ?= gcc
CFLAGS ?= -O2 -Wall
teensy_loader_cli: teensy_loader_cli.c
	$(CC) $(CFLAGS) -s -DUSE_UHID -o teensy_loader_cli teensy_loader_cli.c


endif


clean:
	rm -f teensy_loader_cli teensy_loader_cli.exe
