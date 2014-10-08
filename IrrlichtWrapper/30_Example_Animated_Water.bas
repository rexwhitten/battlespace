'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 30 : Animated Water Effect
'' This example creates an animated water effect that is applied to a flat
'' hillplane object. The effect alters the surface of the mesh in a manner that
'' simulates waves on water
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM Terrain as irr_terrain
DIM TerrainNode as irr_node
DIM TerrainTexture as irr_texture
DIM Camera as irr_camera
DIM CameraNode as irr_node
DIM WaterMesh as irr_mesh
DIM WaterNode as irr_node


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 640, 480, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 30: Animated Water Effect" )


' add a hill plane mesh to the mesh pool
WaterMesh = IrrAddHillPlaneMesh( "HillPlane", 8.0, 8.0, 32, 32,  0,  0.0, 4, 3, 8, 8 )

' add a scene node for rendering an animated water surface mesh
WaterNode = IrrAddWaterSurfaceSceneNode( WaterMesh )

' we load two textures in to apply to the terrain node
TerrainTexture = IrrGetTexture( "./media/water.png" )

' the first texture is a color texture that is applied across the entire
' surface of the map. this needs to be a fairly high resoloution as the map is
' very large now
IrrSetNodeMaterialTexture( WaterNode, TerrainTexture, 0 )

' finally we apply some material texuring effects to the node
' the water is self illuminating
IrrSetNodeMaterialFlag( WaterNode, IRR_EMF_LIGHTING, IRR_OFF )

' the sphere map material type gives a shiny effect appropriate for a
' water surface
IrrSetNodeMaterialType ( WaterNode, IRR_EMT_SPHERE_MAP )

' we add a first person perspective camera to the scene so you can look about
' and move it into the center of the map
Camera = IrrAddFPSCamera
CameraNode = Camera
IrrSetNodePosition( CameraNode, 0, 25, 0 )

' we also hide the mouse pointer to see the view better
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
    EndIf
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
