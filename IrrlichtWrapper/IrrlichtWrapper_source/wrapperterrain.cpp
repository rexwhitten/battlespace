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
#include "CTerrainSphereNode.h"
#include "CTerrainTileSceneNode.h"

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
TERRAIN FUNCTIONS
*/

/* ----------------------------------------------------------------------------
create a terrain node from a highfield map overriding many default parameters
*/
CTerrainSphereNode * DLL_EXPORT IrrAddSphericalTerrain(
								  char *cptrFile0,
								  char *cptrFile1,
								  char *cptrFile2,
								  char *cptrFile3,
								  char *cptrFile4,
								  char *cptrFile5,
								  float xPos, float yPos, float zPos,
								  float xRot, float yRot, float zRot,
								  float xSca, float ySca, float zSca,
								  int a, int r, int g, int b,
								  int smoothing,
								  bool spherical,
								  int maxLOD,
								  int patchSize )
{
    CTerrainSphereNode* terrain = new CTerrainSphereNode(
			NULL,
			smgr,
			device->getFileSystem(),
			0,												// id
			maxLOD,
			(scene::E_TERRAIN_PATCH_SIZE)patchSize,
			core::vector3df(xPos, yPos, zPos),
			core::vector3df(xRot, yRot, zRot),
			core::vector3df(xSca, ySca, zSca));

	io::IReadFile * file[CUBE_FACES];
	file[0] = device->getFileSystem()->createAndOpenFile(cptrFile0);
	file[1] = device->getFileSystem()->createAndOpenFile(cptrFile1);
	file[2] = device->getFileSystem()->createAndOpenFile(cptrFile2);
	file[3] = device->getFileSystem()->createAndOpenFile(cptrFile3);
	file[4] = device->getFileSystem()->createAndOpenFile(cptrFile4);
	file[5] = device->getFileSystem()->createAndOpenFile(cptrFile5);
	if (file)
	{
		terrain->loadHeightMap(file, video::SColor(255,255,255,255), 0);
		for ( s32 i = 0; i < CUBE_FACES; i++ )
            file[i]->drop();
	}

//	terrain->drop();

	return (CTerrainSphereNode*)terrain;
}


/* ----------------------------------------------------------------------------
Apply six textures to the surface of a spherical terrain
*/
void DLL_EXPORT IrrSetSphericalTerrainTexture(
                                            CTerrainSphereNode* terrain,
                                            ITexture *textureTop,
                                            ITexture *textureFront,
                                            ITexture *textureBack,
                                            ITexture *textureLeft,
                                            ITexture *textureRight,
                                            ITexture *textureBottom,
                                            u32 materialIndex )
{
    // set six textures on the spherical terrain one for each face on a cube
    terrain->setTextures( textureTop, textureFront, textureBack,
            textureLeft, textureRight, textureBottom, materialIndex );
}


/* ----------------------------------------------------------------------------
Apply six images to the vertex colors of the faces
*/
void DLL_EXPORT IrrLoadSphericalTerrainVertexColor(
                                            CTerrainSphereNode* terrain,
                                            IImage *imageTop,
                                            IImage *imageFront,
                                            IImage *imageBack,
                                            IImage *imageLeft,
                                            IImage *imageRight,
                                            IImage *imageBottom )
{
    terrain->loadVertexColor( &imageTop );
}

/* ----------------------------------------------------------------------------
Get the surface position of a logical point on the terrain
*/
void DLL_EXPORT IrrGetSphericalTerrainSurfacePosition(
                                            CTerrainSphereNode* terrain,
                                            s32 face,
                                            float logicalX,
                                            float logicalZ,
                                            float &x,
                                            float &y,
                                            float &z )
{
    vector3df pos;
    terrain->getSurfacePosition( face, logicalX, logicalZ, pos );

    x = pos.X;
    y = pos.Y;
    z = pos.Z;
}


