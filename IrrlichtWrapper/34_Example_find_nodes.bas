'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 34 : Finding nodes
'' This example creates and labels nodes in a scene and then finds those nodes
'' as if it wasn't aware of them. This is particularly useful when a scene is
'' loaded from a file and the system does not have node pointers to its objects
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables
Type tPosition
    x As single
    y As single
End Type

' irrlicht objects
DIM CreatedNode as irr_node
DIM FoundNode as irr_node
DIM NodeTexture as irr_texture
DIM Camera as irr_camera
DIM i as integer
Dim position(1 To 9) As tPosition => {(-30,-30), (-30,0), (-30,30), (0,-30), (0,0), (0,30), (30,-30), (30,0), (30,30)}

'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 400, 300, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' set the window caption
IrrSetWindowCaption( "Example 34: Finding nodes" )

' load texture resources for texturing the scene nodes
NodeTexture = IrrGetTexture( "./media/irrlichtlogo.bmp" )

' Add a series of test objects, texture and label them
for i = 1 to 9
    ' alternate between a cube and a sphere
    if (i mod 2 ) = 0 then
        CreatedNode = IrrAddCubeSceneNode( 20.0 )
    else
        CreatedNode = IrrAddSphereSceneNode ( 10.0, 16 )
    end if

    ' texture and lebel the node node
    IrrSetNodeMaterialTexture( CreatedNode, NodeTexture, 0 )
    IrrSetNodeMaterialFlag( CreatedNode, IRR_EMF_LIGHTING, IRR_OFF )
    IrrSetNodeID( CreatedNode, i )
next i

Print "*********************************************************"
Print "If this works correctly we should not find nodes 0 and 10"
Print "*********************************************************"

' now search for the nodes through their ID's and position them into a grid
' we are deliberately looking for the unknown ID's 0 and 10 to generate an error
for i = 0 to 10
    FoundNode = IrrGetSceneNodeFromId ( i )
    if FoundNode <> 0 then
        IrrSetNodePosition( FoundNode, position(i).x, position(i).y, 0 )
    else
        ? "Could not find the node ID ";i
    end if
next i

' add a camera into the scene, the first co-ordinates represents the 3D
' location of our view point into the scene the second co-ordinates specify the
' target point that the camera is looking at
Camera = IrrAddCamera( 0,0,75, 0,0,0 )

' we also hide the mouse pointer to see the view better
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
