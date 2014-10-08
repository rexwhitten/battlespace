// Copyright (C) 2002-2008 Nikolaus Gebhardt
// This file is part of the "Irrlicht Engine".
// For conditions of distribution and use, see copyright notice in irrlicht.h

#include "CParticleEmissionAffector.h"
#include "IAttributes.h"
#include "os.h"

namespace irr
{
namespace scene
{

//! constructor
CParticleEmissionAffector::CParticleEmissionAffector(
        u32 NewEmissionTime,
        IParticleEmitter* pe )
{
	EmissionTime = NewEmissionTime ? NewEmissionTime : 1000 ;
	targetEmitter = pe;
	startTime = 0;
}


//! Affects an array of particles.
void CParticleEmissionAffector::affect(u32 now, SParticle* particlearray, u32 count)
{
	if (!Enabled)
		return;

	if ( startTime == 0 )
	{
		startTime = now;
	}
	else
	{
		if (( now - startTime ) >= EmissionTime )
		{
			targetEmitter->setMaxParticlesPerSecond (0);
			targetEmitter->setMinParticlesPerSecond (0);
			Enabled = false;
		}
	}
}


//! Writes attributes of the object.
//! Implement this to expose the attributes of your scene node animator for
//! scripting languages, editors, debuggers or xml serialization purposes.
void CParticleEmissionAffector::serializeAttributes(io::IAttributes* out, io::SAttributeReadWriteOptions* options) const
{
	out->addFloat("EmissionTime", (f32)EmissionTime);
}

//! Reads attributes of the object.
//! Implement this to set the attributes of your scene node animator for
//! scripting languages, editors, debuggers or xml deserialization purposes.
//! \param startIndex: start index where to start reading attributes.
//! \return: returns last index of an attribute read by this affector
s32 CParticleEmissionAffector::deserializeAttributes(s32 startIndex, io::IAttributes* in, io::SAttributeReadWriteOptions* options)
{
	const char* name = in->getAttributeName(startIndex);

	name = in->getAttributeName(startIndex);
	if (!name || strcmp(name, "EmissionTime"))
		return startIndex; // attribute not valid

	EmissionTime = (u32)in->getAttributeAsFloat(startIndex);

	++startIndex;
	return startIndex;
}


} // end namespace scene
} // end namespace irr

