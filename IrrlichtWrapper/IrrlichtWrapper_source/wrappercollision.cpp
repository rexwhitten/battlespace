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
COLLISION FUNCTIONS
*/

/* ----------------------------------------------------------------------------
create a triangle selector from all triangles in a mesh
*/
void * DLL_EXPORT IrrGetCollisionGroupFromMesh( IAnimatedMesh* mesh, ISceneNode* node, int iframe )
{
    scene::ITriangleSelector* selector;
	if ( mesh )
	{
		selector =
				smgr->createTriangleSelector( mesh->getMesh(iframe), node);
		node->setTriangleSelector(selector);
		selector->drop();
	}
	return selector;
}

/* ----------------------------------------------------------------------------
creates a collision selector from a complex node like a map
*/
void * DLL_EXPORT IrrGetCollisionGroupFromComplexMesh( IAnimatedMesh* mesh, ISceneNode* node, int iframe )
{
    ITriangleSelector* selector = smgr->createOctreeTriangleSelector(
            mesh->getMesh(iframe), node, 128);
    node->setTriangleSelector(selector);
    selector->drop();

    return (void *)selector;
}

/* ----------------------------------------------------------------------------
creates a collision selector from triangles in a nodes bounding box
*/
void * DLL_EXPORT IrrGetCollisionGroupFromBox( ISceneNode *  node )
{
    ITriangleSelector* selector = smgr->createTriangleSelectorFromBoundingBox( node );
    node->setTriangleSelector(selector);
    selector->drop();
    return (void *)selector;
}

/* ----------------------------------------------------------------------------
creates a collision selector from a terrain node
*/
void * DLL_EXPORT IrrGetCollisionGroupFromTerrain( ITerrainSceneNode *  node, int level_of_detail )
{
    return ( void *)smgr->createTerrainTriangleSelector( node, level_of_detail );
}

/* ----------------------------------------------------------------------------
removes the collision group
*/
void IrrRemoveCollisionGroup( ITriangleSelector* selector, ISceneNode * node )
{
    if ( node ) node->setTriangleSelector( NULL );
	selector->drop();
}


/* ----------------------------------------------------------------------------
attach a triangle selector to a node. recommended by agamemnus
*/
void DLL_EXPORT IrrSetNodeTriangleSelector( ISceneNode * node, ITriangleSelector * selector )
{
    node->setTriangleSelector(selector);
}

/* ----------------------------------------------------------------------------
creates a meta-selector that is a group of selector objects
*/
void * DLL_EXPORT IrrCreateCombinedCollisionGroup( void )
{
    return (void *)smgr->createMetaTriangleSelector();
}

/* ----------------------------------------------------------------------------
creates a meta-selector that is a group of selector objects
*/
void DLL_EXPORT IrrAddCollisionGroupToCombination( IMetaTriangleSelector *ms, ITriangleSelector *ts )
{
    ms->addTriangleSelector( ts );
}

/* ----------------------------------------------------------------------------
remove all triangle selectors from the meta selector
*/
void DLL_EXPORT IrrRemoveAllCollisionGroupsFromCombination( IMetaTriangleSelector *ms )
{
    ms->removeAllTriangleSelectors();
}

/* ----------------------------------------------------------------------------
remove a triangle selector from the meta selector group
*/
void DLL_EXPORT IrrRemoveCollisionGroupFromCombination( IMetaTriangleSelector *ms, ITriangleSelector *ts )
{
    ms->removeTriangleSelector( ts );
}

/* ----------------------------------------------------------------------------
create a triangle selector from all triangles in a mesh
*/
void DLL_EXPORT IrrAttachCollisionGroupToNode( scene::ITriangleSelector* selector, ISceneNode* node )
{
	node->setTriangleSelector(selector);
}


