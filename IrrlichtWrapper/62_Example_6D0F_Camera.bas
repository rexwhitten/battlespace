'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 62 : Camera with Six Degrees of freedom
'' This example allows you to control the camera using movements that are free
'' all six degrees, this action is very important for camera motions that
'' represent aircraft and spacecraft movements
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM SkyBox as irr_node
DIM Camera as irr_camera
DIM MeshTexture as irr_texture
DIM TestNode as irr_node

' camera control objects
DIM yaw as single = 0
DIM yaw_dif as single = 0
DIM pitch as single = 0
DIM pitch_dif as single = 0
DIM roll_dif as single = 0
DIM KeyEvent as IRR_KEY_EVENT PTR
DIM MouseEvent as IRR_MOUSE_EVENT PTR
DIM X as single = 0
DIM Y as single = 0
DIM drive as single = 0
DIM strafe as single = 0
DIM elevate as single = 0


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 512, 512, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_CAPTURE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 62: Camera with Six Degrees of freedom" )

' the skybox is a simple hollow cube that surrounds the whole scene. textures
' are applied to all of the six sides of the cube creating an image around the
' entire scene instead of simply the color of the blank canvas
' here we load the textures as parameters of the skybox command (they could
' of course be loaded seperatly and assigned to irr_texture variables
SkyBox = IrrAddSkyBoxToScene( _
        IrrGetTexture("./media/irrlicht2_up.jpg"),_
        IrrGetTexture("./media/irrlicht2_dn.jpg"),_
        IrrGetTexture("./media/irrlicht2_rt.jpg"),_
        IrrGetTexture("./media/irrlicht2_lf.jpg"),_
        IrrGetTexture("./media/irrlicht2_ft.jpg"),_
        IrrGetTexture("./media/irrlicht2_bk.jpg"))

MeshTexture = IrrGetTexture( "./media/texture.jpg" )
TestNode = IrrAddTestSceneNode
IrrSetNodeMaterialTexture( TestNode, MeshTexture, 0 )
IrrSetNodeMaterialFlag( TestNode, IRR_EMF_LIGHTING, IRR_OFF )

' here we add in the camera object. this is the recommended starting position
' for a camera pointing forward at a right angle to the default up direction
Camera = IrrAddCamera( 0,0,0, 0,0,1 )

' when using six degrees of freedom controls if you need to use
' IrrSetNodePosition, IrrSetCameraTarget or IrrSetCameraUpDirection you will
' have to make sure the camera position, target and up direction are at right
' angles to one another the IrrSetCameraUpAtRightAngle command is provided to
' allow you to do this simply.
IrrSetNodePosition( cast(irr_node,Camera), 70, 100, 0 )
IrrSetCameraTarget( Camera, 0,0,0 )
IrrSetCameraUpAtRightAngle( Camera )

' when performing camera operations you need to take note of the order that the
' transformations are applied. in the following example the camera is pitched
' down 90 degrees and then elevated 100 units. This is alot different from
' elevating 100 units and then pitching down 90 degrees
'    IrrRevolveCamera( Camera, 0, -1.571, 0,  0, 0, 100 )

' hide the mouse pointer
IrrHideMouse

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
WHILE IrrRunning
    ' begin the scene, erasing the canvas with sky-blue before rendering
    IrrBeginScene( 240, 255, 255 )
    X = 0.5 : Y = 0.5
    IrrSetMousePosition( X, Y )

    ' while there are mouse events waiting
    while IrrMouseEventAvailable
        ' read the mouse event out
        MouseEvent = IrrReadMouseEvent

        ' if this is a mouse move event
        if MouseEvent->action = IRR_EMIE_MOUSE_MOVED then
            ' spin the camera around
            yaw_dif = X - 0.5
            yaw_dif /= 1
            yaw = X

            pitch_dif = Y - 0.5
            pitch_dif /= 1
            pitch = Y
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
        case KEY_KEY_Q
            ' if the key is going down
            if KeyEvent->direction = IRR_KEY_DOWN then
                roll_dif = 0.005
            else
                roll_dif = 0.0
            endif

        case KEY_KEY_E
            ' if the key is going down
            if KeyEvent->direction = IRR_KEY_DOWN then
                roll_dif = -0.005
            else
                roll_dif = 0.0
            endif

        case KEY_KEY_W
            ' if the key is going down
            if KeyEvent->direction = IRR_KEY_DOWN then
                drive = 0.01
            else
                drive = 0.0
            endif

        case KEY_KEY_S
            ' if the key is going down
            if KeyEvent->direction = IRR_KEY_DOWN then
                drive = -0.01
            else
                drive = 0.0
            endif

        case KEY_KEY_A
            ' if the key is going down
            if KeyEvent->direction = IRR_KEY_DOWN then
                strafe = 0.01
            else
                strafe = 0.0
            endif

        case KEY_KEY_D
            ' if the key is going down
            if KeyEvent->direction = IRR_KEY_DOWN then
                strafe = -0.01
            else
                strafe = 0.0
            endif

        case KEY_KEY_Z
            ' if the key is going down
            if KeyEvent->direction = IRR_KEY_DOWN then
                elevate = 0.01
            else
                elevate = 0.0
            endif

        case KEY_KEY_X
            ' if the key is going down
            if KeyEvent->direction = IRR_KEY_DOWN then
                elevate = -0.01
            else
                elevate = 0.0
            endif
        end select
    wend

    IrrRevolveCamera( Camera, -roll_dif, pitch_dif, -yaw_dif, drive, strafe, elevate )
    yaw_dif = 0.0
    pitch_dif = 0.0

    ' draw the scene
    IrrDrawScene

    ' end drawing the scene and render it
    IrrEndScene
WEND


' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
