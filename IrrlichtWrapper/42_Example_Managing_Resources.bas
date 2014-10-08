'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 42: Managing Texture Resrouces
'' This example demonstrates how texture resource can be managed. If many
'' textures are loaded they should be deleted once no longer needed to ensure
'' memory is not wasted.
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables
' This wrapper uses a series of types to bring type errors to your attention
' when passing variables into the wrapper
DIM IrrlichtLogo as irr_texture
DIM FreeBasicLogo as irr_texture
DIM NewIrrlichtLogo as irr_texture
DIM screen_width as integer
DIM screen_height as integer


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface. The scene will be rendered using the Irrlicht,
' software renderer, the display will be a window 400 x 200 pixels in size, the
' display will not support shadows and we will not capture any keyboard and
' mouse events
screen_width = 400
screen_height = 200
IrrStart( IRR_EDT_OPENGL, screen_width, screen_height, IRR_BITS_PER_PIXEL_32, _
          IRR_WINDOWED, IRR_NO_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' Set the title of the display
IrrSetWindowCaption( "Example 42: Managing texture resources" )

' begin the scene, erasing the canvas with sky-blue before rendering
IrrBeginScene( 0,0,0 )

' end drawing the scene and render it
IrrEndScene

' load a bitmap object temporarily
? "-----------------------------------------------------------------------"
IrrlichtLogo = IrrGetTexture( "./media/irrlichtlogo.bmp" )
? "The address of the Irrlicht Logo is ";IrrlichtLogo

' remove the texture
? "-----------------------------------------------------------------------"
IrrRemoveTexture( IrrlichtLogo )
? "The IrrlichtLogo has been removed"

' load a new texture
? "-----------------------------------------------------------------------"
FreeBasicLogo = IrrGetTexture( "./media/freebasiclogo.bmp" )
? "The address of the FreeBasic Logo is ";FreeBasicLogo

' if the two images were in the same memory space notify the user
if  IrrlichtLogo = FreeBasicLogo then
    ? "-----------------------------------------------------------------------"
    ? "NOTICE: The address of the Irrlicht and FreeBasic logo's are the same"
    ? "this is because IrrlichtLogo was removed and the memory was reused for"
    ? "the FreeBasicLogo. If this was a large texture the saving could be huge"
end if

' reload the first image again
? "-----------------------------------------------------------------------"
NewIrrlichtLogo = IrrGetTexture( "./media/irrlichtlogo.bmp" )
? "The new address of the Irrlicht Logo is ";NewIrrlichtLogo

' if the image is in a different location to where it was before display a message
if  IrrlichtLogo <> NewIrrlichtLogo then
    ? "-----------------------------------------------------------------------"
    ? "NOTICE: The address of the two Irrlicht logo's are different"
    ? "this is because IrrlichtLogo was removed and the memory was reused for"
    ? "the FreeBasicLogo. Now we have loaded it again it is in a different place"
end if

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop

' suspend the application so that the user can monitor the results
? "-----------------------------------------------------------------------"
? "Press any key to end"
sleep