/* ----------------------------------------------------------------------------
detect the collision point of a ray in the scene with a collision object if a
collision was detected 1 is returned and vector collision contains the
co-ordinates of the point of collision
*/
int DLL_EXPORT IrrGetCollisionPoint(
                                    IRR_VECTOR &vectorStart,
                                    IRR_VECTOR &vectorEnd,
                                    ITriangleSelector *ts,
                                    IRR_VECTOR &vectorCollision )
{
    line3d< f32 > ray(  vectorStart.x, vectorStart.y, vectorStart.z,
                        vectorEnd.x, vectorEnd.y, vectorEnd.z );
    vector3df collideVect;
    triangle3df collideTri;
    int collided;
    const ISceneNode *collideNode;

    if ( collided = smgr->getSceneCollisionManager()->getCollisionPoint(
        ray, ts, collideVect, collideTri, collideNode ))
    {
        vectorCollision.x = collideVect.X;
        vectorCollision.y = collideVect.Y;
        vectorCollision.z = collideVect.Z;
    }
    return collided;
}

/* ----------------------------------------------------------------------------
get a ray that goes from the specified camera and through the screen coordinates
the information is coppied into the supplied start and end vectors
*/
void DLL_EXPORT IrrGetRayFromScreenCoordinates(
                                    int x,
                                    int y,
                                    ICameraSceneNode *camera,
                                    IRR_VECTOR &vectorStart,
                                    IRR_VECTOR &vectorEnd )
{
    line3d< f32 > ray;
    position2d< s32 > position( x, y );

    ray = smgr->getSceneCollisionManager()->getRayFromScreenCoordinates(
            position, camera );

    vectorStart.x = ray.start.X;
    vectorStart.y = ray.start.Y;
    vectorStart.z = ray.start.Z;

    vectorEnd.x = ray.end.X;
    vectorEnd.y = ray.end.Y;
    vectorEnd.z = ray.end.Z;
}

/* ----------------------------------------------------------------------------
a ray is cast through the camera and the nearest node that is hit by the ray is
returned. if no node is hit zero is returned for the object
*/
void *DLL_EXPORT IrrGetCollisionNodeFromCamera( ICameraSceneNode *camera )
{
    return (void *)smgr->getSceneCollisionManager()->getSceneNodeFromCameraBB( camera );
}

/* ----------------------------------------------------------------------------
a ray is cast through the supplied coordinates and the nearest node that is hit
by the ray is returned. if no node is hit zero is returned for the object
*/
void *DLL_EXPORT IrrGetCollisionNodeFromRay(
                                    IRR_VECTOR &vectorStart,
                                    IRR_VECTOR &vectorEnd )
{
    line3d< f32 > ray(  vectorStart.x, vectorStart.y, vectorStart.z,
                        vectorEnd.x, vectorEnd.y, vectorEnd.z );
    return (void *)smgr->getSceneCollisionManager()->getSceneNodeFromRayBB( ray );
}

/* ----------------------------------------------------------------------------
a ray is cast through the screen at the specified co-ordinates and the nearest
node that is hit by the ray is returned. if no node is hit zero is returned for
the object
*/
void * DLL_EXPORT IrrGetCollisionNodeFromScreenCoordinates( int x, int y )
{
    position2d< s32 > position( x, y );

    return (void *)smgr->getSceneCollisionManager()->
            getSceneNodeFromScreenCoordinatesBB( position );
}

/* ----------------------------------------------------------------------------
screen co-ordinates are returned for the position of the specified 3d
co-ordinates if an object were drawn at them on the screen, this is ideal for
drawing 2D bitmaps or text around or on your 3D object on the screen
*/
void DLL_EXPORT IrrGetScreenCoordinatesFrom3DPosition(
                                    int *x,
                                    int *y,
                                    IRR_VECTOR vect )
{
    vector3df pos( vect.x, vect.y, vect.z );
    position2d< s32 > position = smgr->getSceneCollisionManager()->
            getScreenCoordinatesFrom3DPosition( pos );
    *x = position.X;
    *y = position.Y;
}

/* ----------------------------------------------------------------------------
The following functions are required for IrrSetupIrrSceneCollision
*/

