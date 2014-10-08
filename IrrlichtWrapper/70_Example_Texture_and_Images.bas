'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 70: Copying between Texture and Images
'' This example loading in a couple of texture and then uses the IrrlichtWrapper
'' blending function to blend the images together onto one texture surface.
'' It also uses the texture locking functions to get a texture surface and to
'' write color to its surface
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables
' This wrapper uses a series of types to bring type errors to your attention
' when passing variables into the wrapper
DIM createdTexture as irr_texture
DIM createdImage as irr_image
DIM loadedImage as irr_image
DIM pixelsDestination as uinteger ptr
DIM pixelsSource as uinteger ptr
DIM i as integer

'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface. The scene will be rendered using the Irrlicht,
' software renderer, the display will be a window 400 x 200 pixels in size, the
' display will not support shadows and we will not capture any keyboard and
' mouse events
IrrStart( IRR_EDT_OPENGL, 256, 256, IRR_BITS_PER_PIXEL_32, _
          IRR_WINDOWED, IRR_NO_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' Set the title of the display
IrrSetWindowCaption( "Example 70: Copying between Textures and Images" )

' create two new blank texture surface and load two pattern images from file
loadedImage = IrrGetImage( "./media/splatter.tga" )
createdImage = IrrCreateImage( 256, 256, ECF_A8R8G8B8 )
createdTexture = IrrCreateTexture( "NewTexture", 256, 256, ECF_A8R8G8B8 )

' First copy the loaded image into the created image
' lock the two images gaining pointers that access their pixels
pixelsSource = IrrLockImage( loadedImage )
pixelsDestination = IrrLockImage( createdImage )

' copy the data between the two, in ECF_A8R8G8B8 format there are 4 bytes per
' pixel a byte for alpha red, green and blue our unsigned integer pointers can
' copy a pixel in one operation, in a 256 x 256 image there are 65,536 pixels
' so we repeat the operation that number of times copying all the pixels from
' one image to another
for i = 0 to 65535
    *pixelsDestination = *pixelsSource
    pixelsSource += 1
    pixelsDestination += 1
next i

' finally we unlock the images releasing them to the system again
IrrUnlockImage( createdImage )
IrrUnlockImage( loadedImage )

' secondly copy the created image into the created texture
pixelsSource = IrrLockImage( createdImage )
pixelsDestination = IrrLockTexture( createdTexture )

for i = 0 to 65535
    *pixelsDestination = *pixelsSource
    pixelsSource += 1
    pixelsDestination += 1
next i

IrrUnlockTexture( createdTexture )
IrrUnlockImage( createdImage )

' while the scene is still running
WHILE IrrRunning
    ' begin the scene, erasing the canvas to Yellow before rendering
    IrrBeginScene( 255,255,0 )

    ' draw all of the images to the display
    IrrDraw2DImage( createdTexture, 0, 0 )

    ' end drawing the scene and render it
    IrrEndScene
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
