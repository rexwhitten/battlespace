'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 56: Zone Management Bounding Boxes
'' This example demonstrates the display of bounding boxes created by adding
'' child objects to parent zone managment objects
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
DIM zone as irr_node
DIM x as integer
DIM z as integer
DIM n as integer


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 800, 600, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 56: Zone Management Bounding Boxes" )

' load the texture resource for the billboard
BillboardTexture = IrrGetTexture( "./media/freebasiclogo_big.jpg" )

' add the billboard to the scene, the first two parameters are the size of the
' billboard in this instance they match the pixel size of the bitmap to give
' the correct aspect ratio. the last three parameters are the position of the
' billboard object
for x = -15 to 15
    for z = -15 to 15
        zone = IrrAddZoneManager(0,600)
'        IrrSetZoneManagerBoundingBox( zone, 0, 0, 0,  100, 100, 100 )
        IrrSetZoneManagerProperties( zone, 0, 600, 1 )
        IrrSetNodePosition( zone, x*100, 0, z*100 )
        IrrDebugDataVisible( zone, &hFFFF )

        for n = 0 to 5
            Billboard = IrrAddBillBoardToScene( 5.0, 5.0 )
            IrrSetNodeMaterialTexture( Billboard, BillboardTexture, 0 )
            IrrSetNodeMaterialFlag( Billboard, IRR_EMF_LIGHTING, IRR_OFF )
            IrrSetNodePosition( Billboard, rnd * 50, rnd * 50, rnd * 50 )
            IrrAddChildToParent( Billboard, zone )
        next n
    next z
next x

' add a first person perspective camera into the scene so we can move around
' the billboard and see how it reacts
Camera = IrrAddFPSCamera

' hide the mouse pointer
IrrHideMouse

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
WHILE IrrRunning
    ' begin the scene, erasing the canvas
    IrrBeginScene( 0, 0, 0 )

    ' draw the scene
    IrrDrawScene

    ' end drawing the scene and render it
    IrrEndScene
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
