'' ////////////////////////////////////////////////////////////////////////////
''
'' A Freebasic Newton Physics toolset for the IrrlichtWrapper
''
'' This is a set of functions that can be used to convert Irrlicht objects
'' extracted though the IrrlichtWrapper into newton dynamics collision objects
''
'' History:
''  2009 Origional functions created by Siskinedge
''  2010 Abstracted interface introduced by Frank Dodd
''
#ifndef __physics__

'' ////////////////////////////////////////////////////////////////////////////
'' include the dependant physics library
#Include "Newton.bi"


'' ////////////////////////////////////////////////////////////////////////////
'' constant definitions

#define PHYSICS_NEWTON


'' ////////////////////////////////////////////////////////////////////////////
'' Type Declarations

' a newton style vector
Type dFloatVector
    x As dFloat
    y As dFloat
    z As dFloat
End Type

' a newton force consisiting of a direction and strength
Type Force
    Vector As dFloatVector
    Angular As dFloatVector
End Type

' a translation matrix for operations on 3d points
Type TransMatrix
    m(15) As dFloat
End Type


Type physics_obj
	node as irr_node                    ' the irrlicht node
    body as NewtonBody Ptr              ' the physics body associated with motion
    collision as NewtonCollision Ptr    ' the physics geometry associated with collision
    material as integer                 ' the material properties of the physics object
'    Impulse as Force                    ' forces applied to the body
End Type


type PhysicsReport as sub (byval as physics_obj ptr, byval as physics_obj ptr)


'' ////////////////////////////////////////////////////////////////////////////
'' global variables

#ifndef nWorld
Dim Shared nWorld As NewtonWorld Ptr                ' newton world object
dim shared as PhysicsReport         reportCallBack = 0
dim shared as NewtonBody ptr        collisionBody1
dim shared as NewtonBody ptr        collisionBody2
dim shared as IRR_VECTOR            gravity = ( 0.0, -9.81, 0.0 )
dim shared as single                default_mass = 10.0f
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

Declare Sub NewtonIrrlichtDestructor Cdecl( Byval TmpNewtBody As NewtonBody Ptr )
Declare Sub NewtonIrrlichtUpdateObjectPosition Cdecl( _
                                Byval TmpNewtBody As NewtonBody Ptr, _
                                Byval TransMatpoint As dFloat Ptr)
Declare Sub NewtonIrrlichtUpdateObjectForces Cdecl(Byval TmpNewtBody As NewtonBody Ptr)

declare function ReportNewtonContactBegin cdecl(_
        byval mat as NewtonMaterial ptr, _
        byval b1 as NewtonBody ptr, _
        byval b2 as NewtonBody ptr) as integer
declare function ReportNewtonContactProcess cdecl( _
        byval mat as NewtonMaterial ptr, _
        byval contact as NewtonContact ptr ) as integer
declare sub ReportNewtonContactEnd cdecl(byval mat as NewtonMaterial ptr)


'' ////////////////////////////////////////////////////////////////////////////
'' API Definitions

'' ---------------------------------------------------------------------------
' Initialise the ODE environment with sensible default parameters
Sub PhysicsInit

    ' create an empty newton world that uses system alloc and free
    nworld = NewtonCreate( 0, 0 )
    
    ' set up some default newton world physical properties
    Dim DefNewtMateral As Short
    DefNewtMateral = NewtonMaterialGetDefaultGroupID(nWorld)
    NewtonMaterialSetDefaultFriction(nWorld, DefNewtMateral, DefNewtMateral, 0.8f, 0.4f)
    NewtonMaterialSetDefaultElasticity(nWorld, DefNewtMateral, DefNewtMateral, 0.3f)
    NewtonMaterialSetDefaultSoftness(nWorld, DefNewtMateral, DefNewtMateral, 0.05f)
    NewtonMaterialSetCollisionCallback(nWorld, DefNewtMateral, DefNewtMateral, 0, 0, 0, 0)
    NewtonSetMinimumFrameRate( nWorld, 2 )
    
    ' Optimise the Solver for speed
    NewtonSetSolverModel( nWorld, 1)

    Dim As dFloat boxp0(2)
    Dim As dFloat boxp1(2)
    Dim TransMat As TransMatrix

    ' create an additional border around the world
    boxP0(0) = -1000.0
    boxP0(1) = -1000.0
    boxP0(2) = -1000.0
    boxP1(0) =  1000.0
    boxP1(1) =  1000.0
    boxP1(2) =  1000.0
    
    ' set the size of the object in the newton world
    NewtonSetWorldSize(nWorld, @boxP0(0), @boxP1(0))

