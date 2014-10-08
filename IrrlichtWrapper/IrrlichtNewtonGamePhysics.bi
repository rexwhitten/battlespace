''
'' A Freebasic Newton Physics toolset for the IrrlichtWrapper
'' SiskinEDGE (2009)
''
'' This is a set of functions that can be used to convert Irrlicht objects
'' extracted though the IrrlichtWrapper into newton dynamics collision objects
''
'' History:
''  Created by Siskinedge 2009
''  Some additional comments and interface changes by Frank Dodd 2009
''
#define IRRLICHT_NEWTON_VERSION 0.2
#ifndef __Newton_bi__

'' ////////////////////////////////////////////////////////////////////////////
'' Instructions to include the dependant library
#Include "Newton.bi"


'' ////////////////////////////////////////////////////////////////////////////
'' Constant Definitions

#define NEWTON_MAP      0
#define NEWTON_OBJECT   1


'' ////////////////////////////////////////////////////////////////////////////
'' Type Definitions

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

' a scene object used to tie irrlicht objects and newton objects together
Type NewtonSceneObjectClass
    ClassTotal As Integer
    MeshSource As String
    TextSource As String
    SpecTextSource As String
    Mesh As Irr_Mesh
    MainText As Irr_Texture
    SpecText As Irr_Texture
    SpecTextType As String
    ObjNewtCollision As NewtonCollision Ptr
    PhysType As String
    Weight As dFloat
    inertia As dFloatVector
    Origin As dFloatVector
End Type

' a scene object used to tie irrlicht objects and newton objects together
Type NewtonSceneObject
    ObjType As String
    ObjClass As Integer
    ObjIndex As Integer
    IrrBody As Irr_node
    NewtBody As NewtonBody Ptr
    Position As dFloatVector
    Angle As dFloatVector
    Core As NewtonSceneObjectClass Ptr
    Impulse As Force
End Type

' a translation matrix for operations on 3d points
Type TransMatrix
    m(15) As dFloat
End Type

' a type that allows for the definition of newton world properties
Type NewtonWorldData
    TmpData(1 To 3) As dFloatVector                                                                                                                'pass on tmp data for iterators
    Gravity As dFloatVector                                                                                                                                        'Gravity Vector
    nWorldAA As dFloatVector                                                                                                                                'Size of newton world, redefined as meshes are added
    nWorldBB As dFloatVector                                                                                                                                'Size of newton world, redefined as meshes are added
    TimeScaleFactor As Single                                                                                                                                'Factor by witch time is scaled
    TimeInterval As Single                                                                                                                                        'Time Since Last update
    LastUpdate As Single                                                                                                                                                'Time of Last update
End Type


'' ////////////////////////////////////////////////////////////////////////////
'' Forward declaration of internal functions
Declare Sub ConvIrrmesh2Newton( Byref targetmesh As irr_mesh, Byref ConvertedColision As NewtonCollision Ptr, Byref theobject As NewtonSceneObject Ptr)
Declare Sub LoadIntoNewtonBodys(ByRef TmpObjPtr As NewtonSceneObject Ptr)
Declare Sub ConvIrr2ConvHull( Byref targetmesh As irr_mesh, Byref ConvertedColision As NewtonCollision Ptr )
Declare Sub LoadNewtMassMatrix(ByRef TargetClss As NewtonSceneObjectClass Ptr)
Declare Sub VisualizeMesh( physicsObject as NewtonSceneObject ptr, srcMesh as irr_mesh )


'' ////////////////////////////////////////////////////////////////////////////
'' Support variables

#ifndef nWorld
Dim Shared nWorld As NewtonWorld Ptr            ' newton world object
Dim Shared nWorldUserData as NewtonWorldData
#endif


'' ////////////////////////////////////////////////////////////////////////////
'' Function Definitions

' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' functions for simplifying the managment the newton world

