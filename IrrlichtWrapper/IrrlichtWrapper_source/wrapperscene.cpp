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
#include "CCloudSceneNode.h"
#include "CLensFlareSceneNode.h"
#include "CGrassPatchSceneNode.h"
#include "CWindGenerator.h"
#include "CBillboardGroupSceneNode.h"
#include "CSkyDomeColorSceneNode.h"
#include "CLODSceneNode.h"
#include "CZoneSceneNode.h"
#include "CBatchingMesh.h"
#include "CImpostorSceneNode.h"
#include "CBoltSceneNode.h"
#include "CBeamSceneNode.h"


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
SCENE MESHS
*/
/* ----------------------------------------------------------------------------
load a model file creating a mesh object for it and returning it for the caller
to manage
*/
void * DLL_EXPORT IrrGetMesh( char *cptrFile )
{
    /* load a mesh and add it to the scene */
	IAnimatedMesh* mesh = smgr->getMesh( cptrFile );

	return (void *)mesh;
}

/* ----------------------------------------------------------------------------
create a mesh from an array of verticies, an array of incidies to those
verticies that connect them to form triangles and finally texture co-ordinates
to map the verticies against a texture plane
*/
void * DLL_EXPORT IrrCreateMesh(
                                char *cptrMeshName,
                                int iVertexCount,
                                IRR_VERT *vVertices,
                                int iIndicesCount,
                                unsigned short *usIndices )
{
    int iLoop;

    /* get the mesh cache for the scene */
    IMeshCache *mcache = smgr->getMeshCache();

    SMeshBuffer *smeshbuffer = new SMeshBuffer;
    SMesh *smesh = new SMesh;
    SAnimatedMesh * sanimmesh = new SAnimatedMesh;

    // add all of the verts
//    printf( "Adding %d verts\n", iVertexCount );
    smeshbuffer->Vertices.set_used(iVertexCount);
    for ( iLoop = 0; iLoop < iVertexCount; iLoop++ )
    {
        smeshbuffer->Vertices[iLoop].Pos.set(
                                            vVertices[iLoop].x,
                                            vVertices[iLoop].y,
                                            vVertices[iLoop].z );
        smeshbuffer->Vertices[iLoop].Normal.set(
                                            vVertices[iLoop].normal_x,
                                            vVertices[iLoop].normal_y,
                                            vVertices[iLoop].normal_z );
        smeshbuffer->Vertices[iLoop].Color.color = vVertices[iLoop].vcolor;
        smeshbuffer->Vertices[iLoop].TCoords.set(
                                            vVertices[iLoop].texture_x,
                                            vVertices[iLoop].texture_y );
    }

    // add all of the indices
//    printf( "Adding %d indicies\n", iIndicesCount );
    smeshbuffer->Indices.set_used(iIndicesCount);
    for ( iLoop = 0; iLoop < iIndicesCount; iLoop++ )
    {
        smeshbuffer->Indices[iLoop] = usIndices[iLoop];
    }

    // assemble the mesh objects
	smeshbuffer->recalculateBoundingBox();
    smesh->addMeshBuffer( smeshbuffer );
    smeshbuffer->drop();

    smesh->recalculateBoundingBox();
    sanimmesh->addMesh( smesh );
    mcache->addMesh( cptrMeshName, sanimmesh );

    // recalculate the bounding box around the object for clipping purposes
    sanimmesh->recalculateBoundingBox();

	return (void *)sanimmesh;
}

/* ----------------------------------------------------------------------------
write the first frame of the supplied animated mesh out to a file using the
specified file format
*/
int DLL_EXPORT IrrWriteMesh( IAnimatedMesh* mesh, int type, const char * filename )
{
	int status = 0;
	EMESH_WRITER_TYPE writer_type[] = { EMWT_IRR_MESH, EMWT_COLLADA, EMWT_STL };

	/* create a mesh writer to save the object */
	IMeshWriter* meshwriter = smgr->createMeshWriter( writer_type[type] );

	if ( meshwriter )
	{
		status = 1;
		// open the file
		IWriteFile *file = guienv->getFileSystem()->createAndWriteFile( filename );
		if ( file )
		{
			status = 2;
			// get the static mesh from within the animated mesh object
			IMesh * staticmesh = mesh->getMesh(0);

			// write the mesh out to file
			if ( meshwriter->writeMesh ( file, staticmesh ))
			{
				status = 3;
			}

			// close the file
			file->drop();
		}
		// we have finished with the mesh writer
		meshwriter->drop();
	}
	return status;
}

/* ----------------------------------------------------------------------------
Clears all meshes that are held in the mesh cache but not used anywhere else.

Warning: If you have pointers to meshes that were loaded with
ISceneManager::getMesh() and you did not grab them, then they may become
invalid.
*/
void DLL_EXPORT IrrClearUnusedMeshes( void )
{
    /* get the mesh cache for the scene */
    IMeshCache *mcache = smgr->getMeshCache();

    /* remove the selected mesh */
    mcache->clearUnusedMeshes();
}

/* ----------------------------------------------------------------------------
remove a loaded mesh from the scene cache useful if you are dealing with large
numbers of meshes that you dont want cached in memory at the same time (for
example when swapping between BSP maps for levels
*/
void DLL_EXPORT IrrRemoveMesh( IAnimatedMesh* mesh )
{
    /* get the mesh cache for the scene */
    IMeshCache *mcache = smgr->getMeshCache();

    /* remove the selected mesh */
    mcache->removeMesh( mesh );
}

/* ----------------------------------------------------------------------------
rename a loaded mesh through the scene cache, the mesh can then subsequently be
loaded again as a different mesh
*/
void DLL_EXPORT IrrRenameMesh( IAnimatedMesh* mesh, const char * name )
{
    /* get the mesh cache for the scene */
    IMeshCache *mcache = smgr->getMeshCache();

    /* remove the selected mesh */
    mcache->renameMesh( mesh, name );
}

/* ----------------------------------------------------------------------------
add a hill plane mesh to the mesh pool
*/
void * DLL_EXPORT IrrAddHillPlaneMesh( const c8* meshname, float tileSizeX, float tileSizeY, int tileCountX, int tileCountY, SMaterial * material, float hillHeight, float countHillsX, float countHillsY, float textureRepeatCountX, float textureRepeatCountY )
{
    scene::IAnimatedMesh* mesh = smgr->addHillPlaneMesh(meshname,
        core::dimension2d<f32>(tileSizeX, tileSizeY),
        core::dimension2d<u32>(tileCountX, tileCountY),
        material,
        hillHeight,
        core::dimension2d<f32>(countHillsX, countHillsY),
        core::dimension2d<f32>(textureRepeatCountX, textureRepeatCountY)
        );
    return (void *) mesh;
}

/* ----------------------------------------------------------------------------
create a batching mesh that will be a collection of other meshes
*/
CBatchingMesh * DLL_EXPORT IrrCreateBatchingMesh( void )
{
	CBatchingMesh* meshBatch = new CBatchingMesh();

	return meshBatch;
}

/* ----------------------------------------------------------------------------
add a mesh to the batch of meshes
*/
void DLL_EXPORT IrrAddToBatchingMesh(	CBatchingMesh * meshBatch,
							IAnimatedMesh * mesh,
							float posX, float posY, float posZ,
							float rotX, float rotY, float rotZ,
							float scaX, float scaY, float scaZ )
{
	meshBatch->addMesh(	mesh,
						core::vector3df( posX,posY,posZ ),
						core::vector3df( rotX,rotY,rotZ ),
						core::vector3df( scaX,scaY,scaZ ));
}

