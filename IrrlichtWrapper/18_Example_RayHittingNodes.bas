'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 18 : Selecting Nodes with a Ray
'' This example selects a node in the scene that is hit by a ray we specify as
'' a line in 3D space
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

#define TEST_NODES 19

' irrlicht objects
DIM MeshTexture as irr_texture
DIM TestNode(1 to TEST_NODES) as irr_node
DIM SelectedNode as irr_node
DIM OurCamera as irr_camera
DIM BitmapFont as irr_font
DIM POSX as single
DIM POSY as single
DIM POSZ as single
DIM x as single
DIM y as single
DIM KeyEvent as IRR_KEY_EVENT PTR
DIM selected_node as wstring * 128
DIM start_vector as IRR_VECTOR
DIM end_vector as IRR_VECTOR
DIM i as integer

'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 400, 400, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_NO_SHADOWS, IRR_CAPTURE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 18: Selecting Nodes with a Ray" )

' load the bitmap font as a texture
BitmapFont = IrrGetFont ( "./media/bitmapfont.bmp" )

' load the test cube texture
MeshTexture = IrrGetTexture( "./media/texture.jpg" )

' itterate all of the test nodes
for i = 1 to TEST_NODES
    ' add a test node to the scene
    TestNode(i) = IrrAddTestSceneNode
    
    ' move the node so that it is arranged into a circle
    IrrSetNodePosition( TestNode(i), 00, sin(cast(single,i)/3)*50, cos(cast(single,i)/3)*50 )

    ' apply a material to the node
    IrrSetNodeMaterialTexture( TestNode(i), MeshTexture, 0 )
next i

' add a camera into the scene and move it into position
OurCamera = IrrAddCamera( 120,50,50, 0,0,0)

' prepare to display a message informing the user how to move the cubes
selected_node = "MOVE WITH A S D W"

' define a ray starting at (100,0,0) and passing through (0,0,0) make sure that
' it doesn't pass through the camera as this can be identified as the nearest
' node too
start_vector.x = 100
start_vector.y = 0
start_vector.z = 0

end_vector.x = 0
end_vector.y = 0
end_vector.z = 0

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
WHILE IrrRunning
    ' begin the scene, erasing the canvas with grey before rendering
    IrrBeginScene( 128,128,128 )

    ' draw the scene
    IrrDrawScene

    ' while there are key events waiting
    while IrrKeyEventAvailable
        ' read the key event out
        KeyEvent = IrrReadKeyEvent

        ' if this is a key down event we might need to start moving in a
        ' specific direction
        if KeyEvent->direction = IRR_KEY_DOWN then
            select case KeyEvent->key
            case 65 ' A
                y = 0.4
            case 87 ' W
                x = -0.4
            case 68 ' S
                y = -0.4
            case 83 ' D
                x = 0.4
            end select
        else
            ' this is a key up event we might need to stop moving in a specific
            ' direction
            select case KeyEvent->key
            case 87, 83 ' W and D
                x = 0
            case 65, 68 ' A and S
                y = 0
            end select
        end if
    wend
    
    ' reposition all of the objects
    for i = 1 to TEST_NODES
        IrrGetNodePosition( TestNode(i), POSX, POSY, POSZ )
        POSY += x
        POSZ += y
        IrrSetNodePosition( TestNode(i), POSX, POSY, POSZ )
    next i

    ' get the nearest node that collides with the ray we defined earlier
    SelectedNode = IrrGetCollisionNodeFromRay( start_vector, end_vector )
    
    ' if the node value that was returned is 0 there is no node selected
    if SelectedNode = 0 then
        ' Display a message informing the user how to move the cubes
        selected_node = "MOVE RAY WITH A S D W"
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

    ' draw the ray so we can see what is happening
    IrrDraw3DLine( start_vector.x,start_vector.y,start_vector.z, _
                    end_vector.x, end_vector.y, end_vector.z, _
                    255,0,0 )


    ' end drawing the scene and render it
    IrrEndScene
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
