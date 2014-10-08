'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 74: Push Particle Mushroom Cloud
'' This example demonstrates the use of the push particle affector to create a
'' mushroom cloud like effect.
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
DIM fade as single
DIM smoke_emitter as irr_emitter
DIM FadeOut as irr_affector
DIM affectorA as irr_affector
DIM affectorB as irr_affector
DIM CenterY as single
DIM TimeSecs as integer = 0
DIM TimeMs as integer

'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 512, 512, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_NO_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 74: Mushroom cloud with the Push Affector" )

' this adds a small test node to the scene, a test node is a simple cube, that
' you can move and texture like any other object however there is another
' reason for adding this node. the particle system needs another node rendered
' onto the display to allow it to display material effects. this may be an issue
' with the wrapper that needs investigation
TestNode = IrrAddTestSceneNode

' set up a particle system that generates a stream of smoke please see example
' Seven for detailed information
SmokeParticles.particles = IrrAddParticleSystemToScene( IRR_NO_EMITTER )
SmokeEmitter.min_box_x = -7
SmokeEmitter.min_box_y = 0
SmokeEmitter.min_box_z = -7
SmokeEmitter.max_box_x = 7
SmokeEmitter.max_box_y = 7
SmokeEmitter.max_box_z = 7
SmokeEmitter.direction_x = 0
SmokeEmitter.direction_y = 0
SmokeEmitter.direction_z = 0
SmokeEmitter.min_paritlcles_per_second = 10
SmokeEmitter.max_paritlcles_per_second = 10
SmokeEmitter.min_start_color_red = 255
SmokeEmitter.min_start_color_green = 255
SmokeEmitter.min_start_color_blue = 255
SmokeEmitter.max_start_color_red = 255
SmokeEmitter.max_start_color_green = 255
SmokeEmitter.max_start_color_blue = 255
SmokeEmitter.min_lifetime = 25000
SmokeEmitter.max_lifetime = 25000
SmokeEmitter.min_start_sizeX = 15.0
SmokeEmitter.min_start_sizeY = 15.0
SmokeEmitter.max_start_sizeX = 15.0
SmokeEmitter.max_start_sizeY = 15.0
SmokeEmitter.max_angle_degrees = 15

' finally we add this particle emitting object to the particle system, usually
' it would be a good idea to add a fade out affector here but as the smoke
' particles are going to be pushed back into the column of smoke when they
' die we wont be able to see them anyway and as we have a lot of particles the
' less affectors we can get away with the more CPU we will have left
smoke_emitter = IrrAddParticleEmitter( SmokeParticles.particles, SmokeEmitter )

' push the particles upward for 100 units above the affector. the push is
' strongest at the center of the effect and diminishes to zero when its 100
' units away, the radial effect is OFF so all particles are pushed in the same
' direction with the same force as if they were affected by gravity.
' this affector also has a column width, this limits the effect into a vertical
' column, effectivly making this push affector like a cylinder 100 units high
' and 20 units in radius, similar to a fountain
IrrAddParticlePushAffector ( _
		SmokeParticles.particles, _
        0, 0, 0, _
        0, 20, 0, _
        100.0, 0.0, 20.0, _
        IRR_OFF )

' this affector pushes from above the particles it has a weaker downward force,
' only 8 units, but it also pushes the particles outwards, the radial effect is
' ON so the particles will be pushed away from the center of the effect, so as
' the particles get higher they will get closer to this effect and will be
' pushed outwards more and more.
' as the affector above is a column the particles will get shoved out of the
' effect of the column and the small downward force will begin to take over and
'  slowly push the particles down
affectorA = IrrAddParticlePushAffector ( _
		SmokeParticles.particles, _
        0, 100, 0, _
        60, 8, 60, _
        75, 0.0, 0.0, _
        IRR_ON )

' this final affector simulates the suction of the vaccum left by the rising
' smoke pushing the particles back into the column, it has a small inward force,
' it is a radial effect so it draws particles in towards its center.
' unlike the other affectors this has a near distance, the near distance acts
' just like the far distance, as particles get closer to the near distance the
' effect gets weaker so in this example the force is zero at 50.0 and 15.0 units
' and strongest in the middle of the numbers at 32.5 units.
' this 'ring' like affector will push the particles back into the column but
' wont squash them to a point at its center and they will also have very little
' effect on the column of particles that rise through its center at the start
affectorB = IrrAddParticlePushAffector ( _
		SmokeParticles.particles, _
        0, 50, 0, _
        -8, 0, -8, _
        50.0, 15.0, 0.0, _
        IRR_ON )

' load a grey smoke like image for the particle
ParticleTexture = IrrGetTexture( "./media/ParticleGrey.tga" )

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
IrrSetNodeMaterialType ( SmokeParticles.node, IRR_EMT_TRANSPARENT_ALPHA_CHANNEL )

' add a fixed position camera to the scene so we can view the particle system.
' the first three parameters are the cameras location, the second three
' parameters are where the camera is looking at
Camera = IrrAddCamera( 100,40,0, 0,40,0 )

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running and less than 30 seconds has
' elapsed
WHILE IrrRunning AND TimeSecs < 30
    ' clear the canvas to black to show the particles up better
    IrrBeginScene( 0,0,0 )

    ' calculate some values based on the time in milliseconds (1/1000th second)
    TimeMs = IrrGetTime

    ' this is the height of the base of the mushroom cloud, it is based on the
    ' center of the suction effect. it is 25 units plus 0.003 units for every
    ' milisecond that passes
    CenterY = 25.0 + 0.003 * TimeMs

    ' this is the number of seconds that have elapsed
    TimeSecs = TimeMs / 1000

    ' if the number of elapsed seconds is less than 21
    if TimeSecs < 21 then
        ' slowly reduce the rate that the smoke particles are emitted, we start
        ' at the maxium rate of 20 a second and as time passes and the number
        ' of elapsed seconds passes less and less particles are emitted
        IrrSetParticleEmitterMinParticlesPerSecond( smoke_emitter, 20 - TimeSecs )
        IrrSetParticleEmitterMaxParticlesPerSecond( smoke_emitter, 20 - TimeSecs )
    end if

    ' here we set the center of the suction effect and the center of the push
    ' outwards effect, the center rises slowly over time and this makes the
    ' top of the mushroom effect rise slowly too, 50 units is kept between the
    ' two effects this is basically the height of the mushrooms 'cap'
    IrrSetCenterOfEffect( affectorA, 0, CenterY + 50.0, 0 )
    IrrSetCenterOfEffect( affectorB, 0, CenterY, 0 )

    ' draw the scene
    IrrDrawScene

    ' end drawing the scene and display it
    IrrEndScene
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
