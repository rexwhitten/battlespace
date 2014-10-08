'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 72: Camera Control with the WASD keys
'' This example demonstrates moving a camera around by using the more
'' traditional WASD control keys rather than the arrow keys
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM BSPMesh as irr_mesh
DIM BSPNode as irr_node
DIM Camera as irr_camera
DIM CameraNode as irr_node


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 800, 400, IRR_BITS_PER_PIXEL_32,_
        IRR_WINDOWED, IRR_NO_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 72: Camera Control with the WASD keys" )

' first we add the pk3 archive to our filing system. once we have done this
' we can open any of the files in the archive as if they were in the current
' working directory
IrrAddZipFile( "./media/map-20kdm2.pk3", IRR_IGNORE_CASE, IRR_IGNORE_PATHS )

' load the BSP map from the archive as a mesh object. any polygons in the mesh
' that do not have textures will be removed from the scene!
BSPMesh = IrrGetMesh( "20kdm2.bsp" )

' add the map to the scene as a node. when adding the mesh this call uses a 
' mechanism called an octtree that if very efficient at rendering large amounts
' of complext geometry most of which cant be seen, using this call for maps
' will greatly improve your framerates
BSPNode = IrrAddMeshToSceneAsOcttree( BSPMesh )

' add a first person perspective camera into the scene that is controlled with
' the mouse and the cursor keys. if however you capture events when starting
' irrlicht this will become a normal camera that can only be moved by code
'Camera = IrrAddFPSCamera
DIM keyMapArray(4) as SKeyMap
keyMapArray(1).Action = EKA_MOVE_FORWARD
keyMapArray(1).KeyCode = KEY_KEY_W
keyMapArray(2).Action = EKA_MOVE_BACKWARD
keyMapArray(2).KeyCode = KEY_KEY_S
keyMapArray(3).Action = EKA_STRAFE_LEFT
keyMapArray(3).KeyCode = KEY_KEY_A
keyMapArray(4).Action = EKA_STRAFE_RIGHT
keyMapArray(4).KeyCode = KEY_KEY_D

Camera = IrrAddFPSCamera ( _
    IRR_NO_OBJECT, _   ' parent, none
    150.0, _           ' rotate speed
    0.1, _             ' move speed
    -1, _              ' camera ID
    @keyMapArray(1), _ ' the address of the keyMap
    4, _               ' number of entries in the keymap
    0, _               ' no vertical movement
    0.0 )              ' jumpspeed

' when we add a camera we are returned a camera object however we can perform
' node operations on many different object types that are entities within the
' scene however first we need to convert the camera type into a node type
CameraNode = Camera

' reposition and rotate the camera to look at a nice part of the map
IrrSetNodePosition( CameraNode, 1750, 149, 1369 )
IrrSetNodeRotation( CameraNode, 4, -461.63, 0 )

' hide the mouse pointer
IrrHideMouse

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
Dim as Single frameTime = timer + 0.0167
WHILE IrrRunning
    ' is it time for another frame
    if timer > frameTime then
        ' calculate the time the next frame starts
        frameTime = timer + 0.0167

        ' begin the scene, erasing the canvas with sky-blue before rendering
        IrrBeginScene( 240, 255, 255 )
    
        ' draw the scene
        IrrDrawScene
    
        ' end drawing the scene and display it
        IrrEndScene
    end if
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
