// Copyright (C) 2008 Frank Dodd
// This file is part of the "IrrlichtWrapper" distributed under the Irrlicht licence
// For conditions of distribution and use, see copyright notice in irrlicht.h

#ifndef __C_ZONE_SCENE_NODE_H_INCLUDED__
#define __C_ZONE_SCENE_NODE_H_INCLUDED__

#include "ISceneNode.h"
#include "SMeshBuffer.h"
#include "CTerrainTileSceneNode.h"

#define ZONE_IDLE							0
#define ZONE_READ_COLOR						1
#define ZONE_READ_DETAIL					2
#define ZONE_WRITING_TERRAIN_STRUCTURE		3
#define ZONE_WRITING_TERRAIN_TRANSFORMATION	4
#define ZONE_WRITING_TERRAIN_PATCHES		5
#define ZONE_RUNNING						6

namespace irr
{
namespace scene
{

class CZoneSceneNode : public ISceneNode
{
	public:
		CZoneSceneNode( f32 initialNearDistance, f32 initialFarDistance,
                        ISceneNode* root, ISceneManager* smgr, s32 id);
		virtual void OnRegisterSceneNode();
		virtual void render();
		virtual const core::aabbox3d<f32>& getBoundingBox() const{ return boundingBox; }
		virtual void SetDrawProperties( f32 newNearDistance, f32 newFarDrawDistance, bool accumulateChildBoxes );
		virtual void SetBoundingBox( f32 x, f32 y, f32 z, f32 w, f32 h, f32 d );
		virtual void addChild (ISceneNode *child);
		virtual void attachTerrain ( CTerrainTileSceneNode * terrainSource,
									char * structureMap,
									char * colorMap,
									char * detailMap,
									core::position2d<s32> dataPositionSource,
									s32 sliceSize );

	private:
        bool accumulateBoundingBoxes ;
        bool firstChild;
		f32 farDrawDistance;
		f32 nearDrawDistance;
		core::aabbox3d<f32> boundingBox;

		// terrain management
		CTerrainTileSceneNode * terrain;
		s32 terrainRow;
		s32 terrainSliceSize;
		char * imageName;
		char * colorName;
		char * detailName;
		video::IImage* image;
		video::ITexture* textureColor;
		video::ITexture* textureDetail;
		core::position2d<s32> dataPosition;
		s32 zoneState;
};


}
}

#endif

