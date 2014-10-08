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
SCENE NODE FUNCTIONS
*/

/* ----------------------------------------------------------------------------
get the parent of this node, returns 0 if there is no parent
*/
ISceneNode* DLL_EXPORT IrrGetNodeParent( ISceneNode* node )
{
    return node->getParent();
}

/* ----------------------------------------------------------------------------
set the parent of this node, returns 0 if there is no parent
*/
void DLL_EXPORT IrrSetNodeParent( ISceneNode* node, ISceneNode *parent )
{
    node->setParent( parent );
}

/* ----------------------------------------------------------------------------
get the first child node of this node, returns 0 if there is no child
*/
ISceneNode* DLL_EXPORT IrrGetNodeFirstChild( ISceneNode* node,
                                             core::list<ISceneNode*>::ConstIterator *it )
{
    const core::list<ISceneNode*>& children = node->getChildren();
    *it = children.begin();
    return **it;
}

/* ----------------------------------------------------------------------------
get the next child node of this node, returns 0 if there is no child
*/
ISceneNode* DLL_EXPORT IrrGetNodeNextChild( ISceneNode* node,
                                            core::list<ISceneNode*>::ConstIterator *it )
{
    const core::list<ISceneNode*>& children = node->getChildren();
    if (*it != children.end())
        return *(*it)++;
    else
        return NULL;
//    return **it;
}

/* ----------------------------------------------------------------------------
returns true if this is the last child of the parent
*/
bool DLL_EXPORT IrrIsNodeLastChild( ISceneNode* node,
                                    core::list<ISceneNode*>::ConstIterator *it )
{
    const core::list<ISceneNode*>& children = node->getChildren();
    return ( *it == children.end());
}

/* ----------------------------------------------------------------------------
get the ID of this node
*/
int DLL_EXPORT IrrGetNodeID( ISceneNode* node )
{
    return node->getID();
}

/* ----------------------------------------------------------------------------
set the ID of this node
*/
void DLL_EXPORT IrrSetNodeID( ISceneNode* node, int id )
{
    node->setID(id);
}

/* ----------------------------------------------------------------------------
get the name of this node
*/
const c8 * DLL_EXPORT IrrGetNodeName( ISceneNode* node )
{
    return node->getName();
}

/* ----------------------------------------------------------------------------
set the name of this node
*/
void DLL_EXPORT IrrSetNodeName( ISceneNode* node, const c8 * name )
{
    node->setName(name);
}

/* ----------------------------------------------------------------------------
render debugging information for nodes to the display
*/
void DLL_EXPORT IrrDebugDataVisible( ISceneNode* node, s32 visible )
{
    node->setDebugDataVisible( visible );
}

/* ----------------------------------------------------------------------------
Get the number of materials associated with the node
*/
unsigned int DLL_EXPORT IrrGetMaterialCount( ISceneNode* node )
{
	return node->getMaterialCount();
}

/* ----------------------------------------------------------------------------
Get the material associated with the node at the particular index
*/
SMaterial * DLL_EXPORT IrrGetMaterial( ISceneNode* node, unsigned int index )
{
	return &node->getMaterial( index );
}

/* ----------------------------------------------------------------------------
apply a material to a scene node
*/
void DLL_EXPORT IrrSetNodeMaterialTexture ( ISceneNode* node, ITexture *texture, int iIndex )
{
    // apply a texture to the model
    node->setMaterialTexture( iIndex, texture );
}

/* ----------------------------------------------------------------------------
set the material of a node
*/
#define MAX_MAT_FLAGS 17
void DLL_EXPORT IrrSetNodeMaterialFlag( void *vptrNode, unsigned int uiFlag, bool boValue )
{
    E_MATERIAL_FLAG emfFlagTable[] = {
            EMF_WIREFRAME,
            EMF_POINTCLOUD,
            EMF_GOURAUD_SHADING,
            EMF_LIGHTING,
            EMF_ZBUFFER,

            EMF_ZWRITE_ENABLE,
            EMF_BACK_FACE_CULLING,
            EMF_FRONT_FACE_CULLING,
            EMF_BILINEAR_FILTER,
            EMF_TRILINEAR_FILTER,

            EMF_ANISOTROPIC_FILTER,
            EMF_FOG_ENABLE,
            EMF_NORMALIZE_NORMALS,
	        EMF_TEXTURE_WRAP,
	        EMF_ANTI_ALIASING,

	        EMF_COLOR_MASK,
	        EMF_COLOR_MATERIAL
    };


    // if a valid flag is selected
    if ( uiFlag < MAX_MAT_FLAGS )
    {
        // change the flags property on this node
        ((ISceneNode*)vptrNode)->setMaterialFlag(
                emfFlagTable[uiFlag], boValue );
    }
}