' start the newton physics engine
'
Sub NewtonStartPhysics
    ' create an empty newton world that uses system alloc and free
    nworld = NewtonCreate( 0, 0 )
    
    ' set up some default newton world physical properties
    Dim DefNewtMateral As Short         ' Default Newton Materal
    DefNewtMateral = NewtonMaterialGetDefaultGroupID(nWorld)
    NewtonMaterialSetDefaultFriction(nWorld, DefNewtMateral, DefNewtMateral, 0.8f, 0.4f)
    NewtonMaterialSetDefaultElasticity(nWorld, DefNewtMateral, DefNewtMateral, 0.3f)
    NewtonMaterialSetDefaultSoftness(nWorld, DefNewtMateral, DefNewtMateral, 0.05f)
    NewtonMaterialSetCollisionCallback(nWorld, DefNewtMateral, DefNewtMateral, 0, 0, 0, 0)
    NewtonSetMinimumFrameRate( nWorld, 2 )
    NewtonWorldSetUserData( nWorld, @nWorldUserData )
    'charecter material needs to be frictionless or movement is weird
    'nWorldUserData.CharMateral = NewtonMaterialCreateGroupID(nWorld)
    'NewtonMaterialSetDefaultFriction(nWorld, DefNewtMateral, nWorldUserData.CharMateral, 0.0f, 0.0f)
    
    ' Optimise the Solver for speed
    NewtonSetSolverModel( nWorld, 1)
    
    ' Seed Random Numbers
    Randomize Timer
    
    ' Set initial Last update timer
    nWorldUserData.LastUpdate = Timer
    ' Set Default Time Scale Factor
    nWorldUserData.TimeScaleFactor = 1
End Sub

' update the newton world. this macro simply obscures the nWorld variable
'
' Update the Newton World, Simplfies Use
Sub NewtonUpdatePhysics
    '' Update Physics
    nWorldUserData.TimeInterval = (Timer - nWorldUserData.LastUpdate)*nWorldUserData.TimeScaleFactor
    nWorldUserData.LastUpdate = Timer
    NewtonUpdate( nWorld, nWorldUserData.TimeInterval )
    '' Free Particles
    'Dim TempLoop As Integer
    'If nWorldUserData.PhysParticles.TotalParticles > 0 Then
    'For TempLoop = 0 To (nWorldUserData.PhysParticles.TotalParticles - 1)
    'If (Timer - nWorldUserData.PhysParticles.Particles[TempLoop].CreationTime) > nWorldUserData.PhysParticles.Particles[TempLoop].LifeTime Then
    'NewtonFreeParticle( @nWorldUserData.PhysParticles.Particles[TempLoop] )
    'EndIf
    'Next
    'EndIf'
End Sub

' stop the newton physics engine releasing allocated resources
'
Sub NewtonStopPhysics
    NewtonDestroy(nWorld)
End Sub

' set the scale of time in the scene
Sub NewtonSetTimeScale( Byref TimeScaleFactor As Single)
    nWorldUserData.TimeScaleFactor = TimeScaleFactor
End Sub

' Get the scale of time in the scene
Function NewtonGetTimeScale As Single
    Return nWorldUserData.TimeScaleFactor
End Function

' simplified call to add an irrlicht object to the newton world as a newton
' tree formed from a soup of polygons
'
Sub NewtonAddMeshObject( ByRef physicsObject as NewtonSceneObject ptr, _
                         ByRef suppliedMesh as irr_mesh, _
                         ByRef suppliedNode as irr_node, _
                         ByRef suppliedWeight as single )

    ' allocate new objects for this node
    Dim ClassPtr as NewtonSceneObjectClass ptr
    ClassPtr = allocate( sizeof( NewtonSceneObjectClass ))

    ' set up any supplied newton properties
    (*physicsObject).ObjType = "Map"
    (*physicsObject).Core = ClassPtr
    (*ClassPtr).Weight = suppliedWeight
    (*ClassPtr).Mesh = suppliedMesh
    (*physicsObject).IrrBody = suppliedNode

    ' if a node was not supplied build a visualisation object
    If suppliedNode = 0 then
        VisualizeMesh( physicsObject, suppliedMesh )
    End If

    ' create the newton object
    ConvIrrmesh2Newton( suppliedMesh, (*ClassPtr).ObjNewtCollision, 0 )
    LoadIntoNewtonBodys(physicsObject)
    
    ' set the node position 
    IrrSetNodePosition( (*physicsObject).IrrBody, _
            (*physicsObject).Position.x, _
            (*physicsObject).Position.y, _
            (*physicsObject).Position.z )
End Sub