End Sub


'' ---------------------------------------------------------------------------
'' update the physics simulation for the specified period of elapsed time
Sub PhysicsUpdate( timeElapsed as single )

    '' Update the Newton world
    NewtonUpdate( nWorld, timeElapsed )

End Sub


'' ---------------------------------------------------------------------------
'' stop the physics engine releasing all resources
Sub PhysicsStop
    
    NewtonDestroy(nWorld)

End Sub


'' ---------------------------------------------------------------------------
'' set the size of the world from the bounding box of the irrlicht object
Sub PhysicsSizeWorld( object as physics_obj )
    
    if NOT object.node = IRR_NO_OBJECT Then
        ' get the bounding box of the node
        DIM as single tx, ty, tz, bx, by, bz
        IrrGetNodeBoundingBox( object.node, tx, ty, tz, bx, by, bz )
    
        ' scale the bounding box
        DIM as single x, y, z
        IrrGetNodeScale( object.node, x, y, z )
        x *= Abs(tx-bx)
        y *= Abs(ty-by)
        z *= Abs(tz-bz)
    
        Dim As dFloat boxp0(2), boxp1(2)
    
        ' derive the box from the node at the origin
        boxP0(0) = -x / 2.0
        boxP0(1) = -y / 2.0
        boxP0(2) = -z / 2.0
        boxP1(0) =  x / 2.0
        boxP1(1) =  y / 2.0
        boxP1(2) =  z / 2.0
        
        ' set the size of the object in the newton world
        NewtonSetWorldSize(nWorld, @boxP0(0), @boxP1(0))

    End If
        
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
    gravity.x = x
    gravity.y = y
    gravity.z = z
    
End Sub


'' ---------------------------------------------------------------------------
'' set a callback for reporting collisions
Sub PhysicsReportCollisions( callback as PhysicsReport )

    reportCallBack = callback

End Sub


