'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 55: Zone Management
'' This example demonstrates zone management objects, these are parent objects
'' that manage the visibility of their child objects and can be used to remove
'' numbers of objects out of the visible scene when the camera moves out of
'' visible range
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
IrrSetWindowCaption( "Example 55: Zone Management" )

' load the texture resource for the billboard
BillboardTexture = IrrGetTexture( "./media/freebasiclogo_big.jpg" )

' here we create 900 zones
for x = -15 to 15
    for z = -15 to 15
        
        ' we add in a zone management object and set the near distance to 100
        ' and the far distance to 300. the zone management object will only
        ' be visible if the zone is more than 100 units from the active camera
        ' and less than 300 units away, any child objects of this zone will be
        ' completely unprocessed.
        ' if you set your zone up in conjunction with fog you can have lots of
        ' complex objects in the scene and when the zone they were in was out of
        ' camera range the objects would be completely disabled and have no
        ' impact on the processing of the scene
        ' you could also place a large number of zone managers into another zone
        ' if your environment was sufficiently complex
        ' the near value also allows you to implement a simple level of detail
        ' LOD effect by having a low and high resoloution zones overlapping one
        ' another the high resoloution zone might display from 0 to 100 while
        ' the low resoloution zone displays from 100 to 500
        zone = IrrAddZoneManager(100,300)

        ' here we create 6 billboards for each zone, this would make nearly 4600
        ' billboards but as only a small set are displayed there is minimal
        ' effect on the speed of the display
        for n = 0 to 5
            Billboard = IrrAddBillBoardToScene( 5.0, 5.0 )
            IrrSetNodeMaterialTexture( Billboard, BillboardTexture, 0 )
            IrrSetNodeMaterialFlag( Billboard, IRR_EMF_LIGHTING, IRR_OFF )
            IrrSetNodePosition( Billboard, rnd * 50, rnd * 50, rnd * 50 )
            
            ' finally we attach the billboard to the zone as a child and the
            ' billboard is thereafter automatically managed by the zone manager
            IrrAddChildToParent( Billboard, zone )
        next n

        IrrSetNodePosition( zone, x*100, 0, z*100 )
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
    IrrBeginScene( 255, 255, 255 )

    ' draw the scene
    IrrDrawScene

    ' end drawing the scene and render it
    IrrEndScene
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
