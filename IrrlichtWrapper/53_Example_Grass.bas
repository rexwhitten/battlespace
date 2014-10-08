'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 53 : Grass
'' An example of a grass object that is layered over a terrain to create extra
'' detail to a terrain increasing the realism
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
dim terrainHeight as irr_image
dim terrainColor as irr_image
dim grassMap as irr_image
dim grassTexture as irr_texture
dim grassNode as irr_node
dim x as single
dim y as single
dim z as single


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 640, 480, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 53: Grass by G Davidson" )

' allow transparency to write to the z buffer, this is often nessecary to make
' many transparent objects appear in the correct order especially transparent
' objects is opaque elements like grass and leaves, the only consideration is
' that there will be an impact on performance
'IrrTransparentZWrite

' here we create the terrain from a greyscale bitmap where bright pixels are
' high points and black pixels are low points. the command generates the mesh
' and automatically adds it as a node to the scene
Terrain = IrrAddTerrain( "./media/terrain-heightmap.bmp" )

' the node is too small to be a proper terrain so we get the node object of the
' terrain and scale its size up 40 times along the X and Z axis and just 4 times
' along the Y axis
TerrainNode = Terrain
IrrSetNodeScale( TerrainNode, 40.0, 2.4, 40.0 )

' we load two textures in to apply to the terrain node
TerrainTexture0 = IrrGetTexture( "./media/terrain-texture.jpg" )
TerrainTexture1 = IrrGetTexture( "./media/detailmap3.jpg" )

' set up the terrain node with textures lighting
IrrSetNodeMaterialTexture( TerrainNode, TerrainTexture0, 0 )
IrrSetNodeMaterialTexture( TerrainNode, TerrainTexture1, 1 )
IrrScaleTexture( Terrain, 1.0, 60.0 )
IrrSetNodeMaterialFlag( TerrainNode, IRR_EMF_LIGHTING, IRR_OFF )
IrrSetNodeMaterialType ( TerrainNode, IRR_EMT_DETAIL_MAP )
IrrSetNodeMaterialFlag( TerrainNode, IRR_EMF_FOG_ENABLE, IRR_ON )

' load the textures and images for that node
terrainHeight = IrrGetImage( "./media/terrain-heightmap.bmp" )
terrainColor = IrrGetImage( "./media/terrain-texture.jpg" )
grassMap = IrrGetImage( "./media/terrain-grassmap.bmp" )
grassTexture = IrrGetTexture( "./media/grass.png" )

' we add the grass in as 100 seperate patches, these could even be grouped
' under a set of zone managers to make them more efficient
for x = 0 to 3
    for y = 0 to 3
        ' here we add the grass object, it has the following parameters: -
        ' a terrain onto which the grass layered,
        ' an x and y tile coordinate for the patch (multiplied by the patch size)
        ' a size for the patch
        ' the distance in patches upto which all blades of grass are drawn
        ' whether pairs of grass are aligned in a cross IRR_ON to enable
        ' a scale for the grass height
        ' the height map associated with the terrain used for setting grass height
        ' the texture map associated with the terrain used for coloring the grass
        ' a grass map defining the types of grass placed onto the terrain
        ' a texture map containing the images of the grass
        grassNode = IrrAddGrass ( _
                                Terrain, _
                                x, y, _
                                1100*3, _
                                2.0, _
                                IRR_OFF, _
                                1.0, _
                                250, 0, 0, _
                                terrainHeight, terrainColor, _
                                grassMap, grassTexture )
                                
        ' here we set how much grass is visible firstly the number of grass
        ' particles that can be seen and secondly the distance upto which they
        ' are drawn
        IrrSetGrassDensity ( grassNode, 300, 4000 )
        
        ' here we set the wind effect on the grass, first parameter sets the
        ' strength of the wind and the second the resoloution
        IrrSetGrassWind ( grassNode, 3.0, 1.0 )
        
        IrrSetNodeMaterialFlag( grassNode, IRR_EMF_LIGHTING, IRR_OFF )
        IrrSetNodeMaterialFlag( grassNode, IRR_EMF_FOG_ENABLE, IRR_ON )
    next y
next x
        
' now we need to add the fog to the scene
IrrSetFog ( 64,100,128, IRR_EXPONENTIAL_FOG, 0.0,4000.0, 0.5 )


' we add a first person perspective camera to the scene so you can look about
' and move it into the center of the map
Camera = IrrAddFPSCamera
CameraNode = Camera
IrrSetNodePosition( CameraNode, 3942.0, 650.0, 5113.0 )
IrrSetNodeRotation( CameraNode, 19, -185.5, 0 )

' the clipping distance of a camera is a distance beyond which no triangles are
' rendered
IrrSetCameraClipDistance( Camera, 12000 )

' we also hide the mouse pointer to see the view better
IrrHideMouse

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
WHILE IrrRunning
    ' begin the scene, erasing the canvas with sky-blue before rendering
'    IrrBeginScene( 240, 255, 255 )
    IrrBeginScene( 64, 100, 125 )

    IrrGetNodePosition( CameraNode, x, y, z )
    y = IrrGetTerrainTileHeight( Terrain, x, z )
    IrrSetNodePosition( CameraNode, x, y+160, z )

    ' draw the scene
    IrrDrawScene

    ' end drawing the scene and render it
    IrrEndScene
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