'' ---------------------------------------------------------------------------
'' create a flat plane
Sub PhysicsCreatePlane ( node as irr_node, object as physics_obj )

	' Create a huge box primitive to represent a plane
    DIM as single x = 5000.0, y = 2500.0, z = 5000.0
	object.collision = NewtonCreateBox( nWorld, x, y, z, 0 )
	object.body = NewtonCreateBody( nWorld, object.collision )

    ' we have filled 1/2 the world with a plane object move it down so everthing
    ' below Y = 0.0 is the ground
    Dim As TransMatrix mat
    mat.m(0) = 1.0
    mat.m(5) = 1.0
    mat.m(10)= 1.0
    mat.m(13)= -1250.0
    NewtonBodySetMatrix( object.body, @(mat.m(0)))

	' Set user data pointer to the scene node
    object.node = node
	NewtonBodySetUserData( object.body, @object )

    ' Posistion Callback
    NewtonBodySetTransformCallback( object.body, @NewtonIrrlichtUpdateObjectPosition)
    
    ' Force and Torque callback
    NewtonBodySetForceAndTorqueCallback( object.body, @NewtonIrrlichtUpdateObjectForces)
    
    ' Destructor Callback
    NewtonBodySetDestructorCallback( object.body, @NewtonIrrlichtDestructor)

    ' the plane should not move
    NewtonWorldFreezeBody( nWorld, object.body )

    ' if collisions are to be reported back
    if NOT reportCallBack = 0 Then
        Dim as integer i = NewtonMaterialGetDefaultGroupID( nWorld )
        NewtonMaterialSetCollisionCallback ( nWorld, i, i, @object, _
                @ReportNewtonContactBegin, @ReportNewtonContactProcess, 0 )
    End If

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
    y *= Abs(ty-by)
    z *= Abs(tz-bz)

	' Create a sphere primitive. 
    object.collision = NewtonCreateSphere( nWorld, x/2, y/2, z/2, 0 )
	object.body = NewtonCreateBody( nWorld, object.collision )

	' Set user data pointer to the scene node
    object.node = node
	NewtonBodySetUserData( object.body, @object )

	' Set some default values for body mass & inertia matrix
	NewtonBodySetMassMatrix ( object.body, default_mass, _
            default_mass*15.0, default_mass*15.0, default_mass*15.0 )

    ' Posistion Callback
    NewtonBodySetTransformCallback( object.body, @NewtonIrrlichtUpdateObjectPosition)
    
    ' Force and Torque callback
    NewtonBodySetForceAndTorqueCallback( object.body, @NewtonIrrlichtUpdateObjectForces)
    
    ' Destructor Callback
    NewtonBodySetDestructorCallback( object.body, @NewtonIrrlichtDestructor)

    ' if collisions are to be reported attach collision callback functions
    if NOT reportCallBack = 0 Then
        Dim as integer i = NewtonMaterialGetDefaultGroupID( nWorld )
        NewtonMaterialSetCollisionCallback ( nWorld, i, i, @object, _
                @ReportNewtonContactBegin, @ReportNewtonContactProcess, 0 )
    End If

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

	' Create a box primitive. 
	object.collision = NewtonCreateBox( nWorld, x, y, z, 0 )
	object.body = NewtonCreateBody( nWorld, object.collision )

	' Set user data pointer to the scene node
    object.node = node
	NewtonBodySetUserData( object.body, @object )

	' Set some default values for body mass & inertia matrix
	NewtonBodySetMassMatrix ( object.body, default_mass, _
            default_mass*15.0, default_mass*15.0, default_mass*15.0 )

    ' Posistion Callback
    NewtonBodySetTransformCallback( object.body, @NewtonIrrlichtUpdateObjectPosition)
    
    ' Force and Torque callback
    NewtonBodySetForceAndTorqueCallback( object.body, @NewtonIrrlichtUpdateObjectForces)
    
    ' Destructor Callback
    NewtonBodySetDestructorCallback( object.body, @NewtonIrrlichtDestructor)

    ' if collisions are to be reported attach collision callback functions
    if NOT reportCallBack = 0 Then
        Dim as integer i = NewtonMaterialGetDefaultGroupID( nWorld )
        NewtonMaterialSetCollisionCallback ( nWorld, i, i, @object, _
                @ReportNewtonContactBegin, @ReportNewtonContactProcess, 0 )
    End If

End Sub


'' ---------------------------------------------------------------------------
'' create a simple physics cylinder body associated with a node
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

	' Create a cylinder primitive. 
	object.collision = NewtonCreateCylinder( nWorld, x / 2.0, y, 0 )
	object.body = NewtonCreateBody( nWorld, object.collision )

	' Set user data pointer to the scene node
    object.node = node
	NewtonBodySetUserData( object.body, @object )

	' Set some default values for body mass & inertia matrix
	NewtonBodySetMassMatrix ( object.body, default_mass, _
            default_mass*15.0, default_mass*15.0, default_mass*15.0 )

    ' Posistion Callback
    NewtonBodySetTransformCallback( object.body, @NewtonIrrlichtUpdateObjectPosition)
    
    ' Force and Torque callback
    NewtonBodySetForceAndTorqueCallback( object.body, @NewtonIrrlichtUpdateObjectForces)
    
    ' Destructor Callback
    NewtonBodySetDestructorCallback( object.body, @NewtonIrrlichtDestructor)

    ' if collisions are to be reported attach collision callback functions
    if NOT reportCallBack = 0 Then
        Dim as integer i = NewtonMaterialGetDefaultGroupID( nWorld )
        NewtonMaterialSetCollisionCallback ( nWorld, i, i, @object, _
                @ReportNewtonContactBegin, @ReportNewtonContactProcess, 0 )
    End If

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

	' Create a capsule primitive. 
	object.collision = NewtonCreateCapsule( nWorld, y / 2.0, x, 0 )
	object.body = NewtonCreateBody( nWorld, object.collision )

	' Set user data pointer to the scene node
    object.node = node
	NewtonBodySetUserData( object.body, @object )

	' Set some default values for body mass & inertia matrix
	NewtonBodySetMassMatrix ( object.body, default_mass, _
            default_mass*15.0, default_mass*15.0, default_mass*15.0 )

    ' Posistion Callback
    NewtonBodySetTransformCallback( object.body, @NewtonIrrlichtUpdateObjectPosition)
    
    ' Force and Torque callback
    NewtonBodySetForceAndTorqueCallback( object.body, @NewtonIrrlichtUpdateObjectForces)
    
    ' Destructor Callback
    NewtonBodySetDestructorCallback( object.body, @NewtonIrrlichtDestructor)

    ' if collisions are to be reported attach collision callback functions
    if NOT reportCallBack = 0 Then
        Dim as integer i = NewtonMaterialGetDefaultGroupID( nWorld )
        NewtonMaterialSetCollisionCallback ( nWorld, i, i, @object, _
                @ReportNewtonContactBegin, @ReportNewtonContactProcess, 0 )
    End If

