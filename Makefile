#
# SECTION 1: What we are making
#
# APPNAME is the name of the executable
APPNAME := example

# LIBNAME is the name of the static lib and DLL
LIBNAME := ecc

# ARCHIVENAME is the name of the gzipped up bundle of deliverables
ARCHIVENAME := bundle

#
# SECTION 2: What our inputs are (i.e. the source files)
#

# APPSRC is the list of source files for the application
_SRCDIR := src
_APPSRCFILES := example.c
APPSRC := $(addprefix $(_SRCDIR)/, $(_APPSRCFILES))

# LIBSRC is the list of source files for the library
_LIBSRCFILES := rs.c galois.c berlekamp.c crcgen.c
LIBSRC := $(addprefix $(_SRCDIR)/, $(_LIBSRCFILES))

# Now we pass all this information off to dockermake!
include dockermake.mk