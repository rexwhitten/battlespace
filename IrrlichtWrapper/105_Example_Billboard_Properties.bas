'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 105: Billboard Propertuies
'' This example demonstrates the modification of Billboard properties to a
'' billboard that has been created in a scene
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"


'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM Billboard as irr_node
DIM BillboardTexture as irr_texture
DIM Camera as irr_camera


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 400, 200, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 105: Billboard Properties" )

' load the texture resource for the billboard
BillboardTexture = IrrGetTexture( "./media/freebasiclogo_big.jpg" )

' add the billboard to the scene, the first two parameters are the size of the
' billboard in this instance they match the pixel size of the bitmap to give
' the correct aspect ratio. the last three parameters are the position of the
' billboard object
Billboard = IrrAddBillBoardToScene( 200.0,102, 0.0,0.0,100.0 )

' now we apply the loaded texture to the billboard using node material index 0
IrrSetNodeMaterialTexture( Billboard, BillboardTexture, 0 )

' rather than have the billboard lit by light sources in the scene we can
' switch off lighting effects on the model and have it render as if it were
' self illuminating
IrrSetNodeMaterialFlag( Billboard, IRR_EMF_LIGHTING, IRR_OFF )

' add a first person perspective camera into the scene so we can move around
' the billboard and see how it reacts
Camera = IrrAddFPSCamera

' hide the mouse pointer
IrrHideMouse

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
Dim as single BillboardWidth = 200
Dim as Single timeElapsed, currentTime, frameTime = timer
WHILE IrrRunning
#ifndef RUN_FLAT_OUT
    ' is it time for another frame
    currentTime = timer
    timeElapsed = currentTime - frameTime
    if timeElapsed > 0.0167 then
        ' record the start time of this frame
        frameTime = currentTime

        ' begin the scene, erasing the canvas with sky-blue before rendering
        IrrBeginScene( 240, 255, 255 )
    
        ' draw the scene
        IrrDrawScene
        
        ' Change billboard properties
        ' the first parameter is the billboard node
        ' the second parameter is the RGBA color of the top of the billboard
        ' the third parameter is the RGBA color of the bottom of the billboard
        IrrSetBillBoardColor( Billboard, _
                RGBA( 255, BillboardWidth, BillboardWidth, 255 ), _
                RGBA( 255, BillboardWidth, BillboardWidth, 255 ))

        ' change the size of the billboard
        IrrSetBillBoardSize( Billboard, BillboardWidth, 100.0 )

        ' animate the width property
        if BillboardWidth > 1.0 Then BillboardWidth -= 0.2

        ' end drawing the scene and render it
        IrrEndScene
    EndIf
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
