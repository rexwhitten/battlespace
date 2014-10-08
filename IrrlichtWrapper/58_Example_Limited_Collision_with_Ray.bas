'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 58 : Limiting Collision with a Ray
'' This example highlights a node selected by collision with a ray, the subset
'' of objects in the scene is limited by only testing objects with a specific
'' ID this can greatly reduce the number of objects that need to be consided
'' thereby reducing the amount of processing required and making time for more
'' activites, such as more collistion tests perhaps
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM MeshTexture as irr_texture
DIM TestNode as irr_node
DIM SelectedNode as irr_node
DIM OurCamera as irr_camera
DIM start_vector as IRR_VECTOR
DIM end_vector as IRR_VECTOR

'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 400, 400, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_NO_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 58: Limited collision with a ray" )

' load the test cube texture
MeshTexture = IrrGetTexture( "./media/texture.jpg" )

' create all of the test nodes
TestNode = IrrAddTestSceneNode
IrrSetNodeID( TestNode, 1 )
IrrSetNodePosition( TestNode, -100, 0, 100 )
IrrSetNodeMaterialTexture( TestNode, MeshTexture, 0 )
IrrSetNodeMaterialFlag( TestNode, IRR_EMF_LIGHTING, IRR_OFF )

TestNode = IrrAddTestSceneNode
IrrSetNodePosition( TestNode, 0, 0, 100 )
IrrSetNodeMaterialTexture( TestNode, MeshTexture, 0 )
IrrSetNodeMaterialFlag( TestNode, IRR_EMF_LIGHTING, IRR_OFF )

TestNode = IrrAddTestSceneNode
IrrSetNodePosition( TestNode, 100, 0, 100 )
IrrSetNodeMaterialTexture( TestNode, MeshTexture, 0 )
IrrSetNodeMaterialFlag( TestNode, IRR_EMF_LIGHTING, IRR_OFF )

TestNode = IrrAddTestSceneNode
IrrSetNodePosition( TestNode, 200, 0, 100 )
IrrSetNodeMaterialTexture( TestNode, MeshTexture, 0 )
IrrSetNodeMaterialFlag( TestNode, IRR_EMF_LIGHTING, IRR_OFF )

' add a camera into the scene and move it into position
OurCamera = IrrAddFPSCamera
IrrHideMouse
IrrSetNodePosition( OurCamera, 50, 0, -200 )

' define a ray starting at (0,0,0) to (0,0,1000) 
start_vector.x = -200
start_vector.y = 0
start_vector.z = 100

end_vector.x = 1000
end_vector.y = 0
end_vector.z = 100

SelectedNode = IRR_NO_OBJECT

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
WHILE IrrRunning
    ' begin the scene, erasing the canvas with grey before rendering
    IrrBeginScene( 128,128,128 )

    ' draw the scene
    IrrDrawScene

    ' the selection test must be performed inside the main loop
    ' we only need to perform it once
    if SelectedNode = 0 then
        ' we will be testing all objects in the scene so get the parent object
        ' of all scene objects
        TestNode = IrrGetRootSceneNode

        ' get the nearest node that collides with the ray we defined earlier
        ' the ID must also contain the bit pattern of '2'. this excludes the
        ' first object we created as we gave that an ID of 1
        SelectedNode = IrrGetChildCollisionNodeFromRay( _
                TestNode, 2, IRR_OFF, start_vector, end_vector )

        ' if a node was selected
        if NOT SelectedNode = 0 then
            ' switch lighting off on this node to indicate that it is selected
            IrrSetNodeMaterialFlag( SelectedNode, IRR_EMF_LIGHTING, IRR_ON )
        end if
    end if

    ' draw the ray so we can see what is happening
    IrrDraw3DLine( -200,0,100, 1000,0,100, 255,0,0 )
    IrrDraw3DLine( -200,5,95, -200,-5,105, 255,0,0 )
    IrrDraw3DLine( -200,-5,95, -200,5,105, 255,0,0 )

    ' end drawing the scene and render it
    IrrEndScene
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
