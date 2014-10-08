'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 94 : Bump Mapping
'' This example loads in a Mesh Model and then then textures it using a bump
'' mapping technique called Normal Mapping. To see this effect your graphics
'' card will need to support pixel and vertex shaders version 1.1
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM ModelMesh as irr_mesh
DIM DiffuseTexture as irr_texture
DIM BumpTexture as irr_texture
DIM SceneNodeNormal as irr_node
DIM SceneNodeParallax as irr_node
DIM OurCamera as irr_camera
DIM Light as irr_node


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 512, 384, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' set the window caption
IrrSetWindowCaption( "Example 94: Bump Mapping" )

' load a mesh this acts as a blue print for the model
ModelMesh = IrrGetMesh( "./media/sphere.obj" )

' the mesh is quite small so scale it up without effecting lighting
IrrScaleMesh( ModelMesh, 12.5 )

' load texture resources for texturing the scene node
DiffuseTexture = IrrGetTexture( "./media/water.png" )
BumpTexture = IrrGetTexture( "./media/earthbump.bmp" )

' convert the grey scale image into a normal mapping texture. if you wish you
' can create your own normal mapping texture but it is often simpler to create
' a simple greyscale image as a bump map that defines the height of the surface
IrrMakeNormalMapTexture( BumpTexture, 9.0 )

' add the mesh to the scene twice to display two types of bump mapping effects
' the mesh is added with a special command that creates a model with lighting
' information embedded into it this is required for bump mapping
SceneNodeNormal = IrrAddStaticMeshForNormalMappingToScene( ModelMesh )
IrrSetNodePosition( SceneNodeNormal, 0, 0, -15 )
SceneNodeParallax = IrrAddStaticMeshForNormalMappingToScene( ModelMesh )
IrrSetNodePosition( SceneNodeParallax, 0, 0, 15 )

' apply a material to the node to give its surface color
IrrSetNodeMaterialTexture( SceneNodeNormal, DiffuseTexture, 0 )
IrrSetNodeMaterialTexture( SceneNodeNormal, BumpTexture, 1 )
IrrSetNodeMaterialTexture( SceneNodeParallax, DiffuseTexture, 0 )
IrrSetNodeMaterialTexture( SceneNodeParallax, BumpTexture, 1 )

' Bump mapping is pointless unless lighting in enabled. we set the materials on
' one of the nodes to Normal Mapping and on the other to Parallax mapping.
' parallax mapping gives a richer deeping bump mapping effect but does require
' a more modern graphics card
IrrSetNodeMaterialType ( SceneNodeNormal, IRR_EMT_NORMAL_MAP_SOLID )
IrrSetNodeMaterialType ( SceneNodeParallax, IRR_EMT_PARALLAX_MAP_SOLID )
IrrSetNodeMaterialFlag( SceneNodeNormal, IRR_EMF_LIGHTING, IRR_ON )
IrrSetNodeMaterialFlag( SceneNodeParallax, IRR_EMF_LIGHTING, IRR_ON )

' add a camera into the scene
OurCamera = IrrAddCamera( 40,0,0, 0,0,0 )

' finally we need to add a light into the scene. bump mapping requires a
' dynamic light to create the bump mapping effect. additionally the lights need
' to be animated to show the changing light on the surface.
Light = IrrAddLight( IRR_NO_PARENT, 100,100,-100, 0.9,0.3,0.3, 600.0 )
IrrAddFlyCircleAnimator( Light, 0,0,0, 100, 0.001 )

' hide the mouse pointer away
IrrHideMouse

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
Dim as Single frameTime = timer + 0.0167
WHILE IrrRunning
    ' is it time for another frame
    if timer > frameTime then
        ' calculate the time the next frame starts
        frameTime = timer + 0.0167

        ' begin the scene, erasing the canvas with sky-blue before rendering
        IrrBeginScene( 0, 0, 0 )
    
        ' draw the scene
        IrrDrawScene
    
        ' end drawing the scene and render it
        IrrEndScene
    End If
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
