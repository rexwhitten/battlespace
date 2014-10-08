'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 09 : Skybox
'' This example adds a skybox around the whole scene that makes a backdrop
'' for your scene to be rendered against
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM SkyBox as irr_node
DIM Camera as irr_camera


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 400, 200, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 09: Skybox" )

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

' we add a first person perspective camera to the scene so you can look about
Camera = IrrAddFPSCamera

' hide the mouse pointer
IrrHideMouse

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
WHILE IrrRunning
    ' begin the scene, erasing the canvas with sky-blue before rendering
    IrrBeginScene( 240, 255, 255 )

    ' draw the scene
    IrrDrawScene

    ' end drawing the scene and render it
    IrrEndScene
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