/* ----------------------------------------------------------------------------
finish adding meshes to the batch mesh and create an animated mesh from it
*/
IAnimatedMesh * DLL_EXPORT IrrFinalizeBatchingMesh( CBatchingMesh * meshBatch )
{
	meshBatch->finalize();
	IMeshManipulator * mm = smgr->getMeshManipulator();
	IAnimatedMesh * resultMesh = mm->createAnimatedMesh( meshBatch );

	return resultMesh;
}


/* ////////////////////////////////////////////////////////////////////////////
SCENE MESH MANIPULATION
*/

/* ----------------------------------------------------------------------------
set a mesh to be a vertex buffer object offloaded to the graphics card. VBOs
are only supported for meshes of 500 verticies and over
*/
void DLL_EXPORT IrrSetMeshHardwareAccelerated( IAnimatedMesh* mesh, int iFrame )
{
	for (int iMeshBuffer=0; iMeshBuffer < (int)mesh->getMesh(iFrame)->getMeshBufferCount(); iMeshBuffer++)
	{
        mesh->getMeshBuffer(iMeshBuffer)->setHardwareMappingHint(scene::EHM_STATIC );
	}
    mesh->setDirty();
}

/* ----------------------------------------------------------------------------
apply a material to a scene node
*/
void DLL_EXPORT IrrSetMeshMaterialTexture ( IAnimatedMesh* mesh, ITexture *texture, int iIndex, int iBuffer )
{
    // apply a texture to the model
    mesh->getMeshBuffer( iBuffer )->getMaterial().setTexture( iIndex, texture );
}


/* ----------------------------------------------------------------------------
get the number of frames in the mesh
*/
u32 DLL_EXPORT IrrGetMeshFrameCount( IAnimatedMesh* mesh )
{
	return mesh->getFrameCount();
}


/* ----------------------------------------------------------------------------
get the number of mesh buffers in the mesh
*/
u32 DLL_EXPORT IrrGetMeshBufferCount( IAnimatedMesh* mesh, int iFrame )
{
	return mesh->getMesh(iFrame)->getMeshBufferCount();
}


/* ----------------------------------------------------------------------------
get the number of indicies in the mesh buffer
*/
int DLL_EXPORT IrrGetMeshIndexCount( IAnimatedMesh* mesh, int iFrame, int iMeshBuffer )
{
    int iIndexCount;

    iIndexCount = mesh->getMesh(iFrame)->getMeshBuffer(iMeshBuffer)->getIndexCount();

	return iIndexCount;
}

/* ----------------------------------------------------------------------------
copy the indicies of a mesh into the supplied buffer, the caller must ensure
that the buffer is big enough to store the data
*/
void DLL_EXPORT IrrGetMeshIndices ( IAnimatedMesh* mesh,
                                    int iFrame,
                                    unsigned short *indicies,
                                    int iMeshBuffer)
{
    int iLoop;
    int iIndexCount = mesh->getMesh(iFrame)->getMeshBuffer(iMeshBuffer)->getIndexCount();

    unsigned short *us = mesh->getMesh(iFrame)->getMeshBuffer(iMeshBuffer)->getIndices();

    for ( iLoop = 0; iLoop < iIndexCount; iLoop++ )
    {
        indicies[iLoop] = us[iLoop];
    }
}

/* ----------------------------------------------------------------------------
copy the indicies in the supplied buffer into the mesh , the caller must ensure
that the buffer is big enough to supply all of the data
*/
void DLL_EXPORT IrrSetMeshIndices ( IAnimatedMesh* mesh,
                                    int iFrame,
                                    unsigned short *indicies,
                                    int iMeshBuffer )
{
    int iLoop;
    int iIndexCount = mesh->getMesh(iFrame)->getMeshBuffer(iMeshBuffer)->getIndexCount();
    unsigned short *us = mesh->getMesh(iFrame)->getMeshBuffer(iMeshBuffer)->getIndices();

    for ( iLoop = 0; iLoop < iIndexCount; iLoop++ )
    {
        us[iLoop] = indicies[iLoop];
    }
}

/* ----------------------------------------------------------------------------
get the number of vertices in the mesh buffer
*/
int DLL_EXPORT IrrGetMeshVertexCount (  IAnimatedMesh* mesh,
                                        int iFrame,
                                        int iMeshBuffer )
{
    int iVertexCount;

    iVertexCount = mesh->getMesh(iFrame)->getMeshBuffer(iMeshBuffer)->getVertexCount();

	return iVertexCount;
}

/* ----------------------------------------------------------------------------
copy the vertices of a mesh into the supplied buffer, the caller must ensure
that the buffer is big enough to store the data
*/
void DLL_EXPORT IrrGetMeshVertices( IAnimatedMesh* mesh,
                                    int iFrame,
                                    IRR_VERT *verts,
                                    int iMeshBuffer )
{
    int iLoop;
    S3DVertex *s3d_verts;
    S3DVertex2TCoords *texture_verts;
    S3DVertexTangents *tangent_verts;

    IMeshBuffer *mb = mesh->getMesh(iFrame)->getMeshBuffer(iMeshBuffer);
    int iVertexCount = mb->getVertexCount();

    switch ( mb->getVertexType())
    {
    case EVT_STANDARD:
        // Standard vertex type used by the Irrlicht engine, video::S3DVertex
        s3d_verts = (S3DVertex *)mb->getVertices();
        for ( iLoop = 0; iLoop < iVertexCount; iLoop++ )
        {
            verts[iLoop].x = s3d_verts[iLoop].Pos.X;
            verts[iLoop].y = s3d_verts[iLoop].Pos.Y;
            verts[iLoop].z = s3d_verts[iLoop].Pos.Z;

            verts[iLoop].normal_x = s3d_verts[iLoop].Normal.X;
            verts[iLoop].normal_y = s3d_verts[iLoop].Normal.Y;
            verts[iLoop].normal_z = s3d_verts[iLoop].Normal.Z;

            verts[iLoop].vcolor = s3d_verts[iLoop].Color.color;
            verts[iLoop].texture_x = s3d_verts[iLoop].TCoords.X;
            verts[iLoop].texture_y = s3d_verts[iLoop].TCoords.Y;
        }
        break;

    case EVT_2TCOORDS:
        /* Vertex with two texture coordinates, video::S3DVertex2TCoords.
        Usually used for geometry with lightmaps or other special materials. */
        texture_verts = (S3DVertex2TCoords *)mb->getVertices();
        for ( iLoop = 0; iLoop < iVertexCount; iLoop++ )
        {
            verts[iLoop].x = texture_verts[iLoop].Pos.X;
            verts[iLoop].y = texture_verts[iLoop].Pos.Y;
            verts[iLoop].z = texture_verts[iLoop].Pos.Z;

            verts[iLoop].normal_x = texture_verts[iLoop].Normal.X;
            verts[iLoop].normal_y = texture_verts[iLoop].Normal.Y;
            verts[iLoop].normal_z = texture_verts[iLoop].Normal.Z;

            verts[iLoop].vcolor = texture_verts[iLoop].Color.color;
            verts[iLoop].texture_x = texture_verts[iLoop].TCoords.X;
            verts[iLoop].texture_y = texture_verts[iLoop].TCoords.Y;
        }
        break;

    case EVT_TANGENTS:
        /* Vertex with a tangent and binormal vector, video::S3DVertexTangents.
        Usually used for tangent space normal mapping. */
        tangent_verts = (S3DVertexTangents *)mb->getVertices();
        for ( iLoop = 0; iLoop < iVertexCount; iLoop++ )
        {
            verts[iLoop].x = tangent_verts[iLoop].Pos.X;
            verts[iLoop].y = tangent_verts[iLoop].Pos.Y;
            verts[iLoop].z = tangent_verts[iLoop].Pos.Z;

            verts[iLoop].normal_x = tangent_verts[iLoop].Normal.X;
            verts[iLoop].normal_y = tangent_verts[iLoop].Normal.Y;
            verts[iLoop].normal_z = tangent_verts[iLoop].Normal.Z;

            verts[iLoop].vcolor = tangent_verts[iLoop].Color.color;
            verts[iLoop].texture_x = tangent_verts[iLoop].TCoords.X;
            verts[iLoop].texture_y = tangent_verts[iLoop].TCoords.Y;
        }
        break;
    }
}