End Sub


'' ---------------------------------------------------------------------------
'' create a simple physics box body associated with a node
Sub PhysicsCreateHeightfield( node as irr_node, object as physics_obj )
    
End Sub


'' ---------------------------------------------------------------------------
'' create a simple physics box body associated with a node
Sub PhysicsCreateConvexHull( node as irr_node, object as physics_obj )

    ' get the scale of the node
    DIM as single x, y, z
    IrrGetNodeScale( node, x, y, z )

    ' get the mesh associated with this node
    DIM as irr_mesh mesh = IrrGetNodeMesh( node )

    ' local variables
    Dim TempLoopC As Integer
    Dim MeshVertextotal As Uinteger

    ' get the number of verticies in the object
    MeshVertextotal = IrrGetMeshVertexCount( mesh, 0)
    
    ' create an array to contain the verticies extracted from the loaded or
    ' created model and a parallel array to contain a converted set of vertices
    Dim ConvNewtVertex(0 To MeshVertextotal-1) As IRR_VERT
    Dim ConvNewtVertexB(0 To MeshVertextotal-1) As dFloatVector
    
    ' extract the vertices from the model
    IrrGetMeshVertices( mesh, 0, ConvNewtVertex(0))
    
    ' itterate all of the vertices
    For TemploopC = 0 To MeshVertextotal-1
        ' convert a single vertex
        ConvNewtVertexB(TemploopC).x = ConvNewtVertex(TemploopC).x * x
        ConvNewtVertexB(TemploopC).y = ConvNewtVertex(TemploopC).y * y
        ConvNewtVertexB(TemploopC).z = ConvNewtVertex(TemploopC).z * z
    Next

    ' add all of the vertices as a single collision object, 12 is the byte size
    ' of a vertex
    object.collision = NewtonCreateConvexHull( nWorld, MeshVertextotal, _
            @ConvNewtVertexB(0).x, 12, 0 )

	' Create a convex hull primitive. 
	object.body = NewtonCreateBody( nWorld, object.collision )

	' Set user data pointer to the scene node
    object.node = node
	NewtonBodySetUserData( object.body, @object )

	' Set some default values for body mass & inertia matrix
	NewtonBodySetMassMatrix ( object.body, default_mass, _
            default_mass*15.0, default_mass*15.0, default_mass*15.0 )

    ' Posistion Callback
    NewtonBodySetTransformCallback( object.body, @NewtonIrrlichtUpdateObjectPosition)
    
    ' Force and Torque callback
    NewtonBodySetForceAndTorqueCallback( object.body, @NewtonIrrlichtUpdateObjectForces)
    
    ' Destructor Callback
    NewtonBodySetDestructorCallback( object.body, @NewtonIrrlichtDestructor)

    ' if collisions are to be reported attach collision callback functions
    if NOT reportCallBack = 0 Then
        Dim as integer i = NewtonMaterialGetDefaultGroupID( nWorld )
        NewtonMaterialSetCollisionCallback ( nWorld, i, i, @object, _
                @ReportNewtonContactBegin, @ReportNewtonContactProcess, 0 )
    End If

