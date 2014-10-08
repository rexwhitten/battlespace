'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 95 : Rotating Nodes and Cameras for Flight Simulation
'' This example controls a cube with a special rotation and position command
'' that can be used to best effect in a flight simulation model
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM BoxTexture as irr_texture
DIM SceneNode as irr_node
DIM SkyBox as irr_node
DIM ChaseCamera as irr_camera
DIM TrackingCamera as irr_camera
DIM KeyEvent as IRR_KEY_EVENT PTR
DIM MouseEvent as IRR_MOUSE_EVENT PTR

' control variables
DIM yaw as single = 0
DIM pitch as single = 0
DIM roll as single = 0
DIM mouse_yaw as single = 0
DIM mouse_pitch as single = 0

DIM X as single = 0
DIM Y as single = 0
DIM drive as single = 0
DIM strafe as single = 0
DIM elevate as single = 0

DIM tracking as integer = 1

' variables used for storing and manipulating positions
DIM as Single xPos, yPos, zPos

' storage for vectors that describe the direction of the node after it is
' revolved and a single arbitrary point that can be used for attaching a camera
DIM as IRR_VECTOR forwardV, upV, camV(0 to 1)


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 800, 600, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_CAPTURE_EVENTS, IRR_VERTICAL_SYNC_ON )

' set the window caption
IrrSetWindowCaption( "Example 95: Rotating Nodes and Cameras for Flight Simulation" )

' load texture resources for texturing the scene nodes
BoxTexture = IrrGetTexture( "./media/texture.jpg" )

' create a background so we can see the camera and object moving
SkyBox = IrrAddSkyBoxToScene( _
        IrrGetTexture("./media/irrlicht2_up.jpg"),_
        IrrGetTexture("./media/irrlicht2_dn.jpg"),_
        IrrGetTexture("./media/irrlicht2_rt.jpg"),_
        IrrGetTexture("./media/irrlicht2_lf.jpg"),_
        IrrGetTexture("./media/irrlicht2_ft.jpg"),_
        IrrGetTexture("./media/irrlicht2_bk.jpg"))

' add a simple mesh to the scene as a new node, the node is an instance of the
' mesh object supplied here
SceneNode = IrrAddTestSceneNode

' apply a material to the node to give its surface color
IrrSetNodeMaterialTexture( SceneNode, BoxTexture, 0 )

' switch off lighting effects on this model, as there are no lights in this
' scene the model would otherwise render pule black
IrrSetNodeMaterialFlag( SceneNode, IRR_EMF_LIGHTING, IRR_OFF )

