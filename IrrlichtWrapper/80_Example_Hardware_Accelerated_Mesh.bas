'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 80 : Hardware Accelerated Mesh
'' This example creates a simple sphere object and then makes it a hardware
'' accelerated object, if the mesh was animated the call to make the object
'' hardware accelerated would need to be called each time it is changed.
'' obviously if you need to call it each frame it defeats the purpose of the
'' hardware acceleration
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM DenseMesh as irr_mesh
DIM MeshTexture as irr_texture
DIM SceneNode as irr_node
DIM OurCamera as irr_camera
DIM BitmapFont as irr_font
DIM metrics as wstring * 256
DIM Light as irr_node


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 512, 512, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' set the window caption
IrrSetWindowCaption( "Example 80: Hardware Accelerated Mesh ... Please wait 6 seconds" )

' load a mesh this acts as a blue print for the model
DenseMesh = IrrGetMesh( "./media/sphere.x" )

' add the mesh to the scene as a new node, the node is an instance of the
' mesh object supplied here
SceneNode = IrrAddMeshToScene( DenseMesh )

' add a simple point light
Light = IrrAddLight( IRR_NO_PARENT, -100,100,100, 1.0,1.0,1.0, 600.0 )

' switch off lighting effects on this model, as there are no lights in this
' scene the model would otherwise render pule black
IrrSetNodeMaterialFlag( SceneNode, IRR_EMF_LIGHTING, IRR_ON )

' load the bitmap font as a texture
BitmapFont = IrrGetFont ( "./media/bitmapfont.bmp" )

' add a camera into the scene, the first co-ordinates represents the 3D
' location of our view point into the scene the second co-ordinates specify the
' target point that the camera is looking at
OurCamera = IrrAddCamera( -2,0,0, 0,0,0 )

' set the recorded frame rates to zero (unrecorded)
dim as integer unacceleratedFPS = 0
dim as integer acceleratedFPS = 0

' record the value of the timer so we can judge time by how far it moves
dim as double startTime = timer

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
WHILE IrrRunning
    ' begin the scene, erasing the canvas with sky-blue before rendering
    IrrBeginScene( 128, 128, 64 )

    ' draw the scene
    IrrDrawScene

    ' if the unaccelerated frame rate is not recorded we are still timing it
    if unacceleratedFPS = 0 then
        ' if 3 seconds have elapsed we should be able to judge the frame rate
        if timer -startTime > 3.0 then
            ' record the unaccelerated frame rate
            unacceleratedFPS = IrrGetFPS

            ' Flag the mesh as a hardware accelerated object
            IrrSetMeshHardwareAccelerated( DenseMesh, 0 )
            
        end if
    else
        ' if the accelerated frame rate is not recorded we are still timing it
        if acceleratedFPS = 0 then

            ' if another 3 seconds have elapsed we should be able to judge the
            ' frame rate again
            if timer - startTime > 6.0 then
                ' record the accelerated frame rate
                acceleratedFPS = IrrGetFPS
            end if
        else
            ' we have both the unaccelerated and accelerated frame rates we
            ' can now display the results of the timings

            ' create a string containing the unaccelerated frame rate
            metrics = "UNACCELERATED FPS "+ Str(unacceleratedFPS)
            
            ' draw this to the screen
            Irr2DFontDraw ( BitmapFont, metrics, 8, 8, 250, 24 )
        
            ' create a string containing the accelerated frame rate
            metrics = "ACCELERATED FPS   "+ Str(acceleratedFPS)
            
            ' draw this to the screen
            Irr2DFontDraw ( BitmapFont, metrics, 8, 16, 250, 24 )
        end if
    end if
    
    ' draw the GUI
    IrrDrawGUI

    ' end drawing the scene and render it
    IrrEndScene
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
