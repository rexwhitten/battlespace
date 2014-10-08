'' ////////////////////////////////////////////////////////////////////////////
''
'' A Freebasic ODE Physics toolset for the IrrlichtWrapper
''
'' This is a set of functions that can be used to convert Irrlicht objects
'' extracted though the IrrlichtWrapper into newton dynamics collision objects
''
'' This utilises the work of D.J Peters bindings for ODE
''
'' History:
''  2009 Origional functions created by Siskinedge
''  2010 Abstracted interface introduced by Frank Dodd
''
#ifndef __physics__

'' ////////////////////////////////////////////////////////////////////////////
'' include the dependant physics library
#include "fbode.bi"


'' ////////////////////////////////////////////////////////////////////////////
'' Constant definitions

#define PHYSICS_ODE
#define MAX_CONTACTS    256           ' maximum number of contacts


'' ////////////////////////////////////////////////////////////////////////////
'' Type Declarations

Type physics_obj

	node as irr_node            ' The irrlicht node
    body as dBodyID             ' the physics body associated with motion
    geom as dGeomID             ' the physics geometry associated with collision
    
    verticies as dVector4 ptr
    indicies as integer ptr

End Type

type PhysicsReport as sub (byval as physics_obj ptr, byval as physics_obj ptr)


'' ////////////////////////////////////////////////////////////////////////////
'' global variables

#ifndef world
dim shared as dWorldID              world
dim shared as dSpaceID              world_space
dim shared as dJointGroupID         contactgroup
dim shared as dContact              contacts(0 to MAX_CONTACTS-1)
dim shared as PhysicsReport         reportCallBack = 0
dim shared as IRR_VECTOR            gravity = ( 0.0, -9.81, 0.0 )
dim shared as single                default_mass = 0.5f
#endif


'' ////////////////////////////////////////////////////////////////////////////
'' API

Declare Sub PhysicsInit
Declare Sub PhysicsUpdate( timeElapsed as single )
Declare Sub PhysicsStop

Declare Sub PhysicsSizeWorld( object as physics_obj )
Declare Sub PhysicsSetGravity( x as single, y as single, z as single )
Declare Sub PhysicsSetDefaultMass( mass as single )
Declare Sub PhysicsReportCollisions( callback as PhysicsReport )

Declare Sub PhysicsCreatePlane( node as irr_node, object as physics_obj )
Declare Sub PhysicsCreateSphere( node as irr_node, object as physics_obj )
Declare Sub PhysicsCreateBox( node as irr_node, object as physics_obj )
Declare Sub PhysicsCreateCylinder( node as irr_node, object as physics_obj )
Declare Sub PhysicsCreateCapsule( node as irr_node, object as physics_obj )
Declare Sub PhysicsCreateConvexHull( node as irr_node, object as physics_obj )
Declare Sub PhysicsCreateTriMesh( node as irr_node, object as physics_obj )
Declare Sub PhysicsCreateHeightfield( node as irr_node, object as physics_obj )

Declare Sub PhysicsCastRay( p1 as IRR_VECTOR, p2 as IRR_VECTOR, object as physics_obj )
Declare Function PhysicsCheckCollision( o1 as physics_obj, o2 as physics_obj ) as integer

Declare Sub PhysicsSetNodePositionAndRotation( object as physics_obj )
Declare Sub PhysicsGetNodePositionAndRotation( object as physics_obj )
Declare Sub PhysicsDestroyObject( object as physics_obj )


'' ////////////////////////////////////////////////////////////////////////////
'' Forward declarations of support functions

Declare Sub PhysicsMovedCallback cdecl ( byval body as dBodyID )

Declare Sub PhysicsNearCallback cdecl (lpData as any ptr, _
                                   o1     as dGeomID, _
                                   o2     as dGeomID)


'' ////////////////////////////////////////////////////////////////////////////
'' API Definitions

