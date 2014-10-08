'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 88: Billboard text over nodes
'' This example demonstrates automatically generated billboard text objects that
'' can be used to label nodes or locations in a scene.
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
DIM Billboard as irr_node
DIM Camera as irr_camera
DIM font as irr_font


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 400, 400, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 88: Billboard text over nodes" )

' load a mesh this acts as a blue print for the model
MD2Mesh = IrrGetMesh( "./media/zumlin.md2" )

' load texture resources for texturing the scene nodes
MeshTexture = IrrGetTexture( "./media/zumlin.pcx" )

' add the mesh to the scene as a new node, the node is an instance of the
' mesh object supplied here
SceneNode = IrrAddMeshToScene( MD2Mesh )

' apply a material to the node to give its surface color
IrrSetNodeMaterialTexture( SceneNode, MeshTexture, 0 )

' switch off lighting effects on this model, as there are no lights in this
' scene the model would otherwise render pule black
IrrSetNodeMaterialFlag( SceneNode, IRR_EMF_LIGHTING, IRR_OFF )

' play an animation sequence embeded in the mesh. MD2 models have a group of
' preset animations for various poses and actions. this animation sequence is
' the character standing idle
IrrPlayNodeMD2Animation( SceneNode, IRR_EMAT_STAND )

' Load a font to use on the billboard
font = IrrGetFont( "./media/fonthaettenschweiler.bmp" )

' add the text billboard to the scene, the font is supplied or you can pass
' IRR_NO_OBJECT and the system font will be used. The text is a wide character
' string followed by the width and height of the billboard and the X, Y, Z
'coordinates. A scenenode can be supplied that will become the billboards
' parent (often the node that its attached to) finally two colours are supplied
' for the top and the bottom of the billboard
Billboard = IrrAddBillboardTextSceneNode( _
        font, "Zumlin Model", _
        64.0, 12.0, _
        0.0, 40.0, 0.0, _
        SceneNode, _
        RGBA(255,255,0,0), _
        RGBA(255,0,0,255))

' add a first person perspective camera into the scene so we can move around
' the billboard and see how it reacts
Camera = IrrAddFPSCamera
IrrSetNodePosition( Camera, 0, 0, -75 )

' hide the mouse pointer
IrrHideMouse

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
