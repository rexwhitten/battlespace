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
#include "os.h"
#include "irrlichtwrapper.h"
#include "CSceneNodeAnimatorFade.h"


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
NODE ANIMATION FUNCTIONS
*/

/* ----------------------------------------------------------------------------
set the frames to playback in the animation
*/
void DLL_EXPORT IrrSetNodeAnimationRange ( IAnimatedMeshSceneNode* node, int iStart, int iEnd )
{
    // set the animation loop in the object
    node->setFrameLoop(iStart, iEnd);
}

/* ----------------------------------------------------------------------------
set the MD2 animation sequence to playback in the animation
*/
void DLL_EXPORT IrrPlayNodeMD2Animation ( IAnimatedMeshSceneNode* node, int iAnimation)
{
    EMD2_ANIMATION_TYPE  animationtable[] = {
        EMAT_STAND,
        EMAT_RUN,
        EMAT_ATTACK,
        EMAT_PAIN_A,
        EMAT_PAIN_B,
        EMAT_PAIN_C,
        EMAT_JUMP,
        EMAT_FLIP,
        EMAT_SALUTE,
        EMAT_FALLBACK,
        EMAT_WAVE,
        EMAT_POINT,
        EMAT_CROUCH_STAND,
        EMAT_CROUCH_WALK,
        EMAT_CROUCH_ATTACK,
        EMAT_CROUCH_PAIN,
        EMAT_CROUCH_DEATH,
        EMAT_DEATH_FALLBACK,
        EMAT_DEATH_FALLFORWARD,
        EMAT_DEATH_FALLBACKSLOW,
        EMAT_BOOM
    };

    // play the selected animation sequence
	node->setMD2Animation(animationtable[iAnimation]);
}


/* ----------------------------------------------------------------------------
set the playback animation speed
*/
void DLL_EXPORT IrrSetNodeAnimationSpeed ( IAnimatedMeshSceneNode* node, f32 fSpeed )
{
    // set the speed of playback in the animation
    node->setAnimationSpeed(fSpeed);
}

/* ----------------------------------------------------------------------------
get the current frame number being played in the animation
*/
unsigned int DLL_EXPORT IrrGetNodeAnimationFrame ( IAnimatedMeshSceneNode* node )
{
    // get the current frame number in the animation
    return (unsigned int)node->getFrameNr();
}

/* ----------------------------------------------------------------------------
set the current frame number being played in the animation
*/
void DLL_EXPORT IrrSetNodeAnimationFrame ( IAnimatedMeshSceneNode* node, f32 fFrame )
{
    // set the current frame in the animation
    node->setCurrentFrame( fFrame );
}

/* ----------------------------------------------------------------------------
Sets the transition time across which two poses of an animated mesh are blended
For example a character in a sitting pose can be switched into a lying down pose
by blending the two animations.
IrrAnimateNode must be called before IrrDrawScene if blending is used
*/
void DLL_EXPORT IrrSetTransitionTime ( IAnimatedMeshSceneNode* node, float fTime )
{
    // set the time in seconds across which the transition occurs
    node->setTransitionTime( fTime );
}

/* ----------------------------------------------------------------------------
Animates the mesh based on the position of the joints, this should be used at
the end of any manual joint operations including blending and joints animated
using IRR_JOINT_MODE_CONTROL and IrrSetNodeRotation on a bone node
*/
void DLL_EXPORT IrrAnimateJoints ( IAnimatedMeshSceneNode* node )
{
    // perform the bone animation
    node->animateJoints();
}

/* ----------------------------------------------------------------------------
Sets the animation mode of joints in a node

IRR_JOINT_MODE_NONE will result in no animation of the model based on bones
IRR_JOINT_MODE_READ will result in automatic animation based upon
IRR_JOINT_MODE_CONTROL will allow the position of the bones to be set through code

When using the control mode IrrAnimateJoints must be called before IrrDrawScene
*/
void DLL_EXPORT IrrSetJointMode ( IAnimatedMeshSceneNode* node, unsigned int mode )
{
	E_JOINT_UPDATE_ON_RENDER jointMode[] = {
		EJUOR_NONE,
		EJUOR_READ,
		EJUOR_CONTROL
	};

    // perform the bone animation
    node->setJointMode( jointMode[mode] );
}


