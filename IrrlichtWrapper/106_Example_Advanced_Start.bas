'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 106 : Advanced Starting
'' This example demonstrates an Advanced Method of Starting the Display that
'' allows for the use of anti-aliasing and high precision FPU maths 
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM MD2Mesh as irr_mesh
DIM MeshTexture as irr_texture
DIM SceneNode as irr_node
DIM OurCamera as irr_camera


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStartAdvanced ( _
    IRR_EDT_OPENGL, _       ' Use OpenGL
    512, 512, _             ' in a window 640x480
    IRR_BITS_PER_PIXEL_32, _' using 32 bit true color
    IRR_WINDOWED, _         ' in a window
    IRR_NO_SHADOWS, _       ' without stencil shadows
    IRR_IGNORE_EVENTS, _    ' dont capture keystrokes and mouse
    IRR_VERTICAL_SYNC_ON, _ ' sync to the monitor refresh rate
    0, _                    ' 0 = use the most appropriate window device
    IRR_ON, _               ' Switch on double buffering of the display
    4, _                    ' Anti-aliasing level 4
    IRR_ON )                ' use high precision floating point math

' set the window caption
IrrSetWindowCaption( "Example 106: Advanced Start" )

' load a mesh this acts as a blue print for the model
MD2Mesh = IrrGetMesh( "./media/zumlin.md2" )

' load texture resources for texturing the scene nodes
MeshTexture = IrrGetTexture( "./media/zumlin.pcx" )

' add the mesh to the scene as a new node, the node is an instance of the
' mesh object supplied here
SceneNode = IrrAddMeshToScene( MD2Mesh )

' make sure that vertex color does not affect any lighting
IrrSetNodeColorByVertex( SceneNode, ECM_NONE )

' set up some lighting colors
IrrSetNodeAmbientColor( SceneNode, RGBA( 255,0,0,255 ))
IrrSetNodeDiffuseColor( SceneNode, RGBA( 64,255,96,255 ))
IrrSetNodeSpecularColor( SceneNode, RGBA( 255,255,0,255 ))
IrrSetNodeEmissiveColor( SceneNode, RGBA( 0,0,0,255 ))

' apply a material to the node to give its surface color
IrrSetNodeMaterialTexture( SceneNode, MeshTexture, 0 )

' play an animation sequence embeded in the mesh. MD2 models have a group of
' preset animations for various poses and actions. this animation sequence is
' the character standing idle
IrrPlayNodeMD2Animation( SceneNode, IRR_EMAT_STAND )

' add a camera into the scene, the first co-ordinates represents the 3D
' location of our view point into the scene the second co-ordinates specify the
' target point that the camera is looking at
OurCamera = IrrAddCamera( 50,0,0, 0,0,0 )

' add a  light source
IrrAddLight( IRR_NO_PARENT, 100,100,-100, 0.9,0.9,0.9, 600.0 )

' add some ambient lighting
IrrSetAmbientLight( 0.1, 0.1, 0.1 )

' allow the window to be resized
IrrSetResizableWindow( IRR_ON )

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
Dim as Single timeElapsed, currentTime, frameTime = timer
DIm as Single X, Y
Dim as string metrics
WHILE IrrRunning
    ' is it time for another frame
    currentTime = timer
    timeElapsed = currentTime - frameTime
    if timeElapsed > 0.0167 then
        ' record the start time of this frame
        frameTime = currentTime

        ' begin the scene, erasing the canvas with sky-blue before rendering
        IrrBeginSceneAdvanced ( RGBA( 128, 128, 128, 0 ), IRR_ON, IRR_ON )
    
        ' draw the scene
        IrrDrawScene

        IrrGet2DPositionFromScreenCoordinates ( 256, 256, x, y, OurCamera )
        metrics = "Example 106: Advanced Start ("+Str(x)+","+Str(y)+")"
        IrrSetWindowCaption( metrics )

        ' end drawing the scene and render it
        IrrEndScene
    End IF
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
