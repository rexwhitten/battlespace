'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 51 : Clouds
'' This example demonstrates the billboard cloud objects that are particularly
'' useful for simulating aircraft flying through cloud cover and also for
'' creating a light cloud embelishment for a skydome
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM Terrain as irr_terrain
DIM TerrainNode as irr_node
DIM TerrainTexture0 as irr_texture
DIM TerrainTexture1 as irr_texture
DIM Camera as irr_camera
DIM CameraNode as irr_node
DIM CloudTexture as irr_texture
DIM CloudNode as irr_node
dim X as single
dim Y as single
dim Z as single
dim TerrainHeight as single


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 800, 600, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 51: Billboard Clouds by G Davidson" )

' load the cloud image in as a video texture
CloudTexture = IrrGetTexture( "./media/cloud4.png" )

' add the clouds to the scene
' the first parameter is the level of detail, higher values add more structure
' to the cloud when it is closer to the camera
' the second parameter sets the number of child clouds created higher values
' create more structure
' the third parameter defines how many clouds are created
CloudNode = IrrAddClouds( CloudTexture, 3, 1, 500 )

' switch the fog on the clouds to prevent the clouds popping up in the distance
IrrSetNodeMaterialFlag( CloudNode, IRR_EMF_FOG_ENABLE, IRR_ON )

' raise the clouds into the sky
IrrSetNodePosition( CloudNode, 0,2700,0 )

' slowly rotate the clouds to simulate drift across the sky
IrrAddRotationAnimator( CloudNode, 0, 0.01, 0 )

' we add a terrain to the scene for demonstration purposes, for a detailed
' explaination of the process please refer to example 10
Terrain = IrrAddTerrain( "./media/terrain-heightmap.bmp" )
TerrainNode = Terrain
IrrSetNodeScale( TerrainNode, 40.0, 4.4, 40.0 )
TerrainTexture0 = IrrGetTexture( "./media/terrain-texture.jpg" )
TerrainTexture1 = IrrGetTexture( "./media/detailmap3.jpg" )
IrrSetNodeMaterialTexture( TerrainNode, TerrainTexture0, 0 )
IrrSetNodeMaterialTexture( TerrainNode, TerrainTexture1, 1 )
IrrScaleTexture( Terrain, 1.0, 60.0 )
IrrSetNodeMaterialFlag( TerrainNode, IRR_EMF_LIGHTING, IRR_OFF )
IrrSetNodeMaterialType ( TerrainNode, IRR_EMT_DETAIL_MAP )
IrrSetNodeMaterialFlag( TerrainNode, IRR_EMF_FOG_ENABLE, IRR_ON )

' add a fog to the scene to gently fade the clouds out in the distance
IrrSetFog ( 128,128,255, IRR_EXPONENTIAL_FOG, 0.0,4000.0, 0.5 )

' we add a first person perspective camera to the scene so you can look about
' and move it into the center of the map
Camera = IrrAddFPSCamera
CameraNode = Camera
IrrSetNodePosition( CameraNode, 3942.8, 1102.7, 5113.9 )
'IrrSetNodeRotation( CameraNode, 19, -185.5, 0 )

' the clipping distance of a camera is a distance beyond which no triangles are
' rendered, this speeds the scene up by not showing geometry that is in the
' distance and too small to see however our terrain is so huge we need to
' extend this distance out
IrrSetCameraClipDistance( Camera, 12000 )

IrrAddTestSceneNode

' we also hide the mouse pointer to see the view better
IrrHideMouse

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
WHILE IrrRunning
    ' begin the scene, erasing the canvas with sky-blue before rendering
    IrrBeginScene( 128, 128, 255 )

    IrrGetNodePosition( CameraNode, X, Y, Z )
    TerrainHeight = IrrGetTerrainHeight( TerrainNode, X, Z )+50
    if Y < TerrainHeight THEN
        IrrSetNodePosition( CameraNode, X, TerrainHeight, Z )
    END IF

    ' draw the scene
    IrrDrawScene

    ' end drawing the scene and render it
    IrrEndScene
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