/* ////////////////////////////////////////////////////////////////////////////
ANIMATOR FUNCTIONS
*/
/* ----------------------------------------------------------------------------
add a collision animator to a node
*/
void *DLL_EXPORT IrrAddCollisionAnimator(
                                        ITriangleSelector* selector,
                                        ISceneNode* node,
                                        float radiusx, float radiusy, float radiusz,
                                        float gravityx, float gravityy, float gravityz,
                                        float offsetx, float offsety, float offsetz )
{
    scene::ISceneNodeAnimator* anim;

    if ( node )
    {
        node->setTriangleSelector(selector);

        anim = smgr->createCollisionResponseAnimator(
            selector, node, core::vector3df(radiusx,radiusy,radiusz),
            core::vector3df(gravityx,gravityy,gravityz),
            core::vector3df(offsetx,offsety,offsetz));
        if ( anim )
        {
            node->addAnimator(anim);
            anim->drop();
        }
        else
        {
            printf( "Could not create animator\n" );
        }
    }
    else
    {
        printf( "No node supplied\n" );
    }
	return (void *)anim;
}

/* ----------------------------------------------------------------------------
add a deletion animator to a node
*/
void *DLL_EXPORT IrrAddDeleteAnimator( ISceneNode* node, int delete_after )
{
    scene::ISceneNodeAnimator* anim = smgr->createDeleteAnimator( delete_after );
	node->addAnimator(anim);
	anim->drop();
	return (void *)anim;
}

/* ----------------------------------------------------------------------------
add a fly-in-circle animator to a node
*/
void *DLL_EXPORT IrrAddFlyCircleAnimator(
                                        ISceneNode* node,
                                        float x, float y, float z,
                                        float radius, float speed )
{
    scene::ISceneNodeAnimator* anim = smgr->createFlyCircleAnimator(
            core::vector3df(x,y,z), radius, speed );
	node->addAnimator(anim);
	anim->drop();
	return (void *)anim;
}

/* ----------------------------------------------------------------------------
add a fly-straight animator to a node
*/
void *DLL_EXPORT IrrAddFlyStraightAnimator(
                                        ISceneNode* node,
                                        float sx, float sy, float sz,
                                        float ex, float ey, float ez,
                                        unsigned int uitime, bool loop )
{
    scene::ISceneNodeAnimator* anim = smgr->createFlyStraightAnimator(
            core::vector3df(sx,sy,sz),
            core::vector3df(ex,ey,ez),
            uitime,
            loop
    );
	node->addAnimator(anim);
	anim->drop();
	return (void *)anim;
}

/* ----------------------------------------------------------------------------
add a rotation animator to a node
*/
void *DLL_EXPORT IrrAddRotationAnimator( ISceneNode* node, float x, float y, float z )
{
    scene::ISceneNodeAnimator* anim = smgr->createRotationAnimator(
            core::vector3df(x,y,z));
	node->addAnimator(anim);
	anim->drop();
	return (void *)anim;
}

/* ----------------------------------------------------------------------------
add a spline animator to a node
*/
void *DLL_EXPORT IrrAddSplineAnimator( ISceneNode* node, int iPoints,
                                    float *x, float *y, float *z,
                                    int time, float speed, float tightness )
{
    core::array<core::vector3df> points;
    for ( int loop = 0; loop < iPoints; loop++ )
    {
        points.push_back(core::vector3df(x[loop], y[loop], z[loop]));
    }

    scene::ISceneNodeAnimator* anim = smgr->createFollowSplineAnimator(
            time, points, speed, tightness);
    node->addAnimator(anim);
    anim->drop();
	return (void *)anim;
}

/* ----------------------------------------------------------------------------
add a fade animator to a node
*/
void *DLL_EXPORT IrrAddFadeAnimator( ISceneNode* node, int delete_after, f32 scale )
{
	scene::ISceneNodeAnimator* anim = new CSceneNodeAnimatorFade(
			smgr, device->getTimer()->getTime(), delete_after, scale );

	node->addAnimator(anim);
	anim->drop();
	return (void *)anim;
}

/* ----------------------------------------------------------------------------
remove an animator from a node
*/
void DLL_EXPORT IrrRemoveAnimator( ISceneNode* node, ISceneNodeAnimator *  anim )
{
    node->removeAnimator ( anim );
}


/* ////////////////////////////////////////////////////////////////////////////
all of the above functions are declared as C functions and are exposed without
any mangled names
*/
}