/* ----------------------------------------------------------------------------
return a pointer to the vertex memory for the supplied mesh operations can be
carried out very quickly on vertices through this function but object sizes and
array access needs to be handled by the caller
*/
void * DLL_EXPORT IrrGetMeshVertexMemory( IAnimatedMesh* mesh,
										  int iFrame,
										  int iMeshBuffer )
{
    IMeshBuffer *mb = mesh->getMesh(iFrame)->getMeshBuffer(iMeshBuffer);
	return mb->getVertices();
}

/* ----------------------------------------------------------------------------
copy the vertices in the supplied buffer into the mesh , the caller must ensure
that the buffer is big enough to supply all of the data
*/
void DLL_EXPORT IrrSetMeshVertices( IAnimatedMesh* mesh,
                                    int iFrame,
                                    IRR_VERT *verts,
                                    int iMeshBuffer )
{
    int iLoop;
    S3DVertex *s3d_verts;
    S3DVertex2TCoords *texture_verts;
    S3DVertexTangents *tangent_verts;

	IMesh * imesh = mesh->getMesh(iFrame);
    IMeshBuffer *mb = imesh->getMeshBuffer(iMeshBuffer);
    int iVertexCount = mb->getVertexCount();
    aabbox3df BoundingBox(0.0,0.0,0.0,0.0,0.0,0.0);

    switch ( mb->getVertexType())
    {
    case EVT_STANDARD:
        // Standard vertex type used by the Irrlicht engine, video::S3DVertex
        s3d_verts = (S3DVertex *)mb->getVertices();

        for ( iLoop = 0; iLoop < iVertexCount; iLoop++ )
        {
            s3d_verts[iLoop].Pos.X = verts[iLoop].x;
            s3d_verts[iLoop].Pos.Y = verts[iLoop].y;
            s3d_verts[iLoop].Pos.Z = verts[iLoop].z;

            s3d_verts[iLoop].Normal.X = verts[iLoop].normal_x;
            s3d_verts[iLoop].Normal.Y = verts[iLoop].normal_y;
            s3d_verts[iLoop].Normal.Z = verts[iLoop].normal_z;

            s3d_verts[iLoop].Color.color = verts[iLoop].vcolor;
            s3d_verts[iLoop].TCoords.X = verts[iLoop].texture_x;
            s3d_verts[iLoop].TCoords.Y = verts[iLoop].texture_y;

            BoundingBox.addInternalPoint(s3d_verts[iLoop].Pos);
        }
        break;

    case EVT_2TCOORDS:
        /* Vertex with two texture coordinates, video::S3DVertex2TCoords.
        Usually used for geometry with lightmaps or other special materials. */
        texture_verts = (S3DVertex2TCoords *)mb->getVertices();

        for ( iLoop = 0; iLoop < iVertexCount; iLoop++ )
        {
            texture_verts[iLoop].Pos.X = verts[iLoop].x;
            texture_verts[iLoop].Pos.Y = verts[iLoop].y;
            texture_verts[iLoop].Pos.Z = verts[iLoop].z;

            texture_verts[iLoop].Normal.X = verts[iLoop].normal_x;
            texture_verts[iLoop].Normal.Y = verts[iLoop].normal_y;
            texture_verts[iLoop].Normal.Z = verts[iLoop].normal_z;

            texture_verts[iLoop].Color.color = verts[iLoop].vcolor;
            texture_verts[iLoop].TCoords.X = verts[iLoop].texture_x;
            texture_verts[iLoop].TCoords.Y = verts[iLoop].texture_y;

            BoundingBox.addInternalPoint(texture_verts[iLoop].Pos);
        }
        break;

    case EVT_TANGENTS:
        /* Vertex with a tangent and binormal vector, video::S3DVertexTangents.
        Usually used for tangent space normal mapping. */
        tangent_verts = (S3DVertexTangents *)mb->getVertices();

        for ( iLoop = 0; iLoop < iVertexCount; iLoop++ )
        {
            tangent_verts[iLoop].Pos.X = verts[iLoop].x;
            tangent_verts[iLoop].Pos.Y = verts[iLoop].y;
            tangent_verts[iLoop].Pos.Z = verts[iLoop].z;

            tangent_verts[iLoop].Normal.X = verts[iLoop].normal_x;
            tangent_verts[iLoop].Normal.Y = verts[iLoop].normal_y;
            tangent_verts[iLoop].Normal.Z = verts[iLoop].normal_z;

            tangent_verts[iLoop].Color.color = verts[iLoop].vcolor;
            tangent_verts[iLoop].TCoords.X = verts[iLoop].texture_x;
            tangent_verts[iLoop].TCoords.Y = verts[iLoop].texture_y;

            BoundingBox.addInternalPoint(tangent_verts[iLoop].Pos);
        }
        break;
    }

	// set the bounding box of the mesh buffer
    mb->setBoundingBox( BoundingBox );

	// add in the bounding boxes of other mesh buffers
	IMeshBuffer *mbuff;
	for ( iLoop = 0; iLoop < (int)imesh->getMeshBufferCount(); iLoop++ )
	{
		// dont add in our own box
		if ( iLoop != iMeshBuffer )
		{
			mbuff = imesh->getMeshBuffer( iLoop );
			BoundingBox.addInternalBox( mbuff->getBoundingBox());
		}
	}

    // now set the bounding box of the mesh
    imesh->setBoundingBox( BoundingBox );
}

/* ----------------------------------------------------------------------------
copy the vertices in the supplied buffer into the mesh , the caller must ensure
that the buffer is big enough to supply all of the data
*/
void DLL_EXPORT IrrScaleMesh( IAnimatedMesh* mesh,
								 float scale,
								 int iFrame,
								 int iMeshBuffer,
								 IAnimatedMesh* sourceMesh )
{
    int iLoop;
    S3DVertex *vertexIn, *vertexOut;
    IMeshBuffer *mbIn, *mbOut;
    aabbox3df BoundingBox(0.0,0.0,0.0,0.0,0.0,0.0);

	// if a difference source mesh was supplied
	if ( sourceMesh )
	{
		// use that as a template
		mbIn = sourceMesh->getMesh(iFrame)->getMeshBuffer(iMeshBuffer);
	}
	else
	{
		// otherwise just scale the destination mesh into itself
		mbIn = mesh->getMesh(iFrame)->getMeshBuffer(iMeshBuffer);
	}
	mbOut = mesh->getMesh(iFrame)->getMeshBuffer(iMeshBuffer);

	// get the verticies
    switch ( mbOut->getVertexType())
    {
        // Standard vertex type used by the Irrlicht engine: video::S3DVertex.
        case EVT_STANDARD:
            vertexIn = (S3DVertex*)mbIn->getVertices();
            vertexOut = (S3DVertex*)mbOut->getVertices();
            break;

        // Vertex with two texture coordinates, video::S3DVertex2TCoords.
        // Usually used for geometry with lightmaps or other special materials.
        case EVT_2TCOORDS:
            vertexIn = (S3DVertex2TCoords*)mbIn->getVertices();
            vertexOut = (S3DVertex2TCoords*)mbOut->getVertices();
            break;

        // Usually used for tangent space normal mapping.
        // Vertex with a tangent and binormal vector, video::S3DVertexTangents.
        case EVT_TANGENTS:
            vertexIn = (S3DVertexTangents*)mbIn->getVertices();
            vertexOut = (S3DVertexTangents*)mbOut->getVertices();
            break;
    }

	// get the number of verticies in this mesh buffer
	int iVertexCount = mbIn->getVertexCount();

	// itterate the verticies
    for ( iLoop = 0; iLoop < iVertexCount; iLoop++ )
    {
		// copy and scale the data
        vertexOut[iLoop].Pos.X = vertexIn[iLoop].Pos.X * scale;
        vertexOut[iLoop].Pos.Y = vertexIn[iLoop].Pos.Y * scale;
        vertexOut[iLoop].Pos.Z = vertexIn[iLoop].Pos.Z * scale;

        BoundingBox.addInternalPoint(vertexOut[iLoop].Pos);
	}

	// set the bounding box of the mesh buffer
    mbOut->setBoundingBox( BoundingBox );

	// add in the bounding boxes of other mesh buffers
	IMeshBuffer *mbuff;
	for ( iLoop = 0; iLoop < (int)mesh->getMeshBufferCount(); iLoop++ )
	{
		// dont add in our own box
		if ( iLoop != iMeshBuffer )
		{
			mbuff = mesh->getMeshBuffer( iLoop );
			BoundingBox.addInternalBox( mbuff->getBoundingBox());

		}
	}

    // now set the bounding box of the mesh
    mesh->setBoundingBox( BoundingBox );
    mesh->getMesh(iFrame)->setBoundingBox( BoundingBox );
}

