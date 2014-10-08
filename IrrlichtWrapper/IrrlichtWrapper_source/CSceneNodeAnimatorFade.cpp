// Copyright (C) 2002-2009 Nikolaus Gebhardt
// This file is part of the "Irrlicht Engine".
// For conditions of distribution and use, see copyright notice in irrlicht.h

#include "CBillboardSceneNode.h"
#include "CSceneNodeAnimatorFade.h"
#include "ISceneManager.h"

using namespace irr;
using namespace core;
using namespace scene;
using namespace video;
using namespace io;
using namespace gui;

namespace irr
{
namespace scene
{


//! constructor
CSceneNodeAnimatorFade::CSceneNodeAnimatorFade(ISceneManager* manager, u32 time, u32 runTime, f32 scale )
: ISceneNodeAnimatorFinishing(time+runTime), SceneManager(manager)
{
	#ifdef _DEBUG
	setDebugName("CSceneNodeAnimatorFade");
	#endif

	nodeScale = scale;
	startTime = time;
	starting = true;
}


//! animates a scene node
void CSceneNodeAnimatorFade::animateNode(ISceneNode* node, u32 timeMs)
{
	// if we are scaling
	if ( nodeScale != 0.0f )
	{
		// calculate the scaling factor
		f32 scale = (f32)(timeMs-startTime) / (f32)(FinishTime-startTime);

		// the way we scale is dependant on the type of node being scaled
		if ( node->getType() == ESNT_BILLBOARD )
		{
			// if we are starting up
			if ( starting )
			{
				// scale the billboard with a billboard scaling function using the scaling parameter
				billboardSize = ((IBillboardSceneNode *)node)->getSize();
				starting = false;
			}
			else
			{
				// scale the billboard with a billboard scaling function using the scaling parameter
				((IBillboardSceneNode *)node)->setSize( billboardSize*(1.0f+scale*nodeScale ));
			}
		}
		else
		{
			// if we are starting up
			if ( starting )
			{
				// scale the billboard with a billboard scaling function using the scaling parameter
				nodeSize = node->getScale();
				starting = false;
			}
			else
			{
				// scale the node with a simple scaling function using the scaling parameter
				node->setScale( nodeSize*(1.0f+scale*nodeScale ));
			}
		}
	}

    // calculate the amount of fading
    u32 fade = (timeMs-startTime) * 255 / (FinishTime-startTime);
    if ( fade > 0xFF ) fade = 0xFF;

    // based upon the material that is in use apply a transparent material and
    // calculate the SCOLOR fade value
    E_MATERIAL_TYPE mat = node->getMaterial( 0 ).MaterialType;
    switch( mat )
    {
    case EMT_TRANSPARENT_ADD_COLOR:
        fade *= 0x01010101;
        fade = 0xFFFFFFFF - fade;
        break;

    case EMT_TRANSPARENT_ALPHA_CHANNEL:
    case EMT_TRANSPARENT_ALPHA_CHANNEL_REF:
        node->setMaterialType( EMT_TRANSPARENT_ADD_ALPHA_CHANNEL );
        fade *= 0x01010101;
        fade = 0xFFFFFFFF - fade;
        break;

    case EMT_TRANSPARENT_ADD_ALPHA_CHANNEL:
        fade *= 0x01010101;
        fade = 0xFFFFFFFF - fade;
        break;

    default:
        node->setMaterialType( EMT_TRANSPARENT_VERTEX_ALPHA );
        fade *= 0x01010101;
        fade = 0xFFFFFFFF - fade;
        break;
    }

    // fade the node through its materials
    SMaterial *material = &node->getMaterial( 0 );
    material->DiffuseColor.set( fade );
    material->AmbientColor.set( fade );
    material->ColorMaterial = ECM_NONE;

    // if the time has expired
	if (timeMs > FinishTime)
	{
	    // indicate that the transition is complete
		HasFinished = true;
		if(node && SceneManager)
		{
			// don't delete if scene manager is attached to an editor
			if (!SceneManager->getParameters()->getAttributeAsBool(IRR_SCENE_MANAGER_IS_EDITOR))
				SceneManager->addToDeletionQueue(node);
		}
	}
}


ISceneNodeAnimator* CSceneNodeAnimatorFade::createClone(ISceneNode* node, ISceneManager* newManager)
{
	CSceneNodeAnimatorFade * newAnimator =
		new CSceneNodeAnimatorFade(SceneManager, FinishTime, startTime, nodeScale);

	return newAnimator;
}


} // end namespace scene
} // end namespace irr

