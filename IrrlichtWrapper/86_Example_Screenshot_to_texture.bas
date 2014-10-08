'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 86 : Copy screenshot to a texture
'' This example displays a model and then after 100 frames grabs a small
'' screenshot as a texture that it then paints to the screen and uses to
'' texture a small cube
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"
#include "crt/string.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM MD2Mesh as irr_mesh
DIM MeshTexture as irr_texture
DIM SceneNode as irr_node
DIM cubeNode as irr_node
DIM OurCamera as irr_camera
DIM texture as irr_texture

'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 400, 300, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' set the window caption
IrrSetWindowCaption( "Example 86 : Copy screenshot to a texture" )

' add credits for the model as a static text GUI object on the display
IrrAddStaticText( "Zumlin model by Rowan 'Sumaleth' Crawford", 4,0,200,16, IRR_GUI_NO_BORDER, IRR_GUI_NO_WRAP )

' load a mesh this acts as a blue print for the model
MD2Mesh = IrrGetMesh( "./media/zumlin.md2" )

' load texture resources for texturing the scene nodes
MeshTexture = IrrGetTexture( "./media/zumlin.pcx" )

' add the mesh to the scene as a new node, the node is an instance of the
' mesh object supplied here
SceneNode = IrrAddMeshToScene( MD2Mesh )

' apply a material to the node to give its surface color
IrrSetNodeMaterialTexture( SceneNode, MeshTexture, 0 )

' switch off lighting effects on this model, as there are no lights in this
' scene the model would otherwise render pule black
IrrSetNodeMaterialFlag( SceneNode, IRR_EMF_LIGHTING, IRR_OFF )

' play an animation sequence embeded in the mesh. MD2 models have a group of
' preset animations for various poses and actions. this animation sequence is
' the character standing idle
IrrPlayNodeMD2Animation( SceneNode, IRR_EMAT_STAND )

' add a simple cube node to the scene
cubeNode = IrrAddTestSceneNode
IrrSetNodePosition( cubeNode, 0,-20,0 )
IrrSetNodeMaterialFlag( cubeNode, IRR_EMF_LIGHTING, IRR_OFF )

' add a camera into the scene, the first co-ordinates represents the 3D
' location of our view point into the scene the second co-ordinates specify the
' target point that the camera is looking at
OurCamera = IrrAddCamera( 50,0,0, 0,0,0 )


' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
Dim frameTime as single = timer
Dim frames as integer = 0

WHILE IrrRunning
    ' if a 60th of a second has passed 
    if timer - frameTime > 0.0167 then
        ' begin the scene, erasing the canvas with sky-blue before rendering
        IrrBeginScene( 0, 0, 0 )
    
        ' draw the scene
        IrrDrawScene
        
        ' draw the GUI
        IrrDrawGUI
    
        ' circle the camera around the model
        IrrSetNodePosition( OurCamera, Cos( frameTime )*50, 0, Sin( frameTime )*50)
    
        ' record the current time
        frameTime = timer
        frames += 1

        ' on the 100th frame grab a screenshot
        if frames = 100 then
            texture = IrrGetScreenShot( 136,0, 128,128 )

            ' apply the texture to the test node
            IrrSetNodeMaterialTexture( cubeNode, texture, 0 )
        end if
        
        ' after the 100th image draw the image to the screen
        if frames > 100 then
            IrrDraw2DImage( texture, 0, 0 )
        end if

        ' end drawing the scene and render it
        IrrEndScene
    end if
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
