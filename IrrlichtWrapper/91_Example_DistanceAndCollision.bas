''' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 91 : Distance and Collision
'' This example demonstrates some additional commands that have been included to
'' provide a new set of operations that return information on distance and
'' collisions
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM BlueTexture as irr_texture
DIM RedTexture as irr_texture
DIM TestBox(1 to 5) as irr_node
DIM CirclingBox as irr_node
DIM IndicatorObject as irr_node
DIM Animator as irr_animator
DIM Camera as irr_camera
DIM BitmapFont as irr_font
DIM box_index as integer
DIM Distance as Single
DIM ResultString as wstring * 256



'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 600, 400, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_NO_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 91: Distance and Collision" )

' load the bitmap font as a texture
BitmapFont = IrrGetFont ( "./media/bitmapfont.bmp" )

' add a bright ambient light to the scene to brighten everything up
IrrSetAmbientLight( 1,1,1 )

' first lets load some textures that we can use on the test boxes in the scene
BlueTexture = IrrGetTexture( "./media/Cross.bmp" )
RedTexture = IrrGetTexture( "./media/Diagonal.bmp" )

' loop around and set up some boxes so we can show each of the animators
for box_index = 1 to 5
    ' create the box
    TestBox(box_index) = IrrAddTestSceneNode

    ' texture the box
    IrrSetNodeMaterialTexture( TestBox(box_index), BlueTexture, 0 )

    ' scale the box up a little
    IrrSetNodeScale( TestBox(box_index), 2.5, 2.5, 2.5 )
    
    ' place the boxes in a circle on the ground
    IrrSetNodePosition( TestBox(box_index), _
                        Cos(box_index * 1.3) * 80, _
                        0, _
                        Sin(box_index * 1.3) * 80 )
next

' create the animated box
CirclingBox = IrrAddTestSceneNode

' texture the animated box
IrrSetNodeMaterialTexture( CirclingBox, BlueTexture, 0 )

' this animator will fly the box around in a circle, the first 3 parameters
' specify the center of the circle, the next specifies the radius of the circle
' and finally a speed parameter to specify how far the box is moved each frame
Animator = IrrAddFlyCircleAnimator( CirclingBox, 0,15,0, 75, 0.001 )

' add a sphere object that will mark a point in space and that will be used to
' to indicate when this location is inside the animated box.
' the sphere we create has a radius of 10.0 and is made from rings of 12
' verticies
IndicatorObject = IrrAddSphereSceneNode( 10.0, 12)

' move the sphere to the location we are going to test
IrrSetNodePosition( IndicatorObject, 50,15,50 )

' texture the sphere
IrrSetNodeMaterialTexture( IndicatorObject, BlueTexture, 0 )

' add a static camera to the scene to observe the animation
Camera = IrrAddCamera( 80,120,80, 0, 0, 0 )

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
Dim as Single frameTime = timer + 0.0167
WHILE IrrRunning
    ' is it time for another frame
    if timer > frameTime then
        ' calculate the time the next frame starts
        frameTime = timer + 0.0167

        ' begin the scene, erasing the canvas with sky-blue before rendering
        IrrBeginScene( 64, 64, 64 )
    
        ' draw the scene
        IrrDrawScene

        ' Get the Distance between the animated box and one of the others
        Distance = IrrGetDistanceBetweenNodes( CirclingBox, TestBox(1))

        ' create a wide string with a list of the positions in
        ResultString = "DISTANCE "+ Str(Distance)
        
        ' draw this position information to the screen
        Irr2DFontDraw ( BitmapFont, ResultString, 4, 4, 700, 24 )

        ' Examine each of the boxes
        for box_index = 1 to 5
            ' if the animated box touching this box
            If IrrAreNodesIntersecting( CirclingBox, TestBox(box_index)) Then
                ' turn the box red
                IrrSetNodeMaterialTexture( TestBox(box_index), RedTexture, 0 )
            Else
                ' it is not touching so make the box blue
                IrrSetNodeMaterialTexture( TestBox(box_index), BlueTexture, 0 )
            End If
        next box_index

        ' if this point in space is inside the animated box
        If IrrIsPointInsideNode( CirclingBox, 56,15,56 ) Then
            ' turn the sphere red
            IrrSetNodeMaterialTexture( IndicatorObject, RedTexture, 0 )
        Else
            ' the point is not inside the box, make the sphere blue
            IrrSetNodeMaterialTexture( IndicatorObject, BlueTexture, 0 )
        End If

        ' end drawing the scene and render it
        IrrEndScene       
    end if
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
