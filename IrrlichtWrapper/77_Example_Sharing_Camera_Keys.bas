'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 77 : Sharing Camera Keys
'' This example describes capturing keys but sharing them with a camera object
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM MeshTexture as irr_texture
DIM TestNode as irr_node
DIM OurCamera as irr_camera
DIM KeyEvent as IRR_KEY_EVENT PTR
DIM MouseEvent as IRR_MOUSE_EVENT PTR


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 512, 512, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_NO_SHADOWS, IRR_CAPTURE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 77: Sharing Camera Keys" )

' load the test cube texture
MeshTexture = IrrGetTexture( "./media/texture.jpg" )

' create a test nodes
TestNode = IrrAddTestSceneNode
IrrSetNodeMaterialTexture( TestNode, MeshTexture, 0 )
IrrSetNodeMaterialFlag( TestNode, IRR_EMF_LIGHTING, IRR_OFF )

' add a camera into the scene and move it into position
OurCamera = IrrAddFPSCamera
IrrSetNodePosition( OurCamera, 0, 10, -20 )
IrrHideMouse

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
DIM quitApp as integer = IRR_OFF
WHILE IrrRunning AND quitApp = IRR_OFF
    ' begin the scene, erasing the canvas with grey before rendering
    IrrBeginScene( 128,128,128 )

    ' while there are key events waiting to be processed
    while IrrKeyEventAvailable
        ' read the key event out.
        KeyEvent = IrrReadKeyEvent

        ' arbitrate based on the key that was pressed
        if KeyEvent->key = KEY_ESCAPE then
            quitApp = IRR_ON
        end if
    wend

    ' while there are mouse events waiting
    while IrrMouseEventAvailable
        ' read the mouse event out
        MouseEvent = IrrReadMouseEvent
    wend
    
    ' draw the scene
    IrrDrawScene

    ' end drawing the scene and render it
    IrrEndScene
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