End Sub


'' ---------------------------------------------------------------------------
'' create a simple physics box body associated with a node
Sub PhysicsCreateTriMesh( node as irr_node, object as physics_obj )

    ' get the scale of the node
    DIM as single x, y, z
    IrrGetNodeScale( node, x, y, z )

    ' get the mesh associated with this node
    DIM as irr_mesh mesh = IrrGetNodeMesh( node )


    ' Local variables
    Dim MeshBufferTotal As Integer
    Dim MeshIndextotal As Integer
    Dim MeshVertextotal As Integer
    Dim i As Integer

    ' create a newton collision object
    object.collision = NewtonCreateTreeCollision( nWorld, 0 )
    NewtonTreeCollisionBeginBuild( object.collision )

    ' itterate the mesh buffers
    MeshBufferTotal = IrrGetMeshBufferCount( mesh, 0 )

    Dim as integer VertTotal = 0
    Dim MeshBufferLoop as Integer
    for MeshBufferLoop = 0 to MeshBufferTotal - 1

        ' get the number of indicies and verticies in the irrlicht mesh
        MeshIndextotal = IrrGetMeshIndexCount( mesh, 0, MeshBufferLoop )
        MeshVertextotal = IrrGetMeshVertexCount( mesh, 0, MeshBufferLoop )

        ' create an array to contain the indicies and verticies extracted from the
        ' loaded or created model
        ReDim ConvNewtIndices(0 To MeshIndextotal-1) As Ushort
        ReDim ConvNewtVertex(0 To MeshVertextotal-1) As IRR_VERT

        ' extract the indicies and verticies from the model
        IrrGetMeshIndices( mesh, 0, ConvNewtIndices(0), MeshBufferLoop )
        IrrGetMeshVertices( mesh, 0, ConvNewtVertex(0), MeshBufferLoop )
    
        ' each face is a triangle consisting of three verticies those verticies
        ' are identified in the table of verticles by each consecutive group of
        ' three indicies. the following store a single face 
        Dim nPoint(8) As Single
        Dim FaceRot As Integer
        Dim As Uinteger VtxCount=3

        ' initialise the state machine to the first vertex of the face
        FaceRot=1
        ' itterate all of the indicies in the mesh
        For i = 0 To MeshIndextotal-1

            Select Case As Const FaceRot
                ' first vertex of the face
                Case 1
                    nPoint(0)=ConvNewtVertex(ConvNewtIndices(i)).x * x
                    nPoint(1)=ConvNewtVertex(ConvNewtIndices(i)).y * y
                    nPoint(2)=ConvNewtVertex(ConvNewtIndices(i)).z * z
                    FaceRot=2
                ' second vertex of the face
                Case 2
                    nPoint(3)=ConvNewtVertex(ConvNewtIndices(i)).x * x
                    nPoint(4)=ConvNewtVertex(ConvNewtIndices(i)).y * y
                    nPoint(5)=ConvNewtVertex(ConvNewtIndices(i)).z * z
                    FaceRot=3
                ' last vertex of the face
                Case 3
                    nPoint(6)=ConvNewtVertex(ConvNewtIndices(i)).x * x
                    nPoint(7)=ConvNewtVertex(ConvNewtIndices(i)).y * y
                    nPoint(8)=ConvNewtVertex(ConvNewtIndices(i)).z * z

                    ' we have converted an entire face add the face to the collision
                    ' object and assign it a unique id number(TemploopC)
                    NewtonTreeCollisionAddFace( object.collision, VtxCount, _
                            @nPoint(0), SizeOf(dFloatVector), i+VertTotal )
                    FaceRot=1
            End Select
        Next
        VertTotal += i
        
    Next MeshBufferLoop

    ' build the converted collision object
    NewtonTreeCollisionEndBuild( object.collision, 1)

    Print "Mesh Buffer Count: ";MeshBufferTotal
    Print "Mesh Buffer(";MeshBufferLoop;") Indicies: ";MeshIndextotal
    Print "Mesh Buffer(";MeshBufferLoop;") Verticies: ";MeshVertextotal

	' Create a convex hull primitive. 
	object.body = NewtonCreateBody( nWorld, object.collision )

	' Set user data pointer to the scene node
    object.node = node
	NewtonBodySetUserData( object.body, @object )

	' Set some default values for body mass & inertia matrix
	NewtonBodySetMassMatrix ( object.body, default_mass, _
            default_mass*15.0, default_mass*15.0, default_mass*15.0 )

    ' Posistion Callback
    NewtonBodySetTransformCallback( object.body, @NewtonIrrlichtUpdateObjectPosition)
    
    ' Force and Torque callback
    NewtonBodySetForceAndTorqueCallback( object.body, @NewtonIrrlichtUpdateObjectForces)
    
    ' Destructor Callback
    NewtonBodySetDestructorCallback( object.body, @NewtonIrrlichtDestructor)

    'Lastly Freeze the body for speed
    NewtonWorldFreezeBody( nWorld, object.body )

