''' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 12 : Collision
'' This example demonstrates the final animator the collision animator and how
'' to make one node collide against another. In this example we collide the
'' camera node against a BSP map allowing us to walk around the map naturally
'' there are a couple of holes in this map as the textures are not available
'' to load the polygons. see if you can escape through the bottom of the screen
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM BSPMesh as irr_mesh
DIM BSPNode as irr_node
DIM Camera as irr_camera
DIM CameraNode as irr_node
DIM MapCollision as irr_selector


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 600, 400, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 12: Collision" )

' first we load the example map into the scene for details on this please
' read example 5
IrrAddZipFile( "./media/map-20kdm2.pk3", IRR_IGNORE_CASE, IRR_IGNORE_PATHS )
BSPMesh = IrrGetMesh( "20kdm2.bsp" )
BSPNode = IrrAddMeshToSceneAsOcttree( BSPMesh )

' next we add a first person perspective camera to the scene
Camera = IrrAddFPSCamera

' and move it into the middle of the map
CameraNode = Camera
IrrSetNodePosition( CameraNode, 1750, 149, 1369 )
IrrSetNodeRotation( CameraNode, 4, -461.63, 0 )


' the first thing we need to do with collision is to create an object called a
' selector that contains a selection of triangle to be used in the collision
' calculations there are a number of different ways of doing this depending on
' the type of mesh you are working with. in this example we are using the
' complex BSP map and therefore should use the following command
MapCollision = IrrGetCollisionGroupFromComplexMesh( BSPMesh, BSPNode )


' now we can add the sixth and final animator to our camera object the collision
' animator. This takes a long list of parameters that define the following :-
' 1) the collision object created from the map
' 2) the node that is going to be collided against the map
' 3) 3 vaues defining the radius of the node (the camera in this case). if you
'    make this value too small you wont be able to climb steps, if its too big
'    you might get stuck in a doorway or be able to jump over a wall. the best
'    thing to do is to have some fun experimenting
' 4) 3 values defining the pull of gravity, in this case a weak downward force
' 5) finally 3 values defining the offset of the node from the collision point
'    this will enable you to bring an object to the surface
IrrAddCollisionAnimator(_
                        MapCollision,_
                        CameraNode,_
                        30.0,30.0,30.0,_
                        0.0,-9.8,0.0,_
                        0.0,50.0,0.0 )

' we also hide the mouse pointer to see the view better
IrrHideMouse


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
    
        ' draw the scene
        IrrDrawScene
    
        ' end drawing the scene and render it
        IrrEndScene
    End if
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
