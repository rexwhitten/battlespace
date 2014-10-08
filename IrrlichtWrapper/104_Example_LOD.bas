'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 104 : Level of Detail
'' This example demonstrates an automatic mesh management node that swaps the
'' mesh used for a node based on how far away that node is from the camera. By
'' adding low resoloution meshes at a distance  you can reduce the number of
'' polygons drawn to the scene and gain a significant improvement of the speed
'' of the program
'' If you add a distance with no mesh this is taken as the limit of the node and
'' beyond this distance the node is faded away to nothing. This allows you to
'' very easily fade nodes in and out of your scene as they appear at the edges.
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

' COMMENT this out to disable Level Of Detail and see your performance gain
#define USE_LOD

' COMMENT this out to remove the framerate restriction and run at maximum speed
#define RUN_FLAT_OUT

' CHANGE this define to control how many objects are added to the scene
#define ROWS_AND_COLUMNS    20


'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM LOD1Mesh as irr_mesh
DIM LOD2Mesh as irr_mesh

DIM MeshTextureA as irr_texture
DIM MeshTextureB as irr_texture
DIM ParticleTexture as irr_texture

DIM SceneNode as irr_node
DIM OurCamera as irr_camera

DIM Shared Objects as integer = 400


Sub NodeChangeCallback cdecl ( visible as uinteger, node as irr_node )
    if visible = 0 then
        Objects -= 1
    else
        Objects += 1
    End if
End Sub

'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

Print "Show LOD for : -"
Print "1 - Mesh Nodes"
Print "2 - Billboards"
Print "3 - Billboard Groups"

Dim nodeType as integer
Input nodeType

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 512, 512, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_NO_SHADOWS, IRR_IGNORE_EVENTS )

' load the meshes used for level of detail on this object
LOD1Mesh = IrrGetMesh( "./media/cylinderY.obj" )
LOD2Mesh = IrrGetMesh( "./media/cylinderYLow.obj" )

' scale the two meshes to a size appropriate for our scene
IrrScaleMesh( LOD1Mesh, 8.0 )
IrrScaleMesh( LOD2Mesh, 8.0 )

' for a fair test make sure that the both meshes are hardware accellerated
IrrSetMeshHardwareAccelerated( LOD1Mesh )
IrrSetMeshHardwareAccelerated( LOD2Mesh )

' load texture resources for texturing the scene nodes
MeshTextureA    = IrrGetTexture( "./media/Cross.bmp" )
MeshTextureB    = IrrGetTexture( "./media/Diagonal.bmp" )
ParticleTexture = IrrGetTexture( "./media/cloud4.png" )

' Add a big grid of nodes to demonstrate level of detail
DIM as irr_node SceneNodes(ROWS_AND_COLUMNS*ROWS_AND_COLUMNS)
DIM as integer i, j, k = 0, l

For i = -ROWS_AND_COLUMNS/2 to ROWS_AND_COLUMNS/2 - 1

    For j = -ROWS_AND_COLUMNS/2 to ROWS_AND_COLUMNS/2 - 1

        If nodeType = 1 Then
            SceneNodes(k) = IrrAddMeshToScene( LOD1Mesh )
            IrrSetNodePosition( SceneNodes(k), i*40.0, 0.0, j*40.0 )
    
            if ( i + (j mod 2)) mod 2 = 0 Then
                IrrSetNodeMaterialTexture( SceneNodes(k), MeshTextureA, 0 )
            Else
                IrrSetNodeMaterialTexture( SceneNodes(k), MeshTextureB, 0 )
            End if

        ElseIf nodeType = 2 Then

            SceneNodes(k) = IrrAddBillBoardToScene( 20.0,20.0, i*40.0, 0.0, j*40.0 )
            IrrSetNodeMaterialTexture( SceneNodes(k), ParticleTexture, 0 )
            IrrSetNodeMaterialType( SceneNodes(k), IRR_EMT_TRANSPARENT_ADD_COLOR )
        
        ElseIf nodeType = 3 Then

            ' add a billboard group to the scene
            SceneNodes(k) = IrrAddBillBoardGroupToScene
            for l = 1 to 5
                IrrAddBillBoardToGroup( SceneNodes(k), l*4.0, l*4.0, rnd*5.0-2.5, rnd*5.0-2.5, rnd*5.0-2.5 )
            next l
            IrrSetNodePosition( SceneNodes(k), i*40.0, 0.0, j*40.0 )
            IrrSetNodeMaterialTexture( SceneNodes(k), ParticleTexture, 0 )
            IrrSetNodeMaterialType( SceneNodes(k), IRR_EMT_TRANSPARENT_ADD_COLOR )
        End If

        IrrSetNodeMaterialFlag( SceneNodes(k), IRR_EMF_LIGHTING, IRR_ON )
        dim as irr_material Material = IrrGetMaterial( SceneNodes(k), 0 )
        IrrMaterialVertexColorAffects( Material, ECM_NONE )
        IrrMaterialSetAmbientColor ( Material, 255,255,255,255 )
        IrrMaterialSetDiffuseColor ( Material, 255,255,255,255 )

        k += 1
    Next j
