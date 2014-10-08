'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 54 : Colored Skydomes
'' This example creates a colored skydome onto which a low color texture could
'' be displayed, the skydome can be recolored over time if you wish and can
'' represent different times of the day without the need for large numbers of
'' sky backdrops
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
DIM SkyDome as irr_node


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 800, 600, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 54: Colored Skydomes" )

' Here we create a terrain, for a detailed explaination of the process please
' refer to example 10
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

' add some fog into the scene
IrrSetFog ( 96,96,128, IRR_EXPONENTIAL_FOG, 0.0,4000.0, 0.5 )


' the skydome is a simple hollow sphere that surrounds the whole scene. a single
' texture is applied to the entire surface of the sphere. Portions of the sphere
' can be rendered to optimise the performance of the scene
SkyDome = IrrAddSkyDomeToScene( _
        IrrGetTexture("./media/skydome.jpg"), _
        32, 16, 1.0, 1.2 )

' here we color the dome the first 3 RGB values set the color of the horizon,
' the second set of RGB values set the color of the zenith of the dome
IrrSetSkyDomeColor( SkyDome, 128, 128, 255,  64, 64, 255 )

' here we add an addition yellowed band of color onto the dome, the first three
' parameters are the color, followed by the vertical vertex number of the center
' of the band, next the amount the band will be faded 1.0 is not at all, and
' the final IRR_ON parameter means that the color will be added to the existing
' color a value of IRR_OFF epecifies that the color will replace the existing
' color
IrrSetSkyDomeColorBand ( SkyDome, 240,220,128, 24, 0.25, IRR_ON )

' here we add a point of light to the dome, this is useful for representing the
' sun or the moon glaring in the atmosphere, the first three parameters are the
' color of the light, the next three are the x,y,z position of the light, the
' next parameter is the radius of the light effect, this is followed by how much
' the effect is faded a value of 1.0 is not at all, finally IRR_ON as above
' means that the color effect will be added to the existing color on the dome
IrrSetSkyDomeColorPoint ( SkyDome, 255,220,96, 1000.0, -250.0, 0.0, 1500.0, 0.75, IRR_ON )


' we add a first person perspective camera to the scene so you can look about
' and move it into the center of the map
Camera = IrrAddFPSCamera
CameraNode = Camera
IrrSetNodePosition( CameraNode, 3942.8, 1102.7, 5113.9 )
IrrSetNodeRotation( CameraNode, 19, -185.5, 0 )

' the clipping distance of a camera is a distance beyond which no triangles are
' rendered, this speeds the scene up by not showing geometry that is in the
' distance and too small to see however our terrain is so huge we need to
' extend this distance out
IrrSetCameraClipDistance( Camera, 12000 )

' we also hide the mouse pointer to see the view better
IrrHideMouse

DIM X as single
DIM Y as single
DIM Z as single
' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
WHILE IrrRunning
    ' begin the scene, erasing the canvas with sky-blue before rendering
    IrrBeginScene( 192, 192, 255 )

    IrrGetNodePosition( CameraNode, X, Y, Z )
    Y = IrrGetTerrainTileHeight( Terrain, X, Z )
    IrrSetNodePosition( CameraNode, X, Y+80, Z )

    ' draw the scene
    IrrDrawScene

    ' end drawing the scene and render it
    IrrEndScene
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
