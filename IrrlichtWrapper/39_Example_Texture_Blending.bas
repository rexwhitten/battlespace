'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 39: Texture Blending
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
DIM TextureA as irr_texture
DIM TextureB as irr_texture
DIM TextureC as irr_texture
DIM TextureD as irr_texture
DIM screen_width as integer
DIM screen_height as integer
DIM pixels as uinteger ptr
DIM i as integer

'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface. The scene will be rendered using the Irrlicht,
' software renderer, the display will be a window 400 x 200 pixels in size, the
' display will not support shadows and we will not capture any keyboard and
' mouse events
screen_width = 256
screen_height = 256
IrrStart( IRR_EDT_OPENGL, screen_width, screen_height, IRR_BITS_PER_PIXEL_32, _
          IRR_WINDOWED, IRR_NO_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' Set the title of the display
IrrSetWindowCaption( "Example 39: Texture Blending" )

' create two new blank texture surface and load two pattern images from file
TextureA = IrrCreateTexture( "stripes", 128, 128, ECF_A8R8G8B8 )
TextureB = IrrGetTexture( "./media/Diagonal.bmp" )
TextureC = IrrGetTexture( "./media/Cross.bmp" )
TextureD = IrrCreateTexture( "merged", 128, 128, ECF_A8R8G8B8 )

' get the pixels of one of the textures and write blocks of color into the image
pixels = IrrLockTexture( TextureA )
for i = 0 to 4095
    *pixels = 16711680
    pixels += 1
next i
for i = 0 to 4095
    *pixels = 65280
    pixels += 1
next i
for i = 0 to 4095
    *pixels = 255
    pixels += 1
next i
for i = 0 to 4095
    *pixels = 0
    pixels += 1
next i
IrrUnlockTexture( TextureA )

' Blend the two loaded textures onto the created surface
IrrBlendTextures( TextureD, TextureB, 0,0, BLEND_ADD )
IrrBlendTextures( TextureD, TextureC, 0,0, BLEND_SCREEN )

' while the scene is still running
WHILE IrrRunning
    ' begin the scene, erasing the canvas to Yellow before rendering
    IrrBeginScene( 255,255,0 )

    ' draw all of the images to the display
    IrrDraw2DImage( TextureA, 0, 0 )
    IrrDraw2DImage( TextureB, 128, 0 )
    IrrDraw2DImage( TextureC, 0, 128 )
    IrrDraw2DImage( TextureD, 128, 128 )

    ' end drawing the scene and render it
    IrrEndScene
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
