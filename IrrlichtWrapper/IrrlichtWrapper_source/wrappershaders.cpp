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
#include <SMaterial.h>

/* ////////////////////////////////////////////////////////////////////////////
global variables
*/
tShaderReply *shader_list = NULL;

/* ////////////////////////////////////////////////////////////////////////////
external variables
*/
extern IrrlichtDevice *device;
extern IVideoDriver* driver;
extern ISceneManager* smgr;
extern IGUIEnvironment* guienv;


/* ////////////////////////////////////////////////////////////////////////////
Support Classes
*/

CIrrShaderCallBack::CIrrShaderCallBack()
{
	vertex_constant_list = NULL;
	pixel_constant_list = NULL;
}

CIrrShaderCallBack::~CIrrShaderCallBack()
{
	tConstant *delete_object;

	// delete all of the vertex constants;
	tConstant *current_object = vertex_constant_list;
	while ( current_object )
	{
		delete_object = current_object;
		current_object = current_object->next;
		delete delete_object;
	}

	// delete all of the pixel constants
	current_object = pixel_constant_list;
	while ( current_object )
	{
		delete_object = current_object;
		current_object = current_object->next;
		delete delete_object;
	}
}

void CIrrShaderCallBack::resolveConstantPreset( int preset, const float **values, int * count )
{
	// set inverted world matrix
	// if we are using highlevel shaders (the user can select this when
	// starting the program), we must set the constants by name.

	switch ( preset )
	{
		case INVERSE_WORLD:
		{
			world = driver->getTransform(video::ETS_WORLD);
			world.makeInverse();
			*values = world.pointer();
			*count = 16;
		}
		break;

		case WORLD_VIEW_PROJECTION:
		{
			world;
			world = driver->getTransform(video::ETS_PROJECTION);
			world *= driver->getTransform(video::ETS_VIEW);
			world *= driver->getTransform(video::ETS_WORLD);
			*values = world.pointer();
			*count = 16;
		}
		break;

		case CAMERA_POSITION:
		{
			pos = device->getSceneManager()->
					getActiveCamera()->getAbsolutePosition();
			*values = reinterpret_cast<f32*>(&pos);
			*count = 3;
		}
		break;

		case TRANSPOSED_WORLD:
		{
			world = driver->getTransform(video::ETS_WORLD);
			world = world.getTransposed();
			*values = world.pointer();
			*count = 16;
		}
	}
}

void CIrrShaderCallBack::OnSetConstants( video::IMaterialRendererServices* services, s32 id )
{
	const float *values = NULL;
	int count = 0;

	// itterate all of the vertex constants
	tConstant * current_constant = vertex_constant_list;
	while ( current_constant )
	{
		if ( current_constant->preset > 0 )
			resolveConstantPreset( current_constant->preset, &values, &count );
		else
		{
			values = current_constant->data;
			count = current_constant->count;
		}

		if (current_constant->name)
		{
			services->setVertexShaderConstant( current_constant->name, values, count);
		}
		else
		{
			count = ((count % 4 ) == 0 ) ? count / 4 : (count / 4) + 1;
			services->setVertexShaderConstant( values, current_constant->address, count);
		}

		current_constant = current_constant->next;
	}

	// itterate all of the pixel constants
	current_constant = pixel_constant_list;
	while ( current_constant)
	{
		if ( current_constant->preset > 0 )
			resolveConstantPreset( current_constant->preset, &values, &count );
		else
		{
			values = current_constant->data;
			count = current_constant->count;
		}

		if (current_constant->name)
		{
			services->setPixelShaderConstant( current_constant->name, values, count);
		}
		else
		{
			count = ((count % 4 ) == 0 ) ? count / 4 : (count / 4) + 1;
			services->setPixelShaderConstant( values, current_constant->address, count);
		}

		current_constant = current_constant->next;
	}
}

/* ----------------------------------------------------------------------------
Releases memory allocated when shaders are created. This should only be called
by IrrStop when the Irrlicht system is shutting down.
*/
void dropShaders( void )
{
	tShaderReply * current_shader;
	tShaderReply * next_shader;

	/* itterate the shader linked list */
	current_shader = shader_list;
	while ( current_shader )
	{
		/* get the next shader */
		next_shader = current_shader->next_shader;

		/* releasing the shader callback */
		delete current_shader->irrShaderCallBack;

		/* release the shader */
		delete current_shader;

		current_shader = next_shader;

	}
}


