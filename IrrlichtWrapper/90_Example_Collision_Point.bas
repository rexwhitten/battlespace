'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 90 : Getting the point of collision
'' This example gets the acurate point of collision between the triangles of a
'' node and a ray we cast out into the scene through the center of the camera
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM MD2Mesh as irr_mesh
DIM MeshTexture as irr_texture
DIM TestTexture as irr_texture
DIM SceneNode as irr_node
DIM TestNode as irr_node
DIM OurCamera as irr_camera
DIM CollisionGroup as irr_selector
DIM StartVector as IRR_VECTOR
DIM EndVector as IRR_VECTOR
DIM CollideAt as IRR_VECTOR


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 400, 400, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 90: Getting the point of collision" )

' load a mesh
MD2Mesh = IrrGetMesh( "./media/zumlin.md2" )

' load texture resources for texturing models
MeshTexture = IrrGetTexture( "./media/zumlin.pcx" )
TestTexture = IrrGetTexture( "./media/texture.jpg" )

' add the mesh to the scene
SceneNode = IrrAddMeshToScene( MD2Mesh )

' add a test node to the scene, we are going to use this test node as the
' marker for the point that is detected by the collision
TestNode = IrrAddTestSceneNode
' rescale the node so that it is an unobtrusive size
IrrSetNodeScale( TestNode, 0.2, 0.2, 0.2 )

' apply materials to the objects
IrrSetNodeMaterialTexture( SceneNode, MeshTexture, 0 )
IrrSetNodeMaterialTexture( TestNode, TestTexture, 0 )

' switch off lighting effects on the model
IrrSetNodeMaterialFlag( SceneNode, IRR_EMF_LIGHTING, IRR_OFF )

' stop the animation playing
IrrSetNodeAnimationRange( SceneNode, 0,0)

' add a first person camera into the scene and point it at the model
OurCamera = IrrAddFPSCamera
IrrSetNodePosition( OurCamera, 50,0,0 )
IrrSetCameraTarget( OurCamera, 0,0,0 )

' create a simple collision group from the triangles containing within the
' bounding box of the model
CollisionGroup = IrrGetCollisionGroupFromMesh( MD2Mesh, SceneNode )

' hide the mouse from the display so we can see things better
IrrHideMouse

DIM as single xpos, ypos, zpos, xnorm, ynorm, znorm
DIM as irr_node nodeHit
' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
WHILE IrrRunning
    ' begin the scene, erasing the canvas with sky-blue before rendering
    IrrBeginScene( 240, 255, 255 )

    IrrGetNodePosition( OurCamera, StartVector.x, StartVector.y, StartVector.z )
    IrrGetCameraTarget( OurCamera, EndVector.x, EndVector.y, EndVector.z )
    
    ' extend the line through the target point for 5000 times its origonal length
    EndVector.x += ((EndVector.x - StartVector.x) * 5000)
    EndVector.y += ((EndVector.y - StartVector.y) * 5000)
    EndVector.z += ((EndVector.z - StartVector.z) * 5000)

    ' reset the collision point so that if the 
    CollideAt.x = 0 : CollideAt.y = 0 : CollideAt.z = 0

    ' using the line we have defined and the collision group created from the
    ' object get the point at which the two collide
    IrrGetNodeAndCollisionPointFromRay ( _
        StartVector, EndVector, _
        nodeHit, xpos,ypos,zpos, xnorm,ynorm,znorm )
    if NOT nodeHit = IRR_NO_OBJECT then
        IrrSetNodeMaterialFlag( nodeHit, IRR_EMF_LIGHTING, IRR_OFF )
    else
        IrrSetNodeMaterialFlag( SceneNode, IRR_EMF_LIGHTING, IRR_ON )
    end if

    ' move the test object to this location to indicate the point of collision
    IrrSetNodePosition( TestNode, xpos,ypos,zpos )

    ' draw the scene
    IrrDrawScene
    
    ' end drawing the scene and render it
    IrrEndScene
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
