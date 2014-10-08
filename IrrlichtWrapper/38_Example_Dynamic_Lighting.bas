'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 38 : Dynamic Lighting
'' This example changes the properties of the lighting dynamically as the
'' program runs
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM SphereNode as irr_node
DIM NodeTexture as irr_texture
DIM Material as irr_material
DIM Light as irr_node
DIM LightAmbient as irr_node
DIM Camera as irr_camera
DIM attenuation as single = 1.0
DIM red_diffuse as single = 1.0
DIM green_diffuse as single = 0.0
DIM blue_diffuse as single = 0.5
DIM ambient as single = 0.0

'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 512, 512, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' set the window caption
IrrSetWindowCaption( "Example 38: Dynamic Lighting" )

' create some simple scene objects
SphereNode = IrrAddSphereSceneNode (30.0, 64 )

' add a simple point light
Light = IrrAddLight( IRR_NO_PARENT, -100,100,100, 1.0,1.0,1.0, 600.0 )

' add a black light used to introduce ambient lighting
LightAmbient = IrrAddLight( IRR_NO_PARENT, 0,0,0, 0.0,0.0,0.0, 600.0 )

' add a camera to the scene to view the objects
Camera = IrrAddCamera( 0,0,75, 0,0,0 )

' we also hide the mouse pointer to see the view better
IrrHideMouse

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
Dim as Single frameTime = timer + 0.0167
WHILE IrrRunning
    ' is it time for another frame
    if timer > frameTime then
        ' calculate the time the next frame starts
        frameTime = timer + 0.0167
        ' begin the scene, erasing the canvas with sky-blue before rendering
        IrrBeginScene( 0, 0, 0 )
    
        ' increase the constant attenuation of the lighting over time making it
        ' gradulally dimmer
        IrrSetLightAttenuation ( Light, attenuation, 0.0, 0.0 )
        attenuation += 0.0025
    
        ' change the diffuse color emitted by the light over time
        IrrSetLightDiffuseColor ( Light, red_diffuse, green_diffuse, blue_diffuse )
        if red_diffuse > 0.0 then red_diffuse -= 0.001
        if green_diffuse < 1.0 then green_diffuse += 0.001
        if blue_diffuse < 1.0 then blue_diffuse += 0.001
    
        ' slowly introduce ambient light
        IrrSetLightAmbientColor( LightAmbient, ambient, ambient, ambient )
        if ambient < 0.1 then ambient += 0.00001
    
        ' draw the scene
        IrrDrawScene
        
        ' end drawing the scene and render it
        IrrEndScene
    End if
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
