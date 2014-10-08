'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 21 : Carrying Objects
'' This example demonstrates how you can attach a child model to an animated
'' Direct X model containing joints
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM DirectXMesh as irr_mesh
DIM BoxTexture as irr_texture
DIM SceneNode as irr_node
DIM OurCamera as irr_camera
DIM JointNode as irr_node
DIM TestNode as irr_node


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 400, 400, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 21: Carrying Objects" )

' load a mesh, when loading a .x file the textures will be automatically loaded
' and applied to the model
DirectXMesh = IrrGetMesh( "./media/dwarf.x" )

' add the mesh to the scene
SceneNode = IrrAddMeshToScene( DirectXMesh )

' switch off lighting effects on this model
IrrSetNodeMaterialFlag( SceneNode, IRR_EMF_LIGHTING, IRR_OFF )

' set the speed of playback for the animated Direct X model
IrrSetNodeAnimationSpeed( SceneNode, 400 )

' add a camera into the scene pointing at the model
OurCamera = IrrAddCamera( 75,40,-50, 0,40,0 )

' create a test node to represent the object that is being carried
TestNode = IrrAddTestSceneNode

' load texture resources for texturing the box
BoxTexture = IrrGetTexture( "./media/texture.jpg" )

' assign a texture to the carried object
IrrSetNodeMaterialTexture( TestNode, BoxTexture, 0 )

' switch off lighting effects on the test box
IrrSetNodeMaterialFlag( TestNode, IRR_EMF_LIGHTING, IRR_OFF )

' offset the position of the node so that it appears to be attached to the
' characters hand
IrrSetNodePosition( TestNode, 20,-15,-10 )

' get an invisible node that is attached to the specified joint on the animated
' node
JointNode = IrrGetDirectXJointNode ( SceneNode, "Joint16" )

' attach the carried test node to this invisible joint node from now on the
' carried object will move along with the joint without any more intervention
' from us
IrrAddChildToParent ( TestNode, JointNode )


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