' simplified call to add an irrlicht object to the newton world as a simple
' convex hull that is an object with no concave angles. for example a box or a
' ball but not a cross
'
Sub NewtonAddConvexObject ( ByRef physicsObject as NewtonSceneObject ptr, _
                            ByRef suppliedMesh as irr_mesh, _
                            ByRef suppliedNode as irr_node, _
                            ByRef suppliedWeight as single )


    ' allocate new objects for this node
    Dim ClassPtr as NewtonSceneObjectClass ptr
    ClassPtr = allocate( sizeof( NewtonSceneObjectClass ))
    
    ' set up any supplied newton properties
    (*physicsObject).ObjType = "Object"
    (*physicsObject).Core = ClassPtr
    (*ClassPtr).Weight = suppliedWeight
    (*ClassPtr).Mesh = suppliedMesh
    (*physicsObject).IrrBody = suppliedNode

    ' create the newton object
    ConvIrr2ConvHull( suppliedMesh, (*ClassPtr).ObjNewtCollision )
    LoadNewtMassMatrix( ClassPtr )
    LoadIntoNewtonBodys( physicsObject )
    NewtonReleaseCollision( nWorld, (*ClassPtr).ObjNewtCollision)
    
    ' set the node position 
    IrrSetNodePosition( (*physicsObject).IrrBody, _
            (*physicsObject).Position.x, _
            (*physicsObject).Position.y, _
            (*physicsObject).Position.z )
End Sub



' remove the newton object from the newton world freeing its resources
'
Sub NewtonRemoveObject( ByRef physicsObject as NewtonSceneObject ptr )
    NewtonDestroyBody( nWorld, (*physicsObject).NewtBody )
End Sub


' Function to set the size of the newton world based on a newton object
'
Sub NewtonSizeWorld( ByRef TmpObjPtr As NewtonSceneObject Ptr )
    Dim As dFloat boxp0(2)
    Dim As dFloat boxp1(2)
    Dim TransMat As TransMatrix

    ' calculate the bounding box of the newton object
    NewtonBodyGetMatrix( TmpObjPtr->NewtBody, @TransMat.m(0))
    NewtonCollisionCalculateAABB ( TmpObjPtr->Core->ObjNewtCollision, _
                                   @(TransMat.m(0)), @boxP0(0), @boxP1(0))

    ' create an additional border around the world
    boxP0(0) -= 100.0
    boxP0(1) -= 00.0
    boxP0(2) -= 100.0
    boxP1(0) += 100.0
    boxP1(1) += 500.0
    boxP1(2) += 100.0
    
    ' set the size of the object in the newton world
    NewtonSetWorldSize(nWorld, @boxP0(0), @boxP1(0))
	NewtonReleaseCollision (nWorld, TmpObjPtr->Core->ObjNewtCollision)
    
    ' display the world size
    print "Newton world size (";boxP0(0);",";boxP0(1);",";boxP0(2);") (";boxP1(0);",";boxP1(1);",";boxP1(2);")"
End Sub



' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' internal callback functions for reacting to events in the newton world

' this callback function is called by newton when an object is destroyed within
' the newton world. we can use this call to release allocated memory.
'
Sub NewtonIrrlichtDestructor Cdecl( Byval TmpNewtBody As NewtonBody Ptr )

    Dim TmpObjPtr As NewtonSceneObject Ptr

    ' Set a pointer equal to the user data pointer
    TmpObjPtr=NewtonBodyGetUserData(TmpNewtBody)

    deallocate ((*TmpObjPtr).Core)
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
    Dim TmpObjPtr As NewtonSceneObject Ptr
    Dim TransMat As TransMatrix Ptr
    TransMat=Cast( Any ptr, TransMatpoint )

    ' Convert the Angle
    NewtonGetEulerAngle(@(*TransMat).m(0), @TmpNewtDat(0))
    TmpNewtDat(0)=TmpNewtDat(0)*(57.32)
    TmpNewtDat(1)=TmpNewtDat(1)*(57.32)
    TmpNewtDat(2)=TmpNewtDat(2)*(57.32)

    ' Set a pointer equal to the user data pointer
    TmpObjPtr=NewtonBodyGetUserData(TmpNewtBody)

    ' set position and rotation via the pointer At translation matrix values 12 to 14
    IrrSetNodePosition((*TmpObjPtr).IrrBody,(*TransMat).m(12),(*TransMat).m(13),(*TransMat).m(14))
    IrrSetNodeRotation((*TmpObjPtr).IrrBody,TmpNewtDat(0),TmpNewtDat(1),TmpNewtDat(2))

    ' Update the body Positions to the body pointer
    (*TmpObjPtr).Position.x=(*TransMat).m(12)
    (*TmpObjPtr).Position.y=(*TransMat).m(13)
    (*TmpObjPtr).Position.z=(*TransMat).m(14)
    (*TmpObjPtr).Angle.x=TmpNewtDat(0)
    (*TmpObjPtr).Angle.y=TmpNewtDat(1)
    (*TmpObjPtr).Angle.z=TmpNewtDat(2)
