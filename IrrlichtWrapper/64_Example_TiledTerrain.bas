'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 64 : Tiled Terrain
'' This example creates a tiled terrain these are vast terrain objects that are
'' generated from tiles that are moved around out of sight of the viewer.
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM Terrain( 0 to 3) as irr_terrain
DIM Zone(0 to 15) as irr_node
DIM TerrainNode as irr_node
DIM Camera as irr_camera
DIM CameraNode as irr_node

DIM TerrainTexture0 as irr_texture
DIM TerrainTexture1 as irr_texture
DIM heightMap as irr_image
DIM colorMap as irr_image

dim I as integer
dim J as integer
dim index as integer
dim X as single
dim Y as single
dim Z as single


#define TILE_SIZE 128

'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 800, 600, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 64: Tiled Terrain" )

TerrainTexture0 = IrrGetTexture( "./media/terrain-texture.jpg" )
TerrainTexture1 = IrrGetTexture( "./media/detailmap3.jpg" )

heightMap = IrrGetImage( "./media/terrain-heightmap.bmp" )
colorMap = IrrGetImage( "./media/terrain-texture.jpg" )

' Create four terrain tiles that are moved across the grid of zones
for I = 0 to 3
    ' here we create the terrain from a greyscale bitmap
    Terrain(I) = IrrAddTerrainTile( heightMap, TILE_SIZE, 0, 0 )
    TerrainNode = Terrain(I)
    IrrSetNodeScale( TerrainNode, 40.0, 0.5, 40.0 )
    IrrSetNodeMaterialTexture( TerrainNode, TerrainTexture0, 1 )
    IrrSetNodeMaterialTexture( TerrainNode, TerrainTexture1, 0 )
    IrrScaleTileTexture( Terrain(I), 64.0, 1.0 )
    IrrSetNodeMaterialFlag( TerrainNode, IRR_EMF_LIGHTING, IRR_OFF )
    IrrSetNodeMaterialType ( TerrainNode, IRR_EMT_DETAIL_MAP )
    IrrSetNodeMaterialFlag( TerrainNode, IRR_EMF_FOG_ENABLE, IRR_ON )
    
    ' debugging is disabled, the skeleton flag on a terrain tile shows the
    ' attached patches and can be useful in telling if your patches are
    ' attached correctly
'    IrrDebugDataVisible( TerrainNode, EDS_SKELETON )
next I

' a terrain is a huge object, even a small 128 x 128 terrain has over 16,000
' faces to reduce this number a terrain displays less detail in the distance by
' skipping over points. when arranging terrains edge to edge to form a larger
' sheet you have to attach these terrains at the edges so that they can match
' the number of points they skip with their neighbour otherwise cracks will
' become visible at the seam between the terrains
IrrAttachTile( Terrain(0), Terrain(2), RIGHT_EDGE )
IrrAttachTile( Terrain(0), Terrain(2), LEFT_EDGE )
IrrAttachTile( Terrain(0), Terrain(1), BOTTOM_EDGE )
IrrAttachTile( Terrain(0), Terrain(1), TOP_EDGE )

IrrAttachTile( Terrain(1), Terrain(3), RIGHT_EDGE )
IrrAttachTile( Terrain(1), Terrain(3), LEFT_EDGE )
IrrAttachTile( Terrain(1), Terrain(0), BOTTOM_EDGE )
IrrAttachTile( Terrain(1), Terrain(0), TOP_EDGE )

IrrAttachTile( Terrain(2), Terrain(0), RIGHT_EDGE )
IrrAttachTile( Terrain(2), Terrain(0), LEFT_EDGE )
IrrAttachTile( Terrain(2), Terrain(3), BOTTOM_EDGE )
IrrAttachTile( Terrain(2), Terrain(3), TOP_EDGE )

IrrAttachTile( Terrain(3), Terrain(1), RIGHT_EDGE )
IrrAttachTile( Terrain(3), Terrain(1), LEFT_EDGE )
IrrAttachTile( Terrain(3), Terrain(2), BOTTOM_EDGE )
IrrAttachTile( Terrain(3), Terrain(2), TOP_EDGE )

' the terrain is to be arranged as depicted in the diagram below, a grid of 
' 16 zones is created and one of the four terrain objects is assigned to each
' of the zones in a tiled pattern. as the camera moves into the range of one of
' the zones it takes the terrain it has been assigned from the zone that
' is using it, moves it into its own position and loads it with the terrain
' details it has been assigned
'|---|---|---|---|
'| 2 | 3 | 2 | 3 |
'|---|---|---|---|
'| 0 | 1 | 0 | 1 |
'|---|---|---|---|
'| 2 | 3 | 2 | 3 |
'|---|---|---|---|
'| 0 | 1 | 0 | 1 |
'|---|---|---|---|
' this zone grid can be extended out to form vast terrains that still only use
' 4 terrain objects.
for J = 0 to 3
    for I = 0 to 3
        Zone(I+J*4) = IrrAddZoneManager(0, 112*40)
        IrrSetNodePosition( Zone(I+J*4), I * 112*40, 0, J * 112*40 )

        if I MOD 2 = 0 THEN index = 0 ELSE index = 1
        if J MOD 2 = 1 THEN index += 2
        IrrSetZoneManagerAttachTerrain ( Zone(I+J*4), Terrain(index), _
                "./media/simpletile.tga", IRR_NO_OBJECT, IRR_NO_OBJECT, 0, 0, 32 )
    next I
next J

'heightMap = IrrGetImage( "./media/terrain2.bmp" )
'IrrSetTileStructure( Terrain, heightMap )

IrrAddLight( IRR_NO_PARENT, 0, 1000, 1500, 1.0, 1.0, 1.0, 160000.0 )

' now we need to add the fog to the scene. the first three parameters are the
' fog color, we set this to the same color as our sky so the scene fogs out
' nicely into nothing, the next parameter specifies whether you want the fog
' to increase in a linear mannar or exponentially - exponential fog usually
' looks more atmospheric while linear looks more like a dense sea fog, the next
' two parameters specify the distance at which the fog starts and the distance
' at which the fog reaches its maximum density and finally the fog density -
' this is only used with exponential fog and determines how quickly the
' exponential change takes place
IrrSetFog ( 240,255,255, IRR_EXPONENTIAL_FOG, 0.0,2240.0, 0.5 )


' we add a first person perspective camera to the scene so you can look about
' and move it into the center of the map
Camera = IrrAddFPSCamera
CameraNode = Camera
'IrrSetNodePosition( CameraNode, 3942.8, 1102.7, 5113.9 )
'IrrSetNodeRotation( CameraNode, 19, -185.5, 0 )
IrrSetNodePosition( CameraNode, 2500.0, 250.0, 2500.0 )
'IrrSetNodeRotation( CameraNode, 180, 0, 0 )

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

'    IrrGetNodePosition( CameraNode, X, Y, Z )
'    Y = IrrGetTerrainTileHeight( Terrain, X, Z )
'    IrrSetNodePosition( CameraNode, X, Y+80, Z )
    
    ' draw the scene
    IrrDrawScene

    ' end drawing the scene and render it
    IrrEndScene
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
