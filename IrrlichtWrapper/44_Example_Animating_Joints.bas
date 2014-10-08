'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 44 : Manually Animating Bones
'' This example loads an animated model containing bones and then adjusts one of
'' those bones through programming
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM MD2Mesh as irr_mesh
DIM MeshTexture as irr_texture
DIM AnimatedNode as irr_node
DIM JointNode as irr_node
DIM OurCamera as irr_camera
DIM rotation as single = 0.0


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 400, 200, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' set the window caption
IrrSetWindowCaption( "Example 44: Manually Animating Bones" )

' add credits for the model as a static text GUI object on the display
IrrAddStaticText( "Dwarf model by Yagodib, many thanks", 4,0,200,16, IRR_GUI_NO_BORDER, IRR_GUI_NO_WRAP )

' load a mesh this acts as a blue print for the model
MD2Mesh = IrrGetMesh( "./media/dwarf.x" )

' add the mesh to the scene as a new node, the node is an instance of the
' mesh object supplied here
AnimatedNode = IrrAddMeshToScene( MD2Mesh )

' switch off lighting effects on this model, as there are no lights in this
' scene the model would otherwise render pule black
IrrSetNodeMaterialFlag( AnimatedNode, IRR_EMF_LIGHTING, IRR_OFF )

' ensure that the bone can be controlled programmatically
IrrSetJointMode( AnimatedNode, IRR_JOINT_MODE_CONTROL )

' get the bone node
JointNode = IrrGetJointNode( AnimatedNode, "Joint4" )

if JointNode = IRR_NO_OBJECT then
    ? "Unable to get joint node"
    sleep
end if

' add a camera into the scene, the first co-ordinates represents the 3D
' location of our view point into the scene the second co-ordinates specify the
' target point that the camera is looking at
OurCamera = IrrAddCamera( 75,30,0, 0,30,0 )

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
WHILE IrrRunning
    ' begin the scene, erasing the canvas with sky-blue before rendering
    IrrBeginScene( 240, 255, 255 )

    'Animates the mesh based on the position of the joints, this should be used at
    'the end of any manual joint operations including blending and joints animated
    'using IRR_JOINT_MODE_CONTROL and IrrSetNodeRotation on a bone node
    IrrAnimateJoints( AnimatedNode )

    ' rotate the node
    IrrSetNodeRotation( JointNode, rotation, 0.0, 0.0 )
    rotation += 0.1


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
