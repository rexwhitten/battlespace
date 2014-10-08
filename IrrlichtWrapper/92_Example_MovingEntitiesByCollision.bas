'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 92: Moving Entities by Collision
'' This example loads a map and a character model into the scene and then
'' uses a collision function to let the character walk up the stairs in the map
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

DIM selector As irr_selector
DIM ellipsoidPosition As IRR_VECTOR
DIM ellipsoidRadius As IRR_VECTOR
DIM velocity As IRR_VECTOR
DIM gravity As IRR_VECTOR
DIM outPosition As IRR_VECTOR
DIM outHitPosition As IRR_VECTOR
DIM outFalling As Integer

'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart(   IRR_EDT_OPENGL, 600, 400, IRR_BITS_PER_PIXEL_32, _
            IRR_WINDOWED, IRR_NO_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' set the window caption
IrrSetWindowCaption( "Example 92: Moving Entities by Collision" )

' Load the character mode
MD2Mesh = IrrGetMesh( "./media/zumlin.md2" )
MeshTexture = IrrGetTexture( "./media/zumlin.pcx" )
SceneNode = IrrAddMeshToScene( MD2Mesh )
IrrSetNodeMaterialTexture( SceneNode, MeshTexture, 0 )
IrrSetNodeMaterialFlag( SceneNode, IRR_EMF_LIGHTING, IRR_OFF )
IrrPlayNodeMD2Animation( SceneNode, IRR_EMAT_RUN )
IrrSetNodeScale( SceneNode, 1.25, 1.25, 1.25 )
IrrSetNodeRotation( SceneNode, 0, 90, 0 )

' load the bsp environment
IrrAddZipFile( "./media/map-20kdm2.pk3", IRR_IGNORE_CASE, IRR_IGNORE_PATHS )
BSPMesh = IrrGetMesh( "20kdm2.bsp" )
BSPNode = IrrAddMeshToSceneAsOcttree( BSPMesh )

' move the map into position around the model
IrrSetNodePosition( BSPNode, -1370,-88,-1400)

' create a collision object from the map
selector = IrrGetCollisionGroupFromComplexMesh( BSPMesh, BSPNode )

' This is the velocity the character moves each frame, the upward velocity seams
' to help the character climb stairs but it should never be greater than gravity
velocity.X = 0.0
velocity.Y =  2.0
velocity.Z = -3.0

' the direction of gravity pulling the character to the ground, if you apply too
' little gravity you may find your character doesn't move
gravity.X  = 0.0
gravity.Y  = -2.8
gravity.Z  =  0.0

' the position of the character in the scene (just at the top of the stairs)
ellipsoidPosition.X = 40.0
ellipsoidPosition.Y = 140.0
ellipsoidPosition.Z = 500.0

' the size of the collision volume. this is important in moving up steps. too
' large and you will get stuck in a doorway, too small and you won't climb
'stairs
ellipsoidRadius.X = 30.0
ellipsoidRadius.Y = 60.0
ellipsoidRadius.Z = 30.0

' add a camera into the scene
OurCamera = IrrAddCamera( 150,0,0, 0,0,0 )

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
Dim as Single frameTime = timer + 0.0167
WHILE IrrRunning
    ' is it time for another frame
    if timer > frameTime then
        ' calculate the time the next frame starts
        frameTime = timer + 0.0167

        ' begin the scene, erasing the canvas with sky-blue before rendering
        IrrBeginScene( 240, 255, 255 )
    
        ' Collides a moving ellipsoid with a 3d world with gravity and returns the
        ' resulting new position of the ellipsoid.
        IrrGetCollisionResultPosition (_
                selector, _
                ellipsoidPosition, _
                ellipsoidRadius, _
                velocity, _
                gravity, _
                0.0005, _
                ellipsoidPosition, _
                outHitPosition, _
                outFalling )

        ' move the character to the position that is the result of the test
        IrrSetNodePosition( SceneNode, _
                            ellipsoidPosition.X, _
                            ellipsoidPosition.Y + gravity.Y - 30.0, _
                            ellipsoidPosition.Z )

        ' make the camera follow the character
        IrrSetNodePosition( OurCamera, _
                            ellipsoidPosition.X + 50.0 + (ellipsoidPosition.Z - 500 ) / 10.0,_
                            ellipsoidPosition.Y + gravity.Y + 40.0, _
                            ellipsoidPosition.Z + 40.0 )

        ' point the camera at the character
        IrrSetCameraTarget( OurCamera, _
                            ellipsoidPosition.X, _
                            ellipsoidPosition.Y + gravity.Y, _
                            ellipsoidPosition.Z )

        ' draw the scene
        IrrDrawScene
    
        ' end drawing the scene and render it
        IrrEndScene
    end if
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
