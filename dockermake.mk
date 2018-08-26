ARCHIVE := $(ARCHIVENAME).tar.gz

uniq = $(if $1,$(firstword $1) $(call uniq,$(filter-out $(firstword $1),$1)))

SRCDIRS := $(call uniq, $(dir $(APPSRC)) $(dir $(LIBSRC)))

OUTDIR := build
WINDIR := $(OUTDIR)/win
LINDIR := $(OUTDIR)/linux
MACDIR := $(OUTDIR)/mac

include tools.mk

CPPFLAGS += -MMD
CPPFLAGS += -MP
CFLAGS += -fPIC

ifneq ($(APPNAME),)
 TARGETW64 := $(WINDIR)/$(APPNAME)64.exe
 TARGETW32 := $(WINDIR)/$(APPNAME).exe
 TARGETL64 := $(LINDIR)/$(APPNAME)64
 TARGETL32 := $(LINDIR)/$(APPNAME)
 TARGETMAC := $(MACDIR)/$(APPNAME)

 WINDOWS += $(TARGETW64) $(TARGETW32)
 LINUX += $(TARGETL64) $(TARGETL32)
 MAC += $(TARGETMAC)
endif

ifneq ($(LIBNAME),)
 STATICLIBW64 := $(WINDIR)/lib$(LIBNAME)64.a
 SHAREDLIBW64 := $(WINDIR)/lib$(LIBNAME)64.dll
 STATICLIBW32 := $(WINDIR)/lib$(LIBNAME).a
 SHAREDLIBW32 := $(WINDIR)/lib$(LIBNAME).dll
 STATICLIBL64 := $(LINDIR)/lib$(LIBNAME)64.a
 SHAREDLIBL64 := $(LINDIR)/lib$(LIBNAME)64.so
 STATICLIBL32 := $(LINDIR)/lib$(LIBNAME).a
 SHAREDLIBL32 := $(LINDIR)/lib$(LIBNAME).so
 STATICLIBMAC := $(MACDIR)/lib$(LIBNAME).a
 SHAREDLIBMAC := $(MACDIR)/lib$(LIBNAME).dynlib

 WINDOWS += $(STATICLIBW64) $(STATICLIBW32) $(SHAREDLIBW64) $(SHAREDLIBW32)
 LINUX += $(STATICLIBL64) $(STATICLIBL32) $(SHAREDLIBL64) $(SHAREDLIBL32)
 MAC += $(STATICLIBMAC) $(SHAREDLIBMAC)
endif

LIBOBJW64 := $(LIBSRC:.c=.ow64)
LIBOBJW32 := $(LIBSRC:.c=.ow32)
LIBOBJL64 := $(LIBSRC:.c=.ol64)
LIBOBJL32 := $(LIBSRC:.c=.ol32)
LIBOBJMAC := $(LIBSRC:.c=.om)

MKDIR_P := mkdir -p

ifeq ($(OS), Windows_NT)
 TARGETS := $(WINDOWS) $(LINUX)
else
 UNAME_S := $(shell uname -s)
 ifeq ($(UNAME_S),Linux)
  TARGETS := $(WINDOWS) $(LINUX)  
 endif
 ifeq ($(UNAME_S),Darwin)
  TARGETS := $(WINDOWS) $(LINUX) $(MAC) 
 endif
endif

all : $(ARCHIVE)

$(ARCHIVE): $(TARGETS)
	$(GZIP) $(CONTDIR)/$(ARCHIVE) $(CONTDIR)/build
#
# Rules for intermediate files
#
%.ow64 : %.c
	@echo "64 bit windows module"
	$(CCW64) $(CPPFLAGS) $(CFLAGS) -c -o $(CONTDIR)/$@ $(CONTDIR)/$<

%.ow32 : %.c
	@echo "32 bit windows module"
	$(CCW32) $(CPPFLAGS) $(CFLAGS) -c -o $(CONTDIR)/$@ $(CONTDIR)/$<

%.ol64 : %.c
	@echo "64 bit linux module"
	$(CCL64) $(CPPFLAGS) $(CFLAGS) -c -o $(CONTDIR)/$@ $(CONTDIR)/$<

%.ol32 : %.c
	@echo "32 bit linux module"
	$(CCL32) $(CPPFLAGS) $(CFLAGS) -c -o $(CONTDIR)/$@ $(CONTDIR)/$<

%.om : %.c
	@echo "mac module"
	$(CCMAC) $(CPPFLAGS) $(CFLAGS) -c -o $@ $<

# Static libs
$(STATICLIBW64): $(LIBOBJW64)
	@echo "64 bit windows lib"
	$(MKDIR_P) $(WINDIR)
	$(ARW64) rcs $(CONTDIR)/$@ $(addprefix $(CONTDIR)/, $^)
	$(RANLIBW64) $(CONTDIR)/$@

$(STATICLIBW32): $(LIBOBJW32)
	@echo "32 bit windows lib"
	$(MKDIR_P) $(WINDIR)
	$(ARW32) rcs $(CONTDIR)/$@ $(addprefix $(CONTDIR)/, $^)
	$(RANLIBW32) $(CONTDIR)/$@

$(STATICLIBL64): $(LIBOBJL64)
	@echo "64 bit linux lib"
	$(MKDIR_P) $(LINDIR)
	$(ARL64) rcs $(CONTDIR)/$@ $(addprefix $(CONTDIR)/, $^)
	$(RANLIBL64) $(CONTDIR)/$@

$(STATICLIBL32): $(LIBOBJL32)
	@echo "32 bit linux lib"
	$(MKDIR_P) $(LINDIR)
	$(ARL32) rcs $(CONTDIR)/$@ $(addprefix $(CONTDIR)/, $^)
	$(RANLIBL32) $(CONTDIR)/$@

