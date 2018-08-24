DOCKER := docker run -it
LOCALDIR := $(shell ./_getcwd.py)
CONTDIR := /bundle
VMAP := -v $(LOCALDIR):$(CONTDIR)

#
# Generic tools
#
CONTAINER_TOOLS := kbrafford/x86_64-linux-gcc
GZIP := $(DOCKER) $(VMAP) $(CONTAINER_TOOLS) tar -cvzf

#
# 64-bit Windows
#
CONTAINER_W64 := kbrafford/win-gcc
TOOL_W64 := x86_64-w64-mingw32

CCW64 := $(DOCKER) $(VMAP) $(CONTAINER_W64) $(TOOL_W64)-gcc
STRIPW64 := $(DOCKER) $(VMAP) $(CONTAINER_W64) $(TOOL_W64)-strip
LDW64 := $(DOCKER) $(VMAP) $(CONTAINER_W64) $(TOOL_W64)-ld
ARW64 := $(DOCKER) $(VMAP) $(CONTAINER_W64) $(TOOL_W64)-ar
RANLIBW64 := $(DOCKER) $(VMAP) $(CONTAINER_W64) $(TOOL_W64)-ranlib

#
# 32-bit Windows
#
CONTAINER_W32 := kbrafford/win-gcc
TOOL_W32 := i686-w64-mingw32

CCW32 := $(DOCKER) $(VMAP) $(CONTAINER_W32) $(TOOL_W32)-gcc
STRIPW32 := $(DOCKER) $(VMAP) $(CONTAINER_W32) $(TOOL_W32)-strip
LDW32 := $(DOCKER) $(VMAP) $(CONTAINER_W32) $(TOOL_W32)-ld
ARW32 := $(DOCKER) $(VMAP) $(CONTAINER_W32) $(TOOL_W32)-ar
RANLIBW32 := $(DOCKER) $(VMAP) $(CONTAINER_W32) $(TOOL_W32)-ranlib

#
# 64-bit Linux
#
CONTAINER_L64 := kbrafford/x86_64-linux-gcc

CCL64 := $(DOCKER) $(VMAP) $(CONTAINER_L64) gcc -m64
STRIPL64 := $(DOCKER) $(VMAP) $(CONTAINER_L64) strip
LDL64 := $(DOCKER) $(VMAP) $(CONTAINER_L64) ld
ARL64 := $(DOCKER) $(VMAP) $(CONTAINER_L64) ar
RANLIBL64 := $(DOCKER) $(VMAP) $(CONTAINER_L64) ranlib

#
# 32-bit Linux
#
CONTAINER_L32 := kbrafford/x86_64-linux-gcc

CCL32 := $(DOCKER) $(VMAP) $(CONTAINER_L32) gcc -m32
STRIPL32 := $(DOCKER) $(VMAP) $(CONTAINER_L32) strip
LDL32 := $(DOCKER) $(VMAP) $(CONTAINER_L32) ld
ARL32 := $(DOCKER) $(VMAP) $(CONTAINER_L32) ar
RANLIBL32 := $(DOCKER) $(VMAP) $(CONTAINER_L32) ranlib

#
# Mac
#
CCMAC := gcc
STRIPMAC := strip
LDMAC := ld
ARMAC := ar
RANLIBMAC := ranlib
