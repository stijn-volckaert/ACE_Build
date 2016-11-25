#=============================================================================
# Unreal Tournament makefile for Linux.
#
# Revision history:
# 	* Created by Mike Danylchuk
#	* 00/01/06 Joshua Garvin
#		   - Changed the name from "Dedicated Unreal Server makefile for 
#		     Linux" to "Unreal Tournament makefile for Linux".
#		   - Changed the name of the backup file from ucc-<date>.tar.gz to
#		     OpenUT-<date>.tar.gz.
#	* 00/01/22 Daniel Vogel
#		   - hooked up the SDL stuff
#	* 00/03/22 Daniel Vogel
#		   - hooked up SDLAudio
#=============================================================================

# Unreal directory. (Location of OpenUT source code)
#(Required by makefile-header.)
UNREAL_DIR	= ../

# Include global definitions.
include makefile-header

# No default sub-make arguments.
ARGS =

#-----------------------------------------------------------------------------
# Rules.
#-----------------------------------------------------------------------------

.PHONY : all
#all : ucc sdldrv xdrv xmesagldrv xlaunch audio sdlaudio sdlgldrv ace
all : ace

.PHONY : ace
ace :
	mkdir -p Common/build/Linux
	mkdir -p Common/build/ENet/Linux
	@$(MAKE) $(ARGS) --directory=Common/Src
	@$(MAKE) $(ARGS) --directory=GameServer/Src

.PHONY : core
core :
	@$(MAKE) $(ARGS) --directory=$(CORE_SRC)
	
.PHONY : ucc
ucc :
	@$(MAKE) $(ARGS) --directory=$(UCC_SRC)

.PHONY : xlaunch
xlaunch :
	@$(MAKE) $(ARGS) --directory=$(XLAUNCH_SRC)

.PHONY : xdrv
xdrv :
	@$(MAKE) $(ARGS) --directory=$(XDRV_SRC)

.PHONY : xmesagldrv
xmesagldrv :
	@$(MAKE) $(ARGS) --directory=$(XMESAGLDRV_SRC)

.PHONY : sdldrv
sdldrv :
	@$(MAKE) $(ARGS) --directory=$(SDLDRV_SRC)

.PHONY : sdlgldrv
sdlgldrv :
	@$(MAKE) $(ARGS) --directory=$(SDLGLDRV_SRC)

.PHONY : glidedrv
glidedrv :
	@$(MAKE) $(ARGS) --directory=$(GLIDEDRV_SRC)

.PHONY : audio
audio :
	@$(MAKE) $(ARGS) --directory=$(AUDIO_SRC)

.PHONY : sdlaudio
sdlaudio :
	@$(MAKE) $(ARGS) --directory=$(SDLAUDIO_SRC)

.PHONY : nullrender
nullrender :
	@$(MAKE) $(ARGS) --directory=$(NULLRENDER_SRC)

.PHONY : ipdrv
ipdrv :
	@$(MAKE) $(ARGS) --directory=$(IPDRV_SRC)
	cp $(IPDRV_OUT)/$(IPDRV_SONAME) /home/stijn/UTLinux/System451/$(IPDRV_SONAME)
	chown stijn /home/stijn/UTLinux/System451/$(IPDRV_SONAME)

#-----------------------------------------------------------------------------
# Maintenance.
#-----------------------------------------------------------------------------

# Backup source code.
.PHONY : backup
backup :
	@-mkdir -p $(BACKUP_DIR)
	@tar zcvf $(BACKUP_DIR)/OpenUT-$(VERSION)-`date +%y%m%d`.tar.gz \
		$(ALL_SRC_DIRS) [Mm]akefile*

# Pass custom targets to module makefiles.
.DEFAULT : 
	@$(MAKE) ARGS=$@ --no-print-directory

#-----------------------------------------------------------------------------
# The End.
#-----------------------------------------------------------------------------
