'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 36 : Simple materials
'' This example sets simple material properties to alter surface lighting and
'' then dynamically alters the properties of those materials as the program runs
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
DIM Camera as irr_camera
DIM EmittedLevel as uinteger = 0
DIM EmittedDirection as integer = 1

'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 512, 512, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' set the window caption
IrrSetWindowCaption( "Example 36: Simple Materials" )

' create some simple scene objects
SphereNode = IrrAddSphereSceneNode ( 30.0, 64 )

' add a simple point light
Light = IrrAddLight( IRR_NO_PARENT, -100,100,100, 0.25,0.25,0.25, 600.0 )

' set the ambient light level across the entire scene
IrrSetAmbientLight( 0.1,0.1,0.1 )

' get the nodes material
Material = IrrGetMaterial( SphereNode, 0 )

' set the surface property effected by the vertex color. as we want the material
' to define the color of reflected ambient, diffuse and specular light we set
' this to none. By default on a node it is ECM_DIFFUSE meaning that setting the
' diffuse color has no effect because the diffuse color is taken from the color
' of the verticies, something we do not want in this example.
IrrMaterialVertexColorAffects( Material, ECM_NONE )

' make the sphere have a shiny red highlight, it will also reflect the diffuse
' lighting making it appear yellow
IrrMaterialSetShininess ( Material, 25.0 )
IrrMaterialSetSpecularColor( Material, 0,255,0,0 )

' set the diffuse color of the object to green
IrrMaterialSetDiffuseColor ( material, 0,0,255,0 )

' set the color of ambient light reflected by the object to blue
IrrMaterialSetAmbientColor ( Material, 0,0,0,255 )

' add a camera to the scene to view the objects
Camera = IrrAddCamera( 0,0,60, 0,0,0 )

' we also hide the mouse pointer to see the view better
IrrHideMouse

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
Dim frameTime as single = timer

WHILE IrrRunning
    ' every 6th of a second mark a frame as being passed
    if timer - frameTime > 0.0167 then
        ' begin the scene, erasing the canvas with sky-blue before rendering
        IrrBeginScene( 0, 0, 0 )
    
        ' bring the emitted lighting from the object up and down
        IrrMaterialSetEmissiveColor ( Material, 0,EmittedLevel,EmittedLevel,EmittedLevel )
    
        EmittedLevel += EmittedDirection
        if EmittedLevel = 255 then
            EmittedDirection = -1
        else
            if EmittedLevel = 0 then
                EmittedDirection = 1
            end if
        end if
        ' draw the scene
        IrrDrawScene
        
        ' end drawing the scene and render it
        IrrEndScene
        
        frameTime = timer
    End if
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