End Sub


' this callback function is called by newton when an object is updated by the
' newton physics engine unless that object has reached a state of inactivity.
' the physics engine will have calculated torque and forces for the body that
' are applied by this callback. additional constraints and events could be
' applied at this point but arent
'
Sub NewtonIrrlichtUpdateObjectForces Cdecl(Byval TmpNewtBody As NewtonBody Ptr)
    ' local variables
    Dim TmpObjPtr As NewtonSceneObject Ptr
    Dim TmpClssPtr As NewtonSceneObjectClass Ptr
    Dim TmpVector As dFloatVector
    Dim TmpForce As dFloatVector
    
    'Retive Data on the Body
    TmpObjPtr = NewtonBodyGetUserData(TmpNewtBody)
    
    'Retrive the classs
    TmpClssPtr=(*TmpObjPtr).Core
    
    'Add the New Rotational Force to the body
    If ((*TmpObjPtr).Impulse.Angular.x)<>0 Or (*TmpObjPtr).Impulse.Angular.y<>0 Or (*TmpObjPtr).Impulse.Angular.z<>0 Then
        NewtonBodyGetOmega(TmpNewtBody, @TmpVector.x )
        TmpVector.x=(*TmpObjPtr).Impulse.Angular.x+TmpVector.x
        TmpVector.y=(*TmpObjPtr).Impulse.Angular.y+TmpVector.y
        TmpVector.z=(*TmpObjPtr).Impulse.Angular.z+TmpVector.z
        NewtonBodySetOmega(TmpNewtBody, @TmpVector.x )
    End If
    
    'Add the New Vector Force to the body
      'Add the New Vector Force to the body
        (*TmpObjPtr).Impulse.Vector.x=(*TmpObjPtr).Impulse.Vector.x+((*TmpClssPtr).inertia.x*nWorldUserData.Gravity.x*nWorldUserData.TimeInterval)
        (*TmpObjPtr).Impulse.Vector.y=(*TmpObjPtr).Impulse.Vector.y+((*TmpClssPtr).inertia.y*nWorldUserData.Gravity.y*nWorldUserData.TimeInterval)
        (*TmpObjPtr).Impulse.Vector.z=(*TmpObjPtr).Impulse.Vector.z+((*TmpClssPtr).inertia.z*nWorldUserData.Gravity.z*nWorldUserData.TimeInterval)    

    'Adds Forces
    NewtonBodyAddForce(TmpNewtBody, @(*TmpObjPtr).Impulse.Vector.x )
    
    'Return the new impulse to zero
    (*TmpObjPtr).Impulse.Angular.x=0
    (*TmpObjPtr).Impulse.Angular.y=0
    (*TmpObjPtr).Impulse.Angular.z=0
    (*TmpObjPtr).Impulse.Vector.x=0
    (*TmpObjPtr).Impulse.Vector.y=0
    (*TmpObjPtr).Impulse.Vector.z=0
End Sub



' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' internal utility functions