/* ----------------------------------------------------------------------------
Change the color of the vertices in the mesh
*/
void DLL_EXPORT IrrSetMeshVertexColors( IAnimatedMesh* mesh,
                                        unsigned int iFrame,
                                        unsigned int *vertexColor,
                                        unsigned int groupCount,
                                        unsigned int *startPos,
                                        unsigned int *endPos,
                                        unsigned int iMeshBuffer )
{
    unsigned int i;
    unsigned int j;
    S3DVertex *vertex;
    IMeshBuffer *mb = mesh->getMesh(iFrame)->getMeshBuffer(iMeshBuffer);

    switch ( mb->getVertexType())
    {
        // Standard vertex type used by the Irrlicht engine: video::S3DVertex.
        case EVT_STANDARD:
            vertex = (S3DVertex*)mb->getVertices();
            break;

        // Vertex with two texture coordinates, video::S3DVertex2TCoords.
        // Usually used for geometry with lightmaps or other special materials.
        case EVT_2TCOORDS:
            vertex = (S3DVertex2TCoords*)mb->getVertices();
            break;

        // Usually used for tangent space normal mapping.
        // Vertex with a tangent and binormal vector, video::S3DVertexTangents.
        case EVT_TANGENTS:
            vertex = (S3DVertexTangents*)mb->getVertices();
            break;
    }

    if (startPos != 0)
    {
        for ( i = 0; i < groupCount; i++ )
        {
            for ( j = startPos[i]; j <= endPos[i]; j++ )
            {
                vertex[j].Color.color = vertexColor[j];
            }
        }
    }
    else
    {
        if (groupCount == 0)
        {
            groupCount = mb->getVertexCount();
        }

        for ( i = 0; i < groupCount; i++ )
        {
            vertex[i].Color.color = vertexColor[i];
        }
    }
}

/* ----------------------------------------------------------------------------
Change the vertex coordinates in the mesh.
*/
void DLL_EXPORT IrrSetMeshVertexCoords( IAnimatedMesh* mesh,
                                        unsigned int iFrame,
                                        IRR_VECTOR *vertexCoord,
                                        unsigned int groupCount,
                                        unsigned int *startPos,
                                        unsigned int *endPos,
                                        unsigned int iMeshBuffer )
{
    unsigned int i;
    unsigned int j;
    S3DVertex *vertex;
    IMeshBuffer *mb = mesh->getMesh(iFrame)->getMeshBuffer(iMeshBuffer);
    aabbox3df BoundingBox(0.0,0.0,0.0,0.0,0.0,0.0);
	IMesh * imesh = mesh->getMesh(iFrame);

    switch ( mb->getVertexType())
    {
        // Standard vertex type used by the Irrlicht engine: video::S3DVertex.
        case EVT_STANDARD:
            vertex = (S3DVertex*)mb->getVertices();
            break;

        // Vertex with two texture coordinates, video::S3DVertex2TCoords.
        // Usually used For geometry with lightmaps or other special materials.
        case EVT_2TCOORDS:
            vertex = (S3DVertex2TCoords *)mb->getVertices();
            break;

        // Usually used for tangent space normal mapping.
        // Vertex with a tangent and binormal vector, video::S3DVertexTangents.
        case EVT_TANGENTS:
            vertex = (S3DVertexTangents*)mb->getVertices();
            break;
    }

    if ( startPos != 0)
    {
        for ( i = 0; i < groupCount; i++ )
        {
            for ( j = startPos[i]; j <= endPos[i]; j++ )
            {
                vertex[j].Pos.X = vertexCoord[j].x;
                vertex[j].Pos.Y = vertexCoord[j].y;
                vertex[j].Pos.Z = vertexCoord[j].z;
                BoundingBox.addInternalPoint(vertex[j].Pos);
            }
        }
    }
    else
    {
        if (groupCount == 0)
        {
            groupCount = mb->getVertexCount();
        }
        for ( i = 0; i < groupCount; i++ )
        {
            vertex[i].Pos.X = vertexCoord[i].x;
            vertex[i].Pos.Y = vertexCoord[i].y;
            vertex[i].Pos.Z = vertexCoord[i].z;
            BoundingBox.addInternalPoint(vertex[i].Pos);
        }
    }

	// set the bounding box of the meshbuffer
    mb->setBoundingBox( BoundingBox );

	// add in the bounding boxes of other mesh buffers
	IMeshBuffer *mbuff;
	for ( i = 0; i < (int)imesh->getMeshBufferCount(); i++ )
	{
		// dont add in our own box
		if ( i != iMeshBuffer )
		{
			mbuff = imesh->getMeshBuffer( i );
			BoundingBox.addInternalBox( mbuff->getBoundingBox());
		}
	}

    // now set the bounding box of the mesh
    mesh->getMesh(iFrame)->setBoundingBox( BoundingBox );
}

/* ----------------------------------------------------------------------------
Change the color of the vertices in the mesh with a uniform color
*/
void DLL_EXPORT IrrSetMeshVertexSingleColor(    IAnimatedMesh* mesh,
                                                unsigned int iFrame,
                                                unsigned int vertexColor,
                                                unsigned int groupCount,
                                                unsigned int *startPos,
                                                unsigned int *endPos,
                                                unsigned int iMeshBuffer )
{
    unsigned int i;
    unsigned int j;
    S3DVertex *vertex;
    IMeshBuffer *mb = mesh->getMesh(iFrame)->getMeshBuffer(iMeshBuffer);

    switch ( mb->getVertexType())
    {
        // Standard vertex type used by the Irrlicht engine: video::S3DVertex.
        case EVT_STANDARD:
            vertex = (S3DVertex*)mb->getVertices();
            break;

        // Vertex with two texture coordinates, video::S3DVertex2TCoords.
        // Usually used for geometry with lightmaps or other special materials.
        case EVT_2TCOORDS:
            vertex = (S3DVertex2TCoords*)mb->getVertices();
            break;

        // Usually used for tangent space normal mapping.
        // Vertex with a tangent and binormal vector, video::S3DVertexTangents.
        case EVT_TANGENTS:
            vertex = (S3DVertexTangents*)mb->getVertices();
            break;
    }

    if (startPos != 0)
    {
        for ( i = 0; i < groupCount; i++ )
        {
            for ( j = startPos[i]; j <= endPos[i]; j++ )
            {
                vertex[j].Color.color = vertexColor;
            }
        }
    }
    else
    {
        if (groupCount == 0)
        {
            groupCount = mb->getVertexCount();
        }

        for ( i = 0; i < groupCount; i++ )
        {
            vertex[i].Color.color = vertexColor;
        }
    }
}