' add a camera into the scene, the first co-ordinates represents the 3D
' location of our view point into the scene the second co-ordinates specify the
' target point that the camera is looking at
ChaseCamera = IrrAddCamera( 0.0,0.0,50.0, 0.0,0.0,0.0 )
TrackingCamera = IrrAddCamera( 0.0,0.0,50.0, 0.0,0.0,0.0 )

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

        ' sets the mouse position to 0.5, 0.5 and at the same time get the
        ' relative change in distance into the X and Y variables
        X = 0.5 : Y = 0.5
        IrrSetMousePosition( X, Y )

        ' while there are mouse events waiting
        while IrrMouseEventAvailable
            ' read the mouse event out
            MouseEvent = IrrReadMouseEvent
    
            ' if this is a mouse move event
            if MouseEvent->action = IRR_EMIE_MOUSE_MOVED then

                ' spin the object around with the mouse
                mouse_pitch = (X - 0.5) * 100
    
                mouse_yaw = (Y - 0.5) * 100
            endif
        wend

        ' while there are key events waiting to be processed
        while IrrKeyEventAvailable
    
            ' read the key event out. the key event has three parameters the key
            ' scan code, the direction of the key and flags that indicate whether
            ' the control key or the shift keys were also pressed
            KeyEvent = IrrReadKeyEvent
    
            ' arbitrate based on the key that was pressed
            select case as const KeyEvent->key
            case KEY_KEY_U
                ' if the key is going down
                if KeyEvent->direction = IRR_KEY_DOWN then
                    roll = 0.5
                else
                    roll = 0.0
                endif
    
            case KEY_KEY_O
                ' if the key is going down
                if KeyEvent->direction = IRR_KEY_DOWN then
                    roll = -0.5
                else
                    roll = 0.0
                endif
    
    
            case KEY_KEY_I
                ' if the key is going down
                if KeyEvent->direction = IRR_KEY_DOWN then
                    yaw = 0.5
                else
                    yaw = 0.0
                endif
    
            case KEY_KEY_K
                ' if the key is going down
                if KeyEvent->direction = IRR_KEY_DOWN then
                    yaw = -0.5
                else
                    yaw = 0.0
                endif
    
            case KEY_KEY_J
                ' if the key is going down
                if KeyEvent->direction = IRR_KEY_DOWN then
                    pitch = 0.5
                else
                    pitch = 0.0
                endif
    
            case KEY_KEY_L
                ' if the key is going down
                if KeyEvent->direction = IRR_KEY_DOWN then
                    pitch = -0.5
                else
                    pitch = 0.0
                endif

            case KEY_KEY_W
                ' if the key is going down
                if KeyEvent->direction = IRR_KEY_DOWN then
                    drive = 0.1
                else
                    drive = 0.0
                endif
    
            case KEY_KEY_S
                ' if the key is going down
                if KeyEvent->direction = IRR_KEY_DOWN then
                    drive = -0.1
                else
                    drive = 0.0
                endif
    
            case KEY_KEY_A
                ' if the key is going down
                if KeyEvent->direction = IRR_KEY_DOWN then
                    strafe = 0.1
                else
                    strafe = 0.0
                endif
    
            case KEY_KEY_D
                ' if the key is going down
                if KeyEvent->direction = IRR_KEY_DOWN then
                    strafe = -0.1
                else
                    strafe = 0.0
                endif
    
            case KEY_KEY_Q
                ' if the key is going down
                if KeyEvent->direction = IRR_KEY_DOWN then
                    elevate = 0.1
                else
                    elevate = 0.0
                endif
    
            case KEY_KEY_E
                ' if the key is going down
                if KeyEvent->direction = IRR_KEY_DOWN then
                    elevate = -0.1
                else
                    elevate = 0.0
                endif
                
            case KEY_KEY_R
                if KeyEvent->direction = IRR_KEY_DOWN then
                    if tracking = 1 then
                        tracking = 0
                        IrrSetActiveCamera( ChaseCamera )
                    else
                        tracking = 1
                        IrrSetActiveCamera( TrackingCamera )
                    end if
                endif
            end select
        wend

        ' initialise an offset for the camera from the node it is chasing
        camV(0).X = 0.0
        camV(0).Y = 0.0
        camV(0).Z = -25.0

        ' initialise an offset for the cameras target
        camV(1).X = 0.0
        camV(1).Y = 0.0
        camV(1).Z = -15.0

        ' apply a change in rotation and a directional force. we can also
        ' optionally pointers to a series of vectors so that we can recover
        ' important information.
        ' the first is a pointer to a vector pointing forwards
        ' the second is a pointer a vector pointing upwards
        ' following this are any number of points that will also be rotated
        ' (the effect on these points is NOT accumulative)
        IrrSetNodeRotationPositionChange( SceneNode, _
                -roll, pitch + mouse_pitch, -yaw - mouse_yaw, _
                drive, strafe, elevate, _
                @forwardV, @upV, _
                2, @camV(0))

        ' reset mouse pitch and yaw 
        mouse_yaw = 0.0
        mouse_pitch = 0.0

        ' Now we are going to update the cameras based on the new position of
        ' the node
        IrrGetNodePosition( SceneNode, xPos, yPos, zPos )

        ' simply make the tracking camera look at the node
        IrrSetCameraTarget( TrackingCamera, xPos, YPos, zPos )

        ' add the offset position to the position of the node and we have the
        ' location of our tracking camera
        IrrSetNodePosition( ChaseCamera, _
                xPos + camV(0).X, yPos + camV(0).Y, zPos + camV(0).Z )

        ' add to this the forward vector and we have a position
        IrrSetCameraTarget( ChaseCamera, _
                xPos + camV(1).X, yPos + camV(1).Y, zPos + camV(1).Z )
        
        ' use the up vector and to set which direction is up for the camera
        IrrSetCameraUpDirection( ChaseCamera, _
                upV.X + camV(0).X, upV.Y + camV(0).Y, upV.Z + camV(0).Z )

        ' draw the scene
        IrrDrawScene
    
        ' end drawing the scene and render it
        IrrEndScene
    End if
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
