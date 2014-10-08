'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 41 : Blending animation
'' This example loads an animated model controlled by bones and then switches
'' between two frames of the animation while blending the transition so that
'' instead of snapping instantly to the new position the bones move smoothly
'' over a set period of time
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM MD2Mesh as irr_mesh
DIM MeshTexture as irr_texture
DIM TransitionNode as irr_node
DIM NormalNode as irr_node
DIM OurCamera as irr_camera
DIM frame as integer = 0


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 640, 400, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' set the window caption
IrrSetWindowCaption( "Example 41: Blending animation" )

' add credits for the model as a static text GUI object on the display
IrrAddStaticText( "Dwarf model by Yagodib, many thanks", 4,0,200,16, IRR_GUI_NO_BORDER, IRR_GUI_NO_WRAP )

' load a mesh this acts as a blue print for the model
MD2Mesh = IrrGetMesh( "./media/dwarf.x" )

' add two copies of the model one that will be blended and one that will not
TransitionNode = IrrAddMeshToScene( MD2Mesh )
NormalNode = IrrAddMeshToScene( MD2Mesh )

' reposition the nodes
IrrSetNodePosition( TransitionNode, -30,0,0 )
IrrSetNodePosition( NormalNode, 30,0,0 )

' switch off lighting effects on this model, as there are no lights in this
' scene the model would otherwise render pule black
IrrSetNodeMaterialFlag( TransitionNode, IRR_EMF_LIGHTING, IRR_OFF )
IrrSetNodeMaterialFlag( NormalNode, IRR_EMF_LIGHTING, IRR_OFF )

' set the animation range and speed on the two nodes
IrrSetNodeAnimationRange ( TransitionNode, 0, 1600 )
IrrSetNodeAnimationSpeed ( TransitionNode, 250 )
IrrSetNodeAnimationRange ( NormalNode, 0, 1600 )
IrrSetNodeAnimationSpeed ( NormalNode, 250 )

' set the time in seconds across which two animation frames are blended
IrrSetTransitionTime( TransitionNode, 0.5 )

' add a camera into the scene, the first co-ordinates represents the 3D
' location of our view point into the scene the second co-ordinates specify the
' target point that the camera is looking at
OurCamera = IrrAddCamera( 0,35,-75, 0,35,0 )

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
WHILE IrrRunning
    ' begin the scene, erasing the canvas with sky-blue before rendering
    IrrBeginScene( 240, 255, 255 )

    ' when the animation reaches the 1000th frame
    if IrrGetNodeAnimationFrame( TransitionNode ) = 1000 then
        ' set the current frame number being played in the animation
        IrrSetNodeAnimationFrame( TransitionNode, 0 )
        IrrSetNodeAnimationFrame( NormalNode, 0 )
    End if

    'Animates the mesh based on the position of the joints, this should be used at
    'the end of any manual joint operations including blending and joints animated
    'using IRR_JOINT_MODE_CONTROL and IrrSetNodeRotation on a bone node
    IrrAnimateJoints( TransitionNode )

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
