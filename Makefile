CTARGET := example.exe
LIBNAME := ecc
STATICLIB := lib$(LIBNAME).a
SHAREDLIB := lib$(LIBNAME)shared.dll

DOCKER := docker run -it
LOCALDIR := $(shell ./getcwd.py)
CONTDIR := /work
VOLUME := -v $(LOCALDIR):$(CONTDIR)
CONTAINER := kbrafford/win-gcc
TOOLROOT := x86_64-w64-mingw32

CC := $(DOCKER) $(VOLUME) $(CONTAINER) $(TOOLROOT)-gcc
STRIP := $(DOCKER) $(VOLUME) $(CONTAINER) $(TOOLROOT)-strip
LD := $(DOCKER) $(VOLUME) $(CONTAINER) $(TOOLROOT)-ld
AR := $(DOCKER) $(VOLUME) $(CONTAINER) $(TOOLROOT)-ar
RANLIB := $(DOCKER) $(VOLUME) $(CONTAINER) $(TOOLROOT)-ranlib

LIBSRC := src/rs.c src/galois.c src/berlekamp.c src/crcgen.c
LIBOBJ := $(LIBSRC:.c=.o)
LIBDEP := $(LIBOBJ:.o=.d)

MAINSRC := main.c
MAINOBJ := $(MAINSRC:.c=.o)
MAINDEP := $(MAINOBJ:.o=.d)

DEPS := $(LIBDEP) $(MAINDEP)
OBJS := $(MAINOBJ) $(LIBOBJ)

CPPFLAGS := -MMD
CPPFLAGS += -MP

CFLAGS := -fPIC

all : $(CTARGET) $(STATICLIB) $(SHAREDLIB)

$(CTARGET): src/example.o $(STATICLIB)
	$(CC) -o $(CONTDIR)/$@ $(addprefix $(CONTDIR)/, $(filter %.o,$^)) -L$(CONTDIR) -l$(LIBNAME)
	$(STRIP) $(CONTDIR)/$@ 

%.o : %.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -c -o $(CONTDIR)/$@ $(CONTDIR)/$<

$(STATICLIB): $(LIBOBJ)
	$(AR) cq $(CONTDIR)/$@ $(addprefix $(CONTDIR)/, $^)
	$(RANLIB) $(CONTDIR)/$@

$(SHAREDLIB): $(LIBOBJ)
	$(CC) -shared -o $(CONTDIR)/$@ $(addprefix $(CONTDIR)/, $(filter %.o,$^))

clean:
	rm -f src/*.o src/*.a src/*.d src/*.so src/*.dll $(CTARGET) $(SHAREDLIB) $(STATICLIB)

test:
	@echo $(CC)
	@echo $(STRIP)
	@echo $(LD)
	@echo $(AR)
	@echo $(RANLIB)

-include $(DEPS)
