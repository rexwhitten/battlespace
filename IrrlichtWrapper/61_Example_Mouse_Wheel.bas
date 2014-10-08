'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 61 : Processing events from the mouse wheel
'' This example processes mouse wheel events and performs an action based on the
'' events
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
DIM MouseEvent as IRR_MOUSE_EVENT PTR
DIM metrics as wstring * 256
DIM BitmapFont as irr_font
DIM delta as single
DIM scale as single = 1.0


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 400, 400, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_NO_SHADOWS, IRR_CAPTURE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 61: Mouse Wheel Events" )

' load the test cube texture
MeshTexture = IrrGetTexture( "./media/texture.jpg" )

' load the bitmap font as a texture
BitmapFont = IrrGetFont ( "./media/bitmapfont.bmp" )

' create a test nodes
TestNode = IrrAddTestSceneNode
IrrSetNodeMaterialTexture( TestNode, MeshTexture, 0 )
IrrSetNodeMaterialFlag( TestNode, IRR_EMF_LIGHTING, IRR_OFF )

' add a camera into the scene and move it into position
OurCamera = IrrAddCamera( 0,0,-100, 0,0,0 )
IrrHideMouse
IrrSetNodePosition( OurCamera, 10, 10, -20 )

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
WHILE IrrRunning
    ' begin the scene, erasing the canvas with grey before rendering
    IrrBeginScene( 128,128,128 )

    ' while there are mouse events waiting
    while IrrMouseEventAvailable
        ' read the mouse event out
        MouseEvent = IrrReadMouseEvent

        ' if this is a mouse wheel event
        if MouseEvent->action = IRR_EMIE_MOUSE_WHEEL then

            ' create a wide string with the mouse wheel delta in it
            metrics = "POSITION "+ Str(MouseEvent->delta)

            if MouseEvent->delta > 0 then
                scale += 0.01
            else
                if MouseEvent->delta < 0 then
                    scale -= 0.01
                end if
            end if
            
            IrrSetNodeScale( TestNode, 1.0, scale, 1.0 )

        endif
    wend
    
    ' draw the mouse co-ordinates information to the screen
    Irr2DFontDraw ( BitmapFont, metrics, 4, 4, 250, 24 )

    ' draw the scene
    IrrDrawScene

    ' end drawing the scene and render it
    IrrEndScene
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
