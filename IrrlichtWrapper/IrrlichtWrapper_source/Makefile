VERSION = 0.7.7
# Irrlicht Wrapper 0.7.7
# Makefile for Linux derived from the Irrlicht linux makefile
# You will need to download and install Irrlicht 1.7.1 before compiling this library
# Irrlicht 1.7.1 and IrrlichtWrapper folders should be in the same parent folder
#
# To use, just run:
#
# make
# su
# make install
#
# This will compile the IrrlichtWrapper into a shared library and will install it into your /usr/lib directory
#

#List of object files in the wrapper
LINKOBJ := irrlichtwrapper.o CBillboardGroupSceneNode.o CLODSceneNode.o CBoltSceneNode.o CBeamSceneNode.o CSceneNodeAnimatorFade.o wrapper2d.o wrapperanimation.o wrappercamera.o wrappercollision.o wrapperfiling.o wrappergui.o wrapperkeyboardmouse.o wrapperlighting.o wrappernode.o wrapperparticles.o wrapperscene.o wrappershaders.o wrappersystem.o wrapperterrain.o CBillboardGroupSceneNode.o CCloudSceneNode.o CColorMorphAffector.o CGrassPatchSceneNode.o CLensFlareSceneNode.o CParticleEmissionAffector.o CParticlePushAffector.o CSkyDomeColorSceneNode.o CSplineAffector.o CTerrainSphereNode.o CTerrainTileSceneNode.o CZoneSceneNode.o CBatchingMesh.o EffectHandler.o CShaderPre.o

#Compiler flags
CXXINCS = -I../../irrlicht-1.7.1/include -I../../irrlicht-1.7.1/source/Irrlicht
CPPFLAGS = $(CXXINCS)
CXXFLAGS = -Wall
CXXFLAGS += -fexpensive-optimizations -O3
STATIC_LIB = libIrrlichtWrapper.a
SHARED_LIB = libIrrlichtWrapper.so
INSTALL_DIR = /usr/lib
staticlib sharedlib install: SYSTEM = Linux
staticlib sharedlib : LDFLAGS = --add-stdcall-alias
sharedlib : LDFLAGS += -L/usr/X11R6/lib -lGL -lXxf86vm
staticlib sharedlib : CXXINCS += -I/usr/X11R6/include


# All target, builds IrrlichtWrapper as a shared library
all linux: sharedlib

# Builds IrrlichtWrapper as shared lib (libIrrlichtWrapper.so.versionNumber)
sharedlib: $(LINKOBJ)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -shared -Wl,-soname,$(SHARED_LIB) -fPIC -o $(SHARED_LIB).$(VERSION) $^ $(LDFLAGS)

# Builds IrrlichtWrapper as static lib (libIrrlichtWrapper.a)
$(STATIC_LIB): $(LINKOBJ)
	$(AR) rs $@ $^

# Installs IrrlichtWrapper if it was created as shared lib
install:
	cp $(SHARED_LIB).$(VERSION) $(INSTALL_DIR)
	cd $(INSTALL_DIR) && ln -s libIrrlichtWrapper.so.$(VERSION) $(SHARED_LIB)
	ldconfig -n $(INSTALL_DIR)

# Create dependency files for automatic recompilation
%.d:%.cpp
	$(CXX) $(CPPFLAGS) -MM -MF $@ $<

-include $(LINKOBJ:.o=.d)

help:
	@echo "Available targets for IrrlichtWrapper"
	@echo " sharedlib: Build shared library IrrlichtWrapper.so for Linux"
	@echo " staticlib: Build static library IrrlichtWrapper.a for Linux"
	@echo " install: Copy shared library to /usr/lib"
	@echo ""
	@echo " clean: Clean up directory"
	@echo ""
	@echo " Irrlicht 1.7.1 must be installed into the same parent folder as"
	@echo " IrrlichtWrapper and called irrlicht-1.7.1 to build these targets"

# Cleans all temporary files and compilation results.
clean:
	$(RM) $(LINKOBJ) $(SHARED_LIB).$(VERSION) $(STATIC_LIB) $(LINKOBJ:.o=.d)

.PHONY: all sharedlib staticlib help install clean
