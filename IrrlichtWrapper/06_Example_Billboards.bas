'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 06: Billboards
'' This example demonstrates Billboards. A billboard is a single rectangular
'' polygon that always faces the camera. It is often referred to as a 3D sprite
'' and is especially good for spherical effects like glowing floating lights
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"


'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM Billboard as irr_node
DIM BillboardTexture as irr_texture
DIM Camera as irr_camera


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 400, 200, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 06: Billboards" )

' load the texture resource for the billboard
BillboardTexture = IrrGetTexture( "./media/freebasiclogo_big.jpg" )

' add the billboard to the scene, the first two parameters are the size of the
' billboard in this instance they match the pixel size of the bitmap to give
' the correct aspect ratio. the last three parameters are the position of the
' billboard object
Billboard = IrrAddBillBoardToScene( 200.0,102, 0.0,0.0,100.0 )

' now we apply the loaded texture to the billboard using node material index 0
IrrSetNodeMaterialTexture( Billboard, BillboardTexture, 0 )

' rather than have the billboard lit by light sources in the scene we can
' switch off lighting effects on the model and have it render as if it were
' self illuminating
IrrSetNodeMaterialFlag( Billboard, IRR_EMF_LIGHTING, IRR_OFF )

' add a first person perspective camera into the scene so we can move around
' the billboard and see how it reacts
Camera = IrrAddFPSCamera

' hide the mouse pointer
IrrHideMouse

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
WHILE IrrRunning
    ' begin the scene, erasing the canvas with sky-blue before rendering
    IrrBeginScene( 240, 255, 255 )

    ' draw the scene
    IrrDrawScene

    ' end drawing the scene and render it
    IrrEndScene
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