/* ----------------------------------------------------------------------------
Gets the bounding box values of a mesh.
*/
void DLL_EXPORT IrrGetMeshBoundingBox (
                                        void *mesh,
                                        f32 &minx,
                                        f32 &miny,
                                        f32 &minz,
                                        f32 &maxx,
                                        f32 &maxy,
                                        f32 &maxz )
{
    aabbox3d<f32> curbox = ((IMesh*)mesh)->getBoundingBox();
    minx = curbox.MinEdge.X;
    miny = curbox.MinEdge.Y;
    minz = curbox.MinEdge.Z;
    maxx = curbox.MaxEdge.X;
    maxy = curbox.MaxEdge.Y;
    maxz = curbox.MaxEdge.Z;
}


/* ////////////////////////////////////////////////////////////////////////////
SCENE NODE CREATION
*/

/* ----------------------------------------------------------------------------
gets the scenes root node, all scene nodes are children of this node
*/
ISceneNode * DLL_EXPORT IrrGetRootSceneNode ( void )
{
    return smgr->getRootSceneNode();
}

/* ----------------------------------------------------------------------------
add a loaded mesh to the irrlicht scene manager
*/
void * DLL_EXPORT IrrAddMeshToScene ( IAnimatedMesh* mesh )
{
	IAnimatedMeshSceneNode* node = smgr->addAnimatedMeshSceneNode( mesh );
	return (void *)node;
}


/* ----------------------------------------------------------------------------
add the supplied mesh object to the scene as an octtree node
*/
void * DLL_EXPORT IrrAddMeshToSceneAsOcttree( void *vptrMesh )
{
    // add the mesh to the scene as an octtree
    return (void *)smgr->addOctreeSceneNode((IAnimatedMesh*)vptrMesh);
}


/* ----------------------------------------------------------------------------
add a loaded mesh to the irrlicht scene manager using a static mesh buffer,
tangent vertex information is added to allow the scene node to be used with
normal and parallax mapping materials
*/
void * DLL_EXPORT IrrAddStaticMeshForNormalMappingToScene ( IAnimatedMesh* mesh )
{
	IMesh* tangentMesh = smgr->getMeshManipulator()->createMeshWithTangents( mesh->getMesh(0));

	ISceneNode *scenenode = (ISceneNode *)smgr->addMeshSceneNode(tangentMesh);

	// drop mesh because we created it
	tangentMesh->drop();

	return scenenode;
}


/* ----------------------------------------------------------------------------
load a scene created with irrEdit
*/
void DLL_EXPORT IrrLoadScene( const c8* filename )
{
    smgr->loadScene(filename);
}


/* ----------------------------------------------------------------------------
save the current scene out to a file that is compatible with irrEdit
*/
void DLL_EXPORT IrrSaveScene( const c8* filename )
{
    smgr->saveScene(filename);
}


/* ----------------------------------------------------------------------------
get a scene node based on its ID and returns null if no node is found
*/
void * DLL_EXPORT IrrGetSceneNodeFromId( int id )
{
    return ( void * )smgr->getSceneNodeFromId ( id, NULL );
}


/* ----------------------------------------------------------------------------
get a node in the scene based upon its name and returns null is no node is found
*/
void * DLL_EXPORT IrrGetSceneNodeFromName( char * name )
{
    return ( void * )smgr->getSceneNodeFromName( name, NULL );
}


/* ----------------------------------------------------------------------------
adds a billboard group to the scene this is a collection of managed flat 3D textured sprites
*/
void * DLL_EXPORT IrrAddBillBoardGroupToScene( float sizex, float sizey, float x, float y, float z )
{
    core::vector3df position( 0.0f, 0.0f, 0.0f );
    core::vector3df rotation( 0.0f, 0.0f, 0.0f );
    core::vector3df scale( 1.0f, 1.0f, 1.0f );
	ISceneNode* node = new CBillboardGroupSceneNode( smgr->getRootSceneNode(), smgr, 666, position, rotation, scale );

	node->drop();
	return node;
}

/* ----------------------------------------------------------------------------
adds a billboard to the scene this is a flat 3D textured sprite
*/
void DLL_EXPORT IrrAddBillBoardToGroup( CBillboardGroupSceneNode *node, float sizex, float sizey, float x, float y, float z, float roll, u32 A, u32 R, u32 G, u32 B )
{
    core::vector3df position( x, y, z );
    core::dimension2df size( sizex, sizey );
    video::SColor vertexColor( A, R, G, B );

    node->addBillboard( position, size, roll, vertexColor );
}

/* ----------------------------------------------------------------------------
adds a billboard to the scene this is a flat 3D textured sprite
*/
void DLL_EXPORT IrrAddBillBoardByAxisToGroup( CBillboardGroupSceneNode *node,
                                              float sizex, float sizey,
                                              float x, float y, float z,
                                              float roll, u32 A, u32 R, u32 G, u32 B,
                                              float axis_x, float axis_y, float axis_z )
{
    core::vector3df position( x, y, z );
    core::vector3df axis( axis_x, axis_y, axis_z );
    core::dimension2df size( sizex, sizey );
    video::SColor vertexColor( A, R, G, B );

    axis.normalize();
    node->addBillboardWithAxis( position, size, axis, roll, vertexColor );
}

/* ----------------------------------------------------------------------------
adds a billboard to the scene this is a flat 3D textured sprite
*/
void DLL_EXPORT IrrRemoveBillBoardFromGroup( CBillboardGroupSceneNode *node, CBillboardGroupSceneNode::SBillboard * billboard )
{
    node->removeBillboard( billboard );
}

/* ----------------------------------------------------------------------------
adds a billboard to the scene this is a flat 3D textured sprite
*/
void DLL_EXPORT IrrBillBoardGroupShadows( CBillboardGroupSceneNode *node, float x, float y, float z, f32 intensity, f32 ambient )
{
    const core::vector3df lightDir( x, y, z );
    node->applyVertexShadows( lightDir, intensity, ambient);
}

/* ----------------------------------------------------------------------------
get the number of billboards in the billboard group
*/
u32 DLL_EXPORT IrrGetBillBoardGroupCount( CBillboardGroupSceneNode *node )
{
    return node->getBillboardCount();
}

/* ----------------------------------------------------------------------------
forces an update of the billboard system
*/
void DLL_EXPORT IrrBillBoardForceUpdate( CBillboardGroupSceneNode *node )
{
    node->forceUpdate( );
}



/* ----------------------------------------------------------------------------
adds a billboard to the scene this is a flat 3D textured sprite
*/
void * DLL_EXPORT IrrAddBillBoardToScene( float sizex, float sizey, float x, float y, float z )
{
    return (void *)smgr->addBillboardSceneNode(
            NULL,
            dimension2d<f32>( sizex, sizey ),
            vector3df(x, y, z )
    );
}

/* ----------------------------------------------------------------------------
Sets the color of a billboard
*/
void DLL_EXPORT IrrSetBillBoardColor( IBillboardSceneNode * node, unsigned int topColor, unsigned int bottomColor )
{
	node->setColor( video::SColor(topColor), video::SColor( bottomColor));
}

/* ----------------------------------------------------------------------------
Sets the size of a billboard
*/
void DLL_EXPORT IrrSetBillBoardSize( IBillboardSceneNode * node, float Width, float Height )
{
	node->setSize( core::dimension2d<f32>(Width,Height));
}