End Sub


'' ---------------------------------------------------------------------------
'' test for collision with a ray cast into the world
Sub PhysicsCastRay( p1 as IRR_VECTOR, p2 as IRR_VECTOR, object as physics_obj )
End Sub


'' ---------------------------------------------------------------------------
'' test for collision between two physics objects
Function PhysicsCheckCollision( o1 as physics_obj, o2 as physics_obj ) as integer

    Dim As TransMatrix o1Mat, o2Mat

    ' get the objects matrix
    NewtonBodyGetMatrix( o1.body, @o1Mat.m(0))
    NewtonBodyGetMatrix( o2.body, @o2Mat.m(0))

    Dim as integer nContacts = 2
    Dim as single contacts(3 * nContacts)
    Dim as single normals(3 * nContacts)
    Dim as single penetration( nContacts )

    ' Check for collision between collision meshes,
    Dim as integer nHits = NewtonCollisionCollide( nWorld, nContacts, _
        o1.collision, @o1Mat.m(0), _
        o2.collision, @o2Mat.m(0), _
        @contacts(0), _
        @normals(0), _
        @penetration(0))

    return nHits

End Function


'' ---------------------------------------------------------------------------
'' Update the position and rotation of an irrlicht node from an ODE body
Sub PhysicsSetNodePositionAndRotation( object as physics_obj )

    ' local variables
    Dim TmpNewtDat(2) As dFloat
    Dim TransMat As TransMatrix

    ' get the objects matrix
    NewtonBodyGetMatrix( object.body, @TransMat.m(0))

    ' Convert the Angle
    NewtonGetEulerAngle(@TransMat.m(0), @TmpNewtDat(0))

    ' set position and rotation via the pointer At translation matrix values 12 to 14
    IrrSetNodePosition( object.node, TransMat.m(12), TransMat.m(13), TransMat.m(14))
    IrrSetNodeRotation( object.node,_
            TmpNewtDat(0) * 57.295779513, _
            TmpNewtDat(1) * 57.295779513, _
            TmpNewtDat(2) * 57.295779513 )

End Sub

'' ---------------------------------------------------------------------------
'' Update the position and rotation of a Newton body from an irrlicht node
Sub PhysicsGetNodePositionAndRotation( object as physics_obj )

    ' set the position of the geometry
    Dim as dFloat X, Y, Z
    Dim TransMat As TransMatrix
    Dim angles(3) As dfloat
    
    ' set the angle of the geometry
    IrrGetNodeRotation( object.node, X, Y, Z )
    angles(0) = x / 57.295779513
    angles(1) = y / 57.295779513
    angles(2) = z / 57.295779513
    NewtonSetEulerAngle(@angles(0), @TransMat.m(0))

    IrrGetNodePosition( object.node, X, Y, Z )
    TransMat.m(12)=x
    TransMat.m(13)=y
    TransMat.m(14)=z
    NewtonBodySetMatrix( object.body, @(TransMat.m(0)))

End Sub


'' ---------------------------------------------------------------------------
'' remove the object from the physics engine
Sub PhysicsDestroyObject( object as physics_obj )

    NewtonReleaseCollision( nWorld, object.collision )
    NewtonDestroyBody( nWorld, object.body )

End Sub



'' ////////////////////////////////////////////////////////////////////////////
'' Support Function Definitions