/* ----------------------------------------------------------------------------
set the way the materials applied to the node are rendered
*/
void DLL_EXPORT IrrSetNodeMaterialType( ISceneNode* node, unsigned int uiType )
{
	/* set the material type directly this may be a preset material type of one
	 * created with a shader program */
	node->setMaterialType(( E_MATERIAL_TYPE)uiType);
}

/* ----------------------------------------------------------------------------
reposition a node
*/
void DLL_EXPORT IrrSetNodePosition ( IAnimatedMeshSceneNode* node, float X, float Y,  float Z )
{
    // reposition the model
    node->setPosition  ( vector3df(X,Y,Z));
}

/* ----------------------------------------------------------------------------
rotate a node
*/
void DLL_EXPORT IrrSetNodeRotation ( IAnimatedMeshSceneNode* node, float iX, float iY, float iZ )
{
    // reposition the model
    node->setRotation (vector3df(iX,iY,iZ));
}

/* ----------------------------------------------------------------------------
scale a node
*/
void DLL_EXPORT IrrSetNodeScale ( IAnimatedMeshSceneNode* node, float fX, float fY, float fZ )
{
    // reposition the model
    node->setScale (vector3df(fX,fY,fZ));
}


/* ----------------------------------------------------------------------------
get the position of the node in the scene
*/
void DLL_EXPORT IrrGetNodePosition ( IAnimatedMeshSceneNode* node, float &X, float &Y,  float &Z )
{
    // get the model position the model
    vector3df vect;
    vect = node->getPosition();
    X = vect.X;
    Y = vect.Y;
    Z = vect.Z;
}

/* ----------------------------------------------------------------------------
get the position of the node in the scene
*/
void DLL_EXPORT IrrGetNodeAbsolutePosition ( IAnimatedMeshSceneNode* node, float &X, float &Y,  float &Z )
{
    // get the model position the model
    vector3df vect;
    vect = node->getAbsolutePosition();
    X = vect.X;
    Y = vect.Y;
    Z = vect.Z;
}


/* ----------------------------------------------------------------------------
get the rotation of the specified node
*/
void DLL_EXPORT IrrGetNodeRotation ( IAnimatedMeshSceneNode* node, float &X, float &Y,  float &Z )
{
    // get the rotation of a node
    vector3df vect;
    vect = node->getRotation();
    X = vect.X;
    Y = vect.Y;
    Z = vect.Z;
}


/* ----------------------------------------------------------------------------
scale a node
*/
void DLL_EXPORT IrrGetNodeScale ( IAnimatedMeshSceneNode* node, float &fX, float &fY, float &fZ )
{
    // get the scale of the node
    vector3df vect;
    vect = node->getScale();
    fX = vect.X;
    fY = vect.Y;
    fZ = vect.Z;
}


/* ----------------------------------------------------------------------------
get a node that represents the position of a joint in a skeleton
*/
ISceneNode *DLL_EXPORT IrrGetJointNode ( IAnimatedMeshSceneNode* node, char *node_name )
{
    return node->getJointNode( node_name );
}

/* ----------------------------------------------------------------------------
get a node that represents the position of a joint in a Milkshape skeleton
(note this call was made redundant by Irrlicht 1.4 please use IrrGetJointNode)
*/
ISceneNode *DLL_EXPORT IrrGetMS3DJointNode ( IAnimatedMeshSceneNode* node, char *node_name )
{
    return node->getMS3DJointNode( node_name );
}

/* ----------------------------------------------------------------------------
get a node that represents the position of a joint in a Direct X skeleton
(note this call was made redundant by Irrlicht 1.4 please use IrrGetJointNode)
*/
ISceneNode *DLL_EXPORT IrrGetDirectXJointNode ( IAnimatedMeshSceneNode* node, char *node_name )
{
    return node->getXJointNode( node_name );
}

/* ----------------------------------------------------------------------------
adds a node to another node as a child to a parent
*/
void DLL_EXPORT IrrAddChildToParent ( ISceneNode *child, ISceneNode *parent )
{
    parent->addChild(child);
}

/* ----------------------------------------------------------------------------
add a stencil shadow to an node
*/
void DLL_EXPORT IrrAddNodeShadow( IAnimatedMeshSceneNode* node, IAnimatedMesh* mesh )
{
    // reposition the model
	// add shadow
	node->addShadowVolumeSceneNode( mesh );
}

/* ----------------------------------------------------------------------------
set whether a node is visible or not
*/
void DLL_EXPORT IrrSetNodeVisibility( ISceneNode* node, bool visible )
{
    // set the speed of playback in the animation
    node->setVisible( visible );
}

/* ----------------------------------------------------------------------------
delete this node from the scene
*/
void DLL_EXPORT IrrRemoveNode ( IAnimatedMeshSceneNode* node )
{
    // delete the node from the scene
    node->remove();
}

