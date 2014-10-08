'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 37 : Shader materials
'' This example applies a GPU program as a material to an object. The material
'' simply adjusts the lighting over the object so that the light appears to be
'' comming from the observer and the color is changed between white and purple
'' as the program runs
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM ShaderNode as irr_node
DIM NoShaderNode as irr_node
DIM NodeTexture as irr_texture
DIM Material as irr_material
DIM Light as irr_node
DIM Camera as irr_camera
DIM EmittedLevel as uinteger = 0
DIM EmittedDirection as integer = 1
DIM vert_shader as IRR_SHADER ptr = IRR_NO_OBJECT
DIM SkyBox as irr_node
DIM MeshTexture as irr_texture
DIM LightLevel(0 to 3) as single = { 1.0, 0.0, 1.0, 1.0 }
DIM change as single = 0.01

'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 400, 200, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' set the window caption
IrrSetWindowCaption( "Example 37: Shader Materials" )

' the skybox is a simple hollow cube that surrounds the whole scene. textures
' are applied to all of the six sides of the cube creating an image around the
' entire scene instead of simply the color of the blank canvas
' here we load the textures as parameters of the skybox command (they could
' of course be loaded seperatly and assigned to irr_texture variables
SkyBox = IrrAddSkyBoxToScene( _
        IrrGetTexture("./media/irrlicht2_up.jpg"),_
        IrrGetTexture("./media/irrlicht2_dn.jpg"),_
        IrrGetTexture("./media/irrlicht2_rt.jpg"),_
        IrrGetTexture("./media/irrlicht2_lf.jpg"),_
        IrrGetTexture("./media/irrlicht2_ft.jpg"),_
        IrrGetTexture("./media/irrlicht2_bk.jpg"))

' load texture resources for texturing the scene nodes
MeshTexture = IrrGetTexture( "./media/texture.jpg" )

' create a simple scene object
ShaderNode = IrrAddSphereSceneNode ( 35.0, 64 )
IrrSetNodePosition( ShaderNode, -40, 0, 0 )
NoShaderNode = IrrAddSphereSceneNode ( 35.0, 64 )
IrrSetNodePosition( NoShaderNode, 40, 0, 0 )

' add a simple point light
Light = IrrAddLight( IRR_NO_PARENT, -100,100,100, 1.0,1.0,1.0, 600.0 )

' set the ambient light level across the entire scene
IrrSetAmbientLight( 0.15,0.15,0.15 )

' create a new shader type material from a file on the disk
' Identical to IrraddShaderMaterial only this varient attempts to load the GPU
' programs from file.
vert_shader = IrrAddShaderMaterialFromFiles( _
        "./media/arb_example_vert.txt", IRR_NO_OBJECT, IRR_EMT_SOLID )

' if a vertex shader was created
if vert_shader <> 0 then
    ' set up shader constants for the example vertex shader provided with Irrlicht
    ' most of the parameters are based on the small number of preset constants
    ' built into the wrapper library
    IrrCreateAddressedVertexShaderConstant ( vert_shader, 0, IRR_INVERSE_WORLD, IRR_NO_OBJECT, 0 )
    IrrCreateAddressedVertexShaderConstant ( vert_shader, 4, IRR_WORLD_VIEW_PROJECTION, IRR_NO_OBJECT, 0 )
    IrrCreateAddressedVertexShaderConstant ( vert_shader, 8, IRR_CAMERA_POSITION, IRR_NO_OBJECT, 0 )
    IrrCreateAddressedVertexShaderConstant ( vert_shader, 9, IRR_NO_PRESET, @LightLevel(0), 4 )
    IrrCreateAddressedVertexShaderConstant ( vert_shader, 10, IRR_TRANSPOSED_WORLD, IRR_NO_OBJECT, 0 )

    ' apply the shader to one of the objects
    IrrSetNodeMaterialType ( ShaderNode, vert_shader->material_type )
    IrrSetNodeMaterialTexture( ShaderNode, MeshTexture, 0 )

    ' apply a preset material to the other for comparison
    IrrSetNodeMaterialType ( NoShaderNode, IRR_EMT_SOLID )
    IrrSetNodeMaterialTexture( NoShaderNode, MeshTexture, 0 )
else
    ? "No shader returned"
end if

' add a camera to the scene to view the objects
Camera = IrrAddCamera( 0,0,100, 0,0,0 )

' we also hide the mouse pointer to see the view better
IrrHideMouse

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
Dim frameTime as single = timer

WHILE IrrRunning
    ' if a 60th of a second has passed 
    IF timer - frameTime > 0.0167 then
        ' begin the scene, erasing the canvas with sky-blue before rendering
        IrrBeginScene( 0, 0, 0 )
    
        ' make a small change to the shader light level each frame
        LightLevel(1) += change
        if LightLevel(1) < 0.0 then
            LightLevel(1) = 0.0
            change = 0.01
        elseif LightLevel(1) > 1.0 then
            LightLevel(1) = 1.0
            change = -0.01
        end if
    
        ' record the current time
        frameTime = timer

        ' draw the scene
        IrrDrawScene
    
        ' end drawing the scene and render it
        IrrEndScene
    END IF
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
