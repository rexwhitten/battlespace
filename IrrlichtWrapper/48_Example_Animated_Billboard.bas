'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 48: Animated Billboards
'' This example demonstrates animated billboards. The texture on the billboard
'' is changed each frame to generate an animated surface.
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"


'' ////////////////////////////////////////////////////////////////////////////
'' global variables

#define LAST_FRAME 4

' irrlicht objects
DIM Billboard as irr_node
DIM BillboardTexture(1 to LAST_FRAME) as irr_texture
DIM Camera as irr_camera
DIM xpos as single = 0.0
DIM frame as integer = 50
DIM framesync as single = 0


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 400, 200, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 48: Animated Billboards" )

' load the texture resource for the billboard
BillboardTexture(1) = IrrGetTexture( "./media/1.tga" )
BillboardTexture(2) = IrrGetTexture( "./media/2.tga" )
BillboardTexture(3) = IrrGetTexture( "./media/3.tga" )
BillboardTexture(4) = IrrGetTexture( "./media/4.tga" )

' add the billboard to the scene, the first two parameters are the size of the
' billboard in this instance they match the pixel size of the bitmap to give
' the correct aspect ratio. the last three parameters are the position of the
' billboard object
Billboard = IrrAddBillBoardToScene( 10.0, 10.0,  0.0, 0.0, 0.0 )

' now we apply the loaded texture to the billboard using node material index 0
IrrSetNodeMaterialTexture( Billboard, BillboardTexture(1), 0 )

' rather than have the billboard lit by light sources in the scene we can
' switch off lighting effects on the model and have it render as if it were
' self illuminating
IrrSetNodeMaterialFlag( Billboard, IRR_EMF_LIGHTING, IRR_OFF )
IrrSetNodeMaterialType ( Billboard, IRR_EMT_TRANSPARENT_ALPHA_CHANNEL )

' add a first person perspective camera into the scene so we can move around
' the billboard and see how it reacts
Camera = IrrAddCamera( 100,0,0, 0,0,0 )

' hide the mouse pointer
IrrHideMouse

' make a note of the time 
framesync = Timer

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
WHILE IrrRunning
    ' begin the scene, erasing the canvas with sky-blue before rendering
    IrrBeginScene( 255, 255, 0 )

    ' move the billboard towards the camera by 0.01 units
    IrrSetNodePosition( Billboard, xpos, 0.0, 0.0 )
    xpos += 0.01

    ' check to see if 0.1 seconds have advanced since we recorded the time
    if Timer - framesync > 0.1 then
        ' record the new time
        framesync = Timer
        ' advance to the next frame
        frame += 1
        ' if we have passed the last frame rewind to the begining
        if frame > LAST_FRAME then frame = 1

        ' change the texture used for the billboard
        IrrSetNodeMaterialTexture( Billboard, BillboardTexture(frame), 0 )
    endif

    ' draw the scene
    IrrDrawScene

    ' end drawing the scene and render it
    IrrEndScene
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
