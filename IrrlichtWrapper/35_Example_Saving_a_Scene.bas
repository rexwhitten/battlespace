'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 35 : Saving a scene
'' This example constructs a scene from some simple objects and then saves the
'' scene to a file 
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
IrrStart( IRR_EDT_OPENGL, 400, 300, 32, IRR_WINDOWED, _
          IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' set the window caption
IrrSetWindowCaption( "Example 35: Saving a scene" )

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
    IrrSetNodePosition( CreatedNode, position(i).x, position(i).y, 0 )
next i

' add a camera to the scene to view the objects
Camera = IrrAddCamera( 0,0,75, 0,0,0 )

' we also hide the mouse pointer to see the view better
IrrHideMouse

' Save the scene to file
IrrSaveScene( ".\myscene.irr" )

' erase the scene
IrrRemoveAllNodes

' load it back in from file
IrrLoadScene( ".\myscene.irr" )

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