/* ----------------------------------------------------------------------------
clears the entire scene, any references to nodes in the scene will become invalid
*/
void DLL_EXPORT IrrRemoveAllNodes ( void )
{
    // delete all nodes from the scene
    smgr->clear();
}

/* ----------------------------------------------------------------------------
Get the bounding box values of a node
*/
void DLL_EXPORT IrrGetNodeBoundingBox (
										void *vptrNode,
										f32 &minx,
										f32 &miny,
										f32 &minz,
										f32 &maxx,
										f32 &maxy,
										f32 &maxz )
{
	aabbox3d<f32> curbox = ((ISceneNode*)vptrNode)->getBoundingBox();
	minx = curbox.MinEdge.X;
	miny = curbox.MinEdge.Y;
	minz = curbox.MinEdge.Z;
	maxx = curbox.MaxEdge.X;
	maxy = curbox.MaxEdge.Y;
	maxz = curbox.MaxEdge.Z;
}

/* ----------------------------------------------------------------------------
Gets the transformed (absolute value) bounding box of a node.
*/
void DLL_EXPORT IrrGetNodeTransformedBoundingBox (
                                                    void *vptrNode,
                                                    f32 &minx,
                                                    f32 &miny,
                                                    f32 &minz,
                                                    f32 &maxx,
                                                    f32 &maxy,
                                                    f32 &maxz )
{
    aabbox3d<f32> curbox = ((ISceneNode*)vptrNode)->getTransformedBoundingBox();
    minx = curbox.MinEdge.X;
    miny = curbox.MinEdge.Y;
    minz = curbox.MinEdge.Z;
    maxx = curbox.MaxEdge.X;
    maxy = curbox.MaxEdge.Y;
    maxz = curbox.MaxEdge.Z;
}

/* ----------------------------------------------------------------------------
Gets the node's mesh.
*/
IAnimatedMesh* DLL_EXPORT IrrGetNodeMesh( ISceneNode* node)
{
	return (reinterpret_cast<IAnimatedMeshSceneNode*>(node))->getMesh();
}

/* ----------------------------------------------------------------------------
Gets the node's mesh.
*/
void DLL_EXPORT IrrSetNodeMesh( IAnimatedMeshSceneNode* node, IAnimatedMesh* mesh)
{
	node->setMesh( mesh );
}


/* ----------------------------------------------------------------------------
revolve the node using matricies, many thanks to the postings of Chev and Arras
in the forums for the development of this function
*/
void DLL_EXPORT IrrSetNodeRotationPositionChange (
		ISceneNode* node,
		float yaw, float pitch, float roll,
		float drive, float strafe, float elevate,
		IRR_VECTOR *forwardStore,
		IRR_VECTOR *upStore,
		unsigned int numOffsets,
		IRR_VECTOR *offsetStore )
{
	// place the rotations to be applied
	vector3df rPlus( yaw, pitch, roll );

	// get rotation of the node
	vector3df rot = node->getRotation();

	// create a clean matrix from the nodes current rotation
	matrix4 currentmat;
	currentmat.setRotationDegrees(rot);

	// create a clean matrix from our desired rotation
	matrix4 relmat;
	relmat.setRotationDegrees(rPlus);

	// multiply the matrices to apply the relative rotation (relative matrix must be the 2nd term)
	matrix4 resmat;
	resmat=currentmat*relmat;

	// get rotation of our final matrix
	vector3df newrot=resmat.getRotationDegrees();

	// apply our new rotation to the node
	node->setRotation(newrot);

	// apply positional forces to the node
	vector3df velocity( drive, elevate, strafe );

	// transform the forces to the same orientation as the node
    resmat.transformVect( velocity );
    node->setPosition( node->getPosition() + velocity );
    node->updateAbsolutePosition();

	// if the caller wants to know any of the direction vectors of the node
	if ( forwardStore )
	{
		vector3df forward(0.0f, 0.0f, 1.0f);
		resmat.transformVect(forward);
		forwardStore->x = forward.X;
		forwardStore->y = forward.Y;
		forwardStore->z = forward.Z;
	}

	if ( upStore )
	{
		vector3df up(0.0f, 1.0f, 0.0f);
		resmat.transformVect(up);
		upStore->x = up.X;
		upStore->y = up.Y;
		upStore->z = up.Z;
	}

	if (( numOffsets > 0 ) && ( offsetStore ))
	{
	    while ( numOffsets-- > 0 )
	    {
            vector3df offset( offsetStore[numOffsets].x, offsetStore[numOffsets].y, offsetStore[numOffsets].z);
            resmat.transformVect(offset);
            offsetStore[numOffsets].x = offset.X;
            offsetStore[numOffsets].y = offset.Y;
            offsetStore[numOffsets].z = offset.Z;
	    }
	}
}

/* ////////////////////////////////////////////////////////////////////////////
all of the above functions are declared as C functions and are exposed without
any mangled names
*/
}
