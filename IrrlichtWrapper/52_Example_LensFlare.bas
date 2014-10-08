'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 52 : Lens Flare
'' A representation of the camera optics effect known as Lens Flare
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM MD2Mesh as irr_mesh
DIM MeshTexture as irr_texture
DIM SceneNode as irr_node
DIM OurCamera as irr_camera


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 640, 480, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' set the window caption
IrrSetWindowCaption( "Example 52: Lens Flare - Camera Optics caught in the light" )

' load texture resources for texturing the scene nodes
MeshTexture = IrrGetTexture( "./media/flares.jpg" )

' simply add the lens flare object and then move it to the position of the
' lightsource that causes the effect, you may have to cast a ray out to this
' point and see if it strikes a node that might be obscuring the light. in this
' case you would make the lens flare invisible
SceneNode = IrrAddLensFlare( MeshTexture )
IrrSetNodePosition( SceneNode, 300,100,1000 )

' add a first person camera into the scene, and hide the mouse
IrrAddFPSCamera
IrrHideMouse


' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
WHILE IrrRunning
    ' begin the scene, erasing the canvas with sky-blue before rendering
    IrrBeginScene( 180, 225, 255 )

    ' draw the scene
    IrrDrawScene
    
    ' draw the GUI
    IrrDrawGUI

    ' end drawing the scene and render it
    IrrEndScene
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