void ISceneNode_assignTriangleSelector(scene::ISceneNode* node, scene::ISceneManager* smgr, io::IFileSystem* ifs)
{
  if (!node || !smgr || !ifs)
    return;

  if (node->getType() == scene::ESNT_OCTREE)
  {
    io::IAttributes* attribs = ifs->createEmptyAttributes();
    if (attribs)
    {
      node->serializeAttributes(attribs);

      // get the mesh name out
      core::stringc name = attribs->getAttributeAsString("Mesh");

      attribs->drop();

      // get the animated mesh for the object
      scene::IAnimatedMesh* mesh = smgr->getMesh(name.c_str());
      if (mesh)
      {
        scene::ITriangleSelector* selector =
          smgr->createOctreeTriangleSelector(mesh->getMesh(0), node, 128);
        node->setTriangleSelector(selector);
        selector->drop();
      }
    }
  }
  else if (node->getType() == scene::ESNT_MESH)
  {
    scene::IMeshSceneNode* msn = (scene::IMeshSceneNode*)node;

    if (msn->getMesh())
    {
      scene::ITriangleSelector* selector =
        smgr->createTriangleSelector(msn->getMesh(), msn);
      msn->setTriangleSelector(selector);
      selector->drop();
    }
  }
  else if (node->getType() == scene::ESNT_ANIMATED_MESH)
  {
    scene::IAnimatedMeshSceneNode* msn = (scene::IAnimatedMeshSceneNode*)node;

    scene::IAnimatedMesh* am = msn->getMesh();
    if (am)
    {
      scene::ITriangleSelector* selector =
        smgr->createTriangleSelector(am->getMesh(0), msn);
      msn->setTriangleSelector(selector);
      selector->drop();
    }
  }
  else if (node->getType() == scene::ESNT_TERRAIN)
  {
    scene::ITerrainSceneNode* tsn = (scene::ITerrainSceneNode*)node;

    scene::ITriangleSelector* selector =
      smgr->createTerrainTriangleSelector(tsn, 0); // probably don't want lod 0 all the time...
    tsn->setTriangleSelector(selector);
    selector->drop();
  }
  else if (node->getType() == scene::ESNT_CUBE)
  {
    scene::ITriangleSelector* selector =
      smgr->createTriangleSelectorFromBoundingBox(node);
    node->setTriangleSelector(selector);
    selector->drop();
  }
  else
  {
    // not something we want to collide with
  }
}


void ISceneNode_assignTriangleSelectors(scene::ISceneNode* node, scene::ISceneManager* smgr, io::IFileSystem* ifs)
{
  // assign a selector for this node
  ISceneNode_assignTriangleSelector(node, smgr, ifs);

  // now recurse on children...
  core::list<scene::ISceneNode*>::ConstIterator begin = node->getChildren().begin();
  core::list<scene::ISceneNode*>::ConstIterator end   = node->getChildren().end();

  for (/**/; begin != end; ++begin)
    ISceneNode_assignTriangleSelectors(*begin, smgr, ifs);
}

void ISceneManager_assignTriangleSelectors(scene::ISceneManager* smgr, io::IFileSystem* ifs)
{
  ISceneNode_assignTriangleSelectors(smgr->getRootSceneNode(), smgr, ifs);
}

void ISceneNode_gatherTriangleSelectors(scene::ISceneNode* node, scene::IMetaTriangleSelector* meta)
{
  scene::ITriangleSelector* selector = node->getTriangleSelector();
  if (selector)
    meta->addTriangleSelector(selector);

  // now recurse on children...
  core::list<scene::ISceneNode*>::ConstIterator begin = node->getChildren().begin();
  core::list<scene::ISceneNode*>::ConstIterator end   = node->getChildren().end();

  for (/**/; begin != end; ++begin)
    ISceneNode_gatherTriangleSelectors(*begin, meta);
}

void ISceneManager_gatherTriangleSelectors(scene::ISceneManager* smgr, scene::IMetaTriangleSelector* meta)
{
  ISceneNode_gatherTriangleSelectors(smgr->getRootSceneNode(), meta);
}


