TARGET := example
LIBNAME := ecc

SRCDIR := src/
LIBSRCFILES := rs.c galois.c berlekamp.c crcgen.c
LIBSRC := $(addprefix $(SRCDIR), $(LIBSRCFILES))

# Windows
TARGETW64 := example64.exe
TARGETW32 := example.exe
W64STATICLIB := lib$(LIBNAME)64.a
W64SHAREDLIB := lib$(LIBNAME)64.dll
W32STATICLIB := lib$(LIBNAME).a
W32SHAREDLIB := lib$(LIBNAME).dll

# Linux
TARGETL64 := example64
TARGETL32 := example
L64STATICLIB := lib$(LIBNAME)64.a
L64SHAREDLIB := lib$(LIBNAME)64.so
L32STATICLIB := lib$(LIBNAME).a
L32SHAREDLIB := lib$(LIBNAME).so



LIBOBJW64 := $(LIBSRC:.c=.ow64)
LIBOBJW32 := $(LIBSRC:.c=.ow32)
LIBOBJL64 := $(LIBSRC:.c=.ol64)
LIBOBJL32 := $(LIBSRC:.c=.ol32)

include tools.mk

CPPFLAGS := -MMD
CPPFLAGS += -MP
CFLAGS := -fPIC

WINDOWS := $(TARGETW64) $(TARGETW32) $(W64STATICLIB) $(W32STATICLIB) $(W64SHAREDLIB) $(W32SHAREDLIB)
LINUX := $(TARGETL64) $(TARGETL32) $(L64STATICLIB) $(L32STATICLIB) $(L64SHAREDLIB) $(L32SHAREDLIB)

all : $(WINDOWS)

#
# Rules for intermediate files
#
%.ow64 : %.c
	$(CCW64) $(CPPFLAGS) $(CFLAGS) -c -o $(CONTDIR)/$@ $(CONTDIR)/$<

%.ow32 : %.c
	$(CCW32) $(CPPFLAGS) $(CFLAGS) -c -o $(CONTDIR)/$@ $(CONTDIR)/$<

%.ol64 : %.c
	$(CCL64) $(CPPFLAGS) $(CFLAGS) -c -o $(CONTDIR)/$@ $(CONTDIR)/$<

%.ol32 : %.c
	$(CCL32) $(CPPFLAGS) $(CFLAGS) -c -o $(CONTDIR)/$@ $(CONTDIR)/$<

%.om : %.c
	$(CCMAC) $(CPPFLAGS) $(CFLAGS) -c -o $(CONTDIR)/$@ $(CONTDIR)/$<

# Static libs
$(W64STATICLIB): $(LIBOBJW64)
	$(ARW64) cq $(CONTDIR)/$@ $(addprefix $(CONTDIR)/, $^)
	$(RANLIBW64) $(CONTDIR)/$@

$(W32STATICLIB): $(LIBOBJW32)
	$(ARW32) cq $(CONTDIR)/$@ $(addprefix $(CONTDIR)/, $^)
	$(RANLIBW32) $(CONTDIR)/$@

$(L64STATICLIB): $(LIBOBJL64)
	$(ARL64) cq $(CONTDIR)/$@ $(addprefix $(CONTDIR)/, $^)
	$(RANLIBL64) $(CONTDIR)/$@

$(L32STATICLIB): $(LIBOBJL32)
	$(ARL32) cq $(CONTDIR)/$@ $(addprefix $(CONTDIR)/, $^)
	$(RANLIBL32) $(CONTDIR)/$@

#  Example executables
$(TARGETW64): $(SRCDIR)example.ow64 $(W64STATICLIB)
	@echo "64 bit windows"
	$(CCW64) -o $(CONTDIR)/$@ $(addprefix $(CONTDIR)/, $(filter %.o,$^)) -L$(CONTDIR) -l$(LIBNAME)64
	$(STRIPW64) $(CONTDIR)/$@ 

$(TARGETW32): $(SRCDIR)example.ow32 $(W32STATICLIB)
	@echo "32 bit windows"
	$(CCW32) -o $(CONTDIR)/$@ $(addprefix $(CONTDIR)/, $(filter %.o,$^)) -L$(CONTDIR) -l$(LIBNAME)
	$(STRIPW32) $(CONTDIR)/$@ 

$(TARGETL64): $(SRCDIR)example.ol64 $(L64STATICLIB)
	$(CCL64) -o $(CONTDIR)/$@ $(addprefix $(CONTDIR)/, $(filter %.o,$^)) -L$(CONTDIR) -l$(LIBNAME)
	$(STRIPL64) $(CONTDIR)/$@ 

$(TARGETL32): $(SRCDIR)example.ol32 $(L32STATICLIB)
	$(CCL32) -o $(CONTDIR)/$@ $(addprefix $(CONTDIR)/, $(filter %.o,$^)) -L$(CONTDIR) -l$(LIBNAME)
	$(STRIPL32) $(CONTDIR)/$@ 

# Shared libraries
$(W64SHAREDLIB): $(LIBOBJW64)
	$(CCW64) -shared -o $(CONTDIR)/$@ $(addprefix $(CONTDIR)/, $(filter %.o,$^))

$(W32SHAREDLIB): $(LIBOBJW32)
	$(CCW32) -shared -o $(CONTDIR)/$@ $(addprefix $(CONTDIR)/, $(filter %.o,$^))

$(L64SHAREDLIB): $(LIBOBJL64)
	$(CCL64) -shared -o $(CONTDIR)/$@ $(addprefix $(CONTDIR)/, $(filter %.o,$^))

$(L32SHAREDLIB): $(LIBOBJL32)
	$(CCL32) -shared -o $(CONTDIR)/$@ $(addprefix $(CONTDIR)/, $(filter %.o,$^))

.PHONY: clean
clean:
	rm -f $(SRCDIR)*.ow64 $(SRCDIR)*.ow32 $(SRCDIR)*.ol64 $(SRCDIR)*.ol32 $(SRCDIR)*.d *.lib *.a *.so *.dll *.dynlib


test:
	@echo $(CCW64) && echo $(STRIPW64) && echo $(LDW64) && echo $(ARW64) && echo $(RANLIBW64)
	@echo $(CCW32) && echo $(STRIPW32) && echo $(LDW32) && echo $(ARW32) && echo $(RANLIBW32)
	@echo $(CCL64) && echo $(STRIPL64) && echo $(LDL64) && echo $(ARL64) && echo $(RANLIBL64)
	@echo $(CCL32) && echo $(STRIPL32) && echo $(LDL32) && echo $(ARL32) && echo $(RANLIBL32)
	@echo $(CCMAC) && echo $(STRIPMAC) && echo $(LDMAC) && echo $(ARMAC) && echo $(RANLIBMAC)