' Function to convert an Irrlicht wrapper mesh to a newton collision tree 
'
Sub ConvIrrmesh2Newton( Byref targetmesh As irr_mesh, _
                        Byref ConvertedColision As NewtonCollision Ptr, _
                        Byref theobject As NewtonSceneObject Ptr)
    ' Local variables
    Dim MeshBufferTotal As Integer
    Dim MeshIndextotal As Integer
    Dim MeshVertextotal As Integer
    Dim TemploopC As Integer

    ' create a newton collision object
    ConvertedColision = NewtonCreateTreeCollision(nWorld, 0)
    NewtonTreeCollisionBeginBuild(ConvertedColision)

    ' itterate the mesh buffers
    MeshBufferTotal = IrrGetMeshBufferCount( targetmesh, 0 )

    Dim as integer VertTotal = 0
    Dim MeshBufferLoop as Integer
    for MeshBufferLoop = 0 to MeshBufferTotal - 1

        ' get the number of indicies and verticies in the irrlicht mesh
        MeshIndextotal = IrrGetMeshIndexCount(targetmesh, 0, MeshBufferLoop)
        MeshVertextotal = IrrGetMeshVertexCount(targetmesh, 0, MeshBufferLoop )
    
        ' create an array to contain the indicies and verticies extracted from the
        ' loaded or created model
        ReDim ConvNewtIndices(0 To MeshIndextotal-1) As Ushort
        ReDim ConvNewtVertex(0 To MeshVertextotal-1) As IRR_VERT

        ' extract the indicies and verticies from the model
        IrrGetMeshIndices( targetmesh,0,ConvNewtIndices(0), MeshBufferLoop )
        IrrGetMeshVertices( targetmesh,0,ConvNewtVertex(0), MeshBufferLoop )
    
        ' each face is a triangle consisting of three verticies those verticies
        ' are identified in the table of verticles by each consecutive group of
        ' three indicies. the following store a single face 
        Dim nPoint(8) As Single
        Dim FaceRot As Integer
        Dim As Uinteger VtxCount=3

        ' initialise the state machine to the first vertex of the face
        FaceRot=1
        ' itterate all of the indicies in the mesh
        For TemploopC = 0 To MeshIndextotal-1

            Select Case As Const FaceRot
                ' first vertex of the face
                Case 1
                    nPoint(0)=ConvNewtVertex(ConvNewtIndices(TemploopC)).x
                    nPoint(1)=ConvNewtVertex(ConvNewtIndices(TemploopC)).y
                    nPoint(2)=ConvNewtVertex(ConvNewtIndices(TemploopC)).z
                    FaceRot=2
                ' second vertex of the face
                Case 2
                    nPoint(3)=ConvNewtVertex(ConvNewtIndices(TemploopC)).x
                    nPoint(4)=ConvNewtVertex(ConvNewtIndices(TemploopC)).y
                    nPoint(5)=ConvNewtVertex(ConvNewtIndices(TemploopC)).z
                    FaceRot=3
                ' last vertex of the face
                Case 3
                    nPoint(6)=ConvNewtVertex(ConvNewtIndices(TemploopC)).x
                    nPoint(7)=ConvNewtVertex(ConvNewtIndices(TemploopC)).y
                    nPoint(8)=ConvNewtVertex(ConvNewtIndices(TemploopC)).z

                    ' we have converted an entire face add the face to the collision
                    ' object and assign it a unique id number(TemploopC)
                    NewtonTreeCollisionAddFace( ConvertedColision, VtxCount, _
                            @nPoint(0), SizeOf(dFloatVector), TemploopC+VertTotal )
                    FaceRot=1
            End Select
        Next
        VertTotal += TempLoopC
        
    Next MeshBufferLoop

    ' build the converted collision object
    NewtonTreeCollisionEndBuild( ConvertedColision, 1)
End Sub


' Function to convert an Irrlicht wrapper mesh to a newton convex hull
'
Sub ConvIrr2ConvHull( Byref targetmesh As irr_mesh, _
                      Byref ConvertedColision As NewtonCollision Ptr )
    ' local variables
    Dim TempLoopC As Integer
    Dim MeshVertextotal As Uinteger

    ' get the number of verticies in the object
    MeshVertextotal = IrrGetMeshVertexCount(targetmesh, 0)
    
    ' create an array to contain the verticies extracted from the loaded or
    ' created model and a parallel array to contain a converted set of vertices
    Dim ConvNewtVertex(0 To MeshVertextotal-1) As IRR_VERT
    Dim ConvNewtVertexB(0 To MeshVertextotal-1) As dFloatVector
    
    ' extract the vertices from the model
    IrrGetMeshVertices(targetmesh,0,ConvNewtVertex(0))
    
    ' itterate all of the vertices
    For TemploopC = 0 To MeshVertextotal-1
        ' convert a single vertex
        ConvNewtVertexB(TemploopC).x=ConvNewtVertex(TemploopC).x
        ConvNewtVertexB(TemploopC).y=ConvNewtVertex(TemploopC).y
        ConvNewtVertexB(TemploopC).z=ConvNewtVertex(TemploopC).z
    Next

    ' add all of the vertices as a single collision object, 12 is the byte size
    ' of a vertex
    ConvertedColision=NewtonCreateConvexHull(nWorld, MeshVertextotal, _
            @ConvNewtVertexB(0).x, 12, 0 )

