'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 14 : Keyboard and Mouse
'' This example captures keyboard and mouse events it uses the keyboard events
'' to straff the camera around with the arrow keys (in a simple manner) and
'' displays the mouse information on the screen. Please take careful note of
'' the IrrStart command that has now been changed to capture events
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
DIM BitmapFont as irr_font
DIM ret as irr_selector
DIM KeyEvent as IRR_KEY_EVENT PTR
DIM MouseEvent as IRR_MOUSE_EVENT PTR
DIM XPOS as single
DIM YPOS as single
DIM ZPOS as single
DIM metrics as wstring * 256
DIM XStrafe as integer
DIM ZStrafe as integer
DIM SPIN as single
DIM TILT as single
DIM vX as IRR_VECTOR
DIM vY as IRR_VECTOR
DIM vZ as IRR_VECTOR
DIM MX as single
DIM MY as single


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
' here we 
IrrStart( IRR_EDT_OPENGL, 640, 480, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_CAPTURE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 14: Keyboard and Mouse" )

' first we load the example map into the scene for details on this please
' read example 5
IrrAddZipFile( "./media/map-20kdm2.pk3", IRR_IGNORE_CASE, IRR_IGNORE_PATHS )
BSPMesh = IrrGetMesh( "20kdm2.bsp" )
BSPNode = IrrAddMeshToSceneAsOcttree( BSPMesh )

' next we add a first person perspective camera to the scene
Camera = IrrAddCamera( 0,0,0, 0,0,0 )
'Camera = IrrAddFPSCamera

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
CameraNode = Camera
ret = IrrAddCollisionAnimator(_
                                MapCollision,_
                                CameraNode,_
                                30.0,30.0,30.0,_
                                0.0,-3.0,0.0,_
                                0.0,50.0,0.0 )

' load the bitmap font as a texture
BitmapFont = IrrGetFont ( "./media/bitmapfont.bmp" )

' hide the mouse pointer
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
    
        ' We need to set the mouse back to the center of the screen so that it
        ' doesnt wander off. when we do this MX and MY will contain how far the
        ' mouse was moved so it was back in the center of the screen
        MX = 0.5 : MY = 0.5
        IrrSetMousePosition( MX, MY )
    
        ' get the position of the camera
        IrrGetNodePosition( CameraNode, XPOS, YPOS, ZPOS )
    
        ' while there are key events waiting to be processed
        while IrrKeyEventAvailable
    
            ' read the key event out. the key event has three parameters the key
            ' scan code, the direction of the key and flags that indicate whether
            ' the control key or the shift keys were also pressed
            KeyEvent = IrrReadKeyEvent
    
            ' arbitrate based on the key that was pressed
            select case as const KeyEvent->key
            case KEY_KEY_D     ' Left Arrow
                ' if the key is going down
                if KeyEvent->direction = IRR_KEY_DOWN then
                    XStrafe = 5
                else
                    if XStrafe = 5 then
                        XStrafe = 0
                    endif
                endif
    
            case KEY_KEY_W     ' Up Arrow
                ' if the key is going down
                if KeyEvent->direction = IRR_KEY_DOWN then
                    ZStrafe = 5
                else
                    if ZStrafe = 5 then
                        ZStrafe = 0
                    endif
                endif
                    
            case KEY_KEY_A     ' Right Arrow
                ' if the key is going down
                if KeyEvent->direction = IRR_KEY_DOWN then
                    XStrafe = -5
                else
                    if XStrafe = -5 then
                        XStrafe = 0
                    endif
                endif
                    
            case KEY_KEY_S     ' Down Arrow
                ' if the key is going down
                if KeyEvent->direction = IRR_KEY_DOWN then
                    ZStrafe = -5
                else
                    if ZStrafe = -5 then
                        ZStrafe = 0
                    end if
                endif
                
            end select
        wend
    
        ' this command gets the camera orientation these are vectors describing the
        ' cameras forward updward and sideways vector
        IrrGetCameraOrientation( Camera, vX,vY,vZ)
    
        ' these vectors will be different lengths depending on how much the camera
        ' is rotated we can use these values to add the fowards distance to both the
        ' X and Z position by different amounts that are related to the direction
        ' that the camera is pointed
        XPOS += vY.X * ZStrafe + vY.Z * XStrafe
        ZPOS -= vY.X * XStrafe - vY.Z * ZStrafe
    
        ' update the position of the camera we call this before Draw Scene so that
        ' the objects positions are updated before we draw the scene
        IrrSetNodePosition( CameraNode, XPOS , YPOS, ZPOS )
    
        ' while there are mouse events waiting
        while IrrMouseEventAvailable
            ' read the mouse event out 
            MouseEvent = IrrReadMouseEvent
    
            ' if this is a mouse move event
            if MouseEvent->action = IRR_EMIE_MOUSE_MOVED then
    
            endif
    
            ' create a wide string with a list of the positions in
            metrics = "POSITION "+ Str(MouseEvent->x) + " " + Str(MouseEvent->y)
        wend
        
        ' MX contains the distance the mouse was moved we can use this to raise or
        ' lower a number that is used to set the camera spin
        SPIN += ( MX - 0.5 ) * 2.0
        
        ' MY contains the distance the mouse was moved vertically we can use this
        ' raise or lower a number that is used to control the camera tilt
        TILT += ( MY - 0.5 ) * 2.0
        
        ' the camera can spin around in circles but it should only be able to tilt
        ' up a down a certain distance otherwise if the player moved their mouse up
        ' a lot they would see very little change at the top but the target would
        ' still be rising a long way into the distance. however they would need to
        ' moved their mouse down a lot to get the camera to tilt back down. this
        ' would feel very strange
        if TILT > 1.5 then TILT = 1.5
        if TILT < -1.5 then TILT = -1.5
    
        ' we change the camera direction by setting the cameras target
        ' the X target is the cameras position plus the Sin value of the SPIN
        ' the Z target is the cameras position plus the Cos value of the SPIN
        ' together the Cos and Sin of a constantly rising number will plot cirlce
        ' and when added to the camera position we get a circle going around camera
        ' by multipling the value by a 1000 the circle has a radius of 1000, we set
        ' the camera target this far away because the collision system that moves
        ' our camera is going to move the camera too to stop it going through walls
        ' and if we set the target to close the angle of the view will change
        ' drastically and look awful
        ' The camera tilting is done very simply, 
        IrrSetCameraTarget( _
            Camera, XPOS + sin ( SPIN ) * 1000, _
            -TILT * 1500, _
            ZPOS + cos ( SPIN ) * 1000 )
    
        ' draw the scene
        IrrDrawScene
    
        ' draw the mouse co-ordinates information to the screen
        Irr2DFontDraw ( BitmapFont, metrics, 4, 4, 250, 24 )
    
        ' end drawing the scene and render it
        IrrEndScene
    End if

WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