/* ----------------------------------------------------------------------------
Adds a text scene node, which uses billboards. The node, and the text on it,
will scale with distance.
*/
void * DLL_EXPORT IrrAddBillboardTextSceneNode(
		IGUIFont * font,
		const wchar_t * text,
		float sizex, float sizey,
		float x, float y, float z,
		ISceneNode * parentNode,
		SColor colorTop,
		SColor colorBottom )
{
	return (void *)smgr->addBillboardTextSceneNode (
			font,
			text,
			parentNode,		// parent
            dimension2d<f32>( sizex, sizey ),
            vector3df(x, y, z ),
			-1,		// default ID
			colorTop.color,
			colorBottom.color);
}

/* ----------------------------------------------------------------------------
add a particle system to the irrlicht scene manager
*/
void * DLL_EXPORT IrrAddParticleSystemToScene ( bool defaultemitter , ISceneNode * parent, int id, float posX, float posY, float posZ, float rotX, float rotY, float rotZ, float scaleX, float scaleY, float scaleZ)
{
	return (void *)smgr->addParticleSystemSceneNode(defaultemitter, parent, id,
                    core::vector3df(posX, posY, posZ),
                    core::vector3df(rotX, rotY, rotZ),
                    core::vector3df(scaleX, scaleY, scaleZ)
    );
}

/* ----------------------------------------------------------------------------
add a skybox to the irrlicht scene manager based on six pictures
*/
void * DLL_EXPORT IrrAddSkyBoxToScene (
                                       ITexture *texture_up,
                                       ITexture *texture_down,
                                       ITexture *texture_left,
                                       ITexture *texture_right,
                                       ITexture *texture_front,
                                       ITexture *texture_back )
{
	return (void *)smgr->addSkyBoxSceneNode(
            texture_up,
            texture_down,
            texture_left,
            texture_right,
            texture_front,
            texture_back
    );
}

/* ----------------------------------------------------------------------------
add a sky dome to the irrlicht scene manager
*/
void * DLL_EXPORT IrrAddSkyDomeToScene (
                                        ITexture *texture_file,
                                        unsigned int  horiRes,
                                        unsigned int  vertRes,
                                        double  texturePercentage,
                                        double  spherePercentage,
										double domeRadius )
{
	ISceneNode* node = new CSkyDomeColorSceneNode(texture_file, horiRes, vertRes,
		texturePercentage, spherePercentage, domeRadius, smgr->getRootSceneNode(), smgr, 666);

	node->drop();
	return node;
}

/* ----------------------------------------------------------------------------
set the color of the verticies in the skydome
*/
void DLL_EXPORT IrrSetSkyDomeColor (
        CSkyDomeColorSceneNode *dome,
        u32 horRed, u32 horGreen, u32 horBlue,
        u32 zenRed, u32 zenGreen, u32 zenBlue )
{
    u32 Red, Green, Blue;

	if ( dome )
	{
		SMeshBuffer *mesh = dome->getMeshBuffer();

		if ( mesh )
		{
			// Get number of vertices.
			u32 vertCount = mesh->getVertexCount();

			if ( vertCount != 0 )
			{
				// Get pointer to vertices.
				video::S3DVertex * vert = (video::S3DVertex *)mesh->getVertices();

				if ( vert )
				{
					u32 currvert = 0;
					f32 scale;
					video::SColor horizonColor( 255, horRed, horGreen, horBlue );
					video::SColor zenithColor( 255, zenRed, zenGreen, zenBlue );

					for ( u32 i = 0; i < dome->getHorizontalRes()+1; i++ )
					{
						for ( u32 j = 0; j < dome->getVerticalRes()+1; j++ )
						{
							if ( currvert < vertCount )
							{
//							    scale = (f32)j / (f32)dome->getVerticalRes();
							    scale = 1.0f - cos((f32)j / (f32)dome->getVerticalRes() * 1.5708f);
//							    scale = sin((f32)j / (f32)dome->getVerticalRes() * 1.5708);

							    Red = (u32)((f32)horizonColor.getRed() * scale + (f32)zenithColor.getRed() * (1 - scale ));
							    Green = (u32)((f32)horizonColor.getGreen() * scale + (f32)zenithColor.getGreen() * (1 - scale ));
							    Blue = (u32)((f32)horizonColor.getBlue() * scale + (f32)zenithColor.getBlue() * (1 - scale ));
								vert[currvert++].Color = video::SColor( 255, Red, Green, Blue );
							}
						}
					}
				}
				else
					printf( "Skydome: No vert data\n" );
			}
			else
				printf( "Skydome: No verts\n" );
		}
		else
			printf( "Skydome: No mesh\n" );
	}
	else
		printf( "Skydome: No node\n" );
}

/* ----------------------------------------------------------------------------
set the color of the verticies in the skydome
*/
void DLL_EXPORT IrrSetSkyDomeColorBand (
        CSkyDomeColorSceneNode *dome,
        u32 horRed, u32 horGreen, u32 horBlue,
		s32 position, float fade, bool addative )
{
    u32 Red, Green, Blue;

	if ( dome )
	{
		SMeshBuffer *mesh = dome->getMeshBuffer();

		if ( mesh )
		{
			// Get number of vertices.
			u32 vertCount = mesh->getVertexCount();

			if ( vertCount != 0 )
			{
				// Get pointer to vertices.
				video::S3DVertex * vert = (video::S3DVertex *)mesh->getVertices();

				if ( vert )
				{
					u32 currvert = 0;
					f32 scale, location;
					video::SColor horizonColor( 255, horRed, horGreen, horBlue );

					for ( u32 i = 0; i < dome->getHorizontalRes()+1; i++ )
					{
						for ( u32 j = 0; j < dome->getVerticalRes()+1; j++ )
						{
							if ( currvert < vertCount )
							{
//								location = fabs((((f32)j-(f32)position) / (f32)dome->getVerticalRes()) * bandScale);
								location = fabs( ((f32)j-(f32)position) / (f32)dome->getVerticalRes());
								if ( location > 1.0 ) location = 1.0;
//								scale = (1 - location) * fade;;
								scale = fabs( cos( location * 1.5708f)) * fade;
								if ( scale > 1.0 ) scale = 1.0;

								if ( addative )
								{
									Red = (u32)((f32)horizonColor.getRed() * scale + (f32)vert[currvert].Color.getRed());
									Green = (u32)((f32)horizonColor.getGreen() * scale + (f32)vert[currvert].Color.getGreen());
									Blue = (u32)((f32)horizonColor.getBlue() * scale + (f32)vert[currvert].Color.getBlue());
									if ( Red > 255 ) Red = 255;
									if ( Green > 255 ) Green = 255;
									if ( Blue > 255 ) Blue = 255;
									vert[currvert++].Color = video::SColor( 255, Red, Green, Blue );
								}
								else
								{
									Red = (u32)((f32)horizonColor.getRed() * scale + (f32)vert[currvert].Color.getRed() * (1 - scale ));
									Green = (u32)((f32)horizonColor.getGreen() * scale + (f32)vert[currvert].Color.getGreen() * (1 - scale ));
									Blue = (u32)((f32)horizonColor.getBlue() * scale + (f32)vert[currvert].Color.getBlue() * (1 - scale ));
									vert[currvert++].Color = video::SColor( 255, Red, Green, Blue );
								}
							}
						}
					}
				}
				else
					printf( "Skydome: No vert data\n" );
			}
			else
				printf( "Skydome: No verts\n" );
		}
		else
			printf( "Skydome: No mesh\n" );
	}
	else
		printf( "Skydome: No node\n" );
}