End Sub


Sub LoadNewtMassMatrix(ByRef TargetClss As NewtonSceneObjectClass Ptr)
	'get inertial matrix and origin
	NewtonConvexCollisionCalculateInertialMatrix( (*TargetClss).ObjNewtCollision, @(*TargetClss).Inertia.x, @(*TargetClss).Origin.x )
	'Multiply inertial matrix by the weight
	(*TargetClss).Inertia.x=(*TargetClss).Weight*(*TargetClss).Inertia.x
	(*TargetClss).Inertia.y=(*TargetClss).Weight*(*TargetClss).Inertia.y
	(*TargetClss).Inertia.z=(*TargetClss).Weight*(*TargetClss).Inertia.z
End Sub


' create a model of the mesh. this can be useful to see exactly what the
' collision function is making out of your supplied object
Sub VisualizeMesh( physicsObject as NewtonSceneObject ptr, srcMesh as irr_mesh )
    ' get the number of indicies and verticies in the irrlicht mesh
    Dim MeshIndextotal as integer = IrrGetMeshIndexCount(srcMesh, 0)
    Dim MeshVertextotal as integer = IrrGetMeshVertexCount(srcMesh, 0)

    ' create an array to contain the indicies and verticies extracted from the
    ' loaded or created model
    Dim ConvNewtIndices(0 To MeshIndextotal-1) As Ushort
    Dim ConvNewtVertex(0 To MeshVertextotal-1) As IRR_VERT

    ' extract the indicies and verticies from the model
    IrrGetMeshIndices(srcMesh,0,ConvNewtIndices(0))
    IrrGetMeshVertices(srcMesh,0,ConvNewtVertex(0))

    Dim TemploopC as integer
    DIM verts(MeshVertextotal) as IRR_VERT
    DIM indices(MeshIndextotal) as ushort
    For TemploopC = 0 To MeshVertextotal-1
        verts(TemploopC).x = ConvNewtVertex(TemploopC).x
        verts(TemploopC).y = ConvNewtVertex(TemploopC).y
        verts(TemploopC).z = ConvNewtVertex(TemploopC).z
        verts(TemploopC).normal_x = ConvNewtVertex(TemploopC).normal_x
        verts(TemploopC).normal_y = ConvNewtVertex(TemploopC).normal_y
        verts(TemploopC).normal_z = ConvNewtVertex(TemploopC).normal_z
        verts(TemploopC).vcolor = ConvNewtVertex(TemploopC).vcolor
        verts(TemploopC).texture_x = ConvNewtVertex(TemploopC).texture_x
        verts(TemploopC).texture_y = ConvNewtVertex(TemploopC).texture_y
    Next TemploopC
    
    For TemploopC = 0 To MeshIndextotal-1
        indices(TemploopC) = ConvNewtIndices(TemploopC)
        if TemploopC < 24 then
            print "(";verts(indices(TemploopC)).x;",";verts(indices(TemploopC)).y;",";verts(indices(TemploopC)).z;")"
        end if
    Next TemploopC
    
    DIM newMesh as irr_mesh
    newMesh = IrrCreateMesh( "TestMesh", MeshVertextotal, verts(0), MeshIndextotal, indices(0))
    (*(*physicsObject).Core).MainText = IrrGetTexture( "./media/texture.jpg" )
    (*physicsObject).IrrBody = IrrAddMeshToScene( newMesh )
    IrrSetNodeMaterialTexture((*physicsObject).IrrBody, (*(*physicsObject).Core).MainText, 0)
    IrrSetNodeMaterialFlag( (*physicsObject).IrrBody, IRR_EMF_LIGHTING, IRR_OFF )
End sub


