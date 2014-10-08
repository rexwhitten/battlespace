'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' IrrlichtNewton functions by SiskinEDGE (2009)
'' Example by Frank Dodd (2009)
'' ----------------------------------------------------------------------------
'' Example 79: Newton collision
'' This example loads a BSP map from a pk3 archive and converts it into a newton
'' object that can be collided against. It then creates two cube objects from a
'' loaded mesh and adds them to the scene before running the simulation so the
'' objects can move and colide under their own power.
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"
#include "IrrlichtNewtonGamePhysics.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht and newton objects
DIM Camera as irr_camera

DIM MapMesh as irr_mesh
DIM MapNode as irr_node
DIM MapPhysics as NewtonSceneObject

DIM CubeTexture as irr_texture
DIM CubeMesh as irr_mesh
DIM CubeANode as irr_node
DIM CubeBNode as irr_node
DIM CubeAPhysics as NewtonSceneObject
DIM CubeBPhysics as NewtonSceneObject


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 800, 400, IRR_BITS_PER_PIXEL_32,_
        IRR_WINDOWED, IRR_NO_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' start the newton world
NewtonStartPhysics

' send the window caption
IrrSetWindowCaption( "Example 79: Newton Collision" )

' first we add the pk3 archive to our filing system. once we have done this
' we can open any of the files in the archive as if they were in the current
' working directory
IrrAddZipFile( "./media/map-20kdm2.pk3", IRR_IGNORE_CASE, IRR_IGNORE_PATHS )

' load the BSP map from the archive as a mesh object. any polygons in the mesh
' that do not have textures will be removed from the scene!
MapMesh = IrrGetMesh( "20kdm2.bsp" )

' add the map to the scene as a node. when adding the mesh this call uses a 
' mechanism called an octtree that if very efficient at rendering large amounts
' of complex geometry most of which cant be seen, using this call for maps
' will greatly improve your framerates
MapNode = IrrAddMeshToSceneAsOcttree( MapMesh )

' set the position of the map. the 20kdm2 map in particular is not based around
' the origon it is offset quite a distance away from 0,0,0 this repositions it
' back to the center.
MapPhysics.Position.x = -1450.0
MapPhysics.Position.y = -149.0
MapPhysics.Position.z = -1369.0

' add the map to the newton world. the map is added as a mesh object that is a
' complex collection of polygons, interiors, concave and convex angles.
' basically it is a set of surfaces suitable for colliding things against but
' not for representing a moving object
NewtonAddMeshObject( @MapPhysics, MapMesh, MapNode, 10.0 )

' set the size of the newton world using the bounding box of the map to define
' its size. this is also another reason we centered the map back to the origon
' earlier. it appears that the size of the newton world has to be centered
' around the origon otherwise the physics will not operate.
NewtonSizeWorld( @MapPhysics )


' load a texture resource for texturing our boxes
CubeTexture = IrrGetTexture( "./media/default_texture.png" )

' load the mesh representing the boxes
CubeMesh = IrrGetMesh( "./media/WoodCrate01.obj" )

' add a couple of boxes to the scene
CubeANode = IrrAddMeshToScene( CubeMesh )
CubeBNode = IrrAddMeshToScene( CubeMesh )

' texture and light the first box
IrrSetNodeMaterialTexture( CubeANode, CubeTexture, 0)
IrrSetNodeMaterialFlag( CubeANode, IRR_EMF_LIGHTING, IRR_OFF )

' texture and light the second box
IrrSetNodeMaterialTexture( CubeBNode, CubeTexture, 0)
IrrSetNodeMaterialFlag( CubeBNode, IRR_EMF_LIGHTING, IRR_OFF )

' Position the first box in the newton world
CubeAPhysics.Position.x = 0.0
CubeAPhysics.Position.y = 300.0
CubeAPhysics.Position.z = 0.0
CubeAPhysics.Angle.x = 9.7

' Add the first cube to the newton world as a simple convex object, this type
' of object must be convex like a ball or a cube, it can not have concave
' angles like a cross. the object is also assigned a weight, 10.0 in this case,
' the weight of the object will determine how it reacts with other objects in
' the environment
NewtonAddConvexObject( @CubeAPhysics, CubeMesh, CubeANode, 10.0 )

' Position the second box in the newton world
CubeBPhysics.Position.x = 4.0
CubeBPhysics.Position.y = 200.0
CubeBPhysics.Position.z = 4.0
CubeAPhysics.Angle.x = -4.7

' Add the second cube to the newton world
NewtonAddConvexObject( @CubeBPhysics, CubeMesh, CubeBNode, 10.0 )


' add a simple camera into the scene looking at a point where some action is
' going to occur
Camera = IrrAddCamera( -100,0,0, 0,-50,0)

' hide the mouse pointer
IrrHideMouse

nWorldUserData.Gravity.y = -60.0

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running and for no more than 10 seconds
Dim startTime as single = Timer
Dim currentTime as single = 0.0
Dim lastTime as single = 0.0
Dim frameCount as integer = 0
Dim as single X, Y, Z

WHILE IrrRunning AND ( currentTime - startTime ) < 10.0
    
    ' get the current time so we can control the speed of the simulation
    currentTime = Timer
    
    ' we are only going to execute the simulation 60 times a second or every
    ' 0.0167 seconds or we could say once every 16.67 milliseconds
    if currentTime - lastTime >= 0.0167 then
  
        ' begin the scene, erasing the canvas with sky-blue before rendering
        IrrBeginScene( 240, 255, 255 )
    
        ' allow newton to update the scene using physics calculations
        NewtonUpdatePhysics

        ' track the boxes by setting the camera target to the position of a box
        IrrGetNodePosition( CubeBNode, X, Y, Z )
        IrrSetCameraTarget ( Camera, X, Y, Z )

        ' draw the scene
        IrrDrawScene
    
        ' end drawing the scene and display it
        IrrEndScene

        ' start measuring the time gap from now
        lastTime = currentTime
        
        ' count the number of frames we have simulated
        frameCount += 1
    End If
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
NewtonStopPhysics
IrrStop

' print out some statistics
print "We ran for ";frameCount;" Frames or ";frameCount\10;" fps"
print "Press a key in this console window to continue"
sleep 10000