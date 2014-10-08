'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 45: Managing Scene Resources
'' This example loads and creates a series of models and then deletes them all
'' before creating another scene. These methods can be used when changing the
'' objects in a scene perhaps between loading levels in a game or chapters in
'' animation, while freeing memory for new resources
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM MD2Mesh as irr_mesh
DIM MeshTexture as irr_texture
DIM BoxTexture as irr_texture
DIM SceneNode as irr_node
DIM Box1Node as irr_node
DIM Box2Node as irr_node
DIM OurCamera as irr_camera
DIM Light as irr_node
DIM frame as integer = 0

'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 400, 200, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' set the window caption
IrrSetWindowCaption( "Example 45: Managing Scene Resources" )

' add credits for the model as a static text GUI object on the display
IrrAddStaticText( "Zumlin model by Rowan 'Sumaleth' Crawford", 4,0,200,16, IRR_GUI_NO_BORDER, IRR_GUI_NO_WRAP )

' load a mesh this acts as a blue print for the model
MD2Mesh = IrrGetMesh( "./media/zumlin.md2" )

' load texture resources for texturing the scene nodes
MeshTexture = IrrGetTexture( "./media/zumlin.pcx" )
BoxTexture = IrrGetTexture( "./media/water.png" )

' add the mesh to the scene as a new node, the node is an instance of the
' mesh object supplied here
SceneNode = IrrAddMeshToScene( MD2Mesh )

' add two simple cube nodes to the scene
Box1Node = IrrAddCubeSceneNode( 20.0 )
Box2Node = IrrAddCubeSceneNode( 20.0 )
IrrSetNodePosition( Box1Node, 0, -10, -30 )
IrrSetNodePosition( Box2Node, 0, -10, 30 )

' apply a material to the nodes to give them surface color
IrrSetNodeMaterialTexture( SceneNode, MeshTexture, 0 )
IrrSetNodeMaterialTexture( Box1Node, BoxTexture, 0 )
IrrSetNodeMaterialTexture( Box2Node, BoxTexture, 0 )

' play an animation sequence embeded in the mesh. MD2 models have a group of
' preset animations for various poses and actions. this animation sequence is
' the character standing idle
IrrPlayNodeMD2Animation( SceneNode, IRR_EMAT_STAND )

' add a simple point light
Light = IrrAddLight( IRR_NO_PARENT, -100,100,100, 1.0,1.0,1.0, 600.0 )

' apply a low ambient lighting level to the light source
IrrSetLightAmbientColor ( Light, 0.25,0.25,0.25 )

' add a camera into the scene, the first co-ordinates represents the 3D
' location of our view point into the scene the second co-ordinates specify the
' target point that the camera is looking at
OurCamera = IrrAddCamera( 50,5,25, 0,0,0 )


' -----------------------------------------------------------------------------
' Display the scene for 500 frames
WHILE IrrRunning And frame < 500
    ' begin the scene, erasing the canvas with sky-blue before rendering
    IrrBeginScene( 240, 255, 255 )

    ' draw the scene
    IrrDrawScene
    
    ' draw the GUI
    IrrDrawGUI

    ' end drawing the scene and render it
    IrrEndScene
    
    frame += 1
WEND

'clear the scene removing all nodes and then all meshes
IrrRemoveAllNodes
IrrClearUnusedMeshes

' add a simple spherical node to the scene
Box1Node = IrrAddSphereSceneNode( 20.0, 16 )

' texture the node
IrrSetNodeMaterialTexture( Box1Node, BoxTexture, 0 )

' add a simple point light
Light = IrrAddLight( IRR_NO_PARENT, 0,100,100, 1.0,1.0,1.0, 600.0 )

' apply a low ambient lighting level to the light source
IrrSetLightAmbientColor ( Light, 0.25,0.25,0.25 )

' add a camera into the scene, the first co-ordinates represents the 3D
' location of our view point into the scene the second co-ordinates specify the
' target point that the camera is looking at
OurCamera = IrrAddCamera( 50,5,25, 0,0,0 )

' -----------------------------------------------------------------------------
' Display the scene
WHILE IrrRunning
    ' begin the scene, erasing the canvas with sky-blue before rendering
    IrrBeginScene( 240, 255, 255 )

    ' draw the scene
    IrrDrawScene
    
    ' draw the GUI
    IrrDrawGUI

    ' end drawing the scene and render it
    IrrEndScene
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
