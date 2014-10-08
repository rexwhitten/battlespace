'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 108 : Lighting Bolt node
'' A special effects node that simulates a electrical discharge
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM SceneNode as irr_node
DIM OurCamera as irr_camera


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 512, 512, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_NO_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' set the window caption
IrrSetWindowCaption( "Example 108: Lighting Bolt Node" )

' load a mesh this acts as a blue print for the model
Dim as irr_mesh Mesh = IrrGetMesh( "./media/cylinderX.obj" )

' load texture resources for texturing the scene nodes
Dim as irr_texture Texture = IrrGetTexture( "./media/water.png" )

' create the a base for the effect and move, scale and rotate it into position
SceneNode = IrrAddMeshToScene( Mesh )
IrrSetNodePosition( SceneNode, 0,47,0)
IrrSetNodeRotation( SceneNode, 0,0,90 )
IrrSetNodeScale( SceneNode, 45,2,2 )

' apply a material to the node to give its surface color
IrrSetNodeMaterialTexture( SceneNode, Texture, 0 )

' switch off lighting effects on this model, as there are no lights in this
' scene the model would otherwise render pule black
IrrSetNodeMaterialFlag( SceneNode, IRR_EMF_LIGHTING, IRR_OFF )

' add the lightning bolt node to the scene
SceneNode = IrrAddBoltSceneNode()

' apply a material to the beam to give its surface color
Texture = IrrGetTexture( "./media/beam.png" )
IrrSetNodeMaterialTexture( SceneNode, Texture, 0 )

' set the bolt properties
IrrSetBoltProperties ( SceneNode, _
        0,90,0, _                 ' the start point for the bolt
        0,0,0, _                  ' the end point for the bolt
        50, _                     ' the bolt updates every 50 miliseconds
        10, _                     ' the bolt is 10 units wide
        5, _                      ' the bolt is 5 units thick
        10, _                     ' there are 10 sub parts in each bolt
        4, _                      ' there are 4 individual bolts
        IRR_ON, _                 ' the end is not connected to an exact point
        RGBA( 255, 255, 255, 255 )) ' Lighting color

' add a camera into the scene
OurCamera = IrrAddCamera( 40,50,40, 0,50,0 )

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
        IrrBeginScene( 16, 24, 32 )
    
        ' draw the scene
        IrrDrawScene
        
        ' end drawing the scene and render it
        IrrEndScene
    Endif
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