/* ----------------------------------------------------------------------------
create generic scene collision for an irr scene
*/
void DLL_EXPORT IrrSetupIrrSceneCollision( ICameraSceneNode *camera )
{
  // recursively assign selectors to nodes

  ISceneManager_assignTriangleSelectors(smgr, device->getFileSystem());

  // recursively gather triangle selectors into a meta selector

  scene::IMetaTriangleSelector* meta = smgr->createMetaTriangleSelector();
  ISceneManager_gatherTriangleSelectors(smgr, meta);

  // create collision response using all objects for collision detection

  scene::ISceneNodeAnimator* anim =
    smgr->createCollisionResponseAnimator(meta, camera, core::vector3df(3,3,3), core::vector3df(0,-1,0), core::vector3df(0,6,0));
    camera->addAnimator(anim);
  anim->drop();

  // drop the meta selector. it is owned by the animator
  meta->drop();
}


// Support function for finding collided nodes using a subset of nodes in the scene
// recursive method for going through all scene nodes
void getNodeRayBB(ISceneNode* root,
               const core::line3df& ray,
               s32 bits,
               bool recurse,
               f32& outbestdistance,
               ISceneNode*& outbestnode)
{
    core::vector3df edges[8];

    const core::list<ISceneNode*>& children = root->getChildren();

    core::list<ISceneNode*>::ConstIterator it = children.begin();
    for (; it != children.end(); ++it)
    {
        ISceneNode* current = *it;

        if (current->isVisible() &&
//        (bNoDebugObjects ? !current->isDebugObject() : true) &&
        (bits==0 || (bits != 0 && (current->getID() & bits))))
        {
            // get world to object space transform
            core::matrix4 mat;
            if (!current->getAbsoluteTransformation().getInverse(mat))
                continue;

            // transform vector from world space to object space
            core::line3df line(ray);
            mat.transformVect(line.start);
            mat.transformVect(line.end);

            const core::aabbox3df& box = current->getBoundingBox();

            // do intersection test in object space
            if (box.intersectsWithLine(line))
            {
                box.getEdges(edges);
                f32 distance = 0.0f;

                for (s32 e=0; e<8; ++e)
                {
                    f32 t = edges[e].getDistanceFromSQ(line.start);
                    if (t > distance)
                        distance = t;
                }

                if (distance < outbestdistance)
                {
                    outbestnode = current;
                    outbestdistance = distance;
                }
            }
        }

        if ( recurse )
            getNodeRayBB(current, ray, bits, recurse, outbestdistance, outbestnode);
    }
}


// Support function for finding collided nodes using a subset of nodes in the scene
// recursive method for going through all scene nodes and testing them against a point
bool getNodePointBB(ISceneNode* root,
                    vector3df point,
                    s32 bits,
                    bool recurse,
                    ISceneNode*& outbestnode)
{
    core::vector3df edges[8];

    const core::list<ISceneNode*>& children = root->getChildren();

    core::list<ISceneNode*>::ConstIterator it = children.begin();
    for (; it != children.end(); ++it)
    {
        ISceneNode* current = *it;

        if (current->isVisible() &&
        //          (bNoDebugObjects ? !current->isDebugObject() : true) &&
        (bits==0 || (bits != 0 && (current->getID() & bits))))
        {
            // get world to object space transform
            core::matrix4 mat;
            if (!current->getAbsoluteTransformation().getInverse(mat))
                continue;

            // transform vector from world space to object space
            vector3df currentPoint( point );
            mat.transformVect(currentPoint);

            const core::aabbox3df& box = current->getBoundingBox();

            // do intersection test in object space
            if (box.isPointInside( currentPoint ))
            {
                outbestnode = current;
                return true;
            }
        }
        if ( recurse )
            if ( getNodePointBB(current, point, bits, recurse, outbestnode))
                return true;
    }
    return false;
}


/* ----------------------------------------------------------------------------
a ray is cast through the supplied coordinates and the nearest node that is hit
by the ray is returned. if no node is hit zero is returned for the object, only
a subset of objects are tested, i.e. the children of the supplied node that
match the supplied id. if the recurse option is enabled the entire tree of child
objects connected to this node are tested
*/
void *DLL_EXPORT IrrGetChildCollisionNodeFromRay(
                                    ISceneNode *node,
                                    s32 id,
                                    bool recurse,
                                    IRR_VECTOR &vectorStart,
                                    IRR_VECTOR &vectorEnd )
{
	ISceneNode* best = 0;
	f32 dist = 9999999999.0f;
    core::line3d<f32> ray( vectorStart.x, vectorStart.y, vectorStart.z, vectorEnd.x, vectorEnd.y, vectorEnd.z );

	getNodeRayBB( node, ray, id, recurse, dist, best);

	return best;
}