' this callback function is called by newton when an object is destroyed within
' the newton world. we can use this call to release allocated memory.
'
Sub NewtonIrrlichtDestructor Cdecl( Byval TmpNewtBody As NewtonBody Ptr )

    ' Set a pointer equal to the user data pointer
    Dim TmpObjPtr As physics_obj Ptr
    TmpObjPtr=NewtonBodyGetUserData(TmpNewtBody)

End Sub


' this callback function is called by newton when an object is updated by the
' newton physics engine unless that object has reached a state of inactivity.
' the physics engine will have calculated a new position and rotation for the
' object and we must move that irrlicht object to this position and rotation
'
Sub NewtonIrrlichtUpdateObjectPosition Cdecl( _
        Byval TmpNewtBody As NewtonBody Ptr, _
        Byval TransMatpoint As dFloat Ptr)

    ' local variables
    Dim TmpNewtDat(2) As dFloat
    Dim TmpObjPtr As physics_obj Ptr
    Dim TransMat As TransMatrix Ptr
    TransMat=Cast( Any ptr, TransMatpoint )

    ' Convert the Angle
    NewtonGetEulerAngle(@(*TransMat).m(0), @TmpNewtDat(0))

    ' Set a pointer equal to the user data pointer
    TmpObjPtr=NewtonBodyGetUserData(TmpNewtBody)

    ' set position and rotation via the pointer At translation matrix values 12 to 14
    If NOT (*TmpObjPtr).node = IRR_NO_OBJECT Then
        IrrSetNodePosition((*TmpObjPtr).node, (*TransMat).m(12),(*TransMat).m(13),(*TransMat).m(14))
        IrrSetNodeRotation((*TmpObjPtr).node, _
                TmpNewtDat(0) * 57.295779513,_
                TmpNewtDat(1) * 57.295779513,_
                TmpNewtDat(2) * 57.295779513)
    End If

End Sub


' this callback function is called by newton when an object is updated by the
' newton physics engine unless that object has reached a state of inactivity.
' the physics engine will have calculated torque and forces for the body that
' are applied by this callback. additional constraints and events could be
' applied at this point
'
Sub NewtonIrrlichtUpdateObjectForces Cdecl( Byval TmpNewtBody As NewtonBody Ptr )

    ' Retrieve Data on the Body
    Dim TmpObjPtr As physics_obj Ptr
    TmpObjPtr = NewtonBodyGetUserData(TmpNewtBody)

    Dim objMass as single
    Dim Ixx as single
    Dim Iyy as single
    Dim Izz as single
    Dim force(3) as single
    Dim torque(3) as single
    
    NewtonBodyGetMassMatrix( (*TmpObjPtr).body, @objMass, @Ixx, @Iyy, @Izz )
    
    force(0) = objMass * gravity.x
    force(1) = objMass * gravity.y
    force(2) = objMass * gravity.z

    torque(0) = 0.0f
    torque(1) = 0.0f
    torque(2) = 0.0f
    
    NewtonBodyAddForce( (*TmpObjPtr).body, @force(0) )
    NewtonBodyAddTorque( (*TmpObjPtr).body, @torque(0) )

End Sub

' this callback is called when it is possible two objects are about to collide
' we just note the objects
function ReportNewtonContactBegin cdecl(_
        mat as NewtonMaterial ptr, _
        b1 as NewtonBody ptr, _
        b2 as NewtonBody ptr) as integer

    collisionBody1 = b1
    collisionBody2 = b2
    return 1

end function

' This callback is called when the objects actually do collide with a list of
' contacts there is a lot you could do here but we simply report the collision
' to our callback function
function ReportNewtonContactProcess cdecl( _
        mat as NewtonMaterial ptr, _
        contact as NewtonContact ptr ) as integer

    Dim As physics_obj Ptr p1, p2
    if NOT collisionBody1 = 0 then p1 = NewtonBodyGetUserData( collisionBody1 )
    if NOT collisionBody2 = 0 then p2 = NewtonBodyGetUserData( collisionBody2 )

    reportCallBack( p1, p2 )

    return 1    ' process this collision

end function


#endif