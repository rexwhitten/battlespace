'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 08: Shadows and Lights
'' This example loads a map and a model into the scene and then applies realtime
'' shadows to the model cast from lights in the scene that can be seen on the
'' surface of other objects.
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
DIM BSPMesh as irr_mesh
DIM BSPNode as irr_node
DIM OurCamera as irr_camera
DIM Light as irr_node

'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 400, 200, IRR_BITS_PER_PIXEL_32, IRR_WINDOWED, _
          IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 08: Shadows and Lights" )

' load the MD2 model from example 4 into the scene
MD2Mesh = IrrGetMesh( "./media/zumlin.md2" )
MeshTexture = IrrGetTexture( "./media/zumlin.pcx" )
SceneNode = IrrAddMeshToScene( MD2Mesh )
IrrSetNodeMaterialTexture( SceneNode, MeshTexture, 0 )
IrrSetNodeMaterialFlag( SceneNode, IRR_EMF_LIGHTING, IRR_OFF )
IrrPlayNodeMD2Animation( SceneNode, IRR_EMAT_STAND )

' load the bsp map from example 5 into the scene
IrrAddZipFile( "./media/map-20kdm2.pk3", IRR_IGNORE_CASE, IRR_IGNORE_PATHS )
BSPMesh = IrrGetMesh( "20kdm2.bsp" )
BSPNode = IrrAddMeshToSceneAsOcttree( BSPMesh )

' move the map into position around the model
IrrSetNodePosition( BSPNode, -1370,-88,-1400)

' add a camera into the scene
OurCamera = IrrAddCamera( 50,0,0, 0,0,0 )

' switching shadows on is very simple just call the command for the scene node
' that you want to cast shadows
IrrAddNodeShadow( SceneNode )

' the shadow colour is a global property for the whole scene (however you can
' change it as you move into different areas of your scene) the first
' parameter is the alpha blend for the shadow this shadow is half washed out
' which gives the appearence of ambient light in the room illuminating the
' shadowed surface, the second set of numbers defines the color of the shadow
' which in this case is black
IrrSetShadowColor( 128, 0, 0, 0 )

' finally we need to add a light into the scene to cast some shadows. when using
' shadows you probably only want one or two lights as they can be time consuming
' the first set of parameters for this light specify the position its created
' at, the second set of parameters define the color - rather than 255 integer
' levels the intensity of red/green/blue is defined from 0 to 1 and finally
' you define the radius of effect of the light 
Light = IrrAddLight( IRR_NO_PARENT, 100,100,-100, 0.9,0.3,0.3, 600.0 )

' the second light is an ambient light and illuminates all surfaces in the scene
' uniformly. this is usually a low value that is used to change the lighting
' level across the entire scene
IrrSetAmbientLight( 0.1, 0.1, 0.1 )


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
