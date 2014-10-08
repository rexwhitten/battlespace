'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 63 : Terrain Tile Splatter
'' This example applies a texture to a terrain that uses a form of texture
'' spattering, several greyscale textures are stored in the color channels of
'' the detail texture and can be mixed onto the terrain by setting the vertex
'' color of the terrain more red in the vertex will add more of the greyscale
'' texture stored in the red channel of the detail texture for example
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
DIM heightMap as irr_image
DIM colorMap as irr_image
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
IrrSetWindowCaption( "Example 63: Terrain Tile Splatter" )

' load the terrain textures
TerrainTexture0 = IrrGetTexture( "./media/splatter.tga" )
TerrainTexture1 = IrrGetTexture( "./media/splatter-color.tga" )

' load the heighmap for the terrain object, this is an image file that is not
' stored in video card memory
heightMap = IrrGetImage( "./media/splatter-height.tga" )

' load a color map used to coloring the verticies, this again is an image file
' that is not stored in video memory
colorMap = IrrGetImage( "./media/splatter-detail.tga" )

' here we create the terrain from a greyscale bitmap
Terrain = IrrAddTerrainTile( heightMap, TILE_SIZE, 0, 0 )
IrrSetTileColor( Terrain, colorMap )
TerrainNode = Terrain
IrrSetNodeScale( TerrainNode, 40.0, 4.4, 40.0 )
IrrSetNodeMaterialTexture( TerrainNode, TerrainTexture0, 0 )
IrrSetNodeMaterialTexture( TerrainNode, TerrainTexture1, 1 )
IrrScaleTileTexture( Terrain, 64.0, 1.0 )
IrrSetNodeMaterialFlag( TerrainNode, IRR_EMF_FOG_ENABLE, IRR_ON )

' as the vertex color is used for mixing in the channels of the texture the
' spattered object cannot support lighting and the lighting needs to be baked
' into the color map
IrrSetNodeMaterialFlag( TerrainNode, IRR_EMF_LIGHTING, IRR_OFF )

' the four detail map is the meterial type used for texture spattering
IrrSetNodeMaterialType ( TerrainNode, IRR_EMT_FOUR_DETAIL_MAP )

' now we need to add the fog to the scene.
IrrSetFog ( 240,255,255, IRR_EXPONENTIAL_FOG, 0.0,4000.0, 0.5 )

' we add a first person perspective camera to the scene so you can look about
' and move it into the center of the map
Camera = IrrAddFPSCamera
CameraNode = Camera
IrrSetNodePosition( CameraNode, 1200.0, 1750.0, 1200.0 )

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
