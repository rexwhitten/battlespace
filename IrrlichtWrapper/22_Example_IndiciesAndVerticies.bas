'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 22 : Indices and Vertices
'' This example loads a simple mesh from a static direct x object it then
'' gets the list of indices and vertices for the object and manipulates them
'' before writing them back to the mesh. This can be used for getting mesh data
'' for use with other libraries like 'Newton' or for directly manipulating the
'' object
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM DirectXMesh as irr_mesh
DIM MeshTexture as irr_texture
DIM SceneNode as irr_node
DIM OurCamera as irr_camera
DIM index_count as integer
DIM vertex_count as integer
DIM i as integer


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 400, 400, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 22: Indices and Vertices" )

' load a mesh
DirectXMesh = IrrGetMesh( "./media/cube.x" )

' display metric information on the mesh, the number of indices and vertices
index_count = IrrGetMeshIndexCount( DirectXMesh, 0 )
vertex_count = IrrGetMeshVertexCount( DirectXMesh, 0 )
? "Index Count = ";index_count
? "Vertex Count = ";vertex_count

' dimention an array large enough to contain the list of vertices
DIM vertices( 0 to vertex_count ) as IRR_VERT

' copy the vertex information into the array
IrrGetMeshVertices( DirectXMesh, 0, vertices(0))

' itterate through all of the vertices
for i = 0 to vertex_count - 1
    ' display the vertex location in 3D space
    print "Vertex ";str(i);" is at ";str(vertices(i).x);", ";str(vertices(i).y);", ";str(vertices(i).z)

    ' shrink the vertex X location by half its size
    vertices(i).x *= 0.5

    ' change the color of the vertex to a random value
    vertices(i).vcolor = IrrMakeARGB(0, rnd * 255, rnd * 255, rnd * 255)
next i

' copy the altered vertex infomation back to the mesh
IrrSetMeshVertices( DirectXMesh, 0, vertices(0) )

' add the mesh to the scene
SceneNode = IrrAddMeshToScene( DirectXMesh )

' scale the node size up as the origonal mesh is very small
IrrSetNodeScale( SceneNode, 20,20,20 )

' switch on debugging information so that you can see the bounding box around
' the node
IrrDebugDataVisible ( SceneNode, IRR_ON )

' switch off lighting effects on this model
IrrSetNodeMaterialFlag( SceneNode, IRR_EMF_LIGHTING, IRR_OFF )

' add a controllable camera into the scene looking at the object
OurCamera = IrrAddFPSCamera( IRR_NO_OBJECT, 100.0f, 0.1f )
IrrSetNodePosition(OurCamera, 50,0,0)
IrrSetCameraTarget(OurCamera,0,0,0)

IrrHideMouse

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
WHILE IrrRunning
    ' begin the scene, erasing the canvas with sky-blue before rendering
    IrrBeginScene( 0, 0, 0 )

    ' draw the scene
    IrrDrawScene
    
    ' end drawing the scene and render it
    IrrEndScene
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
