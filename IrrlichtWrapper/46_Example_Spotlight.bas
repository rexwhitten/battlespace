'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 46 : Spotlight
'' This example creates a simple scene and then animates a spotlight moving
'' across its surface
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM MD2Mesh as irr_mesh
DIM ObjectTexture as irr_texture
DIM SphereMesh as irr_mesh
DIM SphereNode as irr_node
DIM HillMesh as irr_mesh
DIM HillNode as irr_node
DIM OurCamera as irr_camera
DIM Light as irr_node
DIM rotation as single = 70


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 400, 200, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' set the window caption
IrrSetWindowCaption( "Example 46: Spotlight" )

' load texture resources for texturing the scene nodes
ObjectTexture = IrrGetTexture( "./media/water.png" )

' add the mesh to the scene as a new node, the node is an instance of the
' mesh object supplied here
SphereNode = IrrAddSphereSceneNode( 20.0, 32 )

' add a hill plane mesh to the mesh pool, the flat surface is created from a
' flat hillplane so that there are a number of verticies in the object that
' better reflect the lighting effect
HillMesh = IrrAddHillPlaneMesh( "HillPlane", 5, 5, 32, 32 )
HillNode = IrrAddMeshToScene( HillMesh )
IrrSetNodePosition( HillNode, 0, -20, 0 )

' apply a material to the nodes to give them surface color
IrrSetNodeMaterialTexture( SphereNode, ObjectTexture, 0 )
IrrSetNodeMaterialTexture( HillNode, ObjectTexture, 0 )

' add a simple point light
Light = IrrAddLight( IRR_NO_PARENT, 30,200,0, 1.0,1.0,1.0, 600.0 )

' convert the light into a spotlight and set the light cones attributes
IrrSetLightType( Light, ELT_SPOT )
IrrSetLightInnerCone( Light, 10 )
IrrSetLightOuterCone( Light, 20 )
IrrSetLightFalloff( Light, 100.0 )

' add a camera into the scene
OurCamera = IrrAddCamera( 0,50,50, 0,0,0 )

' -----------------------------------------------------------------------------
' Display the scene for 500 frames
WHILE IrrRunning
    ' begin the scene, erasing the canvas with sky-blue before rendering
    IrrBeginScene( 0, 0, 16 )

    ' swing the light node around slowly
    IrrSetNodeRotation( Light, rotation, 0, 0 )
    rotation += 0.01

    ' draw the scene
    IrrDrawScene
    
    ' draw the GUI
    IrrDrawGUI

    ' end drawing the scene and render it
    IrrEndScene
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
