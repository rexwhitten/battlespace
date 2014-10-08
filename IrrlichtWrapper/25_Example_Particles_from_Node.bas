'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 25: Particles emitted from a node
'' This example emits particles from the verticies on an animated node
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
DIM MD2Mesh as irr_mesh
DIM MeshTexture as irr_texture
DIM SceneNode as irr_node
DIM OurCamera as irr_camera
'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 400, 200, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_NO_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' send the window caption
IrrSetWindowCaption( "Example 25: Particles emitted from a node" )

' add credits for the model as a static text GUI object on the display
IrrAddStaticText( "Zumlin model by Rowan 'Sumaleth' Crawford", 4,0,200,16, IRR_GUI_NO_BORDER, IRR_GUI_NO_WRAP )

' load a mesh this acts as a blue print for the model
MD2Mesh = IrrGetMesh( "./media/zumlin.md2" )

' load texture resources for texturing the scene nodes
MeshTexture = IrrGetTexture( "./media/zumlin.pcx" )

' add the mesh to the scene as a new node, the node is an instance of the
' mesh object supplied here
SceneNode = IrrAddMeshToScene( MD2Mesh )

' apply a material to the node to give its surface color
IrrSetNodeMaterialTexture( SceneNode, MeshTexture, 0 )

' switch off lighting effects on this model, as there are no lights in this
' scene the model would otherwise render pule black
IrrSetNodeMaterialFlag( SceneNode, IRR_EMF_LIGHTING, IRR_OFF )

' play an animation sequence embeded in the mesh. MD2 models have a group of
' preset animations for various poses and actions. this animation sequence is
' the character standing idle
IrrPlayNodeMD2Animation( SceneNode, IRR_EMAT_STAND )

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
SmokeEmitter.direction_x = 0
SmokeEmitter.direction_y = 0.04
SmokeEmitter.direction_z = 0
SmokeEmitter.min_paritlcles_per_second = 80
SmokeEmitter.max_paritlcles_per_second = 100
SmokeEmitter.min_start_color_red = 255
SmokeEmitter.min_start_color_green = 255
SmokeEmitter.min_start_color_blue = 255
SmokeEmitter.max_start_color_red = 255
SmokeEmitter.max_start_color_green = 255
SmokeEmitter.max_start_color_blue = 255
SmokeEmitter.min_lifetime = 800
SmokeEmitter.max_lifetime = 2000
SmokeEmitter.min_start_sizeX = 5.0
SmokeEmitter.min_start_sizeY = 5.0
SmokeEmitter.max_start_sizeX = 15.0
SmokeEmitter.max_start_sizeY = 15.0
SmokeEmitter.max_angle_degrees = 15

' finally we add this particle emitting object to the particle system
IrrAddAnimatedMeshSceneNodeEmitter ( SmokeParticles.particles, SceneNode, 1, 0.25, 0, SmokeEmitter )

' load a grey smoke like image for the particle
ParticleTexture = IrrGetTexture( "./media/ParticleGrey.bmp" )

' apply the texture to the particles system, this texture will now be drawn
' across each particles surface
IrrSetNodeMaterialTexture( SmokeParticles.node, ParticleTexture, 0 )

' out particle system is not affected by lighting so we make it self
' illuminating
IrrSetNodeMaterialFlag( SmokeParticles.node, IRR_EMF_LIGHTING, IRR_OFF )

' an affector is a mechanism that alters the particles over time, the fade out
' affector gradually fades the particles out so they are invisible when they
' are deleted this lets them smoothly vanish instead of poping out of existence
IrrAddFadeOutParticleAffector( SmokeParticles.particles, 2000, 16,8,0 )

' another affector is the attractor that can be used to attract or repel
' particles to a particular point
IrrAddParticleAttractionAffector ( SmokeParticles.particles, 10.0,0.0,0.0, 20.0, IRR_REPEL )

' as the particle texture has black borders, each overlapping particle would
' draw this blackness ontop of one another as a sharp egde they would look like
' a lot of solid squares instead of the transparent gas effect we are trying
' to created. so here we change the material type of the node - instead of
' drawing the node solidly onto the screen it is added onto the colour
' underneath itself so black doesnt change the color and white would build up
' top of the existing color until it completly saturates the pixel
IrrSetNodeMaterialType ( SmokeParticles.node, IRR_EMT_TRANSPARENT_VERTEX_ALPHA )

' add a camera into the scene, the first co-ordinates represents the 3D
' location of our view point into the scene the second co-ordinates specify the
' target point that the camera is looking at
OurCamera = IrrAddCamera( 50,0,0, 0,0,0 )


' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
WHILE IrrRunning
    ' clear the canvas to black to show the particles up better
    IrrBeginScene( 0,0,0 )

    ' draw the scene
    IrrDrawScene

    ' end drawing the scene and display it
    IrrEndScene
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
