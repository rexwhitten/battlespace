'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 60: Getting Node Children
'' This example demonstrates acquiring the child nodes connected to a parent
'' node
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"


'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM MeshTexture as irr_texture
DIM Camera as irr_camera
DIM zone as irr_node
DIM x as integer
DIM z as integer
DIM n as integer
DIM BitmapFont as irr_font
DIM nodelabel as string
DIM nodename as wstring * 256
DIM TestNode as irr_node
DIM RootNode as irr_node
DIM position as any ptr

'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 800, 600, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 60: Getting Node Children" )

' load the test cube texture
MeshTexture = IrrGetTexture( "./media/texture.jpg" )

' create a series of zones
for x = -3 to 3
    for z = -3 to 3
        zone = IrrAddZoneManager(0,9999)
        IrrSetZoneManagerBoundingBox( zone, 0, 0, 0,  100, 100, 100 )
        IrrSetNodePosition( zone, x*100, 0, z*100 )
        IrrDebugDataVisible( zone, &hFFFF )
        nodelabel = "ZONE " + Str(X+3) + "," + Str(Z+3)
        IrrSetNodeName( zone, nodelabel )

        ' save the details of one of the zone nodes
        if x = 0 and z = 0 then RootNode = zone

        for n = 0 to 5
            TestNode = IrrAddTestSceneNode
            IrrSetNodePosition( TestNode, rnd * 50, rnd * 50, rnd * 50 )
            IrrSetNodeMaterialTexture( TestNode, MeshTexture, 0 )
            IrrSetNodeMaterialFlag( TestNode, IRR_EMF_LIGHTING, IRR_OFF )

            nodelabel = "ZONE " + Str(X+3) + "," + Str(Z+3) + "," + Str(N)
            IrrSetNodeName( TestNode, nodelabel )

            IrrAddChildToParent( TestNode, zone )
        next n

    next z
next x

' add a first person perspective camera into the scene so we can move around
' the billboard and see how it reacts
Camera = IrrAddFPSCamera

' hide the mouse pointer
IrrHideMouse

' now that everything is created itterate through all of the children attached
' to the zone node we saved
TestNode = IrrGetNodeFirstChild( RootNode, position )

while NOT TestNode = IRR_NO_OBJECT
    if IrrIsNodeLastChild( RootNode, position ) = 0 then
        PRINT "Child node name is "; *IrrGetNodeName( TestNode )
    else
        PRINT "Last Child node name is "; *IrrGetNodeName( TestNode )
    end if

    TestNode = IrrGetNodeNextChild( RootNode, position )
wend

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