'' ---------------------------------------------------------------------------
' Initialise the ODE environment with sensible default parameters
Sub PhysicsInit

    ' initialise the ODE environment
    dInitODE2(0)
    
    ' create world
    world = dWorldCreate()
    
    ' create an space for our objects
    world_space = dSimpleSpaceCreate( 0 )
    
    ' create a contact group (faster to delete)
    contactgroup = dJointGroupCreate(0)

    ' set a sensible default gravity
    dWorldSetGravity( world, gravity.x, gravity.y, gravity.z )

    dWorldSetERP( world, 0.2 )
    dWorldSetCFM( world, 1e-5 )
    
    dWorldSetContactMaxCorrectingVel( world, 0.9 )
    
    dWorldSetContactSurfaceLayer( world, 0.001 )
    
    dWorldSetAutoDisableFlag( world, 1 )
    
End Sub

'' ---------------------------------------------------------------------------
'' update the physics simulation for the specified period of elapsed time
Sub PhysicsUpdate( timeElapsed as single )

    ' update the ODE world
    dJointGroupEmpty(contactgroup)
    dSpaceCollide( world_space, 0, @PhysicsNearCallback)
    dWorldQuickStep(World, timeElapsed)

End Sub

'' ---------------------------------------------------------------------------
'' stop the physics engine releasing all resources
Sub PhysicsStop
    
    dWorldDestroy (world)
    dCloseODE()

End Sub


'' ---------------------------------------------------------------------------
'' set the size of the world from the bounding box of the irrlicht object
Sub PhysicsSizeWorld( object as physics_obj )
End Sub


'' ---------------------------------------------------------------------------
'' stop the physics engine releasing all resources
Sub PhysicsSetDefaultMass( mass as single )
    
    default_mass = mass

End Sub


'' ---------------------------------------------------------------------------
' set the gravity associated with the simulation
Sub PhysicsSetGravity( x as single, y as single, z as single )

    ' set the gravity in the world
    dWorldSetGravity( world, x, y, z )
    
End Sub


'' ---------------------------------------------------------------------------
'' set a callback for reporting collisions
Sub PhysicsReportCollisions( callback as PhysicsReport )

    reportCallBack = callback

End Sub


'' ---------------------------------------------------------------------------
'' create a flat plane
Sub PhysicsCreatePlane ( node as irr_node, object as physics_obj )

    ' create the ground as a static object formed from geometry only
    object.node = node
    object.geom = dCreatePlane( world_space, 0, 1, 0, 0 )

End Sub

'' ---------------------------------------------------------------------------
'' create a simple physics sphere body associated with a node
Sub PhysicsCreateSphere( node as irr_node, object as physics_obj )

    ' get the bounding box of the node
    DIM as single tx, ty, tz, bx, by, bz
    IrrGetNodeBoundingBox( node, tx, ty, tz, bx, by, bz )

    ' scale the bounding box
    DIM as single x, y, z
    IrrGetNodeScale( node, x, y, z )
    x *= Abs(tx-bx)

    ' create a sphere as a dynamic object formed from body and geom
    object.body = dBodyCreate( world )

    ' set the bodies node
    object.node = node
    dBodySetData( object.body, @object )
    
    ' set the dimensions and mass of the sphere
    Dim as dMass m
    dMassSetSphere( @m, default_mass, x / 2.0f )

    ' We can then apply this mass to our objects body.
    dBodySetMass( object.body, @m )

    ' set the movement callback for the object
    dBodySetMovedCallback( object.body, CAST( BODYCALLBACK ptr, @PhysicsMovedCallback ))

    ' create the actual geometry for the object
    object.geom = dCreateSphere( world_space, x / 2.0f )
    
    ' associate the body with the geom using dGeomSetBody
    dGeomSetBody( object.geom, object.body )

End Sub


