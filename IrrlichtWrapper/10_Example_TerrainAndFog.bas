'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 10 : Terrain and Fog
'' This example creates a terrain from a bitmap heightfield and displays it in
'' a foggy scene
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


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 800, 600, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 10: Terrain and Fog" )

' here we create the terrain from a greyscale bitmap where bright pixels are
' high points and black pixels are low points. the command generates the mesh
' and automatically adds it as a node to the scene
'Terrain = IrrAddTerrain( "./media/terrain-heightmap.bmp" )
'Terrain = IrrAddTerrain( "./media/heightmap_tmp.jpg" )
'Terrain = IrrAddTerrain( "./media/200px-Heightmap.jpg" )
Terrain = IrrAddTerrain( "./media/terrain-heightmap.bmp" )

' the node is too small to be a proper terrain so we get the node object of the
' terrain and scale its size up 40 times along the X and Z axis and just 4 times
' along the Y axis
TerrainNode = Terrain
IrrSetNodeScale( TerrainNode, 40.0, 4.4, 40.0 )

' we load two textures in to apply to the terrain node
TerrainTexture0 = IrrGetTexture( "./media/terrain-texture.jpg" )

TerrainTexture1 = IrrGetTexture( "./media/detailmap3.jpg" )

' the first texture is a color texture that is applied across the entire
' surface of the map. this needs to be a fairly high resoloution as the map is
' very large now
IrrSetNodeMaterialTexture( TerrainNode, TerrainTexture0, 0 )

' the second texture is tiled many times across the map this adds fine detail
' and structure to the first enlarged terain color
IrrSetNodeMaterialTexture( TerrainNode, TerrainTexture1, 1 )

' we set the scale of the detail map so its repeated 20 times across the map in
' the x and y axis
IrrScaleTexture( Terrain, 1.0, 60.0 )

' finally we apply some material texuring effects to the node
' the terrain is self illuminating
IrrSetNodeMaterialFlag( TerrainNode, IRR_EMF_LIGHTING, IRR_OFF )
' the material type is detail type. this type applies the first texture across
' the entire node and then scales and applies the second texture across the node
' there are many different material types you can set, these can be found in the
' .bi definition file, experiment with them
IrrSetNodeMaterialType ( TerrainNode, IRR_EMT_DETAIL_MAP )

' finally we switch on fog for this material so that this terrain will fade out
' into a fog in the distance
IrrSetNodeMaterialFlag( TerrainNode, IRR_EMF_FOG_ENABLE, IRR_ON )

' now we need to add the fog to the scene. the first three parameters are the
' fog color, we set this to the same color as our sky so the scene fogs out
' nicely into nothing, the next parameter specifies whether you want the fog
' to increase in a linear mannar or exponentially - exponential fog usually
' looks more atmospheric while linear looks more like a dense sea fog, the next
' two parameters specify the distance at which the fog starts and the distance
' at which the fog reaches its maximum density and finally the fog density -
' this is only used with exponential fog and determines how quickly the
' exponential change takes place
IrrSetFog ( 240,255,255, IRR_EXPONENTIAL_FOG, 0.0,4000.0, 0.5 )


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
