// Copyright (C) 2008 Frank Dodd
// This file is part of the "IrrlichtWrapper" distributed under the Irrlicht licence
// For conditions of distribution and use, see copyright notice in irrlicht.h

#include "IVideoDriver.h"
#include "ISceneManager.h"
#include "ICameraSceneNode.h"
#include "os.h"
#include "CZoneSceneNode.h"

extern irr::video::IVideoDriver* driver;
extern irr::scene::ISceneManager* smgr;


namespace irr
{
namespace scene
{

/*! The zone scene node is used for the management of other scene nodes, it has
no geometry itself instead it only determines if its children should be
displayed
*/
CZoneSceneNode::CZoneSceneNode( f32 initialNearDistance, f32 initialFarDistance,
                                ISceneNode* parent, ISceneManager* mgr, s32 id)
                                : ISceneNode(parent, mgr, id)
{
	// set up the distances
	nearDrawDistance = initialNearDistance;
	farDrawDistance = initialFarDistance;

	// accumulate child boxes by default
	accumulateBoundingBoxes = true;
	firstChild = true;

	// reset terrain parameters
	zoneState = ZONE_IDLE;
	terrain = NULL;
	terrainRow = 0;
	terrainSliceSize = 0;

	imageName = NULL;
	colorName = NULL;
	detailName = NULL;

    image = NULL;
	textureColor = NULL;
	textureDetail = NULL;
}


//! set the distance at which the object becomes invisible
void CZoneSceneNode::SetDrawProperties( f32 newNearDistance, f32 newFarDistance, bool accumulateChildBoxes )
{
	// record the new draw distance
	nearDrawDistance = newNearDistance;
	farDrawDistance = newFarDistance;
    accumulateBoundingBoxes = accumulateChildBoxes;
}


//! Register this node for rendering
void CZoneSceneNode::OnRegisterSceneNode()
{
	// if this node is visible
	if (IsVisible)
	{
		// get the active camera
		scene::ICameraSceneNode *camera = SceneManager->getActiveCamera();

		// if we have a terrain object
		if ( terrain )
		{
			// if we are in visible range of the terrain
			if (( fabs(( getPosition().X + ( farDrawDistance / 2.0f )) - camera->getPosition().X ) <= farDrawDistance ) &&
					( fabs(( getPosition().Z + ( farDrawDistance / 2.0f )) - camera->getPosition().Z ) <= farDrawDistance ))
			{
				// if the zone is not running we have set up to perform
				if ( zoneState != ZONE_RUNNING )
				{
					switch( zoneState )
					{
					case ZONE_IDLE:
						// start by making the terrain invisible
						terrain->setVisible( false );

						// get the image for the terrain
						image = driver->createImageFromFile( imageName );
						terrainRow = 0;

						if ( colorName )
							zoneState = ZONE_READ_COLOR;
						else
							if ( detailName )
								zoneState = ZONE_READ_DETAIL;
							else
								zoneState = ZONE_WRITING_TERRAIN_STRUCTURE;
						break;

					case ZONE_READ_COLOR:
						// get the image for the terrain
						textureColor = driver->getTexture( imageName );
						terrain->setMaterialTexture( 1, textureColor );

						if ( detailName )
							zoneState = ZONE_READ_DETAIL;
						else
							zoneState = ZONE_WRITING_TERRAIN_STRUCTURE;
						break;

					case ZONE_READ_DETAIL:
						// get the image for the terrain
						textureDetail = driver->getTexture( imageName );
						terrain->setMaterialTexture( 0, textureColor );

						zoneState = ZONE_WRITING_TERRAIN_STRUCTURE;
						break;

					case ZONE_WRITING_TERRAIN_STRUCTURE:
						/* load the terrain structure from the image, this can be done in slices
						to spread the process out across a number of frames and to avoid stuttering */
						terrain->loadStructure( image, dataPosition, terrainRow, terrainRow + terrainSliceSize );

						// if all of the terrain structure is written
						terrainRow += terrainSliceSize;
						if ( terrainRow >= terrain->getTerrainSize() )
						{
							terrainRow = 0;
							zoneState = ZONE_WRITING_TERRAIN_TRANSFORMATION;
						}
						break;

					case ZONE_WRITING_TERRAIN_TRANSFORMATION:
						// move the terrain into position
						terrain->loadPosition( getPosition(), terrainRow, terrainRow + terrainSliceSize );

						// if all of the terrain structure is written
						terrainRow += terrainSliceSize;
						if ( terrainRow >= terrain->getTerrainSize() )
						{
							zoneState = ZONE_WRITING_TERRAIN_PATCHES;
						}
						break;

					case ZONE_WRITING_TERRAIN_PATCHES:
						// recalculate the patch data
						terrain->loadPatches();
						zoneState = ZONE_RUNNING;

						// end by making the terrain visible
						terrain->setVisible( true );
						break;

					default:
						break;
					}
				}
			}
			else
			{
				// if the zone is NOT idle
				if ( zoneState != ZONE_IDLE )
				{
					// discard the image
					if ( image )
					{
						image->drop();
						image = NULL;
					}

					// discard the image
					if ( textureColor )
					{
						textureColor->drop();
						textureColor = NULL;
					}

					// discard the image
					if ( textureDetail )
					{
						textureDetail->drop();
						textureDetail = NULL;
					}

					// release possession of the terrain
					zoneState = ZONE_IDLE;
				}
			}
		}

		// get the distance to the active camera
		f32 distance = camera->getPosition().getDistanceFrom( getPosition());

        // if the object is in the visible range
		if (( distance >= nearDrawDistance ) && ( distance <= farDrawDistance ))
		{
			// register this node for rendering (typically debug information)
            smgr->registerNodeForRendering(this);

			// register all child nodes
			ISceneNode::OnRegisterSceneNode();
		}
	}
}


//! renders the node.
void CZoneSceneNode::render()
{
    // if we have been asked to draw the bounding box
    if ( DebugDataVisible & scene::EDS_BBOX )
    {
        // this node has no geometry only debug visuals
        video::SMaterial m;
        m.Lighting = false;
        driver->setMaterial(m);
        driver->setTransform(video::ETS_WORLD, core::matrix4());
        driver->draw3DBox(this->getTransformedBoundingBox(),video::SColor(0,255,255,128));
    }
}


//! manually set the bounding box
void CZoneSceneNode::SetBoundingBox( f32 x, f32 y, f32 z, f32 w, f32 h, f32 d )
{
    boundingBox.reset( core::aabbox3d<f32>( x, y, z, x+w, y+h, z+d ));
}


//! when a child is added to this node, concider accumulating its bounding box
void CZoneSceneNode::addChild (ISceneNode *child)
{
    // if we are accumulating the bounding boxes of children
    if ( accumulateBoundingBoxes )
    {
        // get the childs bounding box
        core::aabbox3d<f32> childBox( child->getBoundingBox());
        childBox.MinEdge += child->getPosition();
        childBox.MaxEdge += child->getPosition();

        // add the childs bounding box into our own
        if ( firstChild )
        {
            firstChild = false;
            boundingBox.reset( childBox );
        }
        else
        {
            boundingBox.addInternalBox( childBox );
        }

    }
    // add the child to this node
    ISceneNode::addChild(child);
}

//! when a child is added to this node, concider accumulating its bounding box
void CZoneSceneNode::attachTerrain (
									CTerrainTileSceneNode * terrainSource,
									char * structureMap,
									char * colorMap,
									char * detailMap,
									core::position2d<s32> dataPositionSource,
									s32 sliceSize )
{
	// record the terrain properties
	terrain = terrainSource;
	imageName = structureMap;
	colorName = colorMap;
	detailName = detailMap;
	dataPosition = dataPositionSource;
	terrainSliceSize = sliceSize;
    terrain->setVisible( false );
}

}
}

