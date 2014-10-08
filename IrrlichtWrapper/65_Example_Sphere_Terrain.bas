'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 65 : Spherical Terrain
'' This example creates a spherical terrain by attaching six terrain objects
'' together in a cube and then applying a spherical distortion to the terrains.
'' the six textures applied to the terrain sphere need to be carefully
'' constructed so that they are properly applied.
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM shared Terrain as irr_terrain
DIM shared TerrainNode as irr_node
DIM shared TerrainTexture0 as irr_texture
DIM shared TerrainTexture1 as irr_texture
DIM Camera as irr_camera
DIM CameraNode as irr_node
DIM BitmapFont as irr_font
DIM metrics as string
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
    TerrainNode = Terrain
    IrrSetNodeMaterialTexture( TerrainNode, TerrainTexture0, 0 )
    IrrSetNodeMaterialTexture( TerrainNode, TerrainTexture1, 1 )
    IrrScaleSphericalTexture( Terrain, 1.0, 60.0 )
    IrrSetNodeMaterialType ( TerrainNode, IRR_EMT_DETAIL_MAP )

end sub


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 640, 480, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 65: Spherical Terrain" )

BitmapFont = IrrGetFont ( "./media/bitmapfont.bmp" )
TerrainTexture0 = IrrGetTexture( "./media/terrain-texture.jpg" )
TerrainTexture1 = IrrGetTexture( "./media/detailmap-dim.jpg" )

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
'IrrSetAmbientLight( 0.1, 0.1, 0.1 )


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
Billboard = IrrAddBillBoardToScene( 600.0,600.0,  3000.0, 1500.0, 0.0 )

' now we apply the loaded texture to the billboard using node material index 0
IrrSetNodeMaterialTexture( Billboard, BillboardTexture, 0 )

' rather than have the billboard lit by light sources in the scene we can
' switch off lighting effects on the model and have it render as if it were
' self illuminating
IrrSetNodeMaterialFlag( Billboard, IRR_EMF_LIGHTING, IRR_OFF )
IrrSetNodeMaterialType( Billboard, IRR_EMT_TRANSPARENT_ALPHA_CHANNEL )
IrrMaterialSetMaterialTypeParam( IrrGetMaterial( Billboard, 0 ), 0.0001 )




' the clipping distance of a camera is a distance beyond which no triangles are
' rendered, this speeds the scene up by not showing geometry that is in the
' distance and too small to see however our terrain is so huge we need to
' extend this distance out
IrrSetCameraClipDistance( Camera, 500000 )

' we also hide the mouse pointer to see the view better
IrrHideMouse

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
WHILE IrrRunning
    ' begin the scene, erasing the canvas with sky-blue before rendering
    IrrBeginScene( 0, 0, 0 )

    ' draw the scene
    IrrDrawScene

    metrics = "Example 65: Spherical Terrain ("+str(IrrGetFPS)+") fps ("+Str(IrrGetPrimitivesDrawn)+" Polygons)"
    IrrSetWindowCaption( metrics )

'    metrics = "PRIMS: "+ Str(IrrGetPrimitivesDrawn)
'    Irr2DFontDraw ( BitmapFont, metrics, 4, 4, 250, 24 )

    ' end drawing the scene and render it
    IrrEndScene
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
'sleep
