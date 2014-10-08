'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 101: XEffects Screen Space Ambient Occlusion
'' This example demonstrates the use of the XEffects module to display the SSAO
'' effect.
'' 
'' SSAO (Screen Space Ambient Occlusion) is an method used to approximate the
'' effect of Ambient Occlusion which darkens areas of an object that are not
'' recieving as much ambient light for example the inside of a cup is darker
'' than the outside as not as much ambient light shines upon it.
''
'' Calculating real AO (Ambient Occlusion) is very expensive and cannot be
'' realistically done in Realtime yet. So this clever approximated method
'' simulates the effect in a less expensive realtime shader
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM RoomMesh as irr_mesh
DIM MeshTexture as irr_texture
DIM SceneNode as irr_node
DIM OurCamera as irr_camera


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 800, 600, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' set the window caption
IrrSetWindowCaption( "Example 101: XEffects Screen Space Ambient Occlusion" )


' add a camera into the scene, the first co-ordinates represents the 3D
' location of our view point into the scene the second co-ordinates specify the
' target point that the camera is looking at
OurCamera = IrrAddFPSCamera( 0, 100.0f, 0.01f )
IrrSetNodePosition( OurCamera, 8.3, 1.0, 8.3 )
IrrSetCameraTarget( OurCamera, 0.0, 3.2, 0.0 )

' set the camera clip distance. this is VERY important with the SSAO effect as
' the effect is distributed across this distance
IrrSetCameraClipDistance( OurCamera, 50, 0.001 )

' start the XEffects system
IrrXEffectsStart( IRR_OFF, IRR_OFF, IRR_ON )

' SSAO needs a depth pass to be rendered so enable the depth render pass
IrrXEffectsEnableDepthPass( IRR_ON )

' add the SSAO shader effect to the scene and two blur shaders (horizontal and
' vertical) the SSAO effect uses random noise that needs to be blurred out. 
IrrXEffectsAddPostProcessingFromFile( "./media/shaders/SSAO.glsl", 1 )
IrrXEffectsAddPostProcessingFromFile( "./media/shaders/BlurVLowHP.glsl" )
IrrXEffectsAddPostProcessingFromFile( "./media/shaders/BlurVLowVP.glsl" )
IrrXEffectsAddPostProcessingFromFile( "./media/shaders/SSAOCombine.glsl" )

' load a mesh this acts as a blue print for the model
RoomMesh = IrrGetMesh( "./media/temple.obj" )

' add the mesh to the scene as a new node, the node is an instance of the
' mesh object supplied here
SceneNode = IrrAddMeshToScene( RoomMesh )

' Add the room to the depth pass test
IrrXEffectsAddNodeToDepthPass( SceneNode )

' switch off lighting effects on this model, as there are no lights in this
' scene the model would otherwise render pule black
IrrSetNodeMaterialFlag( SceneNode, IRR_EMF_LIGHTING, IRR_OFF )

' XEffects does not use the background color defeined in IrrBeginScene to
' display as empty space, instead it uses the color defined here.
IrrXEffectsSetClearColor( 255,250,100,0 )

' hide the mouse from the display
IrrHideMouse


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
        IrrBeginScene( 240, 255, 255 )

        ' draw the scene
        IrrDrawScene
        
        ' end drawing the scene and render it
        IrrEndScene
    End if
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
