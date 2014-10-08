''' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 11 : Animators
'' This example demonstrates animators, these are mechanisms applied to nodes
'' in the scene that animate the object in some manner over time. this wrapper
'' exposes six animators five of which are shown here
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM BoxTexture as irr_texture
DIM FloorBox as irr_node
DIM AnimatedBox(1 to 5) as irr_node
DIM DeletedBox as irr_node
DIM CircleBox as irr_node
DIM FlyBox as irr_node
DIM RotateBox as irr_node
DIM SplineBox as irr_node
DIM ret as irr_animator
DIM Camera as irr_camera
DIM sx(1 to 4) as single
DIM sy(1 to 4) as single
DIM sz(1 to 4) as single
DIM box_index as integer


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 400, 200, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 11: Animators" )

' add a bright ambient light to the scene to brighten everything up
IrrSetAmbientLight( 1,1,1 )

' first lets load a texture that we can use on the test boxes in the scene
BoxTexture = IrrGetTexture( "./media/freebasiclogo_big.jpg" )

' loop around and set up 5 boxes so we can show each of the animators
for box_index = 1 to 5
    ' create the box
    AnimatedBox(box_index) = IrrAddTestSceneNode
    ' texture the box
    IrrSetNodeMaterialTexture( AnimatedBox(box_index), BoxTexture, 0 )
    ' scale the box up to a visible size
    IrrSetNodeScale( AnimatedBox(box_index), 2.5,2.5,2.5 )
next


' this animator will delete the box after a specified number of milliseconds
' have passed, in this case 5 seconds
ret = IrrAddDeleteAnimator( AnimatedBox(1), 5000 )


' this animator will fly the box around in a circle, the first 3 parameters
' specify the center of the circle, the next specifies the radius of the circle
' and finally a speed parameter to specify how far the box is moved each frame
ret = IrrAddFlyCircleAnimator( AnimatedBox(2), 0,50,0, 50, 0.001 )


' this animator will fly the box in a straight line, the first three parameters
' specify the start position, the next three the end position, the next number
' is the number of milliseconds it takes to fly the path (in this case 3
' seconds) and finally you can specify if it is to fly the path once or to loop
' around flying it endlessly
ret = IrrAddFlyStraightAnimator( AnimatedBox(3), 0,50,-300, 0,50,300, 3000, IRR_LOOP )


' this animator will spin the box around its centre, its very easy to set up
' and simply consists of the speed its to be rotated each frame
ret = IrrAddRotationAnimator( AnimatedBox(4), 0, 0.1, 0 )

' we move this box out of the way also so it doesnt obscure the deleted box
IrrSetNodePosition( AnimatedBox(4), 0,100,0 )


' the last animator is the Spline Animator, its more difficult to set up but
' is very natural looking and powerful. A spline is a curved line that passed
' through or close to a list of co-ordinates, creating a smooth flight.

' this animator needs a list of coordinates stored in three arrays, one array
' each for the X, Y and Z locations of all the points. The arrays defined here
' create a 4 point circle that wobbles up and down a bit. another good way to
' get co-ordinates is to load in the camera position example and move your
' camera to a point and write down its co-ordinates, this is particularly good
' for getting points on a map
sx(1) = -100
sy(1) = 50
sz(1) = 0

sx(2) = 0
sy(2) = 100
sz(2) = -100

sx(3) = 100
sy(3) = 50
sz(3) = 0

sx(4) = 0
sy(4) = 100
sz(4) = 100

' once the points are defined we can create the animator first we tell it how
' many points are in the list (in this case 4) then we pass the first element
' of the array of points for each of the x, y and z arrays, the next parameter
' defines the starting point on the curve, the next the speed the node travels
' along the curve and the final number specifies how tightly the curve is tied
' to the points (0 is angular and 1 is loose)
ret = IrrAddSplineAnimator( AnimatedBox(5), 4, sx(1), sy(1), sz(1), 0, 0.5, 1)


' add a static camera to the scene to observe the animation
Camera = IrrAddCamera( 150,50,0, 0,50,0 )

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
