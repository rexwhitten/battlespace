'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 109 : Beam node
'' This example demonstrates the beam node
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
IrrStart( IRR_EDT_OPENGL, 512, 512, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' set the window caption
IrrSetWindowCaption( "Example 109: Beam node" )

' load texture resources for texturing the scene nodes
MeshTexture = IrrGetTexture( "./media/beam.png" )

' add a new beam node to the scene
SceneNode = IrrAddBeamSceneNode

' apply a material to the node to give its surface color
IrrSetNodeMaterialTexture( SceneNode, MeshTexture, 0 )

' use transparency with this billboard type node
IrrSetNodeMaterialType ( SceneNode, IRR_EMT_TRANSPARENT_ALPHA_CHANNEL )

' add a camera into the scene, the first co-ordinates represents the 3D
' location of our view point into the scene the second co-ordinates specify the
' target point that the camera is looking at
OurCamera = IrrAddCamera( 50,0,0, 0,0,0 )

' generate an initial random position
DIM as single x = -400, y = rnd * 100-50, z = rnd * 100-50

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
Dim as Single timeElapsed, currentTime, frameTime = timer
WHILE IrrRunning
    ' is it time for another frame
    currentTime = timer
    timeElapsed = currentTime - frameTime
    if timeElapsed > 0.0167 then
        ' record the start time of this frame
        frameTime = currentTime

        ' begin the scene, erasing the canvas with sky-blue before rendering
        IrrBeginScene( 0, 0, 0 )

        ' set the beam position
        x += 10
        IrrSetBeamPosition( Scenenode, x,y,z,  x+100,y,z )

        ' If the beam exceeds 1000 restart it
        if x > 200 then
            x = - 400
            y = rnd * 100-50
            z = rnd * 100-50

        ' set the beam size
        IrrSetBeamSize( Scenenode, (rnd + 0.01) * 10.0 )

        Endif
        

        ' draw the scene
        IrrDrawScene
        
        ' end drawing the scene and render it
        IrrEndScene
    Endif
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
