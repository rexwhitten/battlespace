'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 83 : Embedded OpenGL Commands
'' This example creates a simple test object for display and then issues some
'' OpenGL commands to include a simple rectangle into the scene
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "fbgfx.bi"
#include "GL/gl.bi"
#include "GL/glu.bi"

#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM MeshTexture as irr_texture
DIM SceneNode as irr_node
DIM OurCamera as irr_camera


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 512, 512, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' set the window caption
IrrSetWindowCaption( "Example 83: Embedded OpenGL Commands" )

' load texture resources for texturing the scene nodes
MeshTexture = IrrGetTexture( "./media/freebasiclogo_big.jpg" )

' add the mesh to the scene as a new node, the node is an instance of the
' mesh object supplied here
SceneNode = IrrAddTestSceneNode
IrrSetNodeScale( SceneNode, 2.5,2.5,2.5 )

' apply a material to the node to give its surface color
IrrSetNodeMaterialTexture( SceneNode, MeshTexture, 0 )

' switch off lighting effects on this model, as there are no lights in this
' scene the model would otherwise render pule black
IrrSetNodeMaterialFlag( SceneNode, IRR_EMF_LIGHTING, IRR_OFF )

' add a camera into the scene, the first co-ordinates represents the 3D
' location of our view point into the scene the second co-ordinates specify the
' target point that the camera is looking at
OurCamera = IrrAddFPSCamera
IrrSetNodePosition( OurCamera, 0,0,-100 )
IrrHideMouse

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
WHILE IrrRunning
    ' begin the scene, erasing the canvas with sky-blue before rendering
    IrrBeginScene( 64, 64, 64 )

    ' draw the scene
    IrrDrawScene

    ' draw a custom rectangle using GL commands
    glBegin GL_QUADS
		glColor3f( 0.5, 0.5, 1.0 )
        glVertex3f(-20,-20, 0)
        glVertex3f(-20, 20, 0)
        glVertex3f( 20, 20, 0)
        glVertex3f( 20,-20, 0)
    glEnd

    ' end drawing the scene and render it
    IrrEndScene

WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
