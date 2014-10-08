''' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 03: Bitmap Fonts
'' This example uses a bitmap based font to draw text to the screen
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables
' This wrapper uses a series of types to bring type errors to your attention
' when passing variables into the wrapper
DIM BitmapFont as irr_font


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface. The scene will be rendered using the Irrlicht,
' software renderer, the display will be a window 400 x 200 pixels in size, the
' display will not support shadows and we will not capture any keyboard and
' mouse events
IrrStart( IRR_EDT_SOFTWARE, 400, 200, IRR_BITS_PER_PIXEL_32,_
          IRR_WINDOWED, IRR_NO_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' Set the title of the display
IrrSetWindowCaption( "Example 03: Bitmap Fonts" )

' load a bitmap font as a texture
BitmapFont = IrrGetFont ( "./media/bitmapfont.bmp" )

' while the scene is still running
WHILE IrrRunning
    ' begin the scene, erasing the canvas to black before rendering
    IrrBeginScene( 0,0,0 )

    ' draw the text using the loaded bitmap font at the supplied co-ordinates
    ' this font only has capitals in the bitmap at the moment lowercase
    ' characters will display as blanks
    Irr2DFontDraw ( BitmapFont, "SIMPLE MONOCHROME FONT", 120, 80, 250, 96 )

    ' end drawing the scene and render it
    IrrEndScene
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