/* ----------------------------------------------------------------------------
Get the surface position and angle of a logical point on the terrain. This is
not the normal of the surface but essentially the angles to the gravitational
center
*/
void DLL_EXPORT IrrGetSphericalTerrainSurfacePositionAndAngle(
                                            CTerrainSphereNode* terrain,
                                            s32 face,
                                            float logicalX,
                                            float logicalZ,
                                            float &px,
                                            float &py,
                                            float &pz,
                                            float &rx,
                                            float &ry,
                                            float &rz )
{
    vector3df pos;
    terrain->getSurfacePosition( face, logicalX, logicalZ, pos );

    px = pos.X;
    py = pos.Y;
    pz = pos.Z;

	vector3df rot = pos.normalize().getHorizontalAngle();

	rx = rot.X;
    ry = rot.Y;
    rz = rot.Z;
}


/* ----------------------------------------------------------------------------
Convert a co-ordinate into a logical Spherical terrain position
Thanks for the example from "David" posted on Infinity-Universe forum
http://www.infinity-universe.com/Infinity/index.php?option=com_smf&Itemid=75&topic=2305.0.html
*/
void DLL_EXPORT IrrGetSphericalTerrainLogicalSurfacePosition(
                                            CTerrainSphereNode* terrain,
                                            float px,
                                            float py,
                                            float pz,
                                            s32 &face,
                                            float &logicalX,
                                            float &logicalZ )
{
	// get the vector from the center of the sphere
	vector3df pos = vector3df( px, py, pz ) - terrain->getPosition();

    float fpx = fabs(pos.X);
	float fpy = fabs(pos.Y);
	float fpz = fabs(pos.Z);

	if( fpx >= fpy )
	{
		if( fpx >= fpz )
            face = ( pos.X > 0.0) ? 3 : 4;  // Left and Right
		else
            face = ( pos.Z > 0.0) ? 1 : 2;  // Front and Back
	}
	else
	{
		if( fpy >= fpz)
            face = ( pos.Y > 0.0) ? 0 : 5;  // Top and Bottom
		else
            face = ( pos.Z > 0.0) ? 1 : 2;  // Front and Back
	}

	switch ( face )
	{
		case 0:	// Top
            /* this gives more accurate results but not accurate enough to
            justify the sin's imo
			logicalX = 1.0 - ( sinf( pos.X / fpy * PI / (PI / 1.5) ) + 1.0 ) / 2.0;
			logicalZ = ( sinf( pos.Z / fpy * PI / (PI / 1.5) ) + 1.0 ) / 2.0; */

			logicalX = 1.0f - ( pos.X / fpy + 1.0f ) / 2.0f;
			logicalZ = ( pos.Z / fpy + 1.0f ) / 2.0f;
			break;

		case 1:	// Front
			logicalX = 1.0f - ( pos.X / fpz + 1.0f ) / 2.0f;
			logicalZ = 1.0f - ( pos.Y / fpz + 1.0f ) / 2.0f;
			break;

		case 2:	// Back
			logicalX = ( pos.X / fpz + 1.0f ) / 2.0f;
			logicalZ = 1.0f - ( pos.Y / fpz + 1.0f ) / 2.0f;
			break;

		case 3:	// Left
			logicalX = ( pos.Z / fpx + 1.0f ) / 2.0f;
			logicalZ = 1.0f - ( pos.Y / fpx + 1.0f ) / 2.0f;
			break;

		case 4:	// Right
			logicalX = 1.0f - ( pos.Z / fpx + 1.0f ) / 2.0f;
			logicalZ = 1.0f - ( pos.Y / fpx + 1.0f ) / 2.0f;
			break;

		case 5:	// Bottom
			logicalX = ( pos.X / fpy + 1.0f ) / 2.0f;
			logicalZ = ( pos.Z / fpy + 1.0f ) / 2.0f;
			break;

        default:
            printf( "Corordinate Error\n" );
	}
}


/* ----------------------------------------------------------------------------
create a terrain node from a highfield map overriding many default parameters
*/
void * DLL_EXPORT IrrAddTerrain(
								  char *cptrFile,
								  float xPos, float yPos, float zPos,
								  float xRot, float yRot, float zRot,
								  float xSca, float ySca, float zSca,
								  int a, int r, int g, int b,
								  int smoothing,
								  int maxLOD,
								  int patchSize )
{
    return smgr->addTerrainSceneNode(
			cptrFile,								// heightmap
			NULL,									// parent
			-1,										// id
			core::vector3df(xPos,yPos,zPos),		// position
			core::vector3df(xRot,yRot,zRot),		// rotation
			core::vector3df(xSca,ySca,zSca),		// scale
			video::SColor(a,r,g,b),					// vertex color
			(s32)maxLOD,							// the maximum level of detail
			(scene::E_TERRAIN_PATCH_SIZE)patchSize,	// the size of the patches
			(s32)smoothing );						// the number of times to smooth the terrain
}

