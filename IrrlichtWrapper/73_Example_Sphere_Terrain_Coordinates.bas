'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 73 : Spherical Terrain Coordinates
'' This example demonstrates converting between grid co-ordinates on a cube and
'' spherical coordinates on a spherical terrain.
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM shared Terrain as irr_terrain
DIM shared TerrainNode as irr_node
DIM shared TerrainTexture as irr_texture
DIM Camera as irr_camera
DIM CameraNode as irr_node
DIM BitmapFont as irr_font
DIM metrics as wstring * 256
DIM Light as irr_node
DIM SkyBox as irr_node
DIM Billboard as irr_node
DIM BillboardTexture as irr_texture

sub AddPlanet( px as single,py as single,pz as single, rx as single,ry as single,rz  as single, col as integer )

    ' add the spherical terrain. this is supplied with six terrain highmaps one for
    ' each of the faces on the cube
    Terrain = IrrAddSphericalTerrain( _
                "./media/simplesphere.bmp", _
                "./media/simplesphere.bmp", _
                "./media/simplesphere.bmp", _
                "./media/simplesphere.bmp", _
                "./media/simplesphere.bmp", _
                "./media/simplesphere.bmp", _
                 px,py,pz,  rx,ry,rz, 6.4,6.4,6.4, _
                 255, 255, 255, 255,  -30, 0, 4, ETPS_17 )

    IrrSetSphericalTerrainTexture( Terrain, _
                IrrGetTexture( "./media/cube_top.jpg" ), _
                IrrGetTexture( "./media/cube_front.jpg" ), _
                IrrGetTexture( "./media/cube_back.jpg" ), _
                IrrGetTexture( "./media/cube_left.jpg" ), _
                IrrGetTexture( "./media/cube_right.jpg" ), _
                IrrGetTexture( "./media/cube_bottom.jpg" ), _
                0 )

    TerrainNode = Terrain
    IrrSetNodeMaterialTexture( TerrainNode, TerrainTexture, 1 )
    IrrScaleSphericalTexture( Terrain, 1.0, 60.0 )
    IrrSetNodeMaterialType ( TerrainNode, IRR_EMT_DETAIL_MAP )
    IrrSetNodeMaterialFlag( TerrainNode, IRR_EMF_LIGHTING, IRR_OFF )

end sub


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 512, 512, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 73: Logical Spherical Terrain Coordinates" )

BitmapFont = IrrGetFont ( "./media/bitmapfont.bmp" )
TerrainTexture = IrrGetTexture( "./media/detailmap-dim.jpg" )

' add a spherical terrain to the scene
AddPlanet( 0,0,0, 0,0,0, 255 )

' add a simple skybox to the scene to represent space
SkyBox = IrrAddSkyBoxToScene( _
        IrrGetTexture("./media/stars.jpg"),_
        IrrGetTexture("./media/stars.jpg"),_
        IrrGetTexture("./media/stars.jpg"),_
        IrrGetTexture("./media/stars.jpg"),_
        IrrGetTexture("./media/stars.jpg"),_
        IrrGetTexture("./media/stars.jpg"))

IrrSetFog ( 255,128,0, IRR_EXPONENTIAL_FOG, 0.0,500.0, 0.5 )
Light = IrrAddLight( IRR_NO_PARENT, 6400,16000,0, 1,1,1, 192200.0 )

' we add a first person perspective camera to the scene so you can look about
' and move it into the center of the map
Camera = IrrAddFPSCamera
CameraNode = Camera
IrrSetNodePosition( CameraNode, 0, 2000, 0 )

' load the texture resource for the billboard
BillboardTexture = IrrGetTexture( "./media/sun.tga" )

' add the billboard to the scene, the first two parameters are the size of the
' billboard in this instance they match the pixel size of the bitmap to give
' the correct aspect ratio. the last three parameters are the position of the
' billboard object
'Billboard = IrrAddBillBoardToScene( 600.0,600.0,  3000.0, 1500.0, 0.0 )
Billboard = IrrAddBillBoardToScene( 600.0,600.0,  0.0, 0.0, 0.0 )

' now we apply the loaded texture to the billboard using node material index 0
IrrSetNodeMaterialTexture( Billboard, BillboardTexture, 0 )

' rather than have the billboard lit by light sources in the scene we can
' switch off lighting effects on the model and have it render as if it were
' self illuminating
IrrSetNodeMaterialFlag( Billboard, IRR_EMF_LIGHTING, IRR_OFF )
IrrSetNodeMaterialType( Billboard, IRR_EMT_TRANSPARENT_ALPHA_CHANNEL )
IrrMaterialSetMaterialTypeParam( IrrGetMaterial( Billboard, 0 ), 0.0001 )


' create a test nodes
DIM TestNode as irr_node
TestNode = IrrAddTestSceneNode
IrrSetNodeMaterialTexture( TestNode, TerrainTexture, 0 )
IrrSetNodeMaterialFlag( TestNode, IRR_EMF_LIGHTING, IRR_OFF )

' the clipping distance of a camera is a distance beyond which no triangles are
' rendered, this speeds the scene up by not showing geometry that is in the
' distance and too small to see however our terrain is so huge we need to
' extend this distance out
IrrSetCameraClipDistance( Camera, 5000 )

' we also hide the mouse pointer to see the view better
IrrHideMouse

DIM X as single : DIM Y as single : DIM Z as single
DIM face as integer : DIM LX as single : DIM LZ as single
' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
WHILE IrrRunning
    ' begin the scene, erasing the canvas with sky-blue before rendering
    IrrBeginScene( 0, 0, 0 )

    ' get the position of the camera
    IrrGetNodePosition( CameraNode, X, Y, Z )
    
    ' translate the camera coordinates into logical coordinates using a face
    ' and an X,Z on that face. This translation is not perfectly accurate yet
    ' I would advise the translation is done at altitude and the difference
    ' blended across as the vehicle decends
    ' the height above the surface can be calculated simply by calculating the
    ' length of the center of the planet to the surface and then the center of
    ' the planet to the space coordinate and subracting the two
    ' the momentum could be calculated by converting two samples and then
    ' measing the difference in height and X and Z on the face
    IrrGetSphericalTerrainLogicalSurfacePosition ( _
            Terrain, X, Y, Z, face, LX, LZ )

    ' get the surface cordinate for placing the test node
    IrrGetSphericalTerrainSurfacePosition ( Terrain, face, LX * 256, LZ* 256, X,Y,Z )
    IrrSetNodePosition( TestNode, X, Y, Z )

    ' draw the scene
    IrrDrawScene

    metrics = "X: "+ Str(LX)+ " Y: "+ Str(LZ)+ " FACE: "+ Str(face)
    Irr2DFontDraw ( BitmapFont, metrics, 4, 4, 250, 24 )

    ' end drawing the scene and render it
    IrrEndScene
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
