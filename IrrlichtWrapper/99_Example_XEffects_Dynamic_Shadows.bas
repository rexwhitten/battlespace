'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 99: XEffects Dynamic Shadows
'' This example demonstrates the use of the XEffects module to display dynamic
'' shadows. XEffects requires shader support on the graphics card.
''
'' This example uses a temple object that has a radiosity rendered lightmap
'' added to it as a texture, this already gives it a realistic look. Then a
'' dynamic light is added to the scene to display moving shadows.
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
IrrStart( IRR_EDT_OPENGL, 512, 512, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' start the XEffect system, this must be called before any other XEffect
' commands. we switch off VSM shadows but switch on soft shadowing
IrrXEffectsStart( IRR_OFF, IRR_ON )

' set the window caption
IrrSetWindowCaption( "Example 99: XEffects Dynamic Shadows" )

' load a mesh this acts as a blue print for the model
RoomMesh = IrrGetMesh( "./media/temple.obj" )

' load texture resources for texturing the scene nodes
MeshTexture = IrrGetTexture( "./media/temple_lightmap.jpg" )

' add the mesh to the scene as a new node, the node is an instance of the
' mesh object supplied here
SceneNode = IrrAddMeshToScene( RoomMesh )

' scale the node up a little (this will not effect this shaders lighting)
IrrSetNodeScale( SceneNode, 14.0, 14.0, 14.0 )

' add dynamic shadows to this node, it will both cast and receive shadows
IrrXEffectsAddShadowToNode( SceneNode, EFT_8PCF, ESM_BOTH )

' apply a material to the node to give its surface color
IrrSetNodeMaterialTexture( SceneNode, MeshTexture, 0 )

' switch off lighting effects on this model, as there are no lights in this
' scene the model would otherwise render pule black
IrrSetNodeMaterialFlag( SceneNode, IRR_EMF_LIGHTING, IRR_OFF )

' add a dynamic shadow casting light
' 1) the size of the shadow map texure this should always be a power of two.
'    512, 1024, 2048, etc ... bigger numbers = more quality = more memory
' 2) three numbers specify the X,Y,Z position of the light
' 3) three numbers specify the X,Y,Z target of the light. a dynamic light is
'    shaped like a spotlight so it needs a target to shine at.
' 4) four numbers specify the R,G,B,A intensity of the light
' 5) two numbers specify the near and far distance of the effect of the light
' 6) the angle of the spotlight 90 degrees in this case
IrrXEffectsAddShadowLight ( 512, 200,200,0, 0,0,0, 0.9,0.9,0.6,0.0, 1.0, 1200.0, 89.99 )

' set the ambient lighting applied by the XEffects system
IrrXEffectsSetAmbientColor( 0,128,128,128)


' add a camera into the scene, the first co-ordinates represents the 3D
' location of our view point into the scene the second co-ordinates specify the
' target point that the camera is looking at
OurCamera = IrrAddFPSCamera( 0, 100.0f, 0.1f )
IrrSetNodePosition( OurCamera, 150,80,100 )
IrrSetCameraTarget( OurCamera, 0,0,0 )

' hide the mouse
IrrHideMouse


' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
Dim as single moveCircle = 0.0f
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

        ' move the light about to show the dynamic lighting effect
        IrrXEffectsSetShadowLightPosition( 0, _
                200, (Cos( moveCircle ) + 1) * 75 + 50, (Sin( moveCircle ) + 1 ) * 75 + 50 )
        moveCircle += 0.01

        ' draw the scene
        IrrDrawScene
        
        ' end drawing the scene and render it
        IrrEndScene
    End if
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