/* ----------------------------------------------------------------------------
the node and its children are recursively tested and the first node that contains
the matched point is returned. if no node is hit zero is returned for the object,
only a subset of objects are tested, i.e. the children of the supplied node that
match the supplied id. if the recurse option is enabled the entire tree of child
objects connected to this node are tested
*/
void *DLL_EXPORT IrrGetChildCollisionNodeFromPoint(
                                    ISceneNode *node,
                                    s32 id,
                                    bool recurse,
                                    IRR_VECTOR &vectorPoint )
{
	ISceneNode* best = 0;
	vector3df point( vectorPoint.x, vectorPoint.y, vectorPoint.z );

	getNodePointBB( node, point, id, recurse, best);

	return best;
}


/* ----------------------------------------------------------------------------
the rootNode and its children are recursively tested and the nearest node whose
bounding box is hit by the ray then has its triangles tested in detail to find
an exact point of collision on a specific triangle. If such a collision is
found the node, the point of collision and the normal of that collision is
returned. For the collision to work the node must have had a triangle selector
created for it.
*/
void DLL_EXPORT IrrGetNodeAndCollisionPointFromRay (
        IRR_VECTOR &vectorStart,
        IRR_VECTOR &vectorEnd,
		ISceneNode **node,
		f32 &x,
		f32 &y,
		f32 &z,
		f32 &normalX,
		f32 &normalY,
		f32 &normalZ,
		s32 id,
		ISceneNode *rootNode )
{
	// create a ray to test for collision
	line3d<f32> curRay( vectorStart.x, vectorStart.y, vectorStart.z,
						vectorEnd.x,   vectorEnd.y,   vectorEnd.z );

	// test for the collision
	vector3d<f32> collisionPoint;
	triangle3d<f32> collisionTriangle;
	*node = smgr->getSceneCollisionManager()->getSceneNodeAndCollisionPointFromRay(
			curRay, collisionPoint, collisionTriangle,
			id, rootNode );

	// return the location of the collision
	x = collisionPoint.X;
	y = collisionPoint.Y;
	z = collisionPoint.Z;

	// calculate and return the normal of the collided triangle
	vector3d<f32>normal = collisionTriangle.getNormal();
	normal.normalize();
	normalX = normal.X;
	normalY = normal.Y;
	normalZ = normal.Z;
}

/*----------------------------------------------------------------------------
Not the fastest squareroot alternative but it has reasonable accuracy
*/
float fsquareroot( float x )
{
    union{
        int intPart;
        float floatPart;
    } converter;
    union{
        int intPart;
        float floatPart;
    } converter2;

    converter.floatPart = x;
    converter2.floatPart = x;
    converter.intPart = 0x1FBCF800 + (converter.intPart >> 1);
    converter2.intPart = 0x5f3759df - (converter2.intPart >> 1);
    return 0.5f*(converter.floatPart + (x * converter2.floatPart));
}

/* ----------------------------------------------------------------------------
get the distance between two nodes using a customised squareroot function
*/
float DLL_EXPORT IrrGetDistanceBetweenNodes(
											ISceneNode *nodeA,
											ISceneNode *nodeB )
{

	core::vector3df posA = nodeA->getAbsolutePosition();
	posA -= nodeB->getAbsolutePosition();

	return fsquareroot( posA.X * posA.X + posA.Y * posA.Y + posA.Z * posA.Z );
}


/* ----------------------------------------------------------------------------
determine if the axis aligned bounding boxes of two nodes are in contact
*/
bool DLL_EXPORT IrrAreNodesIntersecting(
											ISceneNode* nodeA,
											ISceneNode* nodeB )
{
	aabbox3d<f32> boxA, boxB;

	boxA = nodeA->getTransformedBoundingBox();
	boxB = nodeB->getTransformedBoundingBox();

	return boxA.intersectsWithBox( boxB );
}