/* ----------------------------------------------------------------------------
set the color of the verticies in the skydome radiating out from a point
*/
void DLL_EXPORT IrrSetSkyDomeColorPoint (
        CSkyDomeColorSceneNode *dome,
        u32 horRed, u32 horGreen, u32 horBlue,
		f32 positionX, f32 positionY, f32 positionZ,
		f32 radius, f32 fade, bool addative )
{
    u32 Red, Green, Blue;

	if ( dome )
	{
		SMeshBuffer *mesh = dome->getMeshBuffer();

		if ( mesh )
		{
			// Get number of vertices.
			u32 vertCount = mesh->getVertexCount();

			if ( vertCount != 0 )
			{
				// Get pointer to vertices.
				video::S3DVertex * vert = (video::S3DVertex *)mesh->getVertices();

				if ( vert )
				{
					u32 currvert = 0;
					f32 scale;
					video::SColor horizonColor( 255, horRed, horGreen, horBlue );
					vector3df vectLight( positionX, positionY, positionZ);

					for ( s32 i = 0; i < (int)dome->getHorizontalRes()+1; i++ )
					{
						for ( s32 j = 0; j < (int)dome->getVerticalRes()+1; j++ )
						{
							if ( currvert < vertCount )
							{
								// get the position of the vertex
								vector3df vectVert = vert[currvert].Pos;
								vectVert -= vectLight;

								// get the distance from the light to the vertex
								f32 distance = vectVert.getLength() / radius;

								// calculate a graduated light falloff
								if ( distance > 1.0 ) distance = 1.0;
								scale = fabs( cos( distance * 1.5708f)) * fade;
								if ( scale > 1.0 ) scale = 1.0;

								if ( addative )
								{
									Red = (u32)((f32)horizonColor.getRed() * scale + (f32)vert[currvert].Color.getRed());
									Green = (u32)((f32)horizonColor.getGreen() * scale + (f32)vert[currvert].Color.getGreen());
									Blue = (u32)((f32)horizonColor.getBlue() * scale + (f32)vert[currvert].Color.getBlue());
									if ( Red > 255 ) Red = 255;
									if ( Green > 255 ) Green = 255;
									if ( Blue > 255 ) Blue = 255;
									vert[currvert++].Color = video::SColor( 255, Red, Green, Blue );
								}
								else
								{
									Red = (u32)((f32)horizonColor.getRed() * scale + (f32)vert[currvert].Color.getRed() * (1 - scale ));
									Green = (u32)((f32)horizonColor.getGreen() * scale + (f32)vert[currvert].Color.getGreen() * (1 - scale ));
									Blue = (u32)((f32)horizonColor.getBlue() * scale + (f32)vert[currvert].Color.getBlue() * (1 - scale ));
									vert[currvert++].Color = video::SColor( 255, Red, Green, Blue );
								}
							}
						}
					}
				}
				else
					printf( "Skydome: No vert data\n" );
			}
			else
				printf( "Skydome: No verts\n" );
		}
		else
			printf( "Skydome: No mesh\n" );
	}
	else
		printf( "Skydome: No node\n" );
}


/* ----------------------------------------------------------------------------
adds a LOD management node to the scene
*/
CLODSceneNode * DLL_EXPORT IrrAddLODManager( u32 fadeScale, bool useAlpha, void (*callback)(u32, ISceneNode *))
{
	CLODSceneNode* node = new CLODSceneNode( smgr->getRootSceneNode(), -1 );
	if (fadeScale > 0 ) node->fadeScale = fadeScale;
	node->useAlpha = useAlpha;
	node->callback = callback;
	return node;
}

/* ----------------------------------------------------------------------------
adds a level of detail to a LOD management node
*/
void DLL_EXPORT IrrAddLODMesh(CLODSceneNode* node, f32 distance, IAnimatedMesh * mesh )
{
	node->AddLODMesh( distance, mesh );
}

/* ----------------------------------------------------------------------------
sets material mapping for fading LOD nodes
*/
void DLL_EXPORT IrrSetLODMaterialMap(CLODSceneNode* node, E_MATERIAL_TYPE source, E_MATERIAL_TYPE target )
{
	node->SetMaterialMapping( source, target );
}

/* ----------------------------------------------------------------------------
adds a zone/distance management node to the scene
*/
CZoneSceneNode * DLL_EXPORT IrrAddZoneManager( f32 initialNearDistance, f32 initialFarDistance )
{
	CZoneSceneNode* node = new CZoneSceneNode( initialNearDistance, initialFarDistance,
                                                smgr->getRootSceneNode(), smgr, -1 );
//	node->drop();
	return node;
}

/* ----------------------------------------------------------------------------
sets the draw distances of nodes in the zone/distance management node
*/
void DLL_EXPORT IrrSetZoneManagerProperties( CZoneSceneNode* node,
                                            f32 newNearDistance,
                                            f32 newFarDistance,
                                            bool accumulateChildBoxes )
{
	node->SetDrawProperties( newNearDistance, newFarDistance, accumulateChildBoxes );
}

/* ----------------------------------------------------------------------------
sets the draw distances of nodes in the zone/distance management node
*/
void DLL_EXPORT IrrSetZoneManagerBoundingBox(
                                            CZoneSceneNode* node,
                                            f32 x, f32 y, f32 z,
                                            f32 w, f32 h, f32 d )
{
	node->SetBoundingBox( x, y, z, w, h, d );
}


/* ----------------------------------------------------------------------------
sets the draw distances of nodes in the zone/distance management node
*/
void DLL_EXPORT IrrSetZoneManagerAttachTerrain(
                                            CZoneSceneNode* node,
											CTerrainTileSceneNode * terrainSource,
											char * structureMap,
											char * colorMap,
											char * detailMap,
											s32 x, s32 y,
											s32 sliceSize )
{
	core::position2d<s32> dataPositionSource( x, y );
	node->attachTerrain ( terrainSource, structureMap, colorMap, detailMap, dataPositionSource, sliceSize );
}

/* ----------------------------------------------------------------------------
adds an empty node To the scene
*/
void * DLL_EXPORT IrrAddEmptySceneNode( void )
{
    return (void *)smgr->addEmptySceneNode( );
}

/* ----------------------------------------------------------------------------
adds a test node to the scene, the node is a simple cube
*/
void * DLL_EXPORT IrrAddTestSceneNode( void )
{
    return (void *)smgr->addCubeSceneNode();
}

/* ----------------------------------------------------------------------------
adds a simple cube node to the scene
*/
void * DLL_EXPORT IrrAddCubeSceneNode( float size )
{
    return (void *)smgr->addCubeSceneNode( size );
}

/* ----------------------------------------------------------------------------
adds a simple sphere node to the scene
*/
void * DLL_EXPORT IrrAddSphereSceneNode( float radius, int polyCount )
{
    return (void *)smgr->addSphereSceneNode( radius, polyCount );
}

/* ----------------------------------------------------------------------------
adds a simple sphere node to the scene
*/
IAnimatedMesh * DLL_EXPORT IrrAddSphereSceneMesh( const char *name, float radius, int polyCount )
{
    return smgr->addSphereMesh( name, radius, polyCount, polyCount );
}

/* ----------------------------------------------------------------------------
adds a scene node for rendering an animated water surface mesh
*/
void * DLL_EXPORT IrrAddWaterSurfaceSceneNode( IAnimatedMesh* mesh, float waveHeight, float waveSpeed, float waveLength, ISceneNode *  parent, int id, float positionX, float positionY, float positionZ, float rotationX, float rotationY, float rotationZ, float scaleX, float scaleY, float scaleZ)
{
    scene::ISceneNode* node = smgr->addWaterSurfaceSceneNode(
                    mesh->getMesh(0),
                    waveHeight,
                    waveSpeed,
                    waveLength,
                    parent,
                    id,
                    core::vector3df(positionX, positionY, positionZ),
                    core::vector3df(rotationX, rotationY, rotationZ),
                    core::vector3df(scaleX, scaleY, scaleZ)
    );
    return (void *) node;
}


