'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 89 : Orthagonal Camera
'' This example creates a split screen display where one of the cameras displays
'' a persepective view and the other displays an orthagonal view
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM MD2Mesh as irr_mesh
DIM MeshTexture as irr_texture
DIM SceneNode as irr_node
DIM FirstCamera as irr_camera
DIM SecondCamera as irr_camera
DIM camPos as irr_vector


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 400, 200, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' set the window caption
IrrSetWindowCaption( "Example 89: Orthagonal Camera" )

' add credits for the model as a static text GUI object on the display
IrrAddStaticText( "Zumlin model by Rowan 'Sumaleth' Crawford", 4,0,200,16, IRR_GUI_NO_BORDER, IRR_GUI_NO_WRAP )

' load a mesh this acts as a blue print for the model
MD2Mesh = IrrGetMesh( "./media/zumlin.md2" )

' load texture resources for texturing the scene nodes
MeshTexture = IrrGetTexture( "./media/zumlin.pcx" )

' add the mesh to the scene as a new node, the node is an instance of the
' mesh object supplied here
SceneNode = IrrAddMeshToScene( MD2Mesh )
IrrSetNodeScale( SceneNode, 20,20,20 )

' apply a material to the node to give its surface color
IrrSetNodeMaterialTexture( SceneNode, MeshTexture, 0 )

' switch off lighting effects on this model, as there are no lights in this
' scene the model would otherwise render pule black
IrrSetNodeMaterialFlag( SceneNode, IRR_EMF_LIGHTING, IRR_OFF )

' play an animation sequence embeded in the mesh. MD2 models have a group of
' preset animations for various poses and actions. this animation sequence is
' the character standing idle
IrrPlayNodeMD2Animation( SceneNode, IRR_EMAT_STAND )

' add a camera into the scene, the first co-ordinates represents the 3D
' location of our view point into the scene the second co-ordinates specify the
' target point that the camera is looking at
FirstCamera = IrrAddFPSCamera
IrrSetNodePosition( FirstCamera, 500,0,0 )
IrrSetCameraTarget( FirstCamera, 0,0,0 )
SecondCamera = IrrAddCamera( -500,0,0, 0,0,0 )

' as the window we are opening is twice as wide as it is high all camera objects
' are given a default aspect ratio of 0.5, however we want to draw two windows
' side by side 200x200 so we need to set the aspect ratios of the camera to 1.0
IrrSetCameraAspectRatio( FirstCamera, 1.0 )
IrrSetCameraAspectRatio( SecondCamera, 1.0 )

' hide the mouse pointer
IrrHideMouse

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
WHILE IrrRunning
    ' begin the scene, erasing the canvas with sky-blue before rendering
    IrrBeginScene( 240, 255, 255 )

    ' draw the scene on the left
    IrrSetActiveCamera( FirstCamera )
    IrrSetViewPort( 0,0,200,200 )
    IrrDrawScene

    ' Make the second camera track the first camera by copying the first camera
    ' position and target into the second camera
    IrrGetCameraTarget( FirstCamera, camPos.X, camPos.Y, camPos.Z )
    IrrSetCameraTarget( SecondCamera, camPos.X, camPos.Y, camPos.Z )
    IrrGetNodePosition( FirstCamera, camPos.X, camPos.Y, camPos.Z )
    IrrSetNodePosition( SecondCamera, camPos.X, camPos.Y, camPos.Z )

    ' Set the orthagonal settings of the second camera, this switches
    ' perspective display off on this camera. the X, Y and Z values are
    ' the distance to the target, but as Zumlin is at 0,0,0 this distance is
    ' simply the cameras position. if we were looking at a target that was not
    ' at 0,0,0 we would supply the parameters as camPos.X - targetPos.X etc...
    ' this distance generates a zoom effect making the model bigger and smaller
    ' in the display.
    IrrSetCameraOrthagonal( SecondCamera, camPos.X, camPos.Y, camPos.Z )

    ' draw the scene on the left
    IrrSetActiveCamera( SecondCamera )
    IrrSetViewPort( 200,0,400,200 )
    IrrDrawScene

    ' set the viewport back to the whole screen
    IrrSetViewPort( 0,0, 400,200 )
    
    ' switch back to the first Camera so that key events are send to it
    IrrSetActiveCamera( FirstCamera )

    ' draw the GUI
    IrrDrawGUI

    ' end drawing the scene and render it
    IrrEndScene
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
