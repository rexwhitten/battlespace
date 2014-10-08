'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2008)
'' ----------------------------------------------------------------------------
'' Example 23: Testing for Video Features
'' This example performs each of the available tests on the video capabilities
'' of the graphics card. It is often useful to know which features the card
'' will support so that you can apply the appropriate materials to your objects
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface.
IrrStart( IRR_EDT_OPENGL, 400, 200, IRR_BITS_PER_PIXEL_32,_
          IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' Set the title of the display
IrrSetWindowCaption( "Example 23: Video Feature Test" )

' Query each of the video features and display whether they are available

if IrrQueryFeature( EVDF_RENDER_TO_TARGET ) = 1 then
    Color 2 : ? "The driver is able to render to a surface"
Else
    Color 12 : ? "The driver is NOT able to render to a surface"
end if

if IrrQueryFeature( EVDF_HARDWARE_TL ) = 1 then
    Color 2 : ? "Hardeware transform and lighting is supported"
Else
    Color 12 : ? "Hardeware transform and lighting is NOT supported"
end if

if IrrQueryFeature( EVDF_MULTITEXTURE ) = 1 then
    Color 2 : ? "Multiple textures per material are possible"
Else
    Color 12 : ? "Multiple textures per material are NOT possible"
end if

if IrrQueryFeature( EVDF_BILINEAR_FILTER ) = 1 then
    Color 2 : ? "The driver is able to render with a bilinear filter applied"
Else
    Color 12 : ? "The driver is NOT able to render with a bilinear filter applied"
end if

if IrrQueryFeature( EVDF_MIP_MAP ) = 1 then
    Color 2 : ? "The driver can handle mip maps"
Else
    Color 12 : ? "The driver can NOT handle mip maps"
end if

if IrrQueryFeature( EVDF_MIP_MAP_AUTO_UPDATE ) = 1 then
    Color 2 : ? "The driver can update mip maps automatically"
Else
    Color 12 : ? "The driver can NOT update mip maps automatically"
end if

if IrrQueryFeature( EVDF_STENCIL_BUFFER ) = 1 then
    Color 2 : ? "Stencilbuffers are switched on and the device does support stencil buffers"
Else
    Color 12 : ? "Stencilbuffers are NOT switched on or are unsupported"
end if

if IrrQueryFeature( EVDF_VERTEX_SHADER_1_1 ) = 1 then
    Color 2 : ? "Vertex Shader 1.1 is supported"
Else
    Color 12 : ? "Vertex Shader 1.1 is NOT supported"
end if
    
if IrrQueryFeature( EVDF_VERTEX_SHADER_2_0 ) = 1 then
    Color 2 : ? "Vertex Shader 2.0 is supported"
Else
   Color 12 : ? "Vertex Shader 2.0 is NOT supported"
end if

if IrrQueryFeature( EVDF_VERTEX_SHADER_3_0 ) = 1 then
    Color 2 : ? "Vertex Shader 3.0 is supported"
Else
    Color 12 : ? "Vertex Shader 3.0 is NOT supported"
end if

if IrrQueryFeature( EVDF_PIXEL_SHADER_1_1 ) = 1 then
    Color 2 : ? "Pixel Shader 1.1 is supported"
Else
    Color 12 : ? "Pixel Shader 1.1 is NOT supported"
end if

if IrrQueryFeature( EVDF_PIXEL_SHADER_1_2 ) = 1 then
    Color 2 : ? "Pixel Shader 1.2 is supported"
Else
    Color 12 : ? "Pixel Shader 1.2 is NOT supported"
end if

if IrrQueryFeature( EVDF_PIXEL_SHADER_1_3 ) = 1 then
    Color 2 : ? "Pixel Shader 1.3 is supported"
Else
    Color 12 : ? "Pixel Shader 1.3 is NOT supported"
end if

if IrrQueryFeature( EVDF_PIXEL_SHADER_1_4 ) = 1 then
    Color 2 : ? "Pixel Shader 1.4 is supported"
Else
    Color 12 : ? "Pixel Shader 1.4 is NOT supported"
end if

if IrrQueryFeature( EVDF_PIXEL_SHADER_2_0 ) = 1 then
    Color 2 : ? "Pixel Shader 2.0 is supported"
Else
    Color 12 : ? "Pixel Shader 2.0 is NOT supported"
end if

if IrrQueryFeature( EVDF_PIXEL_SHADER_3_0 ) = 1 then
    Color 2 : ? "Pixel Shader 3.0 is supported"
Else
    Color 12 : ? "Pixel Shader 3.0 is NOT supported"
end if

if IrrQueryFeature( EVDF_ARB_VERTEX_PROGRAM_1 ) = 1 then
    Color 2 : ? "ARB vertex programs v1.0 are supported"
Else
    Color 12 : ? "ARB vertex programs v1.0 are NOT supported"
end if

if IrrQueryFeature( EVDF_ARB_FRAGMENT_PROGRAM_1 ) = 1 then
    Color 2 : ? "ARB fragment programs v1.0 are supported"
Else
    Color 12 : ? "ARB fragment programs v1.0 are NOT supported"
end if

if IrrQueryFeature( EVDF_ARB_GLSL ) = 1 then
    Color 2 : ? "GLSL is supported"
Else
    Color 12 : ? "GLSL is NOT supported"
end if

if IrrQueryFeature( EVDF_HLSL ) = 1 then
    Color 2 : ? "HLSL is supported"
Else
    Color 12 : ? "HLSL is NOT supported"
end if

if IrrQueryFeature( EVDF_TEXTURE_NPOT ) = 1 then
    Color 2 : ? "non-power-of-two textures are supported"
Else
    Color 12 : ? "non-power-of-two textures are NOT supported"
end if

if IrrQueryFeature( EVDF_FRAMEBUFFER_OBJECT ) = 1 then
    Color 2 : ? "framebuffer objects are supported"
Else
    Color 12 : ? "framebuffer objects are NOT supported"
end if

    
if IrrQueryFeature( EVDF_VERTEX_BUFFER_OBJECT ) = 1 then
    Color 2 : ? "vertex buffer objects are supported"
Else
    Color 12 : ? "vertex buffer objects are NOT supported"
end if

    
if IrrQueryFeature( EVDF_ALPHA_TO_COVERAGE ) = 1 then
    Color 2 : ? "alpha to coverage is supported"
Else
    Color 12 : ? "alpha to coverage is NOT supported"
end if

    
if IrrQueryFeature( EVDF_COLOR_MASK ) = 1 then
    Color 2 : ? "color masks are supported"
Else
    Color 12 : ? "color masks are NOT supported"
end if

    
if IrrQueryFeature( EVDF_MULTIPLE_RENDER_TARGETS ) = 1 then
    Color 2 : ? "multiple render targets are supported"
Else
    Color 12 : ? "multiple render targets are NOT supported"
end if

    
if IrrQueryFeature( EVDF_MRT_BLEND ) = 1 then
    Color 2 : ? "seperate blend settings for render targets are supported"
Else
    Color 12 : ? "seperate blend settings for render targets are NOT supported"
end if

    
if IrrQueryFeature( EVDF_MRT_COLOR_MASK ) = 1 then
    Color 2 : ? "seperate color masks for render targets are supported"
Else
    Color 12 : ? "seperate color masks for render targets are NOT supported"
end if

    
if IrrQueryFeature( EVDF_MRT_BLEND_FUNC ) = 1 then
    Color 2 : ? "seperate blend functions for render targets are supported"
Else
    Color 12 : ? " seperate blend functions for render targets are NOT supported"
end if

    
if IrrQueryFeature( EVDF_GEOMETRY_SHADER ) = 1 then
    Color 2 : ? "geometry shaders are supported"
Else
    Color 12 : ? "geometry shaders are NOT supported"
end if


' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop

' Display a message and wait for the user to close the application
? "Press a key to finish"
Sleep