Next i

' add a LOD Manager, this takes 3 parameters
' the first is the number of 1/4 seconds over which a node is faded in or out
' in this example it is 4 so they will fade in and out in about a second
' the second parameter is whether alpha is used when objects are faded, some
' materials need it some dont you will have to experiment with this
' the last parameter is a callback function that is called whenever a node is
' made invisible or visible if you dont want this feature leave the parameter out
DIM as irr_node LODManager = IrrAddLODManager( 4, IRR_ON, @NodeChangeCallback )

' The material map tells the LOD system which material you want to use to fade
' a node out for a particular material type. by default every node uses
' IRR_EMT_TRANSPARENT_VERTEX_ALPHA for fading but you can change this on a per
' material basis so here instead of using IRR_EMT_TRANSPARENT_VERTEX_ALPHA the
' material type IRR_EMT_TRANSPARENT_ADD_COLOR uses itself when fading again this
' needs experimentation to find what works best for your scene
IrrSetLODMaterialMap( LODManager, IRR_EMT_TRANSPARENT_ADD_COLOR, IRR_EMT_TRANSPARENT_ADD_COLOR )

' add the first level of detail from 0 outwards this uses a high resoloution mesh
IrrAddLODMesh( LODManager,   0.0, LOD1Mesh )

' add a lower levl of detail from 100.0 outwards, this is more in the distance
' so the mesh is swapped for a low detail mesh
IrrAddLODMesh( LODManager, 100.0, LOD2Mesh )

' fade objects out from 400.0 outwards, when an object is over 400.0 units away
' it will fade out of the scene smoothly
IrrAddLODMesh( LODManager, 400.0, IRR_NO_OBJECT )

' disable lighting on the manager
IrrSetNodeMaterialFlag( LODManager, IRR_EMF_LIGHTING, IRR_OFF )

#ifdef USE_LOD
i = 0
while i < k
    ' add all of the nodes to the LOD Manager
    IrrAddChildToParent( SceneNodes(i), LODManager )
    i += 1
wend
#endif

' add a camera into the scene
OurCamera = IrrAddFPSCamera( IRR_NO_OBJECT, 100.0f, 0.05f )
IrrSetNodePosition( OurCamera, 0,ROWS_AND_COLUMNS*4,ROWS_AND_COLUMNS*2 )
IrrSetCameraTarget( OurCamera, 0,0,0 )
IrrSetCameraClipDistance( OurCamera, 2500.0 )

' set the ambient light level across the entire scene
IrrSetAmbientLight( 1,1,1 )

' hide the mouse pointer
IrrHideMouse


' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
DIM as String metrics
Dim as Single timeElapsed, currentTime, frameTime = timer
WHILE IrrRunning
#ifndef RUN_FLAT_OUT
    ' is it time for another frame
    currentTime = timer
    timeElapsed = currentTime - frameTime
    if timeElapsed > 0.0167 then
        ' record the start time of this frame
        frameTime = currentTime
#endif
        ' begin the scene, erasing the canvas with sky-blue before rendering
        IrrBeginScene( 64, 96, 255 )
    
        ' display the framerate, number of polygons and nodes
        metrics = "Example 103: LOD Manager ("+Str( IrrGetFPS )+" fps) ("+Str( IrrGetPrimitivesDrawn )+" polygons) ("+Str(Objects)+" nodes)"
        IrrSetWindowCaption( metrics )
        
        ' draw the scene
        IrrDrawScene
        
        ' end drawing the scene and render it
        IrrEndScene
#ifndef RUN_FLAT_OUT
    End If
#endif
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
