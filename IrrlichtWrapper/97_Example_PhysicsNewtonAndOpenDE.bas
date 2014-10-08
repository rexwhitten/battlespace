'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 97 : Physics Collision
'' This example animates a scene containing a number of collision primitives
'' through the use of either Newton Game Dynamics physics engine or alternativly
'' the Open Dynamics Engine
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"
'#include "IrrlichtNewton.bi"
#include "IrrlichtODE.bi"

'#define SIMPLE_FLOOR

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM CubeMesh as irr_mesh
DIM CubeTexture as irr_texture
DIM Shared HitTexture as irr_texture
DIM MapTexture as irr_texture
DIM FloorNode as irr_node
DIM PrimMesh(4) as irr_mesh
DIM PrimNode(6) as irr_node
DIM OurCamera as irr_camera
DIM Light as irr_node

' physics objects
DIM physFloor as physics_obj
DIM physPrim(6) as physics_obj


' -----------------------------------------------------------------------------
'' callback function for collisions
Sub PhysicsReported( p1 as physics_obj ptr, p2 as physics_obj ptr)

    if NOT p1 = 0 then if NOT p1->node = 0 then IrrSetNodeMaterialTexture( p1->node, HitTexture, 0 )
    if NOT p2 = 0 then if NOT p2->node = 0 then IrrSetNodeMaterialTexture( p2->node, HitTexture, 0 )

End Sub


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 512, 512, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' set the window caption
IrrSetWindowCaption( "Example 98: Physics Collision" )

' load texture resources for texturing the scene nodes
CubeTexture = IrrGetTexture( "./media/default_texture.png" )
HitTexture = IrrGetTexture( "./media/cross.bmp" )
IrrSetTextureCreationFlag( ETCF_CREATE_MIP_MAPS, IRR_OFF )
MapTexture = IrrGetTexture( "./media/maplightmap.jpg" )

' load resource for the primitive shapes
#ifdef PHYSICS_NEWTON
PrimMesh(1) = IrrGetMesh( "./media/cylinderX.obj" )
PrimMesh(2) = IrrGetMesh( "./media/capsuleX.obj" )
PrimMesh(3) = IrrGetMesh( "./media/wedge.obj" )
PrimMesh(4) = IrrGetMesh( "./media/simplemap.obj" )
#else
PrimMesh(1) = IrrGetMesh( "./media/cylinderY.obj" )
PrimMesh(2) = IrrGetMesh( "./media/capsuleY.obj" )
PrimMesh(3) = IrrGetMesh( "./media/wedge.obj" )
PrimMesh(4) = IrrGetMesh( "./media/simplemap.obj" )
#endif

' scale the map mesh up instead of the node to preserve lighting effects
IrrScaleMesh( PrimMesh(4), 250.0 )

' add nodes to represent the physical objects
PrimNode(1) = IrrAddTestSceneNode
PrimNode(2) = IrrAddSphereSceneNode( 5.0, 8 )
PrimNode(3) = IrrAddMeshToScene( PrimMesh(1) )
PrimNode(4) = IrrAddMeshToScene( PrimMesh(2) )
PrimNode(5) = IrrAddMeshToScene( PrimMesh(3) )

' scale up the primitive meshes
IrrSetNodeScale( PrimNode(3), 5.0, 5.0, 5.0 )
IrrSetNodeScale( PrimNode(4), 5.0, 5.0, 5.0 )
IrrSetNodeScale( PrimNode(5), 5.0, 5.0, 5.0 )

' apply a material to the node to give its surface color
'IrrSetNodeMaterialTexture( FloorNode, CubeTexture, 0 )
IrrSetNodeMaterialTexture( PrimNode(1), CubeTexture, 0 )
IrrSetNodeMaterialTexture( PrimNode(2), CubeTexture, 0 )
IrrSetNodeMaterialTexture( PrimNode(3), CubeTexture, 0 )
IrrSetNodeMaterialTexture( PrimNode(4), CubeTexture, 0 )
IrrSetNodeMaterialTexture( PrimNode(5), CubeTexture, 0 )

