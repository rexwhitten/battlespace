'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 33 : Rendering to a texture
'' This example renders a 3D model and a cube to the scene and uses the 3D model
'' to texture the cube.
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM MD2Mesh as irr_mesh
DIM MeshTexture as irr_texture
DIM RenderTexture as irr_texture
DIM TextureA as irr_texture
DIM TextureB as irr_texture
DIM SceneNode as irr_node
DIM CubeNode as irr_node
DIM StaticCamera as irr_camera
DIM FPSCamera as irr_camera
DIM pixels as uinteger ptr

'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 600, 400, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' set the window caption
IrrSetWindowCaption( "Example 33: Rendering to a texture" )

' add credits for the model as a static text GUI object on the display
IrrAddStaticText( "Zumlin model by Rowan 'Sumaleth' Crawford", 4,0,200,16, IRR_GUI_NO_BORDER, IRR_GUI_NO_WRAP )

' load a mesh this acts as a blue print for the model
MD2Mesh = IrrGetMesh( "./media/zumlin.md2" )

' load texture resources for texturing the scene nodes
MeshTexture = IrrGetTexture( "./media/zumlin.pcx" )

' create a texture surface that is suitable for rendering a display onto
' the renderview must be the same size or larger than this texture
RenderTexture = IrrCreateRenderTargetTexture ( 128, 128 )
TextureA = IrrGetTexture( "./media/Diagonal.bmp" )
TextureB = IrrCreateTexture( "merged", 128, 128, ECF_A8R8G8B8 )

' add the mesh to the scene as a new node, the node is an instance of the
' mesh object supplied here
SceneNode = IrrAddMeshToScene( MD2Mesh )

' add a simple cube to the scene that will be textured with the rendered surface
CubeNode = IrrAddCubeSceneNode( 30.0 )
IrrSetNodePosition( CubeNode, 0, 0, 100 )

' apply a material to the nodes to give its surface color
IrrSetNodeMaterialTexture( SceneNode, MeshTexture, 0 )
IrrSetNodeMaterialTexture( CubeNode, RenderTexture, 0 )

' switch off lighting effects on this model, as there are no lights in this
' scene the model would otherwise render pule black
IrrSetNodeMaterialFlag( SceneNode, IRR_EMF_LIGHTING, IRR_OFF )
IrrSetNodeMaterialFlag( CubeNode, IRR_EMF_LIGHTING, IRR_OFF )

' play an animation sequence embeded in the mesh. MD2 models have a group of
' preset animations for various poses and actions. this animation sequence is
' the character standing idle
IrrPlayNodeMD2Animation( SceneNode, IRR_EMAT_STAND )

' add a static camera that is used to render the scene to a texture
StaticCamera = IrrAddCamera( 50,0,0, 0,0,0 )

' add a first person camera that is used for the display view
FPSCamera = IrrAddFPSCamera( IRR_NO_OBJECT, 100.0f, 0.1f )
IrrSetNodePosition( FPSCamera, 40, 0, 110 )
IrrSetCameraTarget( FPSCamera, 0,0,80 )
'IrrSetNodeRotation( FPSCamera, 160, -400.0, 0 )

' we also hide the mouse pointer to see the view better
IrrHideMouse

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
WHILE IrrRunning
    ' switch to the static camera and render the scene to the texture
    IrrSetActiveCamera ( StaticCamera )
    IrrDrawSceneToTexture ( RenderTexture )

'    pixels = IrrLockTexture( RenderTexture )
'    IrrUnlockTexture( RenderTexture )


    ' begin the scene, erasing the canvas with sky-blue before rendering
    IrrBeginScene( 240, 255, 255 )

    ' switch to the FPS camera draw the scene
    IrrSetActiveCamera ( FPSCamera )
    IrrDrawScene
    
    ' draw the GUI
    IrrDrawGUI

    ' end drawing the scene and render it
    IrrEndScene
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
