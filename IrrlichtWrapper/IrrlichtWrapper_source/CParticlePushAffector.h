// Copyright (C) 2002-2008 Nikolaus Gebhardt
// This file is part of the "Irrlicht Engine".
// For conditions of distribution and use, see copyright notice in irrlicht.h

#ifndef __C_PARTICLE_PUSH_AFFECTOR_H_INCLUDED__
#define __C_PARTICLE_PUSH_AFFECTOR_H_INCLUDED__

#include "IParticleAffector.h"
#include "SColor.h"

namespace irr
{
namespace scene
{

//! Particle Affector for fading out a color
class CParticlePushAffector : public IParticleAffector
{
public:

	CParticlePushAffector(
			core::vector3df centerOfEffect,
			core::vector3df strengthOfEffect,
			f32 furthestDistanceOfEffect,
			f32 nearestDistanceOfEffect,
			f32 columnDistanceOfEffect,
			bool distantEffect );

	//! Affects a particle.
	virtual void affect(u32 now, SParticle* particlearray, u32 count);

	//! Access functions
	virtual void setFurthestDistanceOfEffect( f32 NewDistance ) { FurthestDistanceOfEffect = NewDistance; }
	virtual void setNearestDistanceOfEffect( f32 NewDistance ) { NearestDistanceOfEffect = NewDistance; }
	virtual void setColumnDistanceOfEffect( f32 NewDistance ) { ColumnDistanceOfEffect = NewDistance; }
	virtual void setCenterOfEffect( core::vector3df NewCenter ) { CenterOfEffect = NewCenter; }
	virtual void setStrengthOfEffect( core::vector3df NewStrength ) { StrengthOfEffect = NewStrength; }

	virtual f32 getFurthestDistanceOfEffect() const { return FurthestDistanceOfEffect; }

	//! Writes attributes of the object.
	//! Implement this to expose the attributes of your scene node animator for
	//! scripting languages, editors, debuggers or xml serialization purposes.
	virtual void serializeAttributes(io::IAttributes* out, io::SAttributeReadWriteOptions* options) const;

	//! Reads attributes of the object.
	//! Implement this to set the attributes of your scene node animator for
	//! scripting languages, editors, debuggers or xml deserialization purposes.
	//! \param startIndex: start index where to start reading attributes.
	//! \return: returns last index of an attribute read by this affector
	virtual s32 deserializeAttributes(s32 startIndex, io::IAttributes* in, io::SAttributeReadWriteOptions* options);

	//! Get emitter type
	virtual E_PARTICLE_AFFECTOR_TYPE getType() const { return EPAT_NONE; }

private:

	core::vector3df CenterOfEffect;
	core::vector3df StrengthOfEffect;
	f32 FurthestDistanceOfEffect;
	f32 NearestDistanceOfEffect;
	f32 ColumnDistanceOfEffect;
	bool DistantEffect;

	u32 LastTime;
};

} // end namespace scene
} // end namespace irr


#endif