$(STATICLIBMAC): $(LIBOBJMAC)
	@echo "mac lib"
	$(MKDIR_P) $(MACDIR)
	$(ARMAC) cq $@ $^
	$(RANLIBMAC) $@

#  Application executables
$(TARGETW64): $(addsuffix .ow64, $(basename $(APPSRC))) $(STATICLIBW64)
	@echo "64 bit windows exe"
	$(MKDIR_P) $(WINDIR)	
	$(CCW64) $(CPPFLAGS) $(CFLAGS) -o $(CONTDIR)/$@ $(addprefix $(CONTDIR)/, $(filter %.ow64,$^))  $(addprefix $(CONTDIR)/, $(STATICLIBW64))
	$(STRIPW64) $(CONTDIR)/$@ 

$(TARGETW32): $(addsuffix .ow32, $(basename $(APPSRC))) $(STATICLIBW32)
	@echo "32 bit windows exe"
	$(MKDIR_P) $(WINDIR)	
	$(CCW32) $(CPPFLAGS) $(CFLAGS) -o $(CONTDIR)/$@ $(addprefix $(CONTDIR)/, $(filter %.ow32,$^)) $(addprefix $(CONTDIR)/, $(STATICLIBW32)) 
	$(STRIPW32) $(CONTDIR)/$@ 

$(TARGETL64): $(addsuffix .ol64, $(basename $(APPSRC))) $(STATICLIBL64)
	@echo "64 bit linux exe"
	$(MKDIR_P) $(LINDIR)	
	$(CCL64) $(CPPFLAGS) $(CFLAGS) -o $(CONTDIR)/$@ $(addprefix $(CONTDIR)/, $(filter %.ol64,$^)) $(addprefix $(CONTDIR)/, $(STATICLIBL64))
	$(STRIPL64) $(CONTDIR)/$@ 

$(TARGETL32): $(addsuffix .ol32, $(basename $(APPSRC))) $(STATICLIBL32)
	@echo "32 bit linux exe"
	$(MKDIR_P) $(LINDIR)	
	$(CCL32) $(CPPFLAGS) $(CFLAGS) -o $(CONTDIR)/$@ $(addprefix $(CONTDIR)/, $(filter %.ol32,$^)) $(addprefix $(CONTDIR)/, $(STATICLIBL32))
	$(STRIPL32) $(CONTDIR)/$@ 

$(TARGETMAC): $(addsuffix .om, $(basename $(APPSRC))) $(STATICLIBMAC)
	@echo "mac exe"
	$(MKDIR_P) $(MACDIR)	
	$(CCMAC) $(CPPFLAGS) $(CFLAGS) -o $@ $(filter %.om,$^) -L$(MACDIR) -l$(LIBNAME)
	$(STRIPMAC) $@ 

# Shared libraries
$(SHAREDLIBW64): $(LIBOBJW64)
	@echo "64 bit windows dll"
	$(CCW64) $(CPPFLAGS) $(CFLAGS) -shared -o $(CONTDIR)/$@ $(addprefix $(CONTDIR)/, $(filter %.ow64,$^))

$(SHAREDLIBW32): $(LIBOBJW32)
	@echo "32 bit windows dll"
	$(CCW32) $(CPPFLAGS) $(CFLAGS) -shared -o $(CONTDIR)/$@ $(addprefix $(CONTDIR)/, $(filter %.ow32,$^))

$(SHAREDLIBL64): $(LIBOBJL64)
	@echo "64 bit linux so"
	$(CCL64) $(CPPFLAGS) $(CFLAGS) -shared -o $(CONTDIR)/$@ $(addprefix $(CONTDIR)/, $(filter %.ol64,$^))

$(SHAREDLIBL32): $(LIBOBJL32)
	@echo "32 bit linux so"
	$(CCL32) $(CPPFLAGS) $(CFLAGS) -shared -o $(CONTDIR)/$@ $(addprefix $(CONTDIR)/, $(filter %.ol32,$^))

$(SHAREDLIBMAC): $(LIBOBJMAC)
	@echo "mac dynlib"
	$(CCMAC) $(CPPFLAGS) $(CFLAGS) -shared -o $@ $(filter %.om,$^)

.PHONY: clean
clean:
	rm -f $(addsuffix *.ow64, $(SRCDIRS)) $(addsuffix *.ow32, $(SRCDIRS)) $(addsuffix *.ol64, $(SRCDIRS)) $(addsuffix *.ol32, $(SRCDIRS)) $(addsuffix *.om, $(SRCDIRS)) $(addsuffix *.o, $(SRCDIRS)) $(addsuffix *.d, $(SRCDIRS))
	rm -r -f $(OUTDIR)

test:
	@echo "Windows 64-bit Tools:"
	@echo $(CCW64) && echo $(STRIPW64) && echo $(LDW64) && echo $(ARW64) && echo $(RANLIBW64)
	@echo && echo "Windows 32-bit Tools:"	
	@echo $(CCW32) && echo $(STRIPW32) && echo $(LDW32) && echo $(ARW32) && echo $(RANLIBW32)
	@echo && echo "Linux 64-bit Tools:"
	@echo $(CCL64) && echo $(STRIPL64) && echo $(LDL64) && echo $(ARL64) && echo $(RANLIBL64)
	@echo && echo "Linux 32-bit Tools:"	
	@echo $(CCL32) && echo $(STRIPL32) && echo $(LDL32) && echo $(ARL32) && echo $(RANLIBL32)
	@echo && echo "Mac Tools:"
	@echo $(CCMAC) && echo $(STRIPMAC) && echo $(LDMAC) && echo $(ARMAC) && echo $(RANLIBMAC)
