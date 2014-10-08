'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 100: XEffects Water
'' This example demonstrates the water shader supplied with the XEffects system
'' by Blindside. The effect occurs on the plane at Y = 0.0 and an effect is
'' generated both above and below the water. The animated effect is created by
'' changing the bitmap used to define the surface normal. While this set of
'' images are free to use, you will likely want to source a higher quality set
'' to improve the effect.
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "vbcompat.bi"
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' SPECIFIES the number of frames in the water animation
#define WATER_FRAMES        18
' SPECIFIES that a new water frame will be used every two frames
#define NEW_IMAGE_EVERY     2

' irrlicht objects
DIM RoomMesh as irr_mesh
DIM WaterTexture(WATER_FRAMES) as irr_texture
DIM MeshTexture as irr_texture
DIM SceneNode as irr_node
DIM OurCamera as irr_camera
DIM i as integer
DIM filename as string


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 640, 480, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' set the window caption
IrrSetWindowCaption( "Example 100: XEffects Water" )

' add a camera into the scene, position and target it
OurCamera = IrrAddFPSCamera( 0, 100.0f, 0.1f )
IrrSetNodePosition( OurCamera, 150,80,100 )
IrrSetCameraTarget( OurCamera, 0,0,0 )

' start the XEffects system
IrrXEffectsStart( IRR_OFF, IRR_OFF, IRR_ON )

' enable the depth render pass, this is required for the water shader
IrrXEffectsEnableDepthPass( IRR_ON )

' load a series of dump map images that define the bumpyness of the surface of
' the water. these are then turned into normal maps for the shader to use
for i = 1 to WATER_FRAMES
    filename = "./media/water/water_" + Format( i,"0000" ) + ".png"
    WaterTexture(i) = IrrGetTexture( filename )
    IrrMakeNormalMapTexture( WaterTexture(i), 6.0 )
Next i

' load the shader associated with water rendering
IrrXEffectsAddPostProcessingFromFile( "./media/shaders/ScreenWater.glsl" )

' load a mesh this acts as a blue print for the model
RoomMesh = IrrGetMesh( "./media/temple.obj" )

' load texture resources for texturing the scene nodes
MeshTexture = IrrGetTexture( "./media/temple_lightmap.jpg" )

' add the mesh to the scene as a new node, the node is an instance of the
' mesh object supplied here
SceneNode = IrrAddMeshToScene( RoomMesh )

' scale the node up a little (this will not effect this shaders lighting)
IrrSetNodeScale( SceneNode, 14.0, 14.0, 14.0 )

' Add the room to the depth pass test
IrrXEffectsAddNodeToDepthPass( SceneNode )

' apply a material to the node to give its surface color
IrrSetNodeMaterialTexture( SceneNode, MeshTexture, 0 )

' switch off lighting effects on this model, as there are no lights in this
' scene the model would otherwise render pule black
IrrSetNodeMaterialFlag( SceneNode, IRR_EMF_LIGHTING, IRR_OFF )

' XEffects does not use the background color defeined in IrrBeginScene to
' display as empty space, instead it uses the color defined here.
IrrXEffectsSetClearColor( 255,64,64,128 )

' hide the mouse from the display
IrrHideMouse


' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
i = NEW_IMAGE_EVERY
DIM direction as integer = 1
Dim as Single timeElapsed, currentTime, frameTime = timer
WHILE IrrRunning
    ' is it time for another frame
    currentTime = timer
    timeElapsed = currentTime - frameTime
    if timeElapsed > 0.0167 then
        ' record the start time of this frame
        frameTime = currentTime

        ' set the image used as the surface texture for this water frame
        IrrXEffectsSetPostProcessingUserTexture( WaterTexture(i\NEW_IMAGE_EVERY))
        
        ' keep on counting up images and reset back the begining if needed
        i += direction
        if i = (WATER_FRAMES + 1) * NEW_IMAGE_EVERY then i = NEW_IMAGE_EVERY

        ' begin the scene
        IrrBeginScene( 0, 0, 0 )

        ' draw the scene
        IrrDrawScene
        
        ' end drawing the scene and render it
        IrrEndScene
    End if
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
