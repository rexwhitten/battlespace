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

#ifdef BUILD_DLL
    #define DLL_EXPORT __declspec(dllexport)
#else
    #define DLL_EXPORT
#endif

/* ////////////////////////////////////////////////////////////////////////////
includes
*/
#include <irrlicht.h>
#include <IMeshCache.h>


/* ////////////////////////////////////////////////////////////////////////////
irrlicht namespaces
*/
using namespace irr;
using namespace core;
using namespace scene;
using namespace video;
using namespace io;
using namespace gui;


/* ////////////////////////////////////////////////////////////////////////////
Constant Definitions
*/
#define MAX_ARCHIVED_EVENTS 256

#define INVERSE_WORLD				1
#define WORLD_VIEW_PROJECTION		2
#define CAMERA_POSITION				3
#define TRANSPOSED_WORLD			4


/* ////////////////////////////////////////////////////////////////////////////
structure and class declarations
*/
typedef struct tag_ARCHIVED_MOUSE_EVENT
{
    unsigned int uiaction;
    float fdelta;
    int ix;
    int iy;
}
ARCHIVED_MOUSE_EVENT;

typedef struct tag_ARCHIVED_KEY_EVENT
{
    unsigned int uikey;
    unsigned int uidirection;
    unsigned int uiflags;
}
ARCHIVED_KEY_EVENT;

typedef struct tag_ARCHIVED_GUI_EVENT
{
	s32		id;
	s32		event;
	s32		x;
	s32		y;
}
ARCHIVED_GUI_EVENT;

typedef struct tag_IRR_PARTICLE_EMITTER
{
    float min_box_x;
    float min_box_y;
    float min_box_z;

    float max_box_x;
    float max_box_y;
    float max_box_z;

    float direction_x;
    float direction_y;
    float direction_z;

    unsigned int min_paritlcles_per_second;
    unsigned int max_paritlcles_per_second;

    int min_start_color_red;
    int min_start_color_green;
    int min_start_color_blue;

    int max_start_color_red;
    int max_start_color_green;
    int max_start_color_blue;

    unsigned int min_lifetime;
    unsigned int max_lifetime;

    float min_start_sizeX;
    float min_start_sizeY;
    float max_start_sizeX;
    float max_start_sizeY;

    int max_angle_degrees;
}
IRR_PARTICLE_EMITTER;

// a vertex used in creating custom static mesh objects
typedef struct tag_IRR_VERT
{
    float x;                // The x position of the vertex
    float y;                // The y position of the vertex
    float z;                // The z position of the vertex
    float normal_x;         // The x normal of the vertex
    float normal_y;         // The y normal of the vertex
    float normal_z;         // The z normal of the vertex
    unsigned int vcolor;     // The 32bit ARGB color of the vertex
    float texture_x;        // the x co-ordinate of the vertex on the texture (0 to 1)
    float texture_y;        // the y co-ordinate of the vertex on the texture (0 to 1)
}
IRR_VERT;

typedef struct tag_IRR_VECTOR
{
    float x;
    float y;
    float z;
}
IRR_VECTOR;

/* storage for information pertaining to a shader constant
 */
typedef struct tConstant tConstant;
struct tConstant
{
	tConstant *		next;
	const char *	name;
	int				address;
	int				preset;
	const float *	data;
	int				count;
};

/*
This implementation of the Irrlicht event receiver receives events as they
happen and stores them in a circular buffer. the caller can then pop the
events out of the buffer at their convienence. if the events are unattended
and the buffer filled the oldest event is discarded
*/
class StackedEventReceiver : public IEventReceiver
{
public:
	virtual bool OnEvent(const SEvent& event);
};


/* ----------------------------------------------------------------------------
This class provides a generic callback response for setting shader constants
the values for these constants are setup ahead of rendering as label and pointer
pairs these are then passed to the GPU program during this callback to set
constant values in gpu programs
*/
class CIrrShaderCallBack : public video::IShaderConstantSetCallBack
{
public:
	/* attributes */
	tConstant *vertex_constant_list;
	tConstant *pixel_constant_list;
	bool UseHighLevelShaders;
	core::matrix4 world;
	core::vector3df pos;

	/* operations */
	CIrrShaderCallBack();
	~CIrrShaderCallBack();
	void resolveConstantPreset( int preset, const float **values, int * count );
	virtual void OnSetConstants( video::IMaterialRendererServices* services, s32 id );
};


/* returned structure containing shader information
 */
typedef struct tShaderReply tShaderReply;
struct tShaderReply
{
	/* The number of the material type which can be set in
	SMaterial::MaterialType	to use the renderer */
	s32						material_type;

	/* the shader callback object */
	CIrrShaderCallBack *	irrShaderCallBack;
	tShaderReply *			next_shader;
};