/* ////////////////////////////////////////////////////////////////////////////
Global Function Declarations

all of the below functions are declared as C functions and are exposed without
any mangled names so that they can be easily imported into imperative
languages like FreeBasic
*/
extern "C"
{

/* ////////////////////////////////////////////////////////////////////////////
BASIC MATERIAL PROPERTIES
*/

/* ----------------------------------------------------------------------------
 Set material properties For a node.
*/
void DLL_EXPORT IrrSetNodeAmbientColor (ISceneNode * node, u32 value)
{
	u32 count = node->getMaterialCount();
	for ( u32 i = 0; i < count; i++)
	{
		node->getMaterial(i).AmbientColor = value;
	}
}

void DLL_EXPORT IrrSetNodeDiffuseColor (ISceneNode * node, u32 value)
{
	u32 count = node->getMaterialCount();
	for ( u32 i = 0; i < count; i++)
	{
		node->getMaterial(i).DiffuseColor = value;
	}
}

void DLL_EXPORT IrrSetNodeSpecularColor (ISceneNode * node, u32 value)
{
	u32 count = node->getMaterialCount();
	for ( u32 i = 0; i < count; i++)
	{
		node->getMaterial(i).SpecularColor = value;
	}
}

void DLL_EXPORT IrrSetNodeEmissiveColor (ISceneNode * node, u32 value)
{
	u32 count = node->getMaterialCount();
	for ( u32 i = 0; i < count; i++)
	{
		node->getMaterial(i).EmissiveColor = value;
	}
}

/* ----------------------------------------------------------------------------
Set whether vertex color or material color is used to shade the surface of a node
*/
void DLL_EXPORT IrrSetNodeColorByVertex ( ISceneNode* node, E_COLOR_MATERIAL colorMaterial )
{
	unsigned int count = node->getMaterialCount();

	for (unsigned int i = 0; i < count; i++)
	{
		node->getMaterial(i).ColorMaterial = colorMaterial;
	}
}

/* ----------------------------------------------------------------------------
Set whether vertex color or material color is used to shade the surface
*/
void DLL_EXPORT IrrMaterialVertexColorAffects( SMaterial *material, E_COLOR_MATERIAL colorMaterial )
{
    material->ColorMaterial = colorMaterial;
}

/* ----------------------------------------------------------------------------
Set how shiny the material is the higher the value the more defined the highlights
*/
void DLL_EXPORT IrrMaterialSetShininess( SMaterial *material, float shininess )
{
    material->Shininess = shininess;
}

/* ----------------------------------------------------------------------------
The color of specular highlights on the object
*/
void DLL_EXPORT IrrMaterialSetSpecularColor( SMaterial *material, unsigned int A, unsigned int R, unsigned int G, unsigned int B )
{
    material->SpecularColor.set( A, R, G, B);
}

/* ----------------------------------------------------------------------------
The color of diffuse lighting on the object
*/
void DLL_EXPORT IrrMaterialSetDiffuseColor( SMaterial *material, unsigned int A, unsigned int R, unsigned int G, unsigned int B )
{
    material->DiffuseColor.set( A, R, G, B);
}

/* ----------------------------------------------------------------------------
The color of ambient light reflected by the object
*/
void DLL_EXPORT IrrMaterialSetAmbientColor( SMaterial *material, unsigned int A, unsigned int R, unsigned int G, unsigned int B )
{
    material->AmbientColor.set( A, R, G, B);
}

/* ----------------------------------------------------------------------------
The color of light emitted by the object
*/
void DLL_EXPORT IrrMaterialSetEmissiveColor( SMaterial *material, unsigned int A, unsigned int R, unsigned int G, unsigned int B )
{
    material->EmissiveColor.set( A, R, G, B);
}

/* ----------------------------------------------------------------------------
set material specific parameter
*/
void DLL_EXPORT IrrMaterialSetMaterialTypeParam( SMaterial *material, float value )
{
    material->MaterialTypeParam = value;
}

/* ----------------------------------------------------------------------------
sets the blend factors of a material for the ONETEXTURE_BLEND material type
*/
void DLL_EXPORT IrrSetMaterialBlend( SMaterial *material, E_BLEND_FACTOR blendSrc, E_BLEND_FACTOR blendDest )
{
    material->MaterialTypeParam = pack_texureBlendFunc( blendSrc, blendDest );
}

/* ----------------------------------------------------------------------------
 Sets the line thickness of none 3D elements associated with this material
*/
void DLL_EXPORT IrrSetMaterialLineThickness( SMaterial *material, float lineThickness )
{
	material->Thickness = lineThickness;
}



/* ////////////////////////////////////////////////////////////////////////////
GPU PROGRAMMING SERVICES
*/

/* ----------------------------------------------------------------------------
 * Creates a Vertex shader constant, the constant is attached to the supplied
 * shader and whenever the shader callback is called the data associated with
 * that this constant is written to the shader. this allows the caller to
 * easily set shader constant data without needing to handle the C++ callback.
 * there is no synchronisation for the call though so the data for the constant
 * should be set up outside of the rendering cycle. a series of common preset
 * values used in shaders is available the data for these presets need not be
 * maintained by the caller.
 *
 * Returns:
 *	whether a constant was sucessfully created
 */
bool DLL_EXPORT IrrCreateNamedVertexShaderConstant (
		tShaderReply *	shader_reply,
		const c8 *		name,
		int				preset,
		const f32 *		floats,
		int				count
 )
{
	bool result = false;

	/* if constant element is null then we need to create a new constant */
	if ( shader_reply )
	{
	    if ( shader_reply->irrShaderCallBack->UseHighLevelShaders )
	    {
            tConstant * constant_element = new tConstant;

            if ( constant_element )
            {
                constant_element->name = name;
                constant_element->preset = preset;

                if ( preset == 0 )
                {
                    constant_element->data = floats;
                    constant_element->count = count;
                }
                else
                {
                    constant_element->data = NULL;
                    constant_element->count = 0;
                }

                if ( shader_reply->irrShaderCallBack->vertex_constant_list == NULL )
                {
                    shader_reply->irrShaderCallBack->vertex_constant_list = constant_element;
                constant_element->next = NULL;
                }
                else
                {
                    constant_element->next = shader_reply->irrShaderCallBack->vertex_constant_list;
                    shader_reply->irrShaderCallBack->vertex_constant_list = constant_element;
                }
            }
            else printf( "A constant could not be allocated\n" );
		}
		else printf( "Named variables are added to high level shaders\n" );
	}
	else printf( "A shader was not supplied\n" );

	return result;
}


/* ----------------------------------------------------------------------------
 * Creates a Pixel shader constant, the operation of the function is the same
 * as that of the vertex shader constant above.
 *
 * Returns:
 *	whether a constant was sucessfully created
 */
bool DLL_EXPORT IrrCreateNamedPixelShaderConstant (
		tShaderReply *	shader_reply,
		const c8 *		name,
		int				preset,
		const f32 *		floats,
		int				count
 )
{
	bool result = false;

	/* if constant element is null then we need to create a new constant */
	if ( shader_reply )
	{
	    if ( shader_reply->irrShaderCallBack->UseHighLevelShaders )
	    {
            tConstant * constant_element = new tConstant;

            if ( constant_element )
            {
                constant_element->name = name;
                constant_element->preset = preset;

                if ( preset == 0 )
                {
                    constant_element->data = floats;
                    constant_element->count = count;
                }
                else
                {
                    constant_element->data = NULL;
                    constant_element->count = 0;
                }

                if ( shader_reply->irrShaderCallBack->pixel_constant_list == NULL )
                {
                    shader_reply->irrShaderCallBack->pixel_constant_list = constant_element;
                    constant_element->next = NULL;
                }
                else
                {
                    constant_element->next = shader_reply->irrShaderCallBack->pixel_constant_list;
                    shader_reply->irrShaderCallBack->pixel_constant_list = constant_element;
                }
            }
            else printf( "A constant could not be allocated\n" );
		}
		else printf( "Named variables are added to high level shaders\n" );
	}
	else printf( "A shader was not supplied\n" );

	return result;
}


/* ----------------------------------------------------------------------------
 * the same as IrrCreateNamedVertexShaderConstant but uses an address instead
 * of a name for low level shaders
 *
 * Returns:
 *	whether a constant was sucessfully created
 */
bool DLL_EXPORT IrrCreateAddressedVertexShaderConstant (
		tShaderReply *	shader_reply,
		int				address,
		int				preset,
		const f32 *		floats,
		int				count
 )
{
	bool result = false;

	/* if constant element is null then we need to create a new constant */
	if ( shader_reply )
	{
	    if ( !shader_reply->irrShaderCallBack->UseHighLevelShaders )
	    {
            tConstant * constant_element = new tConstant;

            if ( constant_element )
            {
                constant_element->address = address;
                constant_element->preset = preset;

                constant_element->next = NULL;
                constant_element->name = NULL;
                constant_element->data = NULL;
                constant_element->count = 0;

                if ( preset == 0 )
                {
                    constant_element->data = floats;
                    constant_element->count = count;
                }

                if ( shader_reply->irrShaderCallBack->vertex_constant_list == NULL )
                {
                    shader_reply->irrShaderCallBack->vertex_constant_list = constant_element;
                }
                else
                {
                    constant_element->next = shader_reply->irrShaderCallBack->vertex_constant_list;
                    shader_reply->irrShaderCallBack->vertex_constant_list = constant_element;
                }
            }
            else printf( "A constant could not be allocated\n" );
	    }
		else printf( "Addressed variables are added to low level assembler shaders\n" );
	}
	else printf( "A shader was not supplied\n" );

	return result;
}


/* ----------------------------------------------------------------------------
 * the same as IrrCreateNamedPixelShaderConstant but uses an address instead
 * of a name for low level shaders
 *
 * Returns:
 *	whether a constant was sucessfully created
 */
bool DLL_EXPORT IrrCreateAddressedPixelShaderConstant (
		tShaderReply *	shader_reply,
		int				address,
		int				preset,
		const f32 *		floats,
		int				count
 )
{
	bool result = false;

	/* if constant element is null then we need to create a new constant */
	if ( shader_reply )
	{
	    if ( !shader_reply->irrShaderCallBack->UseHighLevelShaders )
	    {
            tConstant * constant_element = new tConstant;

            if ( constant_element )
            {
                constant_element->address = address;
                constant_element->preset = preset;

                constant_element->next = NULL;
                constant_element->name = NULL;
                constant_element->data = NULL;
                constant_element->count = 0;

                if ( preset == 0 )
                {
                    constant_element->data = floats;
                    constant_element->count = count;
                }

                if ( shader_reply->irrShaderCallBack->pixel_constant_list == NULL )
                    shader_reply->irrShaderCallBack->pixel_constant_list = constant_element;
                else
                {
                    constant_element->next = shader_reply->irrShaderCallBack->pixel_constant_list;
                    shader_reply->irrShaderCallBack->pixel_constant_list = constant_element;
                }
            }
            else printf( "A constant could not be allocated\n" );
	    }
		else printf( "Addressed variables are added to low level assembler shaders\n" );
	}
	else printf( "A shader was not supplied\n" );

	return result;
}


/* ----------------------------------------------------------------------------
Adds a new material renderer to the VideoDriver, based on a high level shading
language. Currently only HLSL/D3D9 and GLSL/OpenGL is supported.

 vertexShaderProgram:
	String containing the source of the vertex shader program. This can be 0 if
	no vertex program shall be used.
 vertexShaderEntryPointName:
	Name of the entry function of the vertexShaderProgram
 vsCompileTarget:
	Vertex shader version where the high level shader shall be compiled to.
 pixelShaderProgram:
	String containing the source of the pixel shader program. This can be 0 if
	no pixel shader shall be used.
 pixelShaderEntryPointName:
	Entry name of the function of the pixelShaderEntryPointName
 psCompileTarget:
	Pixel shader version where the high level shader shall be compiled to.
 baseMaterial:
	Base material which renderstates will be used to shade the material.

Return:
	Returns a structure referening this object or NULL upon error. e.g. if a
	vertex or pixel shader program could not be compiled or a compile target is
	not reachable.
*/
tShaderReply * DLL_EXPORT IrrAddHighLevelShaderMaterial (
		const char * vertexShaderProgram,
		const char *  vertexShaderEntryPointName,
		unsigned int vertexShaderProgramType,
		const char * pixelShaderProgram,
		const char *  pixelShaderEntryPointName,
		unsigned int pixelShaderProgramType,
		unsigned int materialType
)
{
	tShaderReply *			shader_reply = NULL;

	/* call the function to created the shader material */
	video::IGPUProgrammingServices* gpu = driver->getGPUProgrammingServices();
	if (gpu)
	{
		shader_reply = new tShaderReply;
		if ( shader_reply )
		{
			shader_reply->irrShaderCallBack = new CIrrShaderCallBack;
			shader_reply->irrShaderCallBack->UseHighLevelShaders = true;

			if (( shader_reply->material_type = gpu->addHighLevelShaderMaterial (
					vertexShaderProgram,
					vertexShaderEntryPointName,
					(E_VERTEX_SHADER_TYPE)vertexShaderProgramType,
					pixelShaderProgram,
					pixelShaderEntryPointName,
					(E_PIXEL_SHADER_TYPE)pixelShaderProgramType,
					shader_reply->irrShaderCallBack,
					(E_MATERIAL_TYPE)materialType,
					0 )) == -1 )
			{
				delete shader_reply->irrShaderCallBack;
				delete shader_reply;
				shader_reply = NULL;
			}
			else
			{
				/* add the new shader to the list of shaders so that it and all of its associated
				objects can be properly deleted when the system is shut down */
				if ( shader_list == NULL )
				{
					shader_reply->next_shader = NULL;
					shader_list = shader_reply;
				}
				else
				{
					shader_reply->next_shader = shader_list;
					shader_list = shader_reply;
				}
			}
		}
	}
	return shader_reply;
}


/* ----------------------------------------------------------------------------
Identical to IrrAddHighLevelShaderMaterial only this varient attempts to load
the GPU programs from file.
*/
tShaderReply * DLL_EXPORT IrrAddHighLevelShaderMaterialFromFiles (
		const char * vertexShaderProgramFileName,
		const char *  vertexShaderEntryPointName,
		unsigned int vertexShaderProgramType,
		const char * pixelShaderProgramFileName,
		const char *  pixelShaderEntryPointName,
		unsigned int pixelShaderProgramType,
		unsigned int materialType
)
{
	tShaderReply *			shader_reply = NULL;

	/* call the function to created the shader material */
	video::IGPUProgrammingServices* gpu = driver->getGPUProgrammingServices();
	if (gpu)
	{
		shader_reply = new tShaderReply;
		if ( shader_reply )
		{
			shader_reply->irrShaderCallBack = new CIrrShaderCallBack;
			shader_reply->irrShaderCallBack->UseHighLevelShaders = true;

			if (( shader_reply->material_type = gpu->addHighLevelShaderMaterialFromFiles (
					vertexShaderProgramFileName,
					vertexShaderEntryPointName,
					(E_VERTEX_SHADER_TYPE)vertexShaderProgramType,
					pixelShaderProgramFileName,
					pixelShaderEntryPointName,
					(E_PIXEL_SHADER_TYPE)pixelShaderProgramType,
					shader_reply->irrShaderCallBack,
					(E_MATERIAL_TYPE)materialType,
					0 )) == -1 )
			{
				delete shader_reply->irrShaderCallBack;
				delete shader_reply;
				shader_reply = NULL;
			}
			else
			{
				/* add the new shader to the list of shaders so that it and all of its associated
				objects can be properly deleted when the system is shut down */
				if ( shader_list == NULL )
				{
					shader_reply->next_shader = NULL;
					shader_list = shader_reply;
				}
				else
				{
					shader_reply->next_shader = shader_list;
					shader_list = shader_reply;
				}
			}
		}
	}
	return shader_reply;
}


/* ----------------------------------------------------------------------------
Adds a new material renderer to the VideoDriver, using pixel and/or vertex
shaders to render geometry. Note that it is a good idea to call
IVideoDriver::queryFeature() before to check if the IVideoDriver supports the
vertex and/or pixel shader version your are using. The material is added to the
VideoDriver like with IVideoDriver::addMaterialRenderer() and can be used like
it had been added with that method.

vertexShaderProgram:
	String containing the source of the vertex shader program. This can be 0 if
	no vertex program shall be used. For DX8 programs, the will always input
	registers look like this: v0: position, v1: normal, v2: color, v3: texture
	cooridnates, v4: texture coordinates 2 if available. For DX9 programs, you
	can manually set the registers using the dcl_ statements.
pixelShaderProgram:
	String containing the source of the pixel shader program. This can be 0 if
	you don't want to use a pixel shader.
callback:
	Pointer to an implementation of IShaderConstantSetCallBack in which you can
	set the needed vertex and pixel shader program constants. Set this to 0 if you don't need this.
baseMaterial:
	Base material which renderstates will be used to shade the material.

Returns:
	Returns the number of the material type which can be set in
	SMaterial::MaterialType to use the renderer. -1 is returned if an error
	occured. -1 is returned for example if a vertex or pixel shader program
	could not be compiled
*/
tShaderReply * DLL_EXPORT IrrAddShaderMaterial  (
		const char *  vertexShaderProgram,
		const char *  pixelShaderProgram,
		unsigned int materialType
)
{
	tShaderReply *			shader_reply = NULL;

	/* call the function to created the shader material */
	video::IGPUProgrammingServices* gpu = driver->getGPUProgrammingServices();
	if (gpu)
	{
		shader_reply = new tShaderReply;
		if ( shader_reply )
		{
			shader_reply->irrShaderCallBack = new CIrrShaderCallBack;
			shader_reply->irrShaderCallBack->UseHighLevelShaders = false;

			if (( shader_reply->material_type = gpu->addShaderMaterial(
					vertexShaderProgram,
					pixelShaderProgram,
					shader_reply->irrShaderCallBack,
					(E_MATERIAL_TYPE)materialType,
					0 )) == -1 )
			{
				delete shader_reply->irrShaderCallBack;
				delete shader_reply;
				shader_reply = NULL;
			}
			else
			{
				/* add the new shader to the list of shaders so that it and all of its associated
				objects can be properly deleted when the system is shut down */
				if ( shader_list == NULL )
				{
					shader_reply->next_shader = NULL;
					shader_list = shader_reply;
				}
				else
				{
					shader_reply->next_shader = shader_list;
					shader_list = shader_reply;
				}
			}
		}
	}
	return shader_reply;
}


/* ----------------------------------------------------------------------------
Identical to IrraddShaderMaterial only this varient attempts to load the GPU
programs from file.
*/
tShaderReply * DLL_EXPORT IrrAddShaderMaterialFromFiles  (
		const char *  vertexShaderProgramFileName,
		const char *  pixelShaderProgramFileName,
		unsigned int materialType
)
{
	tShaderReply *			shader_reply = NULL;

	/* call the function to created the shader material */
	video::IGPUProgrammingServices* gpu = driver->getGPUProgrammingServices();
	if (gpu)
	{
		shader_reply = new tShaderReply;
		if ( shader_reply )
		{
			shader_reply->irrShaderCallBack = new CIrrShaderCallBack;
			shader_reply->irrShaderCallBack->UseHighLevelShaders = false;

			if (( shader_reply->material_type = gpu->addShaderMaterialFromFiles(
					vertexShaderProgramFileName,
					pixelShaderProgramFileName,
					shader_reply->irrShaderCallBack,
					(E_MATERIAL_TYPE)materialType,
					0 )) == -1 )
			{
				delete shader_reply->irrShaderCallBack;
				delete shader_reply;
				shader_reply = NULL;
			}
			else
			{
				/* add the new shader to the list of shaders so that it and all of its associated
				objects can be properly deleted when the system is shut down */
				if ( shader_list == NULL )
				{
					shader_reply->next_shader = NULL;
					shader_list = shader_reply;
				}
				else
				{
					shader_reply->next_shader = shader_list;
					shader_list = shader_reply;
				}
			}
		}
	}
	return shader_reply;
}

/* ////////////////////////////////////////////////////////////////////////////
all of the above functions are declared as C functions and are exposed without
any mangled names
*/
}
