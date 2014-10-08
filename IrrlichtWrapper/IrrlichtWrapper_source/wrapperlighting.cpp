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
LIGHTING FUNCTIONS
*/
/* ----------------------------------------------------------------------------
add a light to the  scene
*/
void * DLL_EXPORT IrrAddLight( ISceneNode * parent, float X, float Y, float Z, float R, float G, float B, float size )
{
	return smgr->addLightSceneNode( parent, core::vector3df(X,Y,Z),
		video::SColorf(R, G, B), size );

}

/* ----------------------------------------------------------------------------
set the scene ambient lighting
*/
void DLL_EXPORT IrrSetAmbientLight( float R, float G, float B )
{
    smgr->setAmbientLight( SColorf( R, G, B, 0.0f ));
}


/* ----------------------------------------------------------------------------
Ambient color emitted by the light.
*/
void DLL_EXPORT IrrSetLightAmbientColor( ILightSceneNode *light, float R, float G, float B )
{
    light->getLightData().AmbientColor = SColorf( R, G, B, 0.0f );
}

/* ----------------------------------------------------------------------------
Changes the light strength fading over distance. Good values for distance
effects use ( 1.0, 0.0, 0.0) and simply add small values to the second and
third element.
*/
void DLL_EXPORT IrrSetLightAttenuation( ILightSceneNode *light, float constant, float linear, float quadratic )
{
    light->getLightData().Attenuation = vector3df( constant, linear, quadratic );
}

/* ----------------------------------------------------------------------------
Does the light cast shadows?
*/
void DLL_EXPORT IrrSetLightCastShadows( ILightSceneNode *light, bool castShadows )
{
    light->getLightData().CastShadows = castShadows ;
}

/* ----------------------------------------------------------------------------
Diffuse color emitted by the light.
*/
void DLL_EXPORT IrrSetLightDiffuseColor( ILightSceneNode *light, float R, float G, float B )
{
    light->getLightData().DiffuseColor = SColorf( R, G, B, 0.0f );
}

/* ----------------------------------------------------------------------------
The light strength's decrease between Outer and Inner cone.
*/
void DLL_EXPORT IrrSetLightFalloff( ILightSceneNode *light, float Falloff )
{
    light->getLightData().Falloff = Falloff ;
}

/* ----------------------------------------------------------------------------
The angle of the spot's inner cone. Ignored for other lights.
*/
void DLL_EXPORT IrrSetLightInnerCone( ILightSceneNode *light, float InnerCone )
{
    light->getLightData().InnerCone = InnerCone ;
}

/* ----------------------------------------------------------------------------
The angle of the spot's outer cone. Ignored for other lights.
*/
void DLL_EXPORT IrrSetLightOuterCone( ILightSceneNode *light, float OuterCone )
{
    light->getLightData().OuterCone = OuterCone ;
}

/* ----------------------------------------------------------------------------
Radius of light. Everything within this radius be be lighted.
*/
void DLL_EXPORT IrrSetLightRadius( ILightSceneNode *light, float Radius )
{
    light->getLightData().Radius = Radius ;
}

/* ----------------------------------------------------------------------------
Specular color emitted by the light.
*/
void DLL_EXPORT IrrSetLightSpecularColor( ILightSceneNode *light, float R, float G, float B )
{
    light->getLightData().SpecularColor = SColorf( R, G, B, 0.0f );
}

/* ----------------------------------------------------------------------------
Type of the light. Default: ELT_POINT.
*/
void DLL_EXPORT IrrSetLightType( ILightSceneNode *light, E_LIGHT_TYPE Type )
{
    light->getLightData().Type = Type ;
}


/* ////////////////////////////////////////////////////////////////////////////
all of the above functions are declared as C functions and are exposed without
any mangled names
*/
}
