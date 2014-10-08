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
CAMERA FUNCTIONS
*/
/* ----------------------------------------------------------------------------
add a basic first person perspective camera to the scene
*/
void * DLL_EXPORT IrrAddFPSCamera( ISceneNode *  parent , float rotateSpeed , float moveSpeed , int id , SKeyMap *  keyMapArray , int keyMapSize , bool noVerticalMovement , float jumpSpeed  )
{
	return (void *)smgr->addCameraSceneNodeFPS( parent, rotateSpeed, moveSpeed, id, keyMapArray, keyMapSize, noVerticalMovement, jumpSpeed);
}

/* ----------------------------------------------------------------------------
create a camera in the scene at a specified location looking at a specified
target position
*/
void * DLL_EXPORT IrrAddCamera( float cameraX, float cameraY, float cameraZ, float targetX, float targetY, float targetZ )
{
	/*
	To look at the mesh, we place a camera into 3d space at the position
	(0, 30, -40). The camera looks from there to (0,5,0).
	*/
	return (void *)smgr->addCameraSceneNode(0,
            vector3df(cameraX,cameraY,cameraZ),
            vector3df(targetX,targetY,targetZ)
    );
}

/* ----------------------------------------------------------------------------
add a maya style camera to the scene
*/
void * DLL_EXPORT IrrAddMayaCamera( ISceneNode *  parent , float rotateSpeed , float zoomSpeed, float moveSpeed   )
{
    return ( void *)smgr->addCameraSceneNodeMaya  (  parent, rotateSpeed, zoomSpeed, moveSpeed, -1 );
}


/* ----------------------------------------------------------------------------
reposition the target location of a camera
*/
void DLL_EXPORT IrrSetCameraTarget ( ICameraSceneNode* camera, float X, float Y,  float Z )
{
	camera->setTarget(core::vector3df(X,Y,Z));
}

/* ----------------------------------------------------------------------------
get the current target location of a camera
*/
void DLL_EXPORT IrrGetCameraTarget ( ICameraSceneNode* camera, float &X, float &Y,  float &Z )
{
	vector3df vect = camera->getTarget();
	X = vect.X;
	Y = vect.Y;
	Z = vect.Z;
}

/* ----------------------------------------------------------------------------
Get the up vector of the camera
*/
void DLL_EXPORT IrrGetCameraUpDirection ( ICameraSceneNode* camera, float &X, float &Y,  float &Z )
{
    vector3df curVector = camera->getUpVector();
    X = curVector.X;
    Y = curVector.Y;
    Z = curVector.Z;
}

/* ----------------------------------------------------------------------------
set the up vector of the camera allowing the camera to be rolled
*/
void DLL_EXPORT IrrSetCameraUpDirection ( ICameraSceneNode* camera, float X, float Y,  float Z )
{
    camera->setUpVector(core::vector3df(X,Y,Z));
}

/* ----------------------------------------------------------------------------
get the vectors describing the camera direction useful after the camera has been revolved
*/
void DLL_EXPORT IrrGetCameraOrientation( ICameraSceneNode* camera,
                                        IRR_VECTOR &up, IRR_VECTOR &forward,  IRR_VECTOR &right )
{
    vector3df cameraUp = camera->getUpVector();
    vector3df cameraForward = (camera->getTarget() - camera->getPosition()).normalize();
    vector3df cameraRight = cameraForward.crossProduct(cameraUp);

    up.x = cameraUp.X;
    up.y = cameraUp.Y;
    up.z = cameraUp.Z;
    forward.x = cameraForward.X;
    forward.y = cameraForward.Y;
    forward.z = cameraForward.Z;
    right.x = cameraRight.X;
    right.y = cameraRight.Y;
    right.z = cameraRight.Z;
}

/* ----------------------------------------------------------------------------
set the distance at which the camera starts to clip polys
*/
void DLL_EXPORT IrrSetCameraClipDistance ( ICameraSceneNode* camera, float farDistance, float nearDistance )
{
	camera->setFarValue(farDistance);
	camera->setNearValue(nearDistance);
}

