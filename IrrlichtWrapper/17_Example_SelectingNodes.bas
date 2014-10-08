'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 17 : Selecting Nodes with the Mouse
'' This example allows you to move the mouse around the display and to select
'' nodes on the screen by hovering over them.
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

#define TEST_NODES 25

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
        IRR_WINDOWED, IRR_NO_SHADOWS, IRR_CAPTURE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 17: Selecting Nodes with the Mouse" )

' load the bitmap font as a texture
BitmapFont = IrrGetFont ( "./media/bitmapfont.bmp" )

' load the test cube texture
MeshTexture = IrrGetTexture( "./media/texture.jpg" )

' itterate all of the test nodes
for i = 1 to TEST_NODES
    ' add a test node to the scene
    TestNode(i) = IrrAddTestSceneNode
    
    ' move the node so that it is arranged into a square grid
    IrrSetNodePosition( TestNode(i), 00, ((i-1) \ 5) * 20, ((i-1) mod 5) * 20 )

    ' apply a material to the node
    IrrSetNodeMaterialTexture( TestNode(i), MeshTexture, 0 )
next i

' add a camera into the scene and move it into position
OurCamera = IrrAddCamera( 120,40,40, 0,40,40)

' start with the phrase saying nothing is selected
selected_node = "NOTHING SELECTED"

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
WHILE IrrRunning
    ' begin the scene, erasing the canvas with grey before rendering
    IrrBeginScene( 128,128,128 )

    ' draw the scene
    IrrDrawScene

    ' if there is a mouse event waiting
    ' while there are mouse events waiting
    while IrrMouseEventAvailable
        ' read the mouse event out
        MouseEvent = IrrReadMouseEvent

        ' if this is a mouse move event
        if MouseEvent->action = IRR_EMIE_MOUSE_MOVED then
            
            ' Get the node object that is under the mouse
            SelectedNode = IrrGetCollisionNodeFromScreenCoordinates(_
                    MouseEvent->x, MouseEvent->y )

            ' if the node object that was return is 0
            if SelectedNode = 0 then
                ' there is no node under the mouse
                selected_node = "NOTHING SELECTED AT "+str(MouseEvent->x)+","+str(MouseEvent->y)
            else
                ' scan through the list of nodes to find which one is selected
                for i = 1 to TEST_NODES
                    ' if this is the selected node
                    if  SelectedNode = TestNode(i) then
                        ' display the node number
                        selected_node = "NODE "+str(i)+" SELECTED AT "+str(MouseEvent->x)+","+str(MouseEvent->y)
                        ' switch lighting off on the node making it appear black
                        IrrSetNodeMaterialFlag( SelectedNode, IRR_EMF_LIGHTING, IRR_ON )
                    else
                        ' switch lighting on for this node
                        IrrSetNodeMaterialFlag( TestNode(i), IRR_EMF_LIGHTING, IRR_OFF )
                    end if
                next i
            end if
        end if
                
    wend

    ' draw the text indicating which node was selected
    Irr2DFontDraw ( BitmapFont, selected_node, 0, 0, 100, 16 )

    ' end drawing the scene and render it
    IrrEndScene
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
