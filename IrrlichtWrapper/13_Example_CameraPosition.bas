'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 13: Camera Position
'' This example creates a map for you to move around and displays the current
'' position of the camera and its rotation on the screen
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
DIM BitmapFont as irr_font
DIM X as Single
DIM Y as Single
DIM Z as Single
DIM metrics as wstring * 256


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 800, 400, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_NO_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 13: Camera Position and Rotation" )

' create a frist person perspective camera that can be controlled with mouse
' and cursor keys
Camera = IrrAddFPSCamera

' when we add a camera we are returned a camera object however we can perform
' node operations on many different object types that are entities within the
' scene however first we need to convert the camera type into a node type
CameraNode = Camera

' reposition and rotate the camera to look at a nice part of the map
IrrSetNodePosition( CameraNode, 1750, 149, 1369 )
IrrSetNodeRotation( CameraNode, 4, -461.63, 0 )

' load a Quake 3 BSP Map from a zip archive
IrrAddZipFile( "./media/map-20kdm2.pk3", IRR_IGNORE_CASE, IRR_IGNORE_PATHS )
BSPMesh = IrrGetMesh( "20kdm2.bsp" )
BSPNode = IrrAddMeshToSceneAsOcttree( BSPMesh )

' load the bitmap font as a texture
BitmapFont = IrrGetFont ( "./media/bitmapfont.bmp" )

' we also hide the mouse pointer to see the view better
IrrHideMouse

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
WHILE IrrRunning
    ' begin the scene, erasing the canvas with sky-blue before rendering
    IrrBeginScene( 240, 255, 255 )

    ' draw the scene
    IrrDrawScene

    ' get the position of the camera into the three supplied variables
    IrrGetNodePosition( CameraNode, X, Y, Z )

    ' create a wide string with a list of the positions in
    metrics = "POSITION "+ Str(X) + " " + Str(Y) + " " + Str(Z)
    
    ' draw this position information to the screen
    Irr2DFontDraw ( BitmapFont, metrics, 4, 4, 250, 24 )

    ' get the rotation of the camera into the three supplied variables
    IrrGetNodeRotation( CameraNode, X, Y, Z )
    
    ' create a wide string with a list of the rotations in
    metrics = "ROTATION "+ Str(X) + " " + Str(Y) + " " + Str(Z)
    
    ' draw this position information to the screen
    Irr2DFontDraw ( BitmapFont, metrics, 4, 32, 250, 52 )

    ' end drawing the scene and display it
    IrrEndScene
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
