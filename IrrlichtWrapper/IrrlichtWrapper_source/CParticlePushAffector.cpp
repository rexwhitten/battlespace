// Copyright (C) 2002-2008 Nikolaus Gebhardt
// This file is part of the "Irrlicht Engine".
// For conditions of distribution and use, see copyright notice in irrlicht.h

#include "CParticlePushAffector.h"
#include "IAttributes.h"
#include "os.h"

namespace irr
{
namespace scene
{

//! constructor
CParticlePushAffector::CParticlePushAffector(
		core::vector3df centerOfEffect,
		core::vector3df strengthOfEffect,
		f32 furthestDistanceOfEffect,
		f32 nearestDistanceOfEffect,
		f32 columnDistanceOfEffect,
		bool distantEffect ) : CenterOfEffect( centerOfEffect ), StrengthOfEffect( strengthOfEffect ),
							FurthestDistanceOfEffect( furthestDistanceOfEffect ),
							NearestDistanceOfEffect( nearestDistanceOfEffect ),
							ColumnDistanceOfEffect( columnDistanceOfEffect ),
							DistantEffect( distantEffect )
{
	FurthestDistanceOfEffect = furthestDistanceOfEffect - nearestDistanceOfEffect;
}


//! Affects an array of particles.
void CParticlePushAffector::affect(u32 now, SParticle* particlearray, u32 count)
{
	// if this is the first time the affector has been executed
	if( LastTime == 0 )
	{
		// just record the time and return as we cannot calculate a delta
		LastTime = now;
		return;
	}

	// calculate the time delta based on the amount of time that has passed between frames
	f32 timeDelta = ( now - LastTime ) / 1000.0f;

	// record the time so we can calculate the next delta
	LastTime = now;

	// if this affector is disabled we have nothing to do
	if (!Enabled)
		return;

	// itterate all of the particles
	for(u32 i=0; i<count; ++i)
	{
		/* calculate the direction of effect ( even if this is a distant effect we
		still need this to calculate the strength of the effect */
		core::vector3df direction = particlearray[i].pos - CenterOfEffect;
		f32 distance = direction.getLength() - NearestDistanceOfEffect;

		// if we are within the field of effect
		if (( distance >= 0.0f ) && ( distance < FurthestDistanceOfEffect ))
		{
			f32 strength;
			core::vector3df AppliedStrengthOfEffect = StrengthOfEffect;

			/* if this is a torus effect then its X, Z effect is modulated
			between the distant and near */
			// if there is no near distance
			if ( NearestDistanceOfEffect == 0.0f )
			{
				/* calculate the strength based on the distance from the center of the
				effect and the amount of time that has passed */
				strength = timeDelta * (1.0f - ( distance / FurthestDistanceOfEffect ));
			}
			else
			{
				/* calculate the strength based on the halfway distance between
				the near and far distance from the center of the effect and the
				amount of time that has passed */
				strength = timeDelta * (1.0f - ( fabs(distance * 2.0f - FurthestDistanceOfEffect ) / FurthestDistanceOfEffect ));
			}

			// if there is a column distance
			if ( ColumnDistanceOfEffect != 0.0f )
			{
				core::vector2df len2d( fabs( direction.X ), fabs( direction.Z ));
				strength *= ( ColumnDistanceOfEffect - len2d.getLength()) / ColumnDistanceOfEffect;
			}

			// if this is a distant effect
			if ( !DistantEffect )
			{
				// all particles are affected in the same way
				particlearray[i].pos += AppliedStrengthOfEffect * strength;
			}
			else
			{
				// particles are affected individually dependant on their relation to the center of effect
				particlearray[i].pos += direction.normalize() * AppliedStrengthOfEffect * strength;
			}
		}
	}
}


//! Writes attributes of the object.
//! Implement this to expose the attributes of your scene node animator for
//! scripting languages, editors, debuggers or xml serialization purposes.
void CParticlePushAffector::serializeAttributes(io::IAttributes* out, io::SAttributeReadWriteOptions* options) const
{
	out->addFloat("FurthestDistanceOfEffect", (f32)FurthestDistanceOfEffect);
}

//! Reads attributes of the object.
//! Implement this to set the attributes of your scene node animator for
//! scripting languages, editors, debuggers or xml deserialization purposes.
//! \param startIndex: start index where to start reading attributes.
//! \return: returns last index of an attribute read by this affector
s32 CParticlePushAffector::deserializeAttributes(s32 startIndex, io::IAttributes* in, io::SAttributeReadWriteOptions* options)
{
	const char* name = in->getAttributeName(startIndex);

	name = in->getAttributeName(startIndex);
	if (!name || strcmp(name, "FurthestDistanceOfEffect"))
		return startIndex; // attribute not valid

	FurthestDistanceOfEffect = in->getAttributeAsFloat(startIndex);

	++startIndex;
	return startIndex;
}


} // end namespace scene
} // end namespace irr