/* ----------------------------------------------------------------------------
scale the texture on a terrain node
*/
void DLL_EXPORT IrrScaleTexture ( ITerrainSceneNode* terrain, float X, float Y )
{
    // scale the terrain texture
    terrain->scaleTexture(X,Y);
}

/* ----------------------------------------------------------------------------
scale the texture on a terrain node
*/
void DLL_EXPORT IrrScaleSphericalTexture ( ITerrainSphereNode* terrain, float X, float Y )
{
    // scale the terrain texture
    terrain->scaleTexture(X,Y);
}

/* ----------------------------------------------------------------------------
get the height of a point on a terrain
*/
float DLL_EXPORT IrrGetTerrainHeight( ITerrainSceneNode *terrain, float X, float Z )
{
    return terrain->getHeight( X, Z );
}



/* ----------------------------------------------------------------------------
create a terrain node from a highfield map overriding many default parameters
*/
void * DLL_EXPORT IrrAddTerrainTile(
								  IImage * image,
								  int tileSize,
								  int dataX, int dataY,
								  float xPos, float yPos, float zPos,
								  float xRot, float yRot, float zRot,
								  float xSca, float ySca, float zSca,
								  int smoothing,
								  int maxLOD,
								  int patchSize )
{
    CTerrainTileSceneNode* terrain = new CTerrainTileSceneNode(
			smgr->getRootSceneNode(),
			smgr,
			device->getFileSystem(),
			0,												// id
			maxLOD,
			(scene::E_TERRAIN_PATCH_SIZE)patchSize,
			core::vector3df(xPos, yPos, zPos),
			core::vector3df(xRot, yRot, zRot),
			core::vector3df(xSca, ySca, zSca));

	if ( image )
	{
		terrain->loadHeightMapImage( image,
				core::position2d<s32>(dataX, dataY),
				tileSize,
				video::SColor(255,255,255,128), 0);
	}

	return terrain;
}

/* ----------------------------------------------------------------------------
get the height of a point on a terrain tile node
*/
float DLL_EXPORT IrrGetTerrainTileHeight ( CTerrainTileSceneNode* terrain, float X, float Z )
{
    // scale the terrain texture
    return terrain->getHeight(X,Z);
}

/* ----------------------------------------------------------------------------
scale the texture on a terrain tile node
*/
void DLL_EXPORT IrrScaleTileTexture ( CTerrainTileSceneNode* terrain, float X, float Y )
{
    // scale the terrain texture
    terrain->scaleTexture(X,Y);
}

/* ----------------------------------------------------------------------------
set the adjacent tile to this tile node
*/
void DLL_EXPORT IrrAttachTile ( CTerrainTileSceneNode* terrain, CTerrainTileSceneNode* neighbour, int edge )
{
    // attach a neighbouring tile
    terrain->attachTile( neighbour, edge);
}

/* ----------------------------------------------------------------------------
load the height and UV data from an image
*/
void DLL_EXPORT IrrSetTileStructure ( CTerrainTileSceneNode* terrain, IImage * image, int dataX, int dataY )
{
	if ( image )
	{
		terrain->loadStructure( image, core::position2d<s32>(dataX, dataY), 0, terrain->getTerrainSize());
	}
}

/* ----------------------------------------------------------------------------
load the vertex colors from an image
*/
void DLL_EXPORT IrrSetTileColor( CTerrainTileSceneNode* terrain, IImage * image, int dataX, int dataY )
{
	if ( image )
	{
		terrain->loadColor( image, core::position2d<s32>(dataX, dataY));
	}
}


/* ////////////////////////////////////////////////////////////////////////////
all of the above functions are declared as C functions and are exposed without
any mangled names
*/
}
