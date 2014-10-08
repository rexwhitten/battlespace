'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 16 : 2D Text at a 3D location
'' This example draws 2D text at a location on the screen that is directly over
'' specific 3D point in the scene. That point is set to hover over a models
'' head making it appear like the model has a text label
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
DIM BitmapFont as irr_font
DIM x as integer
DIM y as integer
DIM vect as IRR_VECTOR


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 400, 200, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 16: 2D Text at a 3D Location" )

' load the bitmap font as a texture
BitmapFont = IrrGetFont ( "./media/bitmapfont.bmp" )

' load a mesh
MD2Mesh = IrrGetMesh( "./media/zumlin.md2" )

' load texture resources for texturing models
MeshTexture = IrrGetTexture( "./media/zumlin.pcx" )

' add the mesh to the scene a couple of times
SceneNode = IrrAddMeshToScene( MD2Mesh )

' the node is still at the origin move the vector to just over the nodes
' head
vect.y = 35

' apply a material to the object
IrrSetNodeMaterialTexture( SceneNode, MeshTexture, 0 )

' switch off lighting effects on this model
IrrSetNodeMaterialFlag( SceneNode, IRR_EMF_LIGHTING, IRR_OFF )

' play specific animation sequences
IrrPlayNodeMD2Animation( SceneNode, IRR_EMAT_STAND )

' add a camera into the scene and move it into position
OurCamera = IrrAddFPSCamera( IRR_NO_OBJECT, 100.0f, 0.1f )
IrrSetNodePosition( OurCamera, 80,0,0 )
IrrSetCameraTarget( OurCamera, 0,0,0 )

' hide the mouse from the screen
IrrHideMouse

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
WHILE IrrRunning
    ' begin the scene, erasing the canvas with grey before rendering
    IrrBeginScene( 128,128,128 )

    ' draw the scene
    IrrDrawScene

    ' using the 3D coordinate get the X and Y position of this coordinate as it
    ' appears on the screen
    IrrGetScreenCoordinatesFrom3DPosition( x, y, vect )

    ' draw the name of the model over the head of the model
    Irr2DFontDraw ( BitmapFont, "ZUMLIN", x-15, y-8, x+35, y )

    ' end drawing the scene and render it
    IrrEndScene
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
