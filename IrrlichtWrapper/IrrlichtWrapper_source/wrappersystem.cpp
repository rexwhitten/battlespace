//
// Irrlicht Wrapper for Imperative Languages
// Frank Dodd (2006)
//
// This wrapper DLL encapsulates a sub-set of the features of the powerful
// Irrlicht 3D Graphics Engine exposing the Object Oriented architecture and
// providing a functional 3D SDK for languages that are not object oriented.
//
// This source was created with the help of the great examples in the Irrlicht
// SDK and the excellent Irrlicht documentation. This software was developed
// using the GCC compiler and Code::Blocks IDE
//

/* ////////////////////////////////////////////////////////////////////////////
includes
*/
#include "irrlichtwrapper.h"
#include "XEffects.h"


/* ////////////////////////////////////////////////////////////////////////////
global variables
*/
EffectHandler* effect = NULL;

/* ////////////////////////////////////////////////////////////////////////////
external variables
*/
extern IrrlichtDevice *device;
extern IVideoDriver* driver;
extern ISceneManager* smgr;
extern IGUIEnvironment* guienv;
extern StackedEventReceiver receiver;

extern void dropShaders( void );


/* ////////////////////////////////////////////////////////////////////////////
Global Function Declarations

all of the below functions are declared as C functions and are exposed without
any mangled names so that they can be easily imported into imperative
languages like FreeBasic
*/
extern "C"
{

/* ////////////////////////////////////////////////////////////////////////////
SYSTEM FUNCTIONS
*/
/* ----------------------------------------------------------------------------
only one irrlicht device object is supported by this wrapper. this call creates
the device object, a video driver object, scene manager object and a GUI
environment object that are exposed to FreeBasic
*/
bool DLL_EXPORT IrrStart(
                              int iDevice,
                              int iWidth,
                              int iHeight,
                              unsigned int iBPP,
                              bool boFullscreen,
                              bool boShadows,
                              bool boCaptureEvents,
                              bool vsync )
{
    bool boInitStatus = false;
    E_DRIVER_TYPE iDeviceTypes[] = {
            EDT_NULL, EDT_SOFTWARE, EDT_SOFTWARE, EDT_OPENGL, EDT_DIRECT3D8, EDT_DIRECT3D9 };

    // create an irrlicht device object the root of all irrlicht functionality
    // if it is successfully created
	if ( device = createDevice(
            iDeviceTypes[iDevice],
            dimension2d<u32>( iWidth, iHeight),
            iBPP,
			boFullscreen,
			boShadows,
			vsync,
			boCaptureEvents ? &receiver : 0 ))
    {

        /* Get a pointer to the video driver, the SceneManager and the
        graphical user interface environment */
        // if we can successfully create these objects
        if (( driver = device->getVideoDriver()) &&
                ( smgr = device->getSceneManager()) &&
                ( guienv = device->getGUIEnvironment()))
		{
			// the system has started up correctly
            boInitStatus = true;

			// apply an unlight material to the scene so that drawing functions display in set color
			SMaterial unlitMaterial;
			unlitMaterial.Lighting = false;
			driver->setMaterial(unlitMaterial);
		}
    }
    return boInitStatus;
}


/* ----------------------------------------------------------------------------
only one irrlicht device object is supported by this wrapper. this call creates
the device object, a video driver object, scene manager object and a GUI
environment object that are exposed to FreeBasic
*/
bool DLL_EXPORT IrrStartAdvanced (
		int drivertype,			// Default of EDT_OPENGL is used if <= -1.
		int width,				// Default of 800 is used if <= 0
		int height,				// Default of 600 is used if <= 0
		u32 bits,				// Default of 16 (bits) is used if <= 0.
		u32 fullscreen,			// Run in windowed or fullscreen mode
		u32 shadows,			// Does nothing (at this time).
		u32 dontignoreinput,	// capture irrlicht events
		u32 vsyncEnabled,		// sync with the vertical blank for tear free frames

		// Extended values for IrrStartAdvanced (versus IrrStart)
		u32 devicetype,			// Leave at 0 for "EIDT_BEST".
		bool doublebufferEnabled,	// Should be set to 1.
		u32 antialiasEnabled,	// enable full screen antialiasing
		u32 highprecisionfpu )	// enable high precision fpu calculations
{
	E_DEVICE_TYPE devicetypeEnum[] = {EIDT_BEST, EIDT_WIN32, EIDT_WINCE, EIDT_X11, EIDT_OSX, EIDT_SDL, EIDT_FRAMEBUFFER, EIDT_CONSOLE};
	E_DRIVER_TYPE drivertypeEnum[] = {EDT_NULL, EDT_SOFTWARE, EDT_BURNINGSVIDEO, EDT_OPENGL, EDT_DIRECT3D8, EDT_DIRECT3D9};

	SIrrlichtCreationParameters params;

	if (width <= 0) width = 800;
	if (height <= 0) height = 600;

	params.AntiAlias = antialiasEnabled;

	if (bits > 0) params.Bits = bits;

	params.DeviceType = devicetypeEnum[devicetype];
	params.Doublebuffer = (bool)doublebufferEnabled;
	params.DriverType = drivertypeEnum[drivertype];
	params.EventReceiver = &receiver;
	params.Fullscreen = (fullscreen != 0);
	params.IgnoreInput = ((1 - dontignoreinput) != 0);
	params.HighPrecisionFPU = (highprecisionfpu != 0);
	//params.LoggingLevel = logginglevel;
	//params.Stencilbuffer = stencilbuffer;
	//params.Stereobuffer = stereobuffer;
	params.Vsync = (vsyncEnabled != 0);
	//params.WindowId = windowid;
	params.WindowSize = irr::core::dimension2d<u32>(width, height);
	//params.WithAlphaChanel = withalphachannel;
	//params.ZBufferBits = zbufferbits;

	// if we successfully created a an irrlicht device object
	bool initStatus = false;
	if (device = createDeviceEx(params))
	{
		// Get a pointer to the video driver, the SceneManager and the graphical user interface environment.
		if (( driver = device->getVideoDriver()) && ( smgr = device->getSceneManager()) && ( guienv = device->getGUIEnvironment()))
		{
			// The system has started up correctly:
			initStatus = true;

			// Apply an unlit material to the scene so that drawing functions display in a set color.
			SMaterial unlitMaterial;
			unlitMaterial.Lighting = false;
			driver->setMaterial(unlitMaterial);
		}
	}
	// inform the user whether the function was successful or not
	return initStatus;
}


/* ----------------------------------------------------------------------------
allow transparency to write to the z buffer
*/
void DLL_EXPORT IrrTransparentZWrite ( void )
{
    smgr->getParameters()->setAttribute(scene::ALLOW_ZWRITE_ON_TRANSPARENT, true);
}


/* ----------------------------------------------------------------------------
determine if the irrlicht environment is still running or has been quit
*/
int DLL_EXPORT IrrRunning ( void )
{
    return device->run();
}

/* ----------------------------------------------------------------------------
Set the view port to a specific area of the screen
*/
void DLL_EXPORT IrrSetViewPort ( int topX, int topY, int botX, int botY )
{
	driver->setViewPort(rect<s32>(topX, topY, botX, botY ));
}

/* ----------------------------------------------------------------------------
begin rendering a scene eraseing the canvas ready for rendering
*/
void DLL_EXPORT IrrBeginScene ( int R, int G, int B )
{
    // begin the scene
    driver->beginScene(true, true, SColor(0,R,G,B));
}

/* ----------------------------------------------------------------------------
Readies a scene for rendering, erasing the canvas and setting a background color.
*/
void DLL_EXPORT IrrBeginSceneAdvanced ( u32 sceneBackgroundColor,
										bool clearBackBuffer,
										bool clearZBuffer )
{
	driver->beginScene( clearBackBuffer, clearZBuffer, sceneBackgroundColor );
}

/* ----------------------------------------------------------------------------
draw scene manager objects
*/
void DLL_EXPORT IrrDrawScene ( void )
{
    // draw the scene
	if ( effect == NULL )
	    smgr->drawAll();
	else
		effect->update();
}

/* ----------------------------------------------------------------------------
draw scene manager objects to a texture surface
*/
void DLL_EXPORT IrrDrawSceneToTexture ( ITexture * renderTarget )
{
	// set the texture as the render target
	driver->setRenderTarget( renderTarget, true, true, SColor(0,0,0,255));

	// draw whole scene into the texture
	smgr->drawAll();

	// set the display as the render target
	driver->setRenderTarget(0);
}

/* ----------------------------------------------------------------------------
Sets a texture as a render target, or sets the device if the pointer is 0.
*/
void DLL_EXPORT IrrSetRenderTarget (ITexture *renderTarget, u32 sceneBackgroundColor, bool clearBackBuffer, bool clearZBuffer )
{
	// set the texture as the render target
	if (renderTarget == 0)
	{
		driver->setRenderTarget(0);
		return;
	}
	driver->setRenderTarget ( renderTarget, clearBackBuffer, clearZBuffer, sceneBackgroundColor );
}

/* ----------------------------------------------------------------------------
draw GUI components
*/
void DLL_EXPORT IrrDrawGUI ( void )
{
    // draw the gui interface
    guienv->drawAll();
}

/* ----------------------------------------------------------------------------
finish the scene and display it
*/
void DLL_EXPORT IrrEndScene ( void )
{
    // end the scene and display it
	driver->endScene();
}

/* ----------------------------------------------------------------------------
release the irrlicht environment and all of its resources
*/
void DLL_EXPORT IrrStop( void )
{
	device->closeDevice();
	device->drop();

	/* release resources managed by the wrapper and not irrlicht */
	dropShaders();
}

/* ----------------------------------------------------------------------------
get the current frame rate
*/
int DLL_EXPORT IrrGetFPS( void )
{
    return driver->getFPS();
}

/* ----------------------------------------------------------------------------
get the number of primitives (mostly triangles) drawn in the last frame
*/
unsigned int DLL_EXPORT IrrGetPrimitivesDrawn( void )
{
    return driver->getPrimitiveCountDrawn();
}

/* ----------------------------------------------------------------------------
set the caption in the irrlicht window
*/
void DLL_EXPORT IrrSetWindowCaption( const wchar_t * wcptrText )
{
    device->setWindowCaption( wcptrText );
}

/* ----------------------------------------------------------------------------
query whether a feature is supported on the graphics card
*/
bool DLL_EXPORT IrrQueryFeature( enum irr::video::E_VIDEO_DRIVER_FEATURE feature )
{
    return driver->queryFeature( feature );
}

/* ----------------------------------------------------------------------------
disable or enable a specific feature on a graphics card
*/
void DLL_EXPORT IrrDisableFeature( enum irr::video::E_VIDEO_DRIVER_FEATURE feature, bool flag )
{
	driver->disableFeature( feature, flag );
}

/* ----------------------------------------------------------------------------
get the current time in milliseconds
*/
u32 DLL_EXPORT IrrGetTime( void )
{
    return device->getTimer()->getTime();
}

/* ----------------------------------------------------------------------------
set the current time in milliseconds
*/
void DLL_EXPORT IrrSetTime( u32 newTime )
{
    return device->getTimer()->setTime(newTime);
}

/* ----------------------------------------------------------------------------
Gets the screen size.
*/
void DLL_EXPORT IrrGetScreenSize(int &width, int &height)
{
    irr::core::dimension2d<u32> screensize = device->getVideoDriver()->getScreenSize();
    width = screensize.Width;
    height = screensize.Height;
}

/* ----------------------------------------------------------------------------
Checks if the Irrlicht window is running in fullscreen mode.
*/
bool DLL_EXPORT IrrIsFullscreen(void)
{
    return device->isFullscreen();
}

/* ----------------------------------------------------------------------------
Returns if the window is active.
*/
bool DLL_EXPORT IrrIsWindowActive(void)
{
    return device->isWindowActive();
}

/* ----------------------------------------------------------------------------
Checks if the Irrlicht window has focus.
*/
bool DLL_EXPORT IrrIsWindowFocused(void)
{
    return device->isWindowFocused();
}

/* ----------------------------------------------------------------------------
Checks if the Irrlicht window is minimized.
*/
bool DLL_EXPORT IrrIsWindowMinimized(void)
{
    return device->isWindowMinimized ();
}

/* ----------------------------------------------------------------------------
Maximizes the window if possible.
*/
void DLL_EXPORT IrrMaximizeWindow(void)
{
    device->maximizeWindow();
}

/* ----------------------------------------------------------------------------
Minimizes the window if possible.
*/
void DLL_EXPORT IrrMinimizeWindow(void)
{
    device->minimizeWindow();
}

/* ----------------------------------------------------------------------------
Restore the window to normal size if possible.
*/
void DLL_EXPORT IrrRestoreWindow(void)
{
    device->restoreWindow();
}

/* ----------------------------------------------------------------------------
Make the window resizable.
*/
void DLL_EXPORT IrrSetResizableWindow( bool resizable )
{
    device->setResizable( resizable );
}



/* ////////////////////////////////////////////////////////////////////////////
BITPLANES XEFFECT EXTENSION SUPPORT
*/


// We need to pass the view projection matrix to the SSAO shader, so we create a class that inherits from
// IPostProcessingRenderCallback and pass the shader constant in OnPreRender using setPostProcessingEffectConstant.
class SSAORenderCallback : public IPostProcessingRenderCallback
{
	public:
	SSAORenderCallback(irr::s32 materialTypeIn) : materialType(materialTypeIn) {}

	void OnPreRender(EffectHandler* effect)
	{
		IVideoDriver* driver = effect->getIrrlichtDevice()->getVideoDriver();
		viewProj = driver->getTransform(ETS_PROJECTION) * driver->getTransform(ETS_VIEW);
		effect->setPostProcessingEffectConstant(materialType, "mViewProj", viewProj.pointer(), 16);
	}

	void OnPostRender(EffectHandler* effect) {}

	core::matrix4 viewProj;
	s32 materialType;
};


/* ----------------------------------------------------------------------------
Make the window resizable.
*/
void DLL_EXPORT IrrXEffectsStart( bool vsm, bool softShadows, bool bitdepth32 )
{
	effect = new EffectHandler(device, driver->getScreenSize(), vsm, softShadows, bitdepth32 );
}


/* ----------------------------------------------------------------------------
Make the window resizable.
*/
void DLL_EXPORT IrrXEffectsEnableDepthPass( bool enable )
{
	effect->enableDepthPass(enable);
}


/* ----------------------------------------------------------------------------
Make the window resizable.
*/
void DLL_EXPORT IrrXEffectsAddPostProcessingFromFile(
		const char * name, int effectType )
{
	irr::s32 handle = effect->addPostProcessingEffectFromFile( core::stringc( name ));

	if ( effectType == 1 )
	{
		// Create our custom IPostProcessingRenderCallback and pass it to setPostProcessingRenderCallback
		// so that we can perform operations before and after the SSAO effect is rendered.
		SSAORenderCallback* ssaoCallback = new SSAORenderCallback(handle);
		effect->setPostProcessingRenderCallback(handle, ssaoCallback);

		ITexture* randVecTexture = effect->generateRandomVectorTexture(dimension2du(512, 512));
		effect->setPostProcessingUserTexture(randVecTexture);
	}
}


/* ----------------------------------------------------------------------------
Make the window resizable.
*/
void DLL_EXPORT IrrXEffectsSetPostProcessingUserTexture( ITexture * texture )
{
	effect->setPostProcessingUserTexture(texture);
}


/* ----------------------------------------------------------------------------
Make the window resizable.
*/
void DLL_EXPORT IrrXEffectsAddShadowToNode( ISceneNode * node,
		E_FILTER_TYPE filterType, E_SHADOW_MODE shadowType )
{
	effect->addShadowToNode( node, filterType, shadowType );
}


/* ----------------------------------------------------------------------------
Make the window resizable.
*/
void DLL_EXPORT IrrXEffectsRemoveShadowFromNode( ISceneNode * node )
{
	effect->removeShadowFromNode( node );
}


/* ----------------------------------------------------------------------------
Make the window resizable.
*/
void DLL_EXPORT IrrXEffectsExcludeNodeFromLightingCalculations( ISceneNode * node )
{
	effect->excludeNodeFromLightingCalculations( node );
}


/* ----------------------------------------------------------------------------
Make the window resizable.
*/
void DLL_EXPORT IrrXEffectsAddNodeToDepthPass( ISceneNode * node )
{
	effect->addNodeToDepthPass( node );
}


/* ----------------------------------------------------------------------------
Make the window resizable.
*/
void DLL_EXPORT IrrXEffectsSetAmbientColor( u32 R, u32 G, u32 B, u32 Alpha )
{
	effect->setAmbientColor(SColor(R,G,B,Alpha));
}


/* ----------------------------------------------------------------------------
Make the window resizable.
*/
void DLL_EXPORT IrrXEffectsSetClearColor( u32 R, u32 G, u32 B, u32 Alpha )
{
	effect->setClearColour(SColor(R,G,B,Alpha));
}


/* ----------------------------------------------------------------------------
Add a special dynamic shadow casting light
The first parameter specifies the shadow map resolution for the shadow light.
The shadow map is always square, so you need only pass 1 dimension, preferably
a power of two between 512 and 2048, maybe larger depending on your quality
requirements and target hardware. We will just pass the value the user picked.
The second parameter is the light position, the third parameter is the (look at)
target, the next is the light color, and the next two are very important
values, the nearValue and farValue, be sure to set them appropriate to the current
scene. The last parameter is the FOV (Field of view), since the light is similar to
a spot light, the field of view will determine its area of influence. Anything that
is outside of a lights frustum (Too close, too far, or outside of it's field of view)
will be unlit by this particular light, similar to how a spot light works.
We will add one red light and one yellow light.
*/
void DLL_EXPORT IrrXEffectsAddShadowLight(
		u32 shadowDimen,
		float posX, float posY, float posZ,
		float targetX, float targetY, float targetZ,
		float R, float G, float B, float Alpha,
		float lightNearDist , float lightFarDist, float angleDegrees )
{
	effect->addShadowLight(SShadowLight( shadowDimen,			vector3df(posX,posY,posZ),
			vector3df(targetX,targetY,targetZ),
			SColorf(R,G,B,Alpha),			lightNearDist, lightFarDist, angleDegrees * DEGTORAD));
}


/* ----------------------------------------------------------------------------
Make the window resizable.
*/
void DLL_EXPORT IrrXEffectsSetShadowLightPosition(
		u32 index, float posX, float posY, float posZ )
{
	effect->getShadowLight(index).setPosition(vector3df(posX,posY,posZ));
}


/* ----------------------------------------------------------------------------
Make the window resizable.
*/
void DLL_EXPORT IrrXEffectsGetShadowLightPosition(
		u32 index, float &posX, float &posY, float &posZ )
{
	vector3df pos = effect->getShadowLight(index).getPosition();
	posX = pos.X;
	posY = pos.Y;
	posZ = pos.Z;
}


/* ----------------------------------------------------------------------------
Make the window resizable.
*/
void DLL_EXPORT IrrXEffectsSetShadowLightTarget(
		u32 index, float posX, float posY, float posZ )
{
	effect->getShadowLight(index).setTarget(vector3df(posX,posY,posZ));
}


/* ----------------------------------------------------------------------------
Make the window resizable.
*/
void DLL_EXPORT IrrXEffectsGetShadowLightTarget(
		u32 index, float &posX, float &posY, float &posZ )
{
	vector3df pos = effect->getShadowLight(index).getTarget();
	posX = pos.X;
	posY = pos.Y;
	posZ = pos.Z;
}


/* ----------------------------------------------------------------------------
Make the window resizable.
*/
void DLL_EXPORT IrrXEffectsSetShadowLightColor(
		u32 index, float R, float G, float B, float Alpha ){
	effect->getShadowLight(index).setLightColor(SColorf(R,G,B,Alpha));
}


/* ----------------------------------------------------------------------------
Make the window resizable.
*/
void DLL_EXPORT IrrXEffectsGetShadowLightColor(
		u32 index, float &R, float &G, float &B, float &Alpha )
{
	SColorf color = effect->getShadowLight(index).getLightColor();
	R = color.a;
	G = color.g;
	B = color.b;
	Alpha = color.a;
}


/* ////////////////////////////////////////////////////////////////////////////
all of the above functions are declared as C functions and are exposed without
any mangled names
*/
}
