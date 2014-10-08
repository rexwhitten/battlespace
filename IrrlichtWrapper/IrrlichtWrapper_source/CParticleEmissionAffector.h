// Copyright (C) 2002-2008 Nikolaus Gebhardt
// This file is part of the "Irrlicht Engine".
// For conditions of distribution and use, see copyright notice in irrlicht.h

#ifndef __C_PARTICLE_FADE_OUT_AFFECTOR_H_INCLUDED__
#define __C_PARTICLE_FADE_OUT_AFFECTOR_H_INCLUDED__

#include "IParticleAffector.h"
#include "IParticleEmitter.h"
#include "SColor.h"

namespace irr
{
namespace scene
{

//! Particle Affector for fading out a color
class CParticleEmissionAffector : public IParticleAffector
{
public:

	CParticleEmissionAffector(
            u32 EmissionTime,
            IParticleEmitter* pe );

	//! Affects a particle.
	virtual void affect(u32 now, SParticle* particlearray, u32 count);

	//! Sets the amount of time it takes for each particle to fade out.
	virtual void setEmissionTime( u32 NewEmissionTime ) { EmissionTime = NewEmissionTime; }

	//! Gets the amount of time it takes for each particle to fade out.
	virtual u32 getEmissionTime() const { return EmissionTime; }

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

	IParticleEmitter* targetEmitter;
	u32 EmissionTime;
	u32 startTime;
};

} // end namespace scene
} // end namespace irr


#endif

