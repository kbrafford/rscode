
ARCHIVE := $(ARCHIVENAME).tar.gz

OUTDIR := build
WINDIR := $(OUTDIR)/win
LINDIR := $(OUTDIR)/linux
MACDIR := $(OUTDIR)/mac

# Windows
TARGETW64 := $(WINDIR)/$(APPLICATION)64.exe
TARGETW32 := $(WINDIR)/$(APPLICATION).exe
STATICLIBW64 := $(WINDIR)/lib$(LIBNAME)64.a
SHAREDLIBW64 := $(WINDIR)/lib$(LIBNAME)64.dll
STATICLIBW32 := $(WINDIR)/lib$(LIBNAME).a
SHAREDLIBW32 := $(WINDIR)/lib$(LIBNAME).dll

# Linux
TARGETL64 := $(LINDIR)/$(APPLICATION)64
TARGETL32 := $(LINDIR)/$(APPLICATION)
STATICLIBL64 := $(LINDIR)/lib$(LIBNAME)64.a
SHAREDLIBL64 := $(LINDIR)/lib$(LIBNAME)64.so
STATICLIBL32 := $(LINDIR)/lib$(LIBNAME).a
SHAREDLIBL32 := $(LINDIR)/lib$(LIBNAME).so

# Mac
TARGETMAC := $(MACDIR)/$(APPLICATION)
STATICLIBMAC := $(MACDIR)/lib$(LIBNAME).a
SHAREDLIBMAC := $(MACDIR)/lib$(LIBNAME).dynlib

LIBOBJW64 := $(LIBSRC:.c=.ow64)
LIBOBJW32 := $(LIBSRC:.c=.ow32)
LIBOBJL64 := $(LIBSRC:.c=.ol64)
LIBOBJL32 := $(LIBSRC:.c=.ol32)
LIBOBJMAC := $(LIBSRC:.c=.om)

include tools.mk

CPPFLAGS := -MMD
CPPFLAGS += -MP
CFLAGS := -fPIC

WINDOWS := $(TARGETW64) $(TARGETW32) $(STATICLIBW64) $(STATICLIBW32) $(SHAREDLIBW64) $(SHAREDLIBW32)
LINUX := $(TARGETL64) $(TARGETL32) $(STATICLIBL64) $(STATICLIBL32) $(SHAREDLIBL64) $(SHAREDLIBL32)
MAC := $(TARGETMAC) $(STATICLIBMAC) $(SHAREDLIBMAC)

MKDIR_P := mkdir -p

ifeq ($(OS), Windows_NT)
TARGETS := $(WINDOWS) $(LINUX)
else
ifeq ($(OSTYPE), linux-gnu)
TARGETS := $(WINDOWS) $(LINUX)
else
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
	$(ARW64) cq $(CONTDIR)/$@ $(addprefix $(CONTDIR)/, $^)
	$(RANLIBW64) $(CONTDIR)/$@

$(STATICLIBW32): $(LIBOBJW32)
	@echo "32 bit windows lib"
	$(MKDIR_P) $(WINDIR)
	$(ARW32) cq $(CONTDIR)/$@ $(addprefix $(CONTDIR)/, $^)
	$(RANLIBW32) $(CONTDIR)/$@

$(STATICLIBL64): $(LIBOBJL64)
	@echo "64 bit linux lib"
	$(MKDIR_P) $(LINDIR)
	$(ARL64) cq $(CONTDIR)/$@ $(addprefix $(CONTDIR)/, $^)
	$(RANLIBL64) $(CONTDIR)/$@

$(STATICLIBL32): $(LIBOBJL32)
	@echo "32 bit linux lib"
	$(MKDIR_P) $(LINDIR)
	$(ARL32) cq $(CONTDIR)/$@ $(addprefix $(CONTDIR)/, $^)
	$(RANLIBL32) $(CONTDIR)/$@

$(STATICLIBMAC): $(LIBOBJMAC)
	@echo "mac lib"
	$(MKDIR_P) $(MACDIR)
	$(ARMAC) cq $@ $^
	$(RANLIBMAC) $@

#  Application executables
$(TARGETW64): $(addsuffix $(basename $(APPSRC)), .ow64) $(STATICLIBW64)
	@echo "64 bit windows exe"
	$(CCW64) -o $(CONTDIR)/$@ $(addprefix $(CONTDIR)/, $(filter %.ow64,$^)) -L$(CONTDIR)/$(WINDIR) -l$(LIBNAME)64
	$(STRIPW64) $(CONTDIR)/$@ 

$(TARGETW32): $(addsuffix $(basename $(APPSRC)), .ow32) $(STATICLIBW32)
	@echo "32 bit windows exe"
	$(CCW32) -o $(CONTDIR)/$@ $(addprefix $(CONTDIR)/, $(filter %.ow32,$^)) -L$(CONTDIR)/$(WINDIR) -l$(LIBNAME)
	$(STRIPW32) $(CONTDIR)/$@ 

$(TARGETL64): $(addsuffix $(basename $(APPSRC)), .ol64) $(STATICLIBL64)
	@echo "64 bit linux exe"
	$(CCL64) -o $(CONTDIR)/$@ $(addprefix $(CONTDIR)/, $(filter %.ol64,$^)) -L$(CONTDIR)/$(LINDIR) -l$(LIBNAME)64
	$(STRIPL64) $(CONTDIR)/$@ 

$(TARGETL32): $(addsuffix $(basename $(APPSRC)), .ol32) $(STATICLIBL32)
	@echo "32 bit linux exe"
	$(CCL32) -o $(CONTDIR)/$@ $(addprefix $(CONTDIR)/, $(filter %.ol32,$^)) -L$(CONTDIR)/$(LINDIR) -l$(LIBNAME)
	$(STRIPL32) $(CONTDIR)/$@ 

$(TARGETMAC): $(addsuffix $(basename $(APPSRC)), .om) $(STATICLIBMAC)
	@echo "mac exe"
	$(CCMAC) -o $@ $(filter %.om,$^) -L$(MACDIR) -l$(LIBNAME)
	$(STRIPMAC) $@ 

# Shared libraries
$(SHAREDLIBW64): $(LIBOBJW64)
	@echo "64 bit windows dll"
	$(CCW64) -shared -o $(CONTDIR)/$@ $(addprefix $(CONTDIR)/, $(filter %.ow64,$^))

$(SHAREDLIBW32): $(LIBOBJW32)
	@echo "32 bit windows dll"
	$(CCW32) -shared -o $(CONTDIR)/$@ $(addprefix $(CONTDIR)/, $(filter %.ow32,$^))

$(SHAREDLIBL64): $(LIBOBJL64)
	@echo "64 bit linux so"
	$(CCL64) -shared -o $(CONTDIR)/$@ $(addprefix $(CONTDIR)/, $(filter %.ol64,$^))

$(SHAREDLIBL32): $(LIBOBJL32)
	@echo "32 bit linux so"
	$(CCL32) -shared -o $(CONTDIR)/$@ $(addprefix $(CONTDIR)/, $(filter %.ol32,$^))

$(SHAREDLIBMAC): $(LIBOBJMAC)
	@echo "mac dynlib"
	$(CCMAC) -shared -o $@ $(filter %.om,$^)

.PHONY: clean
clean:
	rm -f $(SRCDIR)/*.ow64 $(SRCDIR)/*.ow32 $(SRCDIR)/*.ol64 $(SRCDIR)/*.ol32 $(SRCDIR)/*.om $(SRCDIR)/*.d $(ARCHIVE)
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
