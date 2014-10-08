'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 107 : Render to texture with alpha
'' This example demonstrates rendering to a texture while using the alpha
'' channel to create shaped and animated HUD elements
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
DIM TextureCamera as irr_camera


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 512, 512, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_NO_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' set the window caption
IrrSetWindowCaption( "Example 107: Render to texture with alpha" )

' load a mesh this acts as a blue print for the model
MD2Mesh = IrrGetMesh( "./media/zumlin.md2" )

' load texture resources for texturing the scene nodes
MeshTexture = IrrGetTexture( "./media/zumlin.pcx" )

' add the mesh to the scene as a new node, the node is an instance of the
' mesh object supplied here
SceneNode = IrrAddMeshToScene( MD2Mesh )

' make sure that vertex color does not affect any lighting
IrrSetNodeColorByVertex( SceneNode, ECM_NONE )

' set up some lighting colors
IrrSetNodeAmbientColor( SceneNode, RGBA( 255,0,0,255 ))
IrrSetNodeDiffuseColor( SceneNode, RGBA( 64,255,96,255 ))
IrrSetNodeSpecularColor( SceneNode, RGBA( 255,255,0,255 ))
IrrSetNodeEmissiveColor( SceneNode, RGBA( 0,0,0,255 ))

' apply a material to the node to give its surface color
IrrSetNodeMaterialTexture( SceneNode, MeshTexture, 0 )

' play an animation sequence embeded in the mesh. MD2 models have a group of
' preset animations for various poses and actions. this animation sequence is
' the character standing idle
IrrPlayNodeMD2Animation( SceneNode, IRR_EMAT_STAND )

' add a camera into the scene, the first co-ordinates represents the 3D
' location of our view point into the scene the second co-ordinates specify the
' target point that the camera is looking at
TextureCamera = IrrAddCamera( 50,0,0, 0,0,0 )
OurCamera = IrrAddCamera( 50,0,0, 0,0,0 )

' add a  light source
IrrAddLight( IRR_NO_PARENT, 100,100,-100, 0.9,0.9,0.9, 600.0 )

' add some ambient lighting
IrrSetAmbientLight( 0.1, 0.1, 0.1 )

' create a surface for rendering the image to
Dim as irr_texture Texture = IrrCreateRenderTargetTexture( 128, 128 )

' circle the camera around the object
IrrAddFlyCircleAnimator( OurCamera, 0.0, 0.0, 0.0, 40.0, 0.001 )

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
Dim as Single timeElapsed, currentTime, frameTime = timer
DIm as Single X, Y
Dim as string metrics
WHILE IrrRunning
    ' is it time for another frame
    currentTime = timer
    timeElapsed = currentTime - frameTime
    if timeElapsed > 0.0167 then
        ' record the start time of this frame
        frameTime = currentTime

        ' render to a texture
        IrrSetRenderTarget( Texture, RGBA( 0,0,0,0), IRR_ON, IRR_ON )

        ' switch to the texture camera
        IrrSetActiveCamera( TextureCamera )

        ' draw the scene to the texture
        IrrDrawScene

        ' set the render target back to the screen
        IrrSetRenderTarget( 0 )

        ' switch to the display camera
        IrrSetActiveCamera( OurCamera )

        ' begin the scene, erasing the canvas with sky-blue before rendering
        IrrBeginScene ( 128, 128, 192 )

        ' draw the scene
        IrrDrawScene

        ' draw a the texture with the alpha channel to the screen
        IrrDraw2DImageElement( Texture,_
                               4, 4,_
                               0,0,128,128, IRR_USE_ALPHA )

        ' end drawing the scene and render it
        IrrEndScene
    End IF
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
