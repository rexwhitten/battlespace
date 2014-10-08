'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 81 : GLSL Shader materials
'' This example applies a series of GLSL GPU programs as materials to a set of
'' objects. 
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
'#include "fbgfx.bi"
#include "GL/gl.bi"
#include "GL/glu.bi"

#include "IrrlichtWrapper.bi"
#include "IrrlichtShaders.bas"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM ShaderNode(1 to 9) as irr_node
DIM Material as irr_material
DIM Light as irr_node
DIM Camera as irr_camera

DIM MeshTextureA as irr_texture
DIM MeshTextureB as irr_texture
DIM MeshTextureC as irr_texture
DIM MeshTextureD as irr_texture

DIM change as single = 0.01
DIM objectScale as single = 1.0
DIM objectColor(0 to 3) as single = { 1.0, 1.0, 0.0, 1.0 }

DIM intensity as single = 1.0
DIM color0(0 to 3) as single = {0.8, 0.0, 0.0, 1.0 }
DIM color1(0 to 3) as single = {0.0, 0.0, 0.0, 1.0 }
DIM color2(0 to 3) as single = {0.8, 0.0, 0.0, 1.0 }
DIM eyePos(0 to 2) as single = {0.0, 100.0, 100.0  }


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 600, 600, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' set the window caption
IrrSetWindowCaption( "Example 81: GLSL Shader Materials" )

' load texture resources for texturing the scene nodes
MeshTextureA = IrrGetTexture( "./media/detailmap3.jpg" )
MeshTextureB = IrrGetTexture( "./media/default_texture.png" )
MeshTextureC = IrrGetTexture( "./media/water.png" )

' Create a normal gourad shaded object without shaders
ShaderNode(1) = IrrAddSphereSceneNode ( 30.0, 16 )
IrrSetNodePosition( ShaderNode(1), -100.0, 0.0, 0.0 )
IrrSetNodeMaterialType ( ShaderNode(1), IRR_EMT_SOLID )
IrrSetNodeMaterialTexture( ShaderNode(1), MeshTextureA, 0 )
Material = IrrGetMaterial( ShaderNode(1), 0 )
IrrMaterialSetShininess ( Material, 100.0 )

' create a GLSL per pixel phong shaded object
ShaderNode(2) = IrrAddSphereSceneNode ( 30.0, 16 )
IrrSetNodePosition( ShaderNode(2), -50.0, 0.0, -90.0 )
AttachShader( ShaderNode(2), AddBasicGLSLShader())
IrrSetNodeMaterialTexture( ShaderNode(2), MeshTextureA, 0 )
Material = IrrGetMaterial( ShaderNode(2), 0 )
IrrMaterialSetShininess ( Material, 100.0 )

' create a simple GLSL cell shaded object
ShaderNode(3) = IrrAddSphereSceneNode ( 30.0, 16 )
IrrSetNodePosition( ShaderNode(3), -50.0, 0.0, 90.0 )
AttachShader( ShaderNode(3), AddCellGLSLShader())

' Create a simple clipped object where bright and dark pixels vanish
ShaderNode(4) = IrrAddSphereSceneNode ( 30.0, 16 )
IrrSetNodePosition( ShaderNode(4), 50.0, 0.0, -90.0 )
AttachShader( ShaderNode(4), AddClipGLSLShader())
IrrSetNodeMaterialTexture( ShaderNode(4), MeshTextureA, 0 )

' Create a simple multi-textured object based on the vertex normal
ShaderNode(5) = IrrAddSphereSceneNode ( 30.0, 16 )
IrrSetNodePosition( ShaderNode(5), 50.0, 0.0, 90.0 )
AttachShader( ShaderNode(5), AddMultiTextureGLSLShader())
IrrSetNodeMaterialTexture( ShaderNode(5), MeshTextureA, 0 )
IrrSetNodeMaterialTexture( ShaderNode(5), MeshTextureB, 1 )
IrrSetNodeMaterialTexture( ShaderNode(5), MeshTextureC, 2 )

' create a GLSL per pixel phong shaded object
ShaderNode(6) = IrrAddSphereSceneNode ( 30.0, 16 )
IrrSetNodePosition( ShaderNode(6), 100.0, 0.0, 0.0 )
AttachShader( ShaderNode(6), AddTextureEmissiveGLSLShader())
IrrSetNodeMaterialTexture( ShaderNode(6), MeshTextureA, 0 )
Material = IrrGetMaterial( ShaderNode(6), 0 )
IrrMaterialSetShininess ( Material, 100.0 )



' add a simple point light
Light = IrrAddLight( IRR_NO_PARENT, 100.0,100.0,-100.0, 1.0,1.0,1.0, 600.0 )

' add and ambient light level to the entire scene
IrrSetAmbientLight( 0.1, 0.1, 0.1 )

' add a camera to the scene to view the objects
Camera = IrrAddFPSCamera
IrrSetNodePosition( Camera, 50,150,-200 )
IrrSetCameraTarget( Camera, 0,0,0 )

' we also hide the mouse pointer to see the view better
IrrHideMouse

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
Dim frameTime as single = timer

WHILE IrrRunning
    ' if a 60th of a second has passed 
    if timer - frameTime > 0.0167 then

        ' begin the scene, erasing the canvas before rendering
        IrrBeginScene( 0, 64, 64 )

        ' set up a pulsing variable
        intensity += 0.01
        if intensity > 1.0 then intensity = 0.0

        ' record the current time
        frameTime = timer

        ' draw the scene
        IrrDrawScene
    
        ' end drawing the scene and render it
        IrrEndScene
    end if
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
