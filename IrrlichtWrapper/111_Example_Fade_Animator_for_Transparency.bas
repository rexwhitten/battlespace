'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 111: Fade Animator for Transparency
'' This example demonstrates the fade animator applied to transparent nodes.
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"


'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM Billboard(3) as irr_node
DIM BillboardTexture as irr_texture
DIM Camera as irr_camera


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 512, 512, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 111: Fade Animator for Transparency" )

' load the texture resource for the billboard
BillboardTexture = IrrGetTexture( "./media/beam.png" )

' add the billboard to the scene, the first two parameters are the size of the
' billboard in this instance they match the pixel size of the bitmap to give
' the correct aspect ratio. the last three parameters are the position of the
' billboard object
Billboard(1) = IrrAddBillBoardToScene( 30.0,100.0, -30.0,0.0,100.0 )
Billboard(2) = IrrAddBillBoardToScene( 30.0,100.0,   0.0,0.0,100.0 )
Billboard(3) = IrrAddBillBoardToScene( 30.0,100.0,  30.0,0.0,100.0 )

' now we apply the loaded texture to the billboard using node material index 0
IrrSetNodeMaterialTexture( Billboard(1), BillboardTexture, 0 )
IrrSetNodeMaterialTexture( Billboard(2), BillboardTexture, 0 )
IrrSetNodeMaterialTexture( Billboard(3), BillboardTexture, 0 )

' fading requires that lighting is enabled
IrrSetNodeMaterialFlag( Billboard(1), IRR_EMF_LIGHTING, IRR_ON )
IrrSetNodeMaterialFlag( Billboard(2), IRR_EMF_LIGHTING, IRR_ON )
IrrSetNodeMaterialFlag( Billboard(3), IRR_EMF_LIGHTING, IRR_ON )

' apply transparent materials types
IrrSetNodeMaterialType ( Billboard(1), IRR_EMT_TRANSPARENT_ADD_COLOR )
IrrSetNodeMaterialType ( Billboard(2), IRR_EMT_TRANSPARENT_ALPHA_CHANNEL )
IrrSetNodeMaterialType ( Billboard(3), IRR_EMT_TRANSPARENT_ALPHA_CHANNEL_REF )

' add a first person perspective camera into the scene so we can move around
' the billboard and see how it reacts
Camera = IrrAddCamera( 0,0,0, 0,0,10 )

' hide the mouse pointer
IrrHideMouse

' set the ambient light level across the entire scene
IrrSetAmbientLight( 1,1,1 )

IrrSetNodeScale( Billboard(1), 0.5,0.5,0.5 )

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
dim as integer frames = 0
Dim as Single timeElapsed, currentTime, frameTime = timer
WHILE IrrRunning
    ' is it time for another frame
    currentTime = timer
    timeElapsed = currentTime - frameTime
    if timeElapsed > 0.0167 then
        ' record the start time of this frame
        frameTime = currentTime

         ' begin the scene, erasing the canvas with sky-blue before rendering
        IrrBeginScene( 128, 128, 128 )
    
        ' draw the scene
        IrrDrawScene
    
        ' end drawing the scene and render it
        IrrEndScene
        
        ' wait until 100 frames have elapsed
        frames += 1
        if frames = 100 then
            ' Add the fade, scale and delete animator
            IrrAddFadeAnimator( Billboard(1), 3000, -0.5 )      ' shrink
            IrrAddFadeAnimator( Billboard(2), 3000,  0.0 )      ' dont scale
            IrrAddFadeAnimator( Billboard(3), 3000,  0.5 )      ' expand
        endif
    endif

WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
