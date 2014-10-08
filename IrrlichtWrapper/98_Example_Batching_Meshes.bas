'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 98 : Batching Meshes
'' This example demonstrates how avoiding large numbers of scene nodes by
'' copying the nodes mesh into a single mesh multiple times can have a
'' significant improvement of the speed of the program
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

' COMMENT this define out to add all of the nodes seperately 
#define BATCHING
' CHANGE this define to control how many objects are added
#define ROWS_AND_COLUMNS    50


'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM MiniMesh as irr_mesh
DIM MeshTextureA as irr_texture
DIM MeshTextureB as irr_texture
DIM SceneNode as irr_node
DIM OurCamera as irr_camera

DIM framerate as IRR_GUI_OBJECT
DIM fpsString as wstring * 256


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 512, 512, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' add a static text field for the frame rate
framerate = IrrAddStaticText( "Calculating ...", 4,492, 508,508, IRR_GUI_BORDER, IRR_GUI_NO_WRAP )

' set the window caption
IrrSetWindowCaption( "Example 98: Batching Meshes" )

' load a mesh this acts as a blue print for the model
MiniMesh = IrrGetMesh( "./media/cylinderY.obj" )
IrrScaleMesh( MiniMesh, 4.0 )

' for a fair test make sure that the cylinder object is hardware accellerated
IrrSetMeshHardwareAccelerated( MiniMesh )


' load texture resources for texturing the scene nodes
MeshTextureA = IrrGetTexture( "./media/Cross.bmp" )
MeshTextureB = IrrGetTexture( "./media/Diagonal.bmp" )

#ifdef BATCHING
' create a batching mesh that will be a collection of other meshes
DIM as irr_mesh meshBatch = IrrCreateBatchingMesh

' add a whole mass of meshes to the batch mesh
DIM as integer i, j
For i = -ROWS_AND_COLUMNS/2 to ROWS_AND_COLUMNS/2
    For j = -ROWS_AND_COLUMNS/2 to ROWS_AND_COLUMNS/2

        ' as we are going to add this mesh as a single node if we want to use
        ' different textures with different meshes we need to apply them to the
        ' mesh before we add the mesh to the batch
        if ( i + (j mod 2)) mod 2 = 0 Then
            ' set the texture of the mesh before you add it so that the
            ' seperate meshes have their own colors
            ' This one will be BLUE
            IrrSetMeshMaterialTexture( miniMesh, MeshTextureA, 0 )
        Else
            ' set the texture of the mesh before you add it so that the
            ' seperate meshes have their own colors
            ' This one will be RED
            IrrSetMeshMaterialTexture( miniMesh, MeshTextureB, 0 )
        End if
        
        ' Add this mesh to the batch at its own unique position
        IrrAddToBatchingMesh ( meshBatch, MiniMesh, i*10.0, j*10.0 )
    Next j
Next i

' finish adding meshes to the batch mesh and create an animated mesh from it
MiniMesh = IrrFinalizeBatchingMesh ( meshBatch )

' get more speed by making the mesh hardware accellerated
IrrSetMeshHardwareAccelerated( MiniMesh )

' add the mesh to the scene as a new node, the node is an instance of the
' mesh object supplied here
SceneNode = IrrAddMeshToScene( MiniMesh )

' switch off lighting effects on this model, as there are no lights in this
' scene the model would otherwise render pule black
IrrSetNodeMaterialFlag( SceneNode, IRR_EMF_LIGHTING, IRR_OFF )

#else

' Add rows of seperate nodes to demonstrate the speed difference
DIM as integer i, j
For i = -ROWS_AND_COLUMNS/2 to ROWS_AND_COLUMNS/2
    For j = -ROWS_AND_COLUMNS/2 to ROWS_AND_COLUMNS/2
        SceneNode = IrrAddMeshToScene( MiniMesh )
        IrrSetNodePosition( SceneNode, i*10.0, j*10.0, 0.0 )
        if ( i + (j mod 2)) mod 2 = 0 Then
            IrrSetNodeMaterialTexture( SceneNode, MeshTextureA, 0 )
        Else
            IrrSetNodeMaterialTexture( SceneNode, MeshTextureB, 0 )
        End if
        IrrSetNodeMaterialFlag( SceneNode, IRR_EMF_LIGHTING, IRR_OFF )
    Next j
Next i
#endif

' add a camera into the scene
OurCamera = IrrAddFPSCamera
IrrSetNodePosition( OurCamera, 0,0,ROWS_AND_COLUMNS*10 )
IrrHideMouse


' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
WHILE IrrRunning
    ' begin the scene, erasing the canvas with sky-blue before rendering
    IrrBeginScene( 240, 255, 255 )

    ' draw the scene
    IrrDrawScene
    
    ' format and display the framerate
    fpsString = "FPS: " + Str(IrrGetFPS) + "    Objects: " + Str(ROWS_AND_COLUMNS*ROWS_AND_COLUMNS) + "    Polys: " + Str(IrrGetPrimitivesDrawn) + "    Per Object: " + Str(IrrGetPrimitivesDrawn/(ROWS_AND_COLUMNS*ROWS_AND_COLUMNS))
    IrrGUISetText( framerate, fpsString )

    ' draw the GUI
    IrrDrawGUI

    ' end drawing the scene and render it
    IrrEndScene
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