/* ----------------------------------------------------------------------------
get the distance between two nodes using a customised squareroot function
*/
bool DLL_EXPORT IrrIsPointInsideNode(	ISceneNode* nodeA,
										float X, float Y, float Z )
{
	return nodeA->getTransformedBoundingBox().isPointInside(vector3df(X,Y,Z));
}


/* ----------------------------------------------------------------------------
Collides a moving ellipsoid With a 3d world With gravity And returns the
resulting New position of the ellipsoid. (contributed by The Car)
*/
void DLL_EXPORT IrrGetCollisionResultPosition(	ITriangleSelector *selector,
												IRR_VECTOR &ellipsoidPosition,
												IRR_VECTOR &ellipsoidRadius,
												IRR_VECTOR &velocity,
												IRR_VECTOR &gravity,
												float      slidingSpeed,
												IRR_VECTOR &outPosition,
												IRR_VECTOR &outHitPosition,
												int        *outFalling
												)
{
	core::triangle3df triout;
	core::vector3df hitPosition;
	bool falling;
	const ISceneNode* sceneNode;

	core::vector3df newPosition = smgr->getSceneCollisionManager()->getCollisionResultPosition(
			selector,
			core::vector3df(ellipsoidPosition.x, ellipsoidPosition.y, ellipsoidPosition.z),
			core::vector3df(ellipsoidRadius.x, ellipsoidRadius.y, ellipsoidRadius.z),
			core::vector3df(velocity.x, velocity.y, velocity.z),
			triout, hitPosition, falling, sceneNode,slidingSpeed,
			core::vector3df(gravity.x, gravity.y, gravity.z));

	outPosition.x = newPosition.X;
	outPosition.y = newPosition.Y;
	outPosition.z = newPosition.Z;

	outHitPosition.x = hitPosition.X;
	outHitPosition.y = hitPosition.Y;
	outHitPosition.z = hitPosition.Z;

	*outFalling = falling ? 1 : 0;
}


/* ----------------------------------------------------------------------------
Calculates the intersection between a ray projected through the specified
screen co-ordinates and a plane defined a normal and distance from the
world origin (contributed by agamemnus)
*/
void DLL_EXPORT IrrGet3DPositionFromScreenCoordinates (
		int screenX,
		int screenY,
		float &x,
		float &y,
		float &z,
		irr::scene::ICameraSceneNode* camera,
		float normalX,
		float normalY,
		float normalZ,
		float distanceFromOrigin )
{
	// storage for the result of the intersection
	core::vector3d<f32> endingpos;

	// define a plane from a normal and a distance from the origin
//	core::plane3d<f32> plane(core::vector3d<f32>(0.f,0.f,1.f), 0.f);
	core::plane3d<f32> plane(core::vector3d<f32>(normalX,normalY,normalZ), distanceFromOrigin);

	// create a ray from the screen coordinates
	line3d<f32> ray = smgr->getSceneCollisionManager()-> getRayFromScreenCoordinates(core::position2d<s32>(screenX, screenY), camera);

	// calculate the intersection with the ray and the plane
	plane.getIntersectionWithLimitedLine(ray.start, ray.end, endingpos);

	// copy the point of intersection into the output
	x = endingpos.X;
	y = endingpos.Y;
	z = endingpos.Z;
}

/* ----------------------------------------------------------------------------
Calculates the intersection between a ray projected through the specified
screen co-ordinates and a plane defined a normal and distance from the
world origin (contributed by agamemnus)
*/
void DLL_EXPORT IrrGet2DPositionFromScreenCoordinates (int screenX, int screenY, float &x, float &y, irr::scene::ICameraSceneNode* camera)
{
	core::vector3d<f32> endingpos;
	core::plane3d<f32> plane(core::vector3d<f32>(0.f,0.f,1.f), 0.f);
	line3d<f32> ray = smgr->getSceneCollisionManager()-> getRayFromScreenCoordinates(core::position2d<s32>(screenX, screenY), camera);
	plane.getIntersectionWithLimitedLine(ray.start, ray.end, endingpos);
	x = endingpos.X;
	y = endingpos.Y;
}



/* ////////////////////////////////////////////////////////////////////////////
all of the above functions are declared as C functions and are exposed without
any mangled names
*/
}
