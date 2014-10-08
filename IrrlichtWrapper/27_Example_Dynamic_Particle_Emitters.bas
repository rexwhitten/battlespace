'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 27: Dynamic Particle System Effects
'' This example displays a particle system and then dynamically changes
'' properties of the effect as the animation plays
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"


'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM ParticleTexture as irr_texture
DIM SmokeParticles as irr_model
DIM SmokeEmitter as irr_particle_emitter
DIM ParticlesNode as irr_node
DIM TestNode as irr_node
DIM Camera as irr_camera
DIM Affector as irr_affector
DIM GravityAffector as irr_affector
DIM fade as single
DIM frame as integer
DIM min_red as uinteger
DIM min_blue as uinteger
DIM max_red as uinteger
DIM max_blue as uinteger
DIM emitter as irr_emitter
DIM burn as integer
DIM gravity as single

'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 400, 200, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_NO_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 27: Dynamic Particle System Effects" )

' this adds a small test node to the scene, a test node is a simple cube, that
' you can move and texture like any other object however there is another
' reason for adding this node. the particle system needs another node rendered
' onto the display to allow it to display material effects. this may be an issue
' with the wrapper that needs investigation
TestNode = IrrAddTestSceneNode


' add a particle system to the irrlicht scene manager, a default emitter is not
' created as we will define out own. the particle system is blank at the moment
SmokeParticles.particles = IrrAddParticleSystemToScene( IRR_NO_EMITTER )

' when the particle system starts it creates objects similar to billboards,
' this command specifies how large each of those particles will be
'IrrSetParticleSize( SmokeParticles.particles, 15.0, 15.0 )

' here we define the particle emitter, a particle emitter is a mechanism that
' creates the particles over time and destroys them when their lifetime runs
' out. The parameters include: a box that defines the volume in which particles
' are created - the larger the box the more diffuse the particle cloud, a
' direction that determines where the particles drift off too, a range that
' defines hoe many particles will be generated each second, a colour range that
' determines a random tint that is applied to the particles, a range that
' determines the lifespan of the particles - the large the values the longer
' and larger (and slower) your particle cloud will be and finally an angle that 
' defines a cone around your direction that is the maximum deviation from the
' direction the particles can take - values here make your particles billow
' outward
SmokeEmitter.min_box_x = -7
SmokeEmitter.min_box_y = 0
SmokeEmitter.min_box_z = -7
SmokeEmitter.max_box_x = 7
SmokeEmitter.max_box_y = 1
SmokeEmitter.max_box_z = 7
SmokeEmitter.direction_x = 0
SmokeEmitter.direction_y = 0.06
SmokeEmitter.direction_z = 0
SmokeEmitter.min_paritlcles_per_second = 80
SmokeEmitter.max_paritlcles_per_second = 100
SmokeEmitter.min_start_color_red = 255
SmokeEmitter.min_start_color_green = 192
SmokeEmitter.min_start_color_blue = 128
SmokeEmitter.max_start_color_red = 255
SmokeEmitter.max_start_color_green = 192
SmokeEmitter.max_start_color_blue = 192
SmokeEmitter.min_lifetime = 800
SmokeEmitter.max_lifetime = 2000
SmokeEmitter.min_start_sizeX = 15.0
SmokeEmitter.min_start_sizeY = 15.0
SmokeEmitter.max_start_sizeX = 15.0
SmokeEmitter.max_start_sizeY = 15.0
SmokeEmitter.max_angle_degrees = 15

' finally we add this particle emitting object to the particle system
emitter = IrrAddParticleEmitter( SmokeParticles.particles, SmokeEmitter )

' an affector is a mechanism that alters the particles over time, the fade out
' affector gradually fades the particles out so they are invisible when they
' are deleted this lets them smoothly vanish instead of poping out of existence
Affector = IrrAddFadeOutParticleAffector( SmokeParticles.particles, 1000, 16,8,0 )

' another affector is the gravity affector, this adds a small amount of velocity
' to the particles each frame, although its called a gravity affector it can
' be used to push the particles in any direction so you can have drifting smoke
' bubbling fountains, etc ...
GravityAffector = IrrAddGravityParticleAffector ( SmokeParticles.particles, 0.0, 0.1, 0.0 )

' load a grey smoke like image for the particle
ParticleTexture = IrrGetTexture( "./media/ParticleGrey.bmp" )

' apply the texture to the particles system, this texture will now be drawn
' across each particles surface
IrrSetNodeMaterialTexture( SmokeParticles.node, ParticleTexture, 0 )

' out particle system is not affected by lighting so we make it self
' illuminating
IrrSetNodeMaterialFlag( SmokeParticles.node, IRR_EMF_LIGHTING, IRR_OFF )

' as the particle texture has black borders, each overlapping particle would
' draw this blackness ontop of one another as a sharp egde they would look like
' a lot of solid squares instead of the transparent gas effect we are trying
' to created. so here we change the material type of the node - instead of
' drawing the node solidly onto the screen it is added onto the colour
' underneath itself so black doesnt change the color and white would build up
' top of the existing color until it completly saturates the pixel
IrrSetNodeMaterialType ( SmokeParticles.node, IRR_EMT_TRANSPARENT_VERTEX_ALPHA  )

' add a fixed position camera to the scene so we can view the particle system.
' the first three parameters are the cameras location, the second three
' parameters are where the camera is looking at
Camera = IrrAddCamera( 100,40,0, 0,40,0 )

' Initalise properties controlling the dynamic effects
fade = 1000.0
frame = 0
min_red = 255
min_blue = 128
max_red = 255
max_blue = 192
burn = 1
gravity = 0.02

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
Dim frameTime as single = timer

WHILE IrrRunning
    ' every 60th of a second mark a frame as being passed
    if timer - frameTime > 0.0167 then
        ' clear the canvas to black to show the particles up better
        IrrBeginScene( 0,0,0 )
    
        ' count the frames
        frame += 1
    
        ' only perform this operation once every ten frames
        if frame = 10 then
            ' reset our frame counter
            frame = 0
            
            ' if we are burning
            if burn = 1 then
                ' make the flame more intense and blue
                min_red -= 1
                min_blue += 1
                max_red -= 1
                max_blue += 1
                fade += 100.0
                gravity += 0.001
    
                ' change the color range 
                IrrSetParticleEmitterMinStartColor ( emitter, min_red, 192, min_blue )
                IrrSetParticleEmitterMaxStartColor ( emitter, max_red, 192, max_blue )
    
                ' change the time over which the particles fade out
                IrrSetFadeOutParticleAffectorTime( Affector, fade )
    
                ' change the strength of the gravity effect
                IrrSetGravityParticleAffectorDirection ( GravityAffector, 0.0, 0.1, gravity )
    
                ' if we are at maxiumum values then stop burning
                if max_blue > 254 then burn = 0 end if
            else
                ' we are not burning, make the flame smaller and more red
                min_red += 1
                min_blue -= 1
                max_red += 1
                max_blue -= 1
                fade -= 100.0
                gravity -= 0.001
    
                ' change the time over which the particles fade out
                IrrSetParticleEmitterMinStartColor ( emitter, min_red, 192, min_blue )
                IrrSetParticleEmitterMaxStartColor ( emitter, max_red, 192, max_blue )
    
                ' change the strength of the gravity effect
                IrrSetFadeOutParticleAffectorTime( Affector, fade )
    
                ' change the strength of the gravity effect
                IrrSetGravityParticleAffectorDirection ( GravityAffector, 0.0, 0.1, gravity )
    
                ' if we are at minimum values then start burning again
                if max_blue < 193 then burn = 1 end if
            end if
        end if
    
    
        ' draw the scene
        IrrDrawScene
    
        ' end drawing the scene and display it
        IrrEndScene
        
        frameTime = timer
    end if
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