Sub LoadIntoNewtonBodys(ByRef TmpObjPtr As NewtonSceneObject Ptr)
    Dim LoadMode As String
    Dim TmpClssPtr As NewtonSceneObjectClass Ptr
    LoadMode=(*TmpObjPtr).ObjType
    TmpClssPtr=(*TmpObjPtr).Core

    If LoadMode="Object" Then
		Dim TmpPoint(0 To 2) As dFloat Ptr
		Dim TmpPointB As dFloat Ptr
		'Create the body
		(*TmpObjPtr).NewtBody = NewtonCreateBody (nWorld, (*TmpClssPtr).ObjNewtCollision)
		'set Object data as user data
		NewtonBodySetUserData((*TmpObjPtr).NewtBody, TmpObjPtr)
		'Set Mass
		TmpPoint(0)=@(*TmpClssPtr).inertia.x
		TmpPoint(1)=@(*TmpClssPtr).inertia.y
		TmpPoint(2)=@(*TmpClssPtr).inertia.z
		NewtonBodySetMassMatrix((*TmpObjPtr).NewtBody, (*TmpClssPtr).Weight, (*TmpClssPtr).inertia.x, (*TmpClssPtr).inertia.y, (*TmpClssPtr).inertia.z)
		'Set Origin
		TmpPointB=Allocate(SizeOf(dFloat)*3)
		TmpPointB=@(*TmpClssPtr).Origin.x
		NewtonBodySetCentreOfMass ((*TmpObjPtr).NewtBody, TmpPointB)
		'Position And Rotate Object
		Dim TransMat as TransMatrix
		Dim angles(3) As dfloat
		angles(0) = (*TmpObjPtr).Angle.x/57.32
		angles(1) = (*TmpObjPtr).Angle.y/57.32
		angles(2) = (*TmpObjPtr).Angle.z/57.32
		NewtonSetEulerAngle(@angles(0), @TransMat.m(0))
		TransMat.m(12)=(*TmpObjPtr).Position.x
		TransMat.m(13)=(*TmpObjPtr).Position.y
		TransMat.m(14)=(*TmpObjPtr).Position.z
		NewtonBodySetMatrix( (*TmpObjPtr).NewtBody, @(TransMat.m(0)))
		'Posistion Callback
		NewtonBodySetTransformCallback((*TmpObjPtr).NewtBody, @NewtonIrrlichtUpdateObjectPosition)
        
		'Force and Torque callback
		NewtonBodySetForceAndTorqueCallback((*TmpObjPtr).NewtBody, @NewtonIrrlichtUpdateObjectForces)

		'Destructor Callback
		NewtonBodySetDestructorCallback((*TmpObjPtr).NewtBody, @NewtonIrrlichtDestructor)

        (*TmpObjPtr).Impulse.Angular.x=0
		(*TmpObjPtr).Impulse.Angular.y=0
		(*TmpObjPtr).Impulse.Angular.z=0
		(*TmpObjPtr).Impulse.Vector.x=0
		(*TmpObjPtr).Impulse.Vector.y=0
		(*TmpObjPtr).Impulse.Vector.z=0
    EndIf
	If LoadMode="Map" Then
		Dim TmpPoint(0 To 2) As dFloat Ptr
		Dim TmpPointB As dFloat Ptr
		'Create the body
		(*TmpObjPtr).NewtBody = NewtonCreateBody(nWorld, (*TmpClssPtr).ObjNewtCollision)
		'set Object data as user data
		NewtonBodySetUserData((*TmpObjPtr).NewtBody, @(*TmpObjPtr))
		'Position And Rotate Object
		Dim TransMat as TransMatrix
		Dim angles(3) As dfloat
		angles(0) = (*TmpObjPtr).Angle.x
		angles(1) = (*TmpObjPtr).Angle.y
		angles(2) = (*TmpObjPtr).Angle.z
		NewtonSetEulerAngle(@angles(0), @TransMat.m(0))
		TransMat.m(12)=(*TmpObjPtr).Position.x
		TransMat.m(13)=(*TmpObjPtr).Position.y
		TransMat.m(14)=(*TmpObjPtr).Position.z
		NewtonBodySetMatrix( (*TmpObjPtr).NewtBody, @(TransMat.m(0)))
		'Posistion Callback
		NewtonBodySetTransformCallback ((*TmpObjPtr).NewtBody, @NewtonIrrlichtUpdateObjectPosition)
        
		'Force and Torque callback
		NewtonBodySetForceAndTorqueCallback((*TmpObjPtr).NewtBody, @NewtonIrrlichtUpdateObjectForces)

		'Destructor Callback
		NewtonBodySetDestructorCallback((*TmpObjPtr).NewtBody, @NewtonIrrlichtDestructor)
        
        'Lastly Freeze the body for speed
		NewtonWorldFreezeBody(nWorld, (*TmpObjPtr).NewtBody)
	EndIf
End Sub

#endif