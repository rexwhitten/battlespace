'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 57 : Reading and writing the name of objects
'' This example demonstrates reading and writing the names of objects that can
'' be useful in identifying or storing information inside an object
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


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 400, 200, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' set the window caption
IrrSetWindowCaption( "Example 57: Reading and Writing the Name of Objects" )

' add credits for the model as a static text GUI object on the display
IrrAddStaticText( "Zumlin model by Rowan 'Sumaleth' Crawford", 4,0,200,16, IRR_GUI_NO_BORDER, IRR_GUI_NO_WRAP )

' load a mesh this acts as a blue print for the model
MD2Mesh = IrrGetMesh( "./media/zumlin.md2" )

' load texture resources for texturing the scene nodes
MeshTexture = IrrGetTexture( "./media/zumlin.pcx" )

' add the mesh to the scene as a new node, the node is an instance of the
' mesh object supplied here
SceneNode = IrrAddMeshToScene( MD2Mesh )

' set the node name
IrrSetNodeName( SceneNode, "Zumlin" )

' read the name back
DIM NodeName as Const zstring ptr
NodeName = IrrGetNodeName( SceneNode )
print "The name read back in is ";*NodeName

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
OurCamera = IrrAddCamera( 50,0,0, 0,0,0 )


' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
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
