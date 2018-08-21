CTARGET := example.exe
LIBNAME := ecc
STATICLIB := lib$(LIBNAME).a
SHAREDLIB := lib$(LIBNAME)shared.dll

#else
#    CTARGET := example
#    STATICLIB := libecc.a
#    SHAREDLIB := libeccshared.so
#endif

DOCKER := docker run -it
LOCALDIR := $(abspath .)
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
	$(CC) -o $@ $(filter %.o,$^) -L. -l$(STATICLIB)
	$(STRIP) $@ 

%.o : %.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -c -o $@ $<

$(STATICLIB): $(LIBOBJ)
	$(AR) cq $@ $^
	if [ "$(RANLIB)" ]; then $(RANLIB) $@; fi

$(SHAREDLIB): $(LIBOBJ)
	$(CC) -shared -o $@ $^

clean:
	rm -f *.o *.a *.d *.so *.dll $(CTARGET)

test:
	@echo $(CC)
	@echo $(STRIP)
	@echo $(LD)
	@echo $(AR)	

-include $(DEPS)