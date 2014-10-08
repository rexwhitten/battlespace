'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 19 : Selecting Nodes through the camera
'' This example selects a node in the scene that is hit by a ray that is cast
'' out through the centre of the camera
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

#define TEST_NODES 125

' irrlicht objects
DIM MeshTexture as irr_texture
DIM TestNode(1 to TEST_NODES) as irr_node
DIM SelectedNode as irr_node
DIM OurCamera as irr_camera
DIM BitmapFont as irr_font
DIM x as integer
DIM y as integer
DIM MouseEvent as IRR_MOUSE_EVENT PTR
DIM selected_node as wstring * 128
DIM i as integer


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 400, 400, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_NO_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 19: 2D Text label on a 3D model" )

' load the bitmap font as a texture
BitmapFont = IrrGetFont ( "./media/bitmapfont.bmp" )
MeshTexture = IrrGetTexture( "./media/texture.jpg" )

' itterate all of the test nodes
for i = 1 to TEST_NODES
    ' add a test node to the scene
    TestNode(i) = IrrAddTestSceneNode

    ' move the node so that it is arranged into a large 3D cubed array of nodes
    IrrSetNodePosition( TestNode(i), ((i-1) \ 25) * 40, (((i-1) \ 5) mod 5) * 40, ((i-1) mod 5) * 40 )

    ' apply a material to the node
    IrrSetNodeMaterialTexture( TestNode(i), MeshTexture, 0 )
next i

' add an FPS camera into the scene and move it into position
OurCamera = IrrAddFPSCamera
IrrSetNodePosition( OurCamera, 400, 200, 0 )
IrrSetCameraTarget( OurCamera, 0,0,0)

' prepare a message that indicates that there is no node selected in the scene
selected_node = "NOTHING SELECTED"

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
WHILE IrrRunning
    ' begin the scene, erasing the canvas with grey before rendering
    IrrBeginScene( 128,128,128 )

    ' draw the scene
    IrrDrawScene

    ' get the node that collides with a ray cast out through the center of the
    ' camera
    SelectedNode = IrrGetCollisionNodeFromCamera( OurCamera )

    ' if the node value that was returned is 0 there is no node selected
    if SelectedNode = 0 then
        ' Display a message informing the user how to move the cubes
        selected_node = "NOTHING SELECTED"
    else
        ' some node was hit, scan through the array of nodes to find which one
        ' it was
        for i = 1 to TEST_NODES
            ' if this was the collided node
            if  SelectedNode = TestNode(i) then
                ' display the node index
                selected_node = "NODE "+str(i)+" SELECTED"
                ' switch lighting off on this node to indicate that it is
                ' selected
                IrrSetNodeMaterialFlag( SelectedNode, IRR_EMF_LIGHTING, IRR_ON )
            else
                ' this node is not selected, switch lighting on for this node
                ' to indicate this fact
                IrrSetNodeMaterialFlag( TestNode(i), IRR_EMF_LIGHTING, IRR_OFF )
            end if
        next i
    end if

    ' draw the text indicating which node was selected
    Irr2DFontDraw ( BitmapFont, selected_node, 0, 0, 100, 16 )

    ' end drawing the scene and render it
    IrrEndScene
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