'' ---------------------------------------------------------------------------
'' create a simple physics box body associated with a node
Sub PhysicsCreateBox( node as irr_node, object as physics_obj )

    ' get the bounding box of the node
    DIM as single tx, ty, tz, bx, by, bz
    IrrGetNodeBoundingBox( node, tx, ty, tz, bx, by, bz )

    ' scale the bounding box
    DIM as single x, y, z
    IrrGetNodeScale( node, x, y, z )
    x *= Abs(tx-bx)
    y *= Abs(ty-by)
    z *= Abs(tz-bz)

    ' create a box as a dynamic object formed from body and geom
    object.body = dBodyCreate( world )

    ' set the bodies node
    object.node = node
    dBodySetData( object.body, @object )
    
    ' set the dimensions and mass of the cube
    Dim as dMass m
    dMassSetBox( @m, default_mass, x, y, z ) 'Abs(tx-bx), Abs(ty-by), Abs(tz-bz))

    ' We can then apply this mass to our objects body.
    dBodySetMass( object.body, @m )

    ' set the movement callback for the object
    dBodySetMovedCallback( object.body, CAST( BODYCALLBACK ptr, @PhysicsMovedCallback ))

    ' create the actual geometry for the object
    object.geom = dCreateBox( world_space, x, y, z )
    
    ' associate the body with the geometry
    dGeomSetBody( object.geom, object.body )
    
End Sub


'' ---------------------------------------------------------------------------
'' create a simple physics cylinder body associated with a node
'' NOTE: Cylinders in ODE do not current collide with themselves
Sub PhysicsCreateCylinder( node as irr_node, object as physics_obj )

    ' get the bounding box of the node
    DIM as single tx, ty, tz, bx, by, bz
    IrrGetNodeBoundingBox( node, tx, ty, tz, bx, by, bz )

    ' scale the bounding box
    DIM as single x, y, z
    IrrGetNodeScale( node, x, y, z )
    x *= Abs(tx-bx)
    y *= Abs(ty-by)
    z *= Abs(tz-bz)

    ' create a box as a dynamic object formed from body and geom
    object.body = dBodyCreate( world )

    ' set the bodies node
    object.node = node
    dBodySetData( object.body, @object )
    
    ' set the dimensions and mass of the cube
    Dim as dMass m
    dMassSetCylinder( @m, default_mass, 1, x / 2.0f, y )

    ' We can then apply this mass to our objects body.
    dBodySetMass( object.body, @m )

    ' set the movement callback for the object
    dBodySetMovedCallback( object.body, CAST( BODYCALLBACK ptr, @PhysicsMovedCallback ))

    ' Here we create the actual geometry
    object.geom = dCreateCylinder( world_space, x / 2.0f, y )
    
    ' associate the body with the geometry
    dGeomSetBody( object.geom, object.body )
    
End Sub


'' ---------------------------------------------------------------------------
'' create a simple physics capsule body associated with a node
Sub PhysicsCreateCapsule( node as irr_node, object as physics_obj )

    ' get the bounding box of the node
    DIM as single tx, ty, tz, bx, by, bz
    IrrGetNodeBoundingBox( node, tx, ty, tz, bx, by, bz )

    ' scale the bounding box
    DIM as single x, y, z
    IrrGetNodeScale( node, x, y, z )
    x *= Abs(tx-bx)
    y *= Abs(ty-by)
    z *= Abs(tz-bz)

    ' create a box as a dynamic object formed from body and geom
    object.body = dBodyCreate( world )

    ' set the bodies node
    object.node = node
    dBodySetData( object.body, @object )
    
    ' set the dimensions and mass of the cube
    Dim as dMass m
    dMassSetCapsule( @m, default_mass, 1, x / 2.0f, y )

    ' We can then apply this mass to our objects body.
    dBodySetMass( object.body, @m )

    ' set the movement callback for the object
    dBodySetMovedCallback( object.body, CAST( BODYCALLBACK ptr, @PhysicsMovedCallback ))

    ' Here we create the actual geometry
    object.geom = dCreateCapsule( world_space, x / 2.0f, y )
    
    ' associate the body with the geometry
    dGeomSetBody( object.geom, object.body )

End Sub


'' ---------------------------------------------------------------------------
'' create a freeform physics heightfield terrain associated with a node
Sub PhysicsCreateHeightfield( node as irr_node, object as physics_obj )
    
End Sub