/* ----------------------------------------------------------------------------
adds a set of clouds to the scene
*/
ISceneNode * DLL_EXPORT IrrAddClouds( ITexture * txture, u32 lod, u32 depth, u32 density )
{
    // create a cloud node
    scene::CCloudSceneNode* clouds = new scene::CCloudSceneNode(
            smgr->getRootSceneNode(), smgr,
                device->getTimer(), -1, core::vector3df(0,0,0), core::vector3df(0,0,0), core::vector3df(1,1,1));

    // set the level of details to draw at what distance
    clouds->setLOD((f32)lod);

    // set the maximum detail level when recursing
    clouds->setMaxDepth(depth);

    // call a "here's one I made earlier" function
    clouds->makeRandomCloud(density);

 //   clouds->setLOD(1.0f);

    // for some reason ISceneNode material properties cannot be called from here
    clouds->setMaterialTexture(0,txture);
    clouds->getMaterial(0).Lighting = false;
    clouds->getMaterial(0).MaterialType = video::EMT_TRANSPARENT_ALPHA_CHANNEL;

    return clouds;
}


/* ----------------------------------------------------------------------------
Adds a lens flare patch object to the scene based on the supplied parameters
*/
CLensFlareSceneNode * DLL_EXPORT IrrAddLensFlare( ITexture * txture )
{
    CLensFlareSceneNode* flare = new CLensFlareSceneNode(smgr->getRootSceneNode(),smgr,-1, core::vector3df(300,100,1000));

    // set the texture used for the lens flare effect
    flare->setMaterialTexture(0, txture);

    return flare;
}


/* ----------------------------------------------------------------------------
Adds a grass object to the scene
*/
CGrassPatchSceneNode * DLL_EXPORT IrrAddGrass(
                                    scene::ITerrainSceneNode* terrain,
                                    s32 x,
                                    s32 z,
                                    s32 patchSize,
                                    f32 fadeDistance ,
									bool crossed,
                                    f32 grassScale,
									u32 maxDensity,
									u32 dataPositionX,
									u32 dataPositionY,
                                    video::IImage* heightMap,
                                    video::IImage* textureMap,
                                    video::IImage* grassMap,
                                    video::ITexture *grassTexture )
{
    scene::IWindGenerator *wind;
    scene::CGrassPatchSceneNode *grass;

    wind = scene::createWindGenerator( 30.0f, 3.0f );

	core::position2d<s32> dataPosition( dataPositionX, dataPositionY );

	grass = new scene::CGrassPatchSceneNode(
            terrain,
            smgr,
            -1,
            core::vector3d<s32>(x,0,z),
            patchSize,
            grassScale,
			maxDensity,
			dataPosition,
            "grass",
            heightMap,
            textureMap,
            grassMap,
            wind,
			crossed );

    grass->setFadeDistance( fadeDistance );

    grass->setMaterialFlag(video::EMF_LIGHTING,false);
    grass->setMaterialType(video::EMT_TRANSPARENT_ALPHA_CHANNEL);
    grass->setMaterialTexture(0,grassTexture);

    return grass;
}


/* ----------------------------------------------------------------------------
Set grass density
*/
void DLL_EXPORT IrrSetGrassDensity( CGrassPatchSceneNode * grass, int density, float distance )
{
    grass->setMaxDensity( density );
    grass->setDrawDistance( distance );
}


/* ----------------------------------------------------------------------------
Adds a grass object to the scene
*/
void DLL_EXPORT IrrSetGrassWind( CGrassPatchSceneNode * grass, float strength, float res )
{
    grass->getWind()->setStrength( strength );
    grass->getWind()->setRegularity( res );
}


/* ----------------------------------------------------------------------------
get the number of grass objects drawn
*/
u32 DLL_EXPORT IrrGetGrassDrawCount( CGrassPatchSceneNode * grass )
{
    return grass->getLastDrawCount();
}


/* ----------------------------------------------------------------------------
Sets the scale of optics in the scene
*/
void DLL_EXPORT IrrSetFlareScale( CLensFlareSceneNode * flare, float source, float optics )
{
    flare->setOpticsScale( source, optics );
}


/* ----------------------------------------------------------------------------
add a bolt node to the scene
*/
irr::scene::CBoltSceneNode * DLL_EXPORT IrrAddBoltSceneNode( void )
{
	irr::scene::CBoltSceneNode* beam = new irr::scene::CBoltSceneNode(
			smgr->getRootSceneNode(),
			smgr,
			-1 );
   beam->drop();

    return beam;
}

/* ----------------------------------------------------------------------------
set the properties of a bolt node in the scene
*/
void DLL_EXPORT IrrSetBoltProperties( irr::scene::CBoltSceneNode* beam,
							    f32 sx, f32 sy, f32 sz,
								f32 ex, f32 ey, f32 ez,
								u32 updateTime,
								u32 height,
								f32 thickness,
								u32 parts,
								u32 bolts,
								bool steddyend,
								video::SColor color )
{
   beam->setLine(irr::core::vector3df(sx,sy,sz), irr::core::vector3df(ex,ey,ez), updateTime, height, parts, bolts, steddyend, thickness, color );
}

/* ----------------------------------------------------------------------------
add a beam node to the scene
*/
scene::CBeamSceneNode * DLL_EXPORT IrrAddBeamSceneNode()
{
	scene::CBeamSceneNode *bolt = new scene::CBeamSceneNode(
			smgr->getRootSceneNode(),
			smgr,
			666,
			core::vector3df(50,0,0),
			core::vector3df(0,20,300),
			10);
	bolt->drop();

	return bolt;
}

/* ----------------------------------------------------------------------------
set the size of a beam
*/
void DLL_EXPORT IrrSetBeamSize( scene::CBeamSceneNode* beam, f32 size )
{
   beam->setSize( size );
}

/* ----------------------------------------------------------------------------
set the position of a beam
*/
void DLL_EXPORT IrrSetBeamPosition( scene::CBeamSceneNode* beam,
									f32 sx, f32 sy, f32 sz,
									f32 ex, f32 ey, f32 ez )
{
   beam->setPosition( core::vector3df( sx,sy,sz ), core::vector3df( ex,ey,ez ));
}


/* ////////////////////////////////////////////////////////////////////////////
SCENE EFFECTS
*/

/* ----------------------------------------------------------------------------
set the color of shadows in the scene
*/
void DLL_EXPORT IrrSetShadowColor( int alpha, int R, int G, int B )
{
	// set shadow color
	smgr->setShadowColor(video::SColor(alpha,R,G,B));
}

/* ----------------------------------------------------------------------------
set the scene fog
*/
void DLL_EXPORT IrrSetFog( int R, int G, int B, bool fogtype, float start, float end, float density )
{
    driver->setFog( SColor(0, R, G, B), fogtype?EFT_FOG_LINEAR:EFT_FOG_EXP, start, end, density );
}

/* ----------------------------------------------------------------------------
draw a 3D line into the display
*/
void DLL_EXPORT IrrDraw3DLine( float xStart, float yStart, float zStart, float xEnd, float yEnd, float zEnd, unsigned int R, unsigned int G, unsigned int B )
{
    // this node has no geometry only debug visuals
    video::SMaterial m;
    m.Lighting = false;
    driver->setMaterial(m);
    driver->setTransform(video::ETS_WORLD, core::matrix4());

    driver->draw3DLine( vector3df( xStart, yStart, zStart ), vector3df( xEnd, yEnd, zEnd ), SColor( 0, R, G, B));
}



/* ////////////////////////////////////////////////////////////////////////////
all of the above functions are declared as C functions and are exposed without
any mangled names
*/
}