#ifdef SIMPLE_FLOOR
' create a simple node to represent the ground as large flat plane
FloorNode = IrrAddTestSceneNode
IrrSetNodeScale( FloorNode, 20.0, 0.02, 20.0 )
IrrSetNodeMaterialTexture( FloorNode, CubeTexture, 0 )
IrrSetNodeMaterialFlag( FloorNode, IRR_EMF_LIGHTING, IRR_OFF )
#else
PrimNode(6) = IrrAddMeshToScene( PrimMesh(4) )
IrrSetNodeMaterialTexture( PrimNode(6), MapTexture, 0 )
#endif

' add a simple light into the scene
IrrAddLight( IRR_NO_PARENT, 100,100,-100, 1.9,0.9,0.9, 2600.0 )

' add a camera into the scene,
OurCamera = IrrAddCamera( 50,50,50, 0,0,0 )


' initialise the physics environment
PhysicsInit

' request that collisions are reported
#ifdef SIMPLE_FLOOR
PhysicsReportCollisions( @PhysicsReported )
#endif

' create an physics world box from the bounding box of a node
PhysicsCreateBox( PrimNode(1), physPrim(1) )
PhysicsCreateSphere( PrimNode(2), physPrim(2) )
#ifdef PHYSICS_NEWTON
PhysicsCreateCylinder( PrimNode(3), physPrim(3) )
#else
PhysicsCreateCapsule( PrimNode(3), physPrim(3) )
#endif
PhysicsCreateCapsule( PrimNode(4), physPrim(4) )
PhysicsCreateConvexHull( PrimNode(5), physPrim(5) )

#ifdef SIMPLE_FLOOR
' Create the ground
PhysicsCreatePlane( IRR_NO_OBJECT, physFloor )
#else
PhysicsCreateTriMesh( PrimNode(6), physPrim(6) )
#endif


' create a random rotation for the node and update the associated physics object
IrrSetNodeRotation( PrimNode(1), Rnd*360, Rnd*360, Rnd*360 )
IrrSetNodePosition( PrimNode(1), 0.0, 40.0, 0.0 )
PhysicsGetNodePositionAndRotation( physPrim(1) )

' create a random rotation for the node and update the associated physics object
IrrSetNodeRotation( PrimNode(2), Rnd*360, Rnd*360, Rnd*360 )
IrrSetNodePosition( PrimNode(2), 0.0, 60.0, 0.0 )
PhysicsGetNodePositionAndRotation( physPrim(2) )

' create a random rotation for the node and update the associated physics object
IrrSetNodeRotation( PrimNode(3), Rnd*360, Rnd*360, Rnd*360 )
IrrSetNodePosition( PrimNode(3), 0.0, 80.0, 0.0 )
PhysicsGetNodePositionAndRotation( physPrim(3) )

' create a random rotation for the node and update the associated physics object
IrrSetNodeRotation( PrimNode(4), Rnd*360, Rnd*360, Rnd*360 )
IrrSetNodePosition( PrimNode(4), 0.0, 100.0, 0.0 )
PhysicsGetNodePositionAndRotation( physPrim(4) )

' create a random rotation for the node and update the associated physics object
IrrSetNodeRotation( PrimNode(5), Rnd*360, Rnd*360, Rnd*360 )
IrrSetNodePosition( PrimNode(5), 0.0, 120.0, 0.0 )
PhysicsGetNodePositionAndRotation( physPrim(5) )


' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
Dim as Single timeElapsed, currentTime, frameTime = timer
WHILE IrrRunning
    ' is it time for another frame
    currentTime = timer
    timeElapsed = currentTime - frameTime
    if timeElapsed > 0.0167 then
        ' record the start time of this frame
        frameTime = currentTime

        ' begin the scene, erasing the canvas with sky-blue before rendering
        IrrBeginScene( 240, 255, 255 )

        ' Update the physics environment
        PhysicsUpdate( timeElapsed )

        ' make the camera track the first box
        Dim as single x,y,z
        IrrGetNodePosition( PrimNode(1), x,y,z)
        IrrSetNodePosition( OurCamera, cos(currentTime/5) * 80.0, 30.0, Sin(currentTime/5) * 80.0 )
        IrrSetCameraTarget( OurCamera,x,y,z)

        ' draw the scene
        IrrDrawScene
        
        ' end drawing the scene and render it
        IrrEndScene
    End If
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop

' release Physics resources
PhysicsStop