'' ---------------------------------------------------------------------------
'' create a freeform physics convex hull associated with a node
Sub PhysicsCreateConvexHull( node as irr_node, object as physics_obj )

    ' get the scale of the node
    DIM as single x, y, z
    IrrGetNodeScale( node, x, y, z )

    ' get the mesh associated with this node
    DIM as irr_mesh mesh = IrrGetNodeMesh( node )

    ' get the number of verticies in the object
    Dim as uinteger MeshVertextotal = IrrGetMeshVertexCount( mesh, 0)
    
    ' create and array of vertices to translate across from Irrlicht structures
    Dim verticies(0 To MeshVertextotal-1) As IRR_VERT
    object.verticies = Allocate( MeshVertextotal * SizeOf( dVector4 ))
    
    ' extract the vertices from the model
    IrrGetMeshVertices( mesh, 0, verticies(0))
    
    ' translate all of the verticies into the physics structures
    Dim i as integer
    For i = 0 To MeshVertextotal-1
        ' convert a single vertex
        object.verticies[i].v(0) = verticies(i).x * x
        object.verticies[i].v(1) = verticies(i).y * y
        object.verticies[i].v(2) = verticies(i).z * z
    Next

    ' get the number of indicies in the object
    Dim as integer MeshIndextotal = IrrGetMeshIndexCount( mesh, 0 )

    ' create and array of indicies to translate across from Irrlicht structures
    Dim Indices(0 To MeshIndextotal-1) As Ushort
    object.indicies = Allocate( MeshIndextotal * Sizeof( Integer ))

    ' extract the indicies from the model
    IrrGetMeshIndices( mesh, 0, Indices(0) )

    ' itterate all of the indicies
    For i = 0 To MeshIndexTotal-1
        ' convert a single vertex
        object.indicies[i] = Indices(i)
    Next

    ' add all of the vertices as a single collision object
    Dim as dTriMeshDataID geomData = dGeomTriMeshDataCreate()

    dGeomTriMeshDataBuildSimple( geomData, _
            Cast( dReal ptr, object.verticies), MeshVertextotal, _
            object.indicies, MeshIndextotal )

    ' build the trimesh geom 
    object.geom=dCreateTriMesh( world_space, geomData, 0, 0, 0 )

    ' create a box as a dynamic object formed from body and geom
    object.body = dBodyCreate( world )

    ' set the bodies node
    object.node = node
    dBodySetData( object.body, @object )
    
    ' set the dimensions and mass of the cube
    Dim as dMass m
    dMassSetTrimesh( @m, default_mass, object.geom )

    ' reposition the geometry to the origin
    dGeomSetPosition( object.geom, -m.c.v(0), -m.c.v(1), -m.c.v(2))
    dMassTranslate( @m, -m.c.v(0), -m.c.v(1), -m.c.v(2))

    ' We can then apply this mass to our objects body.
    dBodySetMass( object.body, @m )

    ' set the movement callback for the object
    dBodySetMovedCallback( object.body, CAST( BODYCALLBACK ptr, @PhysicsMovedCallback ))

    ' associate the body with the geometry
    dGeomSetBody( object.geom, object.body )


End Sub


