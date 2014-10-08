'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 59: Limited Collision with a Point
'' This example demonstrates the use of tests of collisions between a point and
'' objects in a scene limited by the ID of the those objects
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
DIM CameraNode as irr_node
DIM zone as irr_node
DIM x as integer
DIM z as integer
DIM BitmapFont as irr_font
DIM nodelabel as string
DIM nodename as wstring * 256
DIM vector as IRR_VECTOR
DIM SelectedNode as irr_node
DIM RootNode as irr_node


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 800, 600, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 59: Limited Collision with a Point" )

' load the bitmap font as a texture
BitmapFont = IrrGetFont ( "./media/bitmapfont.bmp" )

' create a series of zones
for x = -3 to 3
    for z = -3 to 3
        zone = IrrAddZoneManager(0,9999)
        IrrSetZoneManagerBoundingBox( zone, 0, 0, 0,  100, 100, 100 )
        IrrSetNodePosition( zone, x*100, 0, z*100 )
        IrrDebugDataVisible( zone, &hFFFF )
        nodelabel = "ZONE " + Str(X+3) + "," + Str(Z+3)
        IrrSetNodeName( zone, nodelabel )
        PRINT *IrrGetNodeName(zone)
    next z
next x

' add a first person perspective camera into the scene so we can move around
' the billboard and see how it reacts
Camera = IrrAddFPSCamera
CameraNode = Camera

' hide the mouse pointer
IrrHideMouse

' get the root node of the scene
RootNode = IrrGetRootSceneNode

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
WHILE IrrRunning
    ' begin the scene, erasing the canvas
    IrrBeginScene( 0, 0, 0 )

    ' draw the scene
    IrrDrawScene

    ' get the position of the camera
    IrrGetNodePosition( CameraNode, vector.X, vector.Y, vector.Z )

    ' get the first object that is the subject of a collision with the specified
    ' point, the call is supplied with the Parent node to test, a bitmask to
    ' tlimit the ID of the nodes included into the test a flag to declare
    ' whether the entire tree of nodes is tested and finally the point to be
    ' tested against
    SelectedNode = IrrGetChildCollisionNodeFromPoint( _
            RootNode, 0, IRR_OFF, vector )

    ' if a node was selected
    if NOT SelectedNode = 0 then
        ' get the name of the zone
        nodename = "SELECTED NODE IS:" + *IrrGetNodeName(SelectedNode)
        
        ' draw this position information to the screen
        Irr2DFontDraw ( BitmapFont, nodename, 4, 32, 250, 52 )
    end if

    ' end drawing the scene and render it
    IrrEndScene
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
