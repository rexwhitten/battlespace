'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 15 : Custom Mesh
'' This example creates a pyramid mesh that is set up ready to be textured
'' it then adds the mesh as a new node and applies a material to it
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM Mesh as irr_mesh
DIM MeshTexture as irr_texture
DIM SceneNode as irr_node
DIM OurCamera as irr_camera


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 400, 400, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' set the window caption
IrrSetWindowCaption( "Example 15: Create a custom mesh" )

' a mesh is created from an array of types called vertices that define a point
' in space. and an array of indices to these vertices that are grouped into
' threes to create triangles that form the mesh
DIM verts(0 to 4) as IRR_VERT
DIM indices(0 to 17) as ushort

' -----------------------------------------------------------------------------
' set up five vertices to define the points of a pyramid. the vertices have
' many properties that need to be set up to properly define the structure
verts(0).x = -10 : verts(0).y = 0 : verts(0).z = -10
verts(1).x = -10 : verts(1).y = 0 : verts(1).z = 10
verts(2).x = 10 : verts(2).y = 0 : verts(2).z = 10
verts(3).x = 10 : verts(3).y = 0 : verts(3).z = -10
verts(4).x = 0 : verts(4).y = 20 : verts(4).z = 0

' the co-ordinates across a texture run from 0 to 1 so we place each of the
' vertices on this texture plane to appear as if the pyramid was painted from
' its bottom up
verts(0).texture_x = 0 : verts(0).texture_y = 0
verts(1).texture_x = 0 : verts(1).texture_y = 1
verts(2).texture_x = 1 : verts(2).texture_y = 1
verts(3).texture_x = 1 : verts(3).texture_y = 0
verts(4).texture_x = 0.5 : verts(4).texture_y = 0.5

' each of the vertices can be assigned a colour to tint the texture, in this
' case we use white
verts(0).vcolor = &h00FFFFFF
verts(1).vcolor = &h00FFFFFF
verts(2).vcolor = &h00FFFFFF
verts(3).vcolor = &h00FFFFFF
verts(4).vcolor = &h00FFFFFF

' -----------------------------------------------------------------------------
' create the faces, this is an array of indices referencing the vectors they
' are collected into groups of three each defining a triangle in the mesh
indices(0) = 0 : indices(1) = 1 : indices(2) = 4
indices(3) = 1 : indices(4) = 2 : indices(5) = 4
indices(6) = 2 : indices(7) = 3 : indices(8) = 4
indices(9) = 3 : indices(10) = 0 : indices(11) = 4
indices(12) = 2 : indices(13) = 1 : indices(14) = 0
indices(15) = 0 : indices(16) = 3 : indices(17) = 2

' create the mesh from the array of vertices and indices
Mesh = IrrCreateMesh( "TestMesh", 5, verts(0), 18, indices(0))

' load texture resource for texturing the nodes
MeshTexture = IrrGetTexture( "./media/texture.jpg" )

' add the mesh to the scene a couple of times
SceneNode = IrrAddMeshToScene( Mesh )

' apply a material to the node
IrrSetNodeMaterialTexture( SceneNode, MeshTexture, 0 )

' switch off lighting effects on this node
IrrSetNodeMaterialFlag( SceneNode, IRR_EMF_LIGHTING, IRR_OFF )

' add a camera into the scene and resposition it to look at the pyramid
OurCamera = IrrAddFPSCamera( IRR_NO_OBJECT, 100.0f, 0.1f )
IrrSetNodePosition( OurCamera, 30,50,25)
IrrSetCameraTarget(OurCamera, 0,0,0)
IrrHideMouse


' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
WHILE IrrRunning
    ' begin the scene, erasing the canvas with sky-blue before rendering
    IrrBeginScene( 64, 96, 96 )

    ' draw the scene
    IrrDrawScene
    
    ' end drawing the scene and render it
    IrrEndScene
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