'' ---------------------------------------------------------------------------
'' create a simple static physics tri-mesh associated with a node
Sub PhysicsCreateTriMesh( node as irr_node, object as physics_obj )

    ' get the scale of the node
    DIM as single x, y, z
    IrrGetNodeScale( node, x, y, z )

    ' get the mesh associated with this node
    DIM as irr_mesh mesh = IrrGetNodeMesh( node )

    ' get the number of verticies in the object
    Dim as uinteger MeshVertextotal = IrrGetMeshVertexCount( mesh, 0)
    
    ' create and array of vertices to translate across from Irrlicht structures
    Dim verticies(0 To MeshVertextotal-1) As IRR_VERT
    object.verticies = Allocate( MeshVertextotal * SizeOf( dVector4 ))
    
    ' extract the vertices from the model
    IrrGetMeshVertices( mesh, 0, verticies(0))
    
    ' translate all of the verticies into the physics structures
    Dim i as integer
    For i = 0 To MeshVertextotal-1
        ' convert a single vertex
        object.verticies[i].v(0) = verticies(i).x * x
        object.verticies[i].v(1) = verticies(i).y * y
        object.verticies[i].v(2) = verticies(i).z * z
    Next

    ' get the number of indicies in the object
    Dim as integer MeshIndextotal = IrrGetMeshIndexCount( mesh, 0 )

    ' create and array of indicies to translate across from Irrlicht structures
    Dim Indices(0 To MeshIndextotal-1) As Ushort
    object.indicies = Allocate( MeshIndextotal * Sizeof( Integer ))

    ' extract the indicies from the model
    IrrGetMeshIndices( mesh, 0, Indices(0) )

    ' itterate all of the indicies
    For i = 0 To MeshIndexTotal-1
        ' convert a single vertex
        object.indicies[i] = Indices(i)
    Next

    ' add all of the vertices as a single collision object
    Dim as dTriMeshDataID geomData = dGeomTriMeshDataCreate()

    dGeomTriMeshDataBuildSimple( geomData, _
            Cast( dReal ptr, object.verticies), MeshVertextotal, _
            object.indicies, MeshIndextotal )

    ' build the trimesh geom 
    object.geom=dCreateTriMesh( world_space, geomData, 0, 0, 0 )

    ' set the objects node
    object.node = node
    
    ' there is no body geometry associated with a static tri-mesh object
    object.body = 0

End Sub


'' ---------------------------------------------------------------------------
'' test for collision with a ray cast into the world
Sub PhysicsCastRay( p1 as IRR_VECTOR, p2 as IRR_VECTOR, object as physics_obj )
End Sub


'' ---------------------------------------------------------------------------
'' test for collision between two physics objects
Function PhysicsCheckCollision( o1 as physics_obj, o2 as physics_obj ) as integer

    return dCollide( o1.geom, o2.geom, MAX_CONTACTS, @contacts(0).geom, sizeof(dContactGeom))

End Function


'' ---------------------------------------------------------------------------
'' Update the position and rotation of an irrlicht node from an ODE body
Sub PhysicsSetNodePositionAndRotation( object as physics_obj )
    
    ' get the node associated with this body
    Dim as irr_node node = object.node

    ' get the new position of the ODE geometry
    Dim as dReal ptr ode_pos
    ode_pos = dBodyGetPosition( object.body )
    
    ' set the position of the scene node to match the ODE geometry
    IrrSetNodePosition( object.node, ode_pos[0], ode_pos[1], ode_pos[2] )

    ' get the ODE geometry rotation quaternion
    Dim as dQuaternion ptr result
    result = cast( dQuaternion ptr, dBodyGetQuaternion( object.body ))

    ' convert it to euler angles
    Dim as dReal w,x,y,z
    w=result->q(0)
    x=result->q(1)
    y=result->q(2)
    z=result->q(3)

    ' calculate the squares of the Quaternion parameters
    Dim as double sqw = w*w   
    Dim as double sqx = x*x   
    Dim as double sqy = y*y   
    Dim as double sqz = z*z

    ' convert them to euler angles
    Dim as single eX, eY, eZ
    eZ = atan2( 2.0 * (x*y + z*w),(sqx - sqy - sqz + sqw)) * 57.295779513
    eX = atan2( 2.0 * (y*z + x*w),(-sqx - sqy + sqz + sqw)) * 57.295779513
    eY = asin( -2.0 * (x*z - y*w)) * 57.295779513

    ' set the rotation
    IrrSetNodeRotation( object.node, eX, eY, eZ )

End Sub

