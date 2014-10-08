'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 50 : Fading Nodes Out
'' This example shows how a node can be faded out of a scene through the use of
'' material properties
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
DIM OurCamera as irr_camera
DIM Material as irr_material
DIM Light as irr_node
DIM SphereNode as irr_node


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 800, 600, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' set the window caption
IrrSetWindowCaption( "Example 50: Fading Nodes Out" )

' add credits for the model as a static text GUI object on the display
IrrAddStaticText( "Zumlin model by Rowan 'Sumaleth' Crawford", 4,0,200,16, IRR_GUI_NO_BORDER, IRR_GUI_NO_WRAP )

' load a mesh this acts as a blue print for the model
MD2Mesh = IrrGetMesh( "./media/zumlin.md2" )

' load texture resources for texturing the scene nodes
MeshTexture = IrrGetTexture( "./media/zumlin.pcx" )


' create a simple sphere object in the background so that the transparency of
' the nodes can be seen
SphereNode = IrrAddSphereSceneNode ( 30.0, 8 )
IrrSetNodePosition( SphereNode, -50,0,0 )
Material = IrrGetMaterial( SphereNode, 0 )
IrrMaterialSetAmbientColor ( Material, 0,0,0,0 )
IrrMaterialSetDiffuseColor ( Material, 0,255,255,255 )

' create a simple sphere object in the background so that the transparency of
' the nodes can be seen
SphereNode = IrrAddSphereSceneNode ( 30.0, 8 )
IrrSetNodePosition( SphereNode, -50,0,-90 )
Material = IrrGetMaterial( SphereNode, 0 )
IrrMaterialSetAmbientColor ( Material, 0,0,0,0 )
IrrMaterialSetDiffuseColor ( Material, 0,255,255,255 )

' add a copy of the model to the scene to use as a reference, paint it and
' move it into position
SceneNode = IrrAddMeshToScene( MD2Mesh )
IrrSetNodeMaterialTexture( SceneNode, MeshTexture, 0 )
IrrSetNodePosition( SceneNode, 0,0, -25 )

' add a second copy of the model to the scene this is the model that will be
' faded out
SceneNode = IrrAddMeshToScene( MD2Mesh )
IrrSetNodeMaterialTexture( SceneNode, MeshTexture, 0 )

' we switch lighting on for this model
'IrrSetNodeMaterialFlag( SceneNode, IRR_EMF_LIGHTING, IRR_ON )

' the material type is set to Transparent Vertex alpha, so that the alpha value
' of the colour of the verticies in the mesh set how transparent the object is
IrrSetNodeMaterialType( SceneNode, IRR_EMT_TRANSPARENT_VERTEX_ALPHA )

' we get the material used to paint the node that is to fade out
Material = IrrGetMaterial( SceneNode, 0 )

' set the surface property effected by the vertex color.
IrrMaterialVertexColorAffects( Material, ECM_NONE )

' the amount of fading is made from a combination of the values assigned to the
' node for ambient and diffuse lighting more examples are shown below and
'commented out
' half faded
'IrrMaterialSetAmbientColor ( Material, 0,255,255,255 )
'IrrMaterialSetDiffuseColor ( Material, 0,255,255,255 )

' completely opaque
'IrrMaterialSetAmbientColor ( Material, 255,255,255,255 )
'IrrMaterialSetDiffuseColor ( Material, 255,255,255,255 )

' completely transparent
'IrrMaterialSetAmbientColor ( Material, 0,0,0,0 )
'IrrMaterialSetDiffuseColor ( Material, 0,0,0,0 )

' almost completely transparent
IrrMaterialSetAmbientColor ( Material, 0,32,32,32 )
IrrMaterialSetDiffuseColor ( Material, 0,32,32,32 )

' play an animation sequence embeded in the mesh. MD2 models have a group of
' preset animations for various poses and actions. this animation sequence is
' the character standing idle
IrrPlayNodeMD2Animation( SceneNode, IRR_EMAT_STAND )

' add a camera into the scene, the first co-ordinates represents the 3D
' location of our view point into the scene the second co-ordinates specify the
' target point that the camera is looking at
OurCamera = IrrAddCamera( 50,0,0, 0,0,0 )

' add a simple point light
Light = IrrAddLight( IRR_NO_PARENT, -100,100,100, 1.0,1.0,1.0, 600.0 )

' set the ambient light level across the entire scene
IrrSetAmbientLight( 1,1,1 )

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
WHILE IrrRunning
    ' begin the scene, erasing the canvas with sky-blue before rendering
    IrrBeginScene( 0, 0, 0 )

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