/* ----------------------------------------------------------------------------
set the active camera in the scene
*/
void DLL_EXPORT IrrSetActiveCamera ( ICameraSceneNode* camera )
{
    smgr->setActiveCamera(camera);
}

/* ----------------------------------------------------------------------------
sets the field of view (Default: PI / 2.5f).
*/
void DLL_EXPORT IrrSetCameraFOV ( ICameraSceneNode* camera, float fov )
{
	camera->setFOV(fov);
}


/* ----------------------------------------------------------------------------
make the camera display an orthagonal view
*/
void DLL_EXPORT IrrSetCameraOrthagonal( ICameraSceneNode* camera, f32 x, f32 y, f32 z )
{
    CMatrix4<f32> projectionMatrix;
    vector3d<f32> camDistance( x,y,z );

    f32 viewScale = camDistance.getLength();

    // calculate the orthagonal projection matrix
    projectionMatrix.buildProjectionMatrixOrthoLH(
            viewScale * camera->getAspectRatio(), viewScale,
            camera->getNearValue(), camera->getFarValue());

    // set the cameras projection matrix to this orthaonal construct
    camera->setProjectionMatrix(projectionMatrix, true);
}


/* ----------------------------------------------------------------------------
Function to rotate a vector by a specific angle around another vector
describing an axis for that rotation. Created by rogerborg and contributed to
the Irrlicht Forumns
*/
void rotateVectorAroundAxis(vector3df & vector, const vector3df & axis, f32 radians)
{
	quaternion MrQuaternion;
	matrix4 MrMatrix;

	// construct a quaternion from a vector describing an axis and a rotation
	(void)MrQuaternion.fromAngleAxis( radians, axis );

	// construct a rotation matrix from the quaternion
	MrMatrix = MrQuaternion.getMatrix();

	/* rotate the target vector around the axis by the supplied rotation
	using the matrix derived from the quaterion */
	MrMatrix.rotateVect( vector );
}


/* ----------------------------------------------------------------------------
revolve the camera using quaternion calculations, this will help avoid gimbal
lock associated with normal Rotations many thanks to RogerBorg for this
*/
void DLL_EXPORT IrrRevolveCamera ( ICameraSceneNode* camera,
                                    float yaw, float pitch, float roll,
                                    float drive, float strafe, float elevate )
{
    // Work out the 3 axes for the camera.
    vector3df forward = ( camera->getTarget() - camera->getPosition()).normalize();
    vector3df up = camera->getUpVector();
    vector3df right = forward.crossProduct( up );

    // yaw around the up axis
    rotateVectorAroundAxis( forward, up, yaw);

    // pitch around the right axis (we need to change both forward AND up)
    rotateVectorAroundAxis( forward, right, pitch );
    rotateVectorAroundAxis( up, right, pitch );

    // roll around the forward axis
    rotateVectorAroundAxis( up, forward, roll);

    core::vector3df pos = camera->getPosition();
    pos += ( forward * drive ) + ( up * elevate ) + ( right * strafe );
    camera->setPosition( pos );

    // And re-orient the camera to face along the foward and up axes.
    camera->setTarget( pos + forward );
    camera->setUpVector( up );
}

/* ----------------------------------------------------------------------------
set the camera up at a right angle to the camera vector
*/
void DLL_EXPORT IrrSetCameraUpAtRightAngle ( ICameraSceneNode* camera )
{
    // Work out the 3 axes for the camera.
    vector3df forward = ( camera->getTarget() - camera->getPosition()).normalize();
    vector3df up;

	up.X = -forward.X;
	up.Y = forward.Z;
	up.Z = forward.Y;

    camera->setUpVector( up );
}

/* ----------------------------------------------------------------------------
set the aspect ratio of a camera
*/
void DLL_EXPORT IrrSetCameraAspectRatio ( ICameraSceneNode* camera, float aspectRatio )
{
	camera->setAspectRatio( aspectRatio );
}


/* ////////////////////////////////////////////////////////////////////////////
all of the above functions are declared as C functions and are exposed without
any mangled names
*/
}