'' ---------------------------------------------------------------------------
'' Update the position and rotation of an ODE body from an irrlicht node
Sub PhysicsGetNodePositionAndRotation( object as physics_obj )

    ' get the node associated with this body
    Dim as irr_node node = object.node

    ' set the position of the ODE geometry
    Dim as dReal X, Y, Z
    IrrGetNodePosition( object.node, X, Y, Z )
    dBodySetPosition( object.body, X, Y, Z )

    ' get the rotation of the the object
    Dim as dReal eX, eY, eZ
    IrrGetNodeRotation( object.node, eX, eY, eZ )

    ' compute elements of the euler to quaternion equation
    Dim as dQuaternion result
    Dim as single theta_z = eX/57.295779513
    Dim as single theta_y = eY/57.295779513
    Dim as single theta_x = eZ/57.295779513
    
    Dim as single cos_z_2 = cos(0.5*theta_z)
    Dim as single cos_y_2 = cos(0.5*theta_y)
    Dim as single cos_x_2 = cos(0.5*theta_x)
    
    Dim as single sin_z_2 = sin(0.5*theta_z)
    Dim as single sin_y_2 = sin(0.5*theta_y)
    Dim as single sin_x_2 = sin(0.5*theta_x)
    
    ' and now compute quaternion
    result.q(0) = cos_z_2*cos_y_2*cos_x_2 + sin_z_2*sin_y_2*sin_x_2
    result.q(3) = cos_z_2*cos_y_2*sin_x_2 - sin_z_2*sin_y_2*cos_x_2
    result.q(2) = cos_z_2*sin_y_2*cos_x_2 + sin_z_2*cos_y_2*sin_x_2
    result.q(1) = sin_z_2*cos_y_2*cos_x_2 - cos_z_2*sin_y_2*sin_x_2

    dBodySetQuaternion( object.body, result )

End Sub


'' ---------------------------------------------------------------------------
'' remove the object from the physics engine
Sub PhysicsDestroyObject( object as physics_obj )

    dGeomDestroy( object.geom )
    dBodyDestroy( object.body )
    if NOT object.verticies = 0 then Deallocate( object.verticies )
    if NOT object.indicies = 0 then Deallocate( object.indicies )

End Sub


'' ////////////////////////////////////////////////////////////////////////////
'' Support Function Definitions

'' ---------------------------------------------------------------------------
'' Callback for handling the movement of a physics object
Sub PhysicsMovedCallback cdecl ( byval body as dBodyID )

    Dim as physics_obj ptr object = dBodyGetData( body )
    PhysicsSetNodePositionAndRotation( *object )

End Sub

'' ---------------------------------------------------------------------------
'' Callback for handling colliding physics objects
Sub PhysicsNearCallback cdecl (lpData as any ptr, _
                        o1     as dGeomID, _
                        o2     as dGeomID)

    ' Temporary index for each contact
    dim as integer i, numc

    ' Get the dynamics body for each geom
    Dim as dBodyID b1 = dGeomGetBody( o1 )
    Dim as dBodyID b2 = dGeomGetBody( o2 )

    ' elasticity (bounce) parameters
    for i = 0 to MAX_CONTACTS - 1

        contacts(i).surface.mode = dContactBounce OR dContactSoftCFM
        contacts(i).surface.mu = 1000.0f 'dInfinity
        contacts(i).surface.mu2 = 0.0
        contacts(i).surface.bounce = 0.01
        contacts(i).surface.bounce_vel = 0.01
        contacts(i).surface.soft_cfm = 0.0

    next i

    ' perform the collisions test and recover the number of points of contact
    numc = dCollide( o1, o2, MAX_CONTACTS, @contacts(0).geom, sizeof(dContact))

    ' itterate all of the contacts in the collision
    if numc > 0 Then

        ' add the contacts to the contact group
        for i = 0 to numc - 1

            ' create a temporary joint for the collision
            Dim as dJointID c = dJointCreateContact(World, contactgroup, @contacts(i))
            dJointAttach(c, b1, b2)

            ' if a reporting callback function has been defined
            if NOT reportCallBack = 0 Then
                ' recover the physics objects from the user data
                Dim as physics_obj ptr p1 = 0
                Dim as physics_obj ptr p2 = 0
                if NOT b1 = 0 Then  p1 = dBodyGetData( b1 )
                if NOT b2 = 0 Then  p2 = dBodyGetData( b2 )
                
                ' inform the subscriber of the collision
                reportCallBack( p1, p2 )
            End if
            
        next i
    end if
End Sub


#endif