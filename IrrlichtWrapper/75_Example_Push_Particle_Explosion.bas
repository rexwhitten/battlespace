'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 75: Push Particle Explosion
'' This example demonstrates the use of the push particle affector to create a
'' flash explosion like effect.
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
DIM FadeOut as irr_affector
DIM fade as single
DIM smoke_emitter as irr_emitter

'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 512, 512, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_NO_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 75: Push Particle Explosion" )

' this adds a small test node to the scene, a test node is a simple cube, that
' you can move and texture like any other object however there is another
' reason for adding this node. the particle system needs another node rendered
' onto the display to allow it to display material effects. this may be an issue
' with the wrapper that needs investigation
TestNode = IrrAddTestSceneNode

' set up a particle system that generates a stream of smoke please see example
' Seven for detailed information
SmokeParticles.particles = IrrAddParticleSystemToScene( IRR_NO_EMITTER )

' define the properties describing the emitter
SmokeEmitter.min_box_x = -7
SmokeEmitter.min_box_y = 0
SmokeEmitter.min_box_z = -7
SmokeEmitter.max_box_x = 7
SmokeEmitter.max_box_y = 7
SmokeEmitter.max_box_z = 7
SmokeEmitter.direction_x = 0
SmokeEmitter.direction_y = 0
SmokeEmitter.direction_z = 0
SmokeEmitter.min_paritlcles_per_second = 2000
SmokeEmitter.max_paritlcles_per_second = 2000
SmokeEmitter.min_start_color_red = 255
SmokeEmitter.min_start_color_green = 255
SmokeEmitter.min_start_color_blue = 255
SmokeEmitter.max_start_color_red = 255
SmokeEmitter.max_start_color_green = 255
SmokeEmitter.max_start_color_blue = 255
SmokeEmitter.min_lifetime = 300
SmokeEmitter.max_lifetime = 300
SmokeEmitter.min_start_sizeX = 15.0
SmokeEmitter.min_start_sizeY = 15.0
SmokeEmitter.max_start_sizeX = 15.0
SmokeEmitter.max_start_sizeY = 15.0
SmokeEmitter.max_angle_degrees = 15

' finally we add this particle emitting object to the particle system along
' with a series of affectors
smoke_emitter = IrrAddParticleEmitter( SmokeParticles.particles, SmokeEmitter )
IrrAddFadeOutParticleAffector( SmokeParticles.particles, 2000, 16,8,0 )

' push the particles upward for 100 units above the affector
IrrAddParticlePushAffector ( _
		SmokeParticles.particles, _
        0, 0, 0, _
        300, 300, 300, _
        50, 0.0, 0.0, _
        IRR_ON )

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
IrrSetNodeMaterialType ( SmokeParticles.node, IRR_EMT_TRANSPARENT_VERTEX_ALPHA )

' add a fixed position camera to the scene so we can view the particle system.
' the first three parameters are the cameras location, the second three
' parameters are where the camera is looking at
Camera = IrrAddCamera( 100,40,0, 0,40,0 )

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
DIM StartTime as integer = IrrGetTime
WHILE IrrRunning
    ' clear the canvas to black to show the particles up better
    IrrBeginScene( 0,0,0 )

    ' draw the scene
    IrrDrawScene

    ' end drawing the scene and display it
    IrrEndScene

    ' Only create particles for the first second
    if IrrGetTime > StartTime + 400 then
        IrrSetParticleEmitterMinParticlesPerSecond( smoke_emitter, 0 )
        IrrSetParticleEmitterMaxParticlesPerSecond( smoke_emitter, 0 )
    end if

WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
