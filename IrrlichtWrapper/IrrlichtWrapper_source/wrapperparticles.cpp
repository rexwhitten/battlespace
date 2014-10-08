//
// Irrlicht Wrapper for Imperative Languages
// Frank Dodd (2006)
//
// This wrapper DLL encapsulates a sub-set of the features of the powerful
// Irrlicht 3D Graphics Engine exposing the Object Oriented architecture and
// providing a functional 3D SDK for languages that are not object oriented.
//
// This source was created with the help of the great examples in the Irrlicht
// SDK and the excellent Irrlicht documentation. This software was developed
// using the GCC compiler and Code::Blocks IDE
//

/* ////////////////////////////////////////////////////////////////////////////
includes
*/
#include "irrlichtwrapper.h"
#include "CParticleEmissionAffector.h"
#include "CParticlePushAffector.h"
#include "CColorMorphAffector.h"
#include "CSplineAffector.h"


/* ////////////////////////////////////////////////////////////////////////////
global variables
*/

/* ////////////////////////////////////////////////////////////////////////////
external variables
*/
extern IrrlichtDevice *device;
extern IVideoDriver* driver;
extern ISceneManager* smgr;
extern IGUIEnvironment* guienv;


/* ////////////////////////////////////////////////////////////////////////////
Global Function Declarations

all of the below functions are declared as C functions and are exposed without
any mangled names so that they can be easily imported into imperative
languages like FreeBasic
*/
extern "C"
{

/* ////////////////////////////////////////////////////////////////////////////
PARTICLE FUNCTIONS
*/
/* ----------------------------------------------------------------------------
set the size of a particle in the particle system
*/
void DLL_EXPORT IrrSetParticleSize( IParticleEmitter *em, float x, float y )
{
	// this function is depreciated and no longer has an operation
    em->setMinStartSize( dimension2d<f32>(x,y));
    em->setMaxStartSize( dimension2d<f32>(x,y));
}

/* ----------------------------------------------------------------------------
set the size of a particle in the particle system
*/
void DLL_EXPORT IrrSetParticleMinSize( IParticleEmitter *em, float x, float y )
{
    em->setMinStartSize( dimension2d<f32>(x,y));
}

/* ----------------------------------------------------------------------------
set the size of a particle in the particle system
*/
void DLL_EXPORT IrrSetParticleMaxSize( IParticleEmitter *em, float x, float y )
{
    em->setMaxStartSize( dimension2d<f32>(x,y));
}

/* ----------------------------------------------------------------------------
create an emitter that can be added to a particle system
*/
IParticleEmitter * DLL_EXPORT IrrAddParticleEmitter( IParticleSystemSceneNode* ps, IRR_PARTICLE_EMITTER prop )
{
	IParticleEmitter* em = ps->createBoxEmitter(
		core::aabbox3d<f32>(prop.min_box_x,prop.min_box_y,prop.min_box_z,prop.max_box_x,prop.max_box_y,prop.max_box_z),
		core::vector3df(prop.direction_x,prop.direction_y,prop.direction_z),
		prop.min_paritlcles_per_second,prop.max_paritlcles_per_second,
		video::SColor(0,prop.min_start_color_red,prop.min_start_color_green,prop.min_start_color_blue),
		video::SColor(0,prop.max_start_color_red,prop.max_start_color_green,prop.max_start_color_blue),
		prop.min_lifetime,prop.max_lifetime,
		prop.max_angle_degrees );

    em->setMinStartSize( dimension2d<f32>(prop.min_start_sizeX, prop.min_start_sizeY));
    em->setMaxStartSize( dimension2d<f32>(prop.max_start_sizeX, prop.max_start_sizeY));
	ps->setEmitter(em);
	em->drop();
	return em;
}

/* ----------------------------------------------------------------------------
Creates a particle emitter for an animated mesh scene node

Parameters:
 node,:  Pointer to the animated mesh scene node to emit particles from
 useNormalDirection,:  If true, the direction of each particle created will be
						the normal of the vertex that it's emitting from. The
						normal is divided by the normalDirectionModifier
						parameter, which defaults to 100.0f.
 direction,:  Direction and speed of particle emission.
 normalDirectionModifier,:  If the emitter is using the normal direction then the
							normal of the vertex that is being emitted from is
							divided by this number.
 mbNumber,:  This allows you to specify a specific meshBuffer for the IMesh* to
			emit particles from. The default value is -1, which means a random
			meshBuffer picked from all of the meshes meshBuffers will be selected
			to pick a random vertex from. If the value is 0 or greater, it will
			only pick random vertices from the meshBuffer specified by this value.
 everyMeshVertex,:  If true, the emitter will emit between min/max particles every
					second, for every vertex in the mesh, if false, it will emit
					between min/max particles from random vertices in the mesh.
 minParticlesPerSecond,:  Minimal amount of particles emitted per second.
 maxParticlesPerSecond,:  Maximal amount of particles emitted per second.
 minStartColor,:  Minimal initial start color of a particle. The real color of every
				particle is calculated as random interpolation between minStartColor
				and maxStartColor.
 maxStartColor,:  Maximal initial start color of a particle. The real color of every
				particle is calculated as random interpolation between minStartColor
				and maxStartColor.
 lifeTimeMin,:  Minimal lifetime of a particle, in milliseconds.
 lifeTimeMax,:  Maximal lifetime of a particle, in milliseconds.
 maxAngleDegrees,:  Maximal angle in degrees, the emitting direction of the particle
					will differ from the orignial direction.

Returns:
Returns a pointer to the created particle emitter. To set this emitter as new
emitter of this particle system, just call setEmitter(). Note that you'll have
to drop() the returned pointer, after you don't need it any more, see
IReferenceCounted::drop() for more informations.
*/
IParticleEmitter * DLL_EXPORT IrrAddAnimatedMeshSceneNodeEmitter (
		IParticleSystemSceneNode* ps,
		IAnimatedMeshSceneNode* node,
		bool useNormalDirection,
		float normalDirectionModifier,
		bool emitFromEveryMeshVertex,
		IRR_PARTICLE_EMITTER prop )
{
	IParticleEmitter* em = ps->createAnimatedMeshSceneNodeEmitter(
			node,
			useNormalDirection,
			core::vector3df(prop.direction_x,prop.direction_y,prop.direction_z),
			normalDirectionModifier,
			-1,	// use a random meshbuffer from within the node
			emitFromEveryMeshVertex,
			prop.min_paritlcles_per_second,prop.max_paritlcles_per_second,
			video::SColor(0,prop.min_start_color_red,prop.min_start_color_green,prop.min_start_color_blue),
			video::SColor(0,prop.max_start_color_red,prop.max_start_color_green,prop.max_start_color_blue),
			prop.min_lifetime,prop.max_lifetime,
			prop.max_angle_degrees );

    em->setMinStartSize( dimension2d<f32>(prop.min_start_sizeX, prop.min_start_sizeY));
    em->setMaxStartSize( dimension2d<f32>(prop.max_start_sizeX, prop.max_start_sizeY));
	ps->setEmitter(em);
	em->drop();
	return em;
}

/* ----------------------------------------------------------------------------
Add an affector to the particle system to fade the particles out (the
documentation for this object doesnt seam to be correct) the fade out time is
actually a multiple of the particle lifetime)
*/
IParticleFadeOutAffector* DLL_EXPORT IrrAddFadeOutParticleAffector( IParticleSystemSceneNode* ps, unsigned int FadeFactor, unsigned int Red, unsigned int Green, unsigned int Blue )
{
	IParticleFadeOutAffector* paf = ps->createFadeOutParticleAffector(SColor(0,Red,Green,Blue), FadeFactor);
	ps->addAffector(paf);
	paf->drop();
	return paf;
}

/* ----------------------------------------------------------------------------
Add an affector to the particle system to alter their position with gravity
*/
IParticleGravityAffector* DLL_EXPORT IrrAddGravityParticleAffector(
		IParticleSystemSceneNode* ps,
		float x,
		float y,
		float z,
		unsigned int timeForceLost )
{
	IParticleGravityAffector* paf = ps->createGravityAffector(vector3df(x,y,z), timeForceLost);
	ps->addAffector(paf);
	paf->drop();
	return paf;
}

/* ----------------------------------------------------------------------------
Creates a point attraction affector. This affector modifies the positions of
the particles and attracts them to a specified point at a specified speed per
second.

Parameters:
 point,:    Point to attract particles to.
 speed,:    Speed in units per second, to attract to the specified point.
 attract,:  Whether the particles attract or detract from this point.
 affectX,:  Whether or not this will affect the X position of the particle.
 affectY,:  Whether or not this will affect the Y position of the particle.
 affectZ,:  Whether or not this will affect the Z position of the particle.

Returns:
Returns a pointer to the created particle affector. To add this affector as
new affector of this particle system, just call addAffector(). Note that
you'll have to drop() the returned pointer, after you don't need it any more,
see IReferenceCounted::drop() for more informations
*/
IParticleAttractionAffector* DLL_EXPORT IrrAddParticleAttractionAffector(
		IParticleSystemSceneNode* ps,
		float x,
		float y,
		float z,
		float speed,
		bool attract,
		bool affectX,
		bool affectY,
		bool affectZ )
{
	IParticleAttractionAffector* paf = ps->createAttractionAffector  (
			vector3df(x,y,z),
			speed,
			attract,
			affectX,
			affectY,
			affectZ );

	ps->addAffector(paf);
	paf->drop();
	return paf;
}

/* ----------------------------------------------------------------------------
Creates a rotation affector. This affector modifies the positions of the
particles and attracts them to a specified point at a specified speed per second.

Parameters:
 speed,:  Rotation in degrees per second
 pivotPoint,:  Point to rotate the particles around

Returns:
Returns a pointer to the created particle affector. To add this affector as new
affector of this particle system, just call addAffector(). Note that you'll have
to drop() the returned pointer, after you don't need it any more, see
IReferenceCounted::drop() for more informations.
*/
IParticleRotationAffector *  DLL_EXPORT IrrAddRotationAffector (
		IParticleSystemSceneNode* ps,
		float SpeedX, float SpeedY, float SpeedZ,
		float PivotX, float PivotY, float PivotZ )
{
	IParticleRotationAffector* paf = ps->createRotationAffector(
			vector3df(SpeedX,SpeedY,SpeedZ), vector3df(PivotX,PivotY,PivotZ));

	ps->addAffector(paf);
	paf->drop();
	return paf;
}

/* ----------------------------------------------------------------------------
Creates a stop particle affector. The stop particle affector waits for the
specified period of time to elapse and then stops the specified emitter
emitting particles by setting its minimum and maximum particle emission rate
to zero. The emitter can easily be started up again by changing its emission
rate..

Parameters:
 time,:  The amount of milliseconds to elapse before stopping the emitter

Returns:
Returns a pointer to the created particle affector. To add this affector as new
affector of this particle system, just call addAffector(). Note that you'll have
to drop() the returned pointer, after you don't need it any more, see
IReferenceCounted::drop() for more informations.
*/
IParticleAffector *  DLL_EXPORT IrrAddStopParticleAffector (
		IParticleSystemSceneNode* ps, u32 time, IParticleEmitter* em  )
{
	CParticleEmissionAffector* paf = new CParticleEmissionAffector( time, em );
	ps->addAffector(paf);
	paf->drop();
	return paf;
}


/* ----------------------------------------------------------------------------
Creates a point push affector. This affector modifies the positions of
the particles and pushes them toward or away from a specified point at a
specified speed per second. The strength of this effect is adjusted by a near
and a far distance and can be used in combination to create complex motions.

Parameters:
 point,:    Point to attract particles to.
 strength,: A vector describing the strength of the effect
 far,:		Furthest distance of effect
 near,:		Closest distance of effect
 distant,:  True if a common direction is applied to the particles and False
			when a radial effect is applied to the particles

Returns:
Returns a pointer to the created particle affector.
*/
IParticleAffector *  DLL_EXPORT IrrAddParticlePushAffector(
		IParticleSystemSceneNode* ps,
		f32 x,
		f32 y,
		f32 z,
		f32 speedX,
		f32 speedY,
		f32 speedZ,
		f32 far,
		f32 near,
		f32 column,
		bool distant )
{
	CParticlePushAffector* paf = new CParticlePushAffector(
			vector3df(x,y,z),
			vector3df(speedX,speedY,speedZ),
			far,
			near,
			column,
			distant );

	ps->addAffector(paf);
	paf->drop();
	return paf;
}


/* ----------------------------------------------------------------------------
Creates a color morph affector. This affector modifies the color of the
particles over time in accordance with an array of color values supplied to the
call
*/
IParticleAffector *  DLL_EXPORT IrrAddColorMorphAffector(
		IParticleSystemSceneNode* ps,
		u32 numEntries,
		u32 * colors,
		u32 * time,
		bool smooth )
{
    core::array<video::SColor> colorlist;
    core::array<u32> timelist;

    for ( u32 i=0; i< numEntries; i++ )
    {
        colorlist.push_back( SColor( colors[i] ));
        if ( time )
            timelist.push_back( time[i] );
    }

	CColorMorphAffector* paf = new CColorMorphAffector( colorlist, smooth, timelist );
	ps->addAffector(paf);
	paf->drop();

    colorlist.clear();
    timelist.clear();
	return paf;
}


/* ----------------------------------------------------------------------------
Creates a spline path affector. This affector moves the particles along the path
of a spline for very controled particle modifies the color of the
particles over time in accordance with an array of color values supplied to the
call
*/
IParticleAffector *  DLL_EXPORT IrrAddSplineAffector(
		IParticleSystemSceneNode* ps,
        u32 iVertexCount,
        IRR_VERT *vVertices,
		f32 speed,
		f32 tightness,
		f32 attraction,
		bool deleteAtEnd )
{
	core::array<core::vector3df> splineVerts;

    for ( u32 i=0; i< iVertexCount; i++ )
    {
		splineVerts.push_back( core::vector3df( vVertices[i].x, vVertices[i].y, vVertices[i].z ));
    }

	CSplineAffector* paf = new CSplineAffector( splineVerts, speed, tightness, attraction, deleteAtEnd );
	ps->addAffector(paf);
	paf->drop();

    splineVerts.clear();
	return paf;
}


/* ----------------------------------------------------------------------------
remove all effectors from this particle system
*/
void DLL_EXPORT IrrRemoveAffectors( IParticleSystemSceneNode* ps )
{
	ps->removeAllAffectors();
}


/* ----------------------------------------------------------------------------
Set direction the emitter emits particles.
*/
void DLL_EXPORT IrrSetParticleEmitterDirection( IParticleEmitter* pe, float x, float y, float z )
{
	pe->setDirection( vector3df( x,y,z ));
}

/* ----------------------------------------------------------------------------
Set minimum number of particles the emitter emits per second.
*/
void DLL_EXPORT IrrSetParticleEmitterMinParticlesPerSecond( IParticleEmitter* pe, unsigned int minPPS )
{
	pe->setMinParticlesPerSecond( minPPS );
}

/* ----------------------------------------------------------------------------
Set maximum number of particles the emitter emits per second.
*/
void DLL_EXPORT IrrSetParticleEmitterMaxParticlesPerSecond( IParticleEmitter* pe, unsigned int maxPPS )
{
	pe->setMaxParticlesPerSecond( maxPPS );
}

/* ----------------------------------------------------------------------------
Set minimum starting color for particles.
*/
void DLL_EXPORT IrrSetParticleEmitterMinStartColor( IParticleEmitter* pe, unsigned int R, unsigned int G, unsigned int B )
{
	pe->setMinStartColor( SColor(0,R,G,B ));
}

/* ----------------------------------------------------------------------------
Set maximum starting color for particles.
*/
void DLL_EXPORT IrrSetParticleEmitterMaxStartColor( IParticleEmitter* pe, unsigned int R, unsigned int G, unsigned int B )
{
	pe->setMaxStartColor( SColor(0,R,G,B ));
}



/* ----------------------------------------------------------------------------
Enable or disable an affector
*/
void DLL_EXPORT IrrSetParticleAffectorEnable( IParticleAffector* foa, bool enable )
{
	foa->setEnabled( enable );
}

/* ----------------------------------------------------------------------------
Alter the fadeout affector changing the fade out time
*/
void DLL_EXPORT IrrSetFadeOutParticleAffectorTime( IParticleFadeOutAffector* foa, float FadeFactor )
{
	foa->setFadeOutTime( FadeFactor );
}

/* ----------------------------------------------------------------------------
Alter the fadeout affector changing the target color
*/
void DLL_EXPORT IrrSetFadeOutParticleAffectorTargetColor( IParticleFadeOutAffector* foa, unsigned int R, unsigned int G, unsigned int B  )
{
	foa->setTargetColor( SColor( 0,R,G,B )) ;
}

/* ----------------------------------------------------------------------------
Alter the direction and force of gravity
*/
void DLL_EXPORT IrrSetGravityParticleAffectorDirection( IParticleGravityAffector* foa, float x, float y, float z )
{
	foa->setGravity( vector3df( x,y,z ));
}

/* ----------------------------------------------------------------------------
Set the time in milliseconds when the gravity force is totally lost and the
particle does not move any more
*/
void DLL_EXPORT IrrSetGravityParticleAffectorTimeForceLost( IParticleGravityAffector* foa, float timeForceLost )
{
	foa->setTimeForceLost( timeForceLost );
}

/* ----------------------------------------------------------------------------
Set whether or not this will affect particles in the X direction.
*/
void DLL_EXPORT IrrSetParticleAttractionAffectorAffectX( IParticleAttractionAffector* foa, bool affect )
{
	foa->setAffectX( affect );
}

/* ----------------------------------------------------------------------------
Set whether or not this will affect particles in the Y direction.
*/
void DLL_EXPORT IrrSetParticleAttractionAffectorAffectY( IParticleAttractionAffector* foa, bool affect )
{
	foa->setAffectY( affect );
}

/* ----------------------------------------------------------------------------
Set whether or not this will affect particles in the Z direction.
*/
void DLL_EXPORT IrrSetParticleAttractionAffectorAffectZ( IParticleAttractionAffector* foa, bool affect )
{
	foa->setAffectZ( affect );
}

/* ----------------------------------------------------------------------------
Set whether or not the particles are attracting or detracting.
*/
void DLL_EXPORT IrrSetParticleAttractionAffectorAttract( IParticleAttractionAffector* foa, bool attract )
{
	foa->setAttract( attract );
}

/* ----------------------------------------------------------------------------
Set the point that particles will attract to.
*/
void DLL_EXPORT IrrSetParticleAttractionAffectorPoint( IParticleAttractionAffector* foa, float x, float y, float z )
{
	foa->setPoint( vector3df( x,y,z ));
}

/* ----------------------------------------------------------------------------
Set the point that particles will rotate about.
*/
void DLL_EXPORT IrrSetRotationAffectorPivotPoint( IParticleRotationAffector* foa, float x, float y, float z )
{
	foa->setPivotPoint( vector3df( x,y,z ));
}


/* ----------------------------------------------------------------------------
Set the point that particles will rotate about.
*/
void DLL_EXPORT IrrSetFurthestDistanceOfEffect( CParticlePushAffector* foa, float NewDistance )
{
	foa->setFurthestDistanceOfEffect( NewDistance );
}

/* ----------------------------------------------------------------------------
Set the point that particles will rotate about.
*/
void DLL_EXPORT IrrSetNearestDistanceOfEffect( CParticlePushAffector* foa, float NewDistance )
{
	foa->setNearestDistanceOfEffect( NewDistance );
}

/* ----------------------------------------------------------------------------
Set the point that particles will rotate about.
*/
void DLL_EXPORT IrrSetColumnDistanceOfEffect( CParticlePushAffector* foa, float NewDistance )
{
	foa->setColumnDistanceOfEffect( NewDistance );
}

/* ----------------------------------------------------------------------------
Set the point that particles will rotate about.
*/
void DLL_EXPORT IrrSetCenterOfEffect( CParticlePushAffector* foa, float x, float y, float z )
{
	foa->setCenterOfEffect( vector3df( x,y,z ));
}

/* ----------------------------------------------------------------------------
Set the point that particles will rotate about.
*/
void DLL_EXPORT IrrSetStrengthOfEffect( CParticlePushAffector* foa, float x, float y, float z )
{
	foa->setStrengthOfEffect( vector3df( x,y,z ));
}



/* ////////////////////////////////////////////////////////////////////////////
all of the above functions are declared as C functions and are exposed without
any mangled names
*/
}
