'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 93 : 3D Position from Screen Coordinates
'' This example demonstrates how to get a 3D position in space from a set of
'' screen coordinates and the definition of a 2D plane in 3D space. this can
'' be particularly useful in a scene management application for constraining
'' the movement of an object to a specific axis
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM MyTexture as irr_texture
DIM CenterNode as irr_node
DIM IndicatorObject as irr_node
DIM Camera as irr_camera
DIM KeyEvent as IRR_KEY_EVENT PTR
DIM MouseEvent as IRR_MOUSE_EVENT PTR
DIM XPOS as single
DIM YPOS as single
DIM ZPOS as single
DIM normalX as single = 0.0
DIM normalY as single = 0.0
DIM normalZ as single = 1.0


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 640, 480, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_NO_SHADOWS, IRR_CAPTURE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 93 : 3D Position from Screen Coordinates" )

' add a bright ambient light to the scene to brighten everything up
IrrSetAmbientLight( 1,1,1 )

' first load a texture
MyTexture = IrrGetTexture( "./media/texture.jpg" )

' add a simple test node so we can visualise the world origin
CenterNode = IrrAddTestSceneNode

' texture the node
IrrSetNodeMaterialTexture( CenterNode, MyTexture, 0 )


' add a sphere object that will mark the point in 3D space
' the sphere we create has a radius of 10.0 and is made from rings of 12
' verticies
IndicatorObject = IrrAddSphereSceneNode( 10.0, 12)

' texture the sphere
IrrSetNodeMaterialTexture( IndicatorObject, MyTexture, 0 )

' add a static camera to the scene
Camera = IrrAddCamera( 100,100,100, 0, 0, 0 )

' Hide the mouse pointer
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
        IrrBeginScene( 255, 255, 255 )
    
        ' while there are key events waiting to be processed
        while IrrKeyEventAvailable
            ' read the key event out.
            KeyEvent = IrrReadKeyEvent

            ' arbitrate based on the key that was pressed
            select case as const KeyEvent->key
            case KEY_KEY_X
                ' Constrain movement in the X axis
                normalX  = 1.0
                normalY  = 0.0
                normalZ  = 0.0
            case KEY_KEY_Y
                ' Constrain movement in the Y axis
                normalX  = 0.0
                normalY  = 1.0
                normalZ  = 0.0
            case KEY_KEY_Z
                ' Constrain movement in the Z axis
                normalX  = 0.0
                normalY  = 0.0
                normalZ  = 1.0
            end select
        wend
    
        ' while there are mouse events waiting
        while IrrMouseEventAvailable
            ' read the mouse event out 
            MouseEvent = IrrReadMouseEvent
    
            ' if this is a mouse move event
            if MouseEvent->action = IRR_EMIE_MOUSE_MOVED then

                ' get the position of the object projected against the plane
                IrrGet3DPositionFromScreenCoordinates( _
                        MouseEvent->x, MouseEvent->y, _
                        XPOS, YPOS, ZPOS, _
                        Camera, _
                        normalX, normalY, normalZ )

                ' update the position of the indicator object
                IrrSetNodePosition( IndicatorObject, XPOS , YPOS, ZPOS )
            endif
        wend

        ' draw the scene
        IrrDrawScene

        ' end drawing the scene and render it
        IrrEndScene       
    end if
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
