/* ////////////////////////////////////////////////////////////////////////////
includes
*/
#include "irrlichtwrapper.h"
#include "CLODSceneNode.h"

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

// add to namespace
namespace irr
{
namespace scene
{

CLODSceneNode::CLODSceneNode(ISceneNode* parent, s32 id ): ISceneNode(parent, smgr, id)
{
    callback = NULL;
    fadeScale = 1;
	useAlpha = true;

	int i;
	for ( i = 0; i < EMT_TRANSPARENT_ADD_ALPHA_CHANNEL+1; i++ )
	{
		matmap[i] = EMT_TRANSPARENT_VERTEX_ALPHA;
	}
}

CLODSceneNode::~CLODSceneNode()
{
}

//add a child lod node
void CLODSceneNode::addChild(ISceneNode* child)
{
	ISceneNode::addChild(child);

/*
	case ESNT_WATER_SURFACE:
	case ESNT_SKY_BOX:
	case ESNT_SHADOW_VOLUME:
	case ESNT_EMPTY:
	case ESNT_DUMMY_TRANSFORMATION:
	case ESNT_PARTICLE_SYSTEM:
	case ESNT_CAMERA:
	case ESNT_CAMERA_MAYA:
	case ESNT_CAMERA_FPS:
	case ESNT_LIGHT:
	case ESNT_BILLBOARD:
	case ESNT_ANIMATED_MESH:
	case ESNT_CUBE:
	case ESNT_SPHERE:
	case ESNT_TEXT:
	case ESNT_OCTREE:
	case ESNT_MESH:
	case ESNT_TERRAIN:
	case ESNT_MD3_SCENE_NODE:
	case ESNT_UNKNOWN:
*/
    // add a link to this node
    SChildLink link;
    link.node = child;
    link.lod = 0;
    children.push_back(link);
}

// remove a child node from the LOD manager
bool CLODSceneNode::removeChild(ISceneNode* child)
{
	// remove this child
	SChildLink childLink;
	childLink.node = child;
	s32 p = children.linear_search(childLink);
	if (p!=-1)
	{
		// remove it
		children.erase(p);
	}

	return ISceneNode::removeChild(child);
}

// add a mesh to be displayed from a specific distance
void CLODSceneNode::AddLODMesh( float distance, IAnimatedMesh *mesh )
{
	// add the lod structure to the array of lods
	SLOD lod;
	lod.mesh = mesh;
	lod.distance = distance;
	lods.push_back(lod);
}

// set a material mapping
void CLODSceneNode::SetMaterialMapping( E_MATERIAL_TYPE source, E_MATERIAL_TYPE target )
{
	matmap[source] = target;
}

// animated the node, nothing special here
void CLODSceneNode::OnAnimate(u32 timeMs)
{
	// animate children
	ISceneNode::OnAnimate(timeMs);
}


// registering the scene node for rendering, here we take the opportunity
// to make LOD adjustments to child nodes
void CLODSceneNode::OnRegisterSceneNode()
{
	//if this node is invisible forget any child nodes
	if (!IsVisible)
		return;

	// get a timer to calculate the amount to fade objects
	u32 time = device->getTimer()->getTime();

	// get the camera position
	ICameraSceneNode* cam = smgr->getActiveCamera();
	core::vector3df vectorCam = cam->getAbsolutePosition();

	// loop through all child nodes
	u32 i,j;
	u32 lod, fade;
	SMaterial * material;
	for (i=0; i < children.size(); ++i)
	{
		// get the node associated with this link
		SChildLink &child = children[i];
		IAnimatedMeshSceneNode *node = (IAnimatedMeshSceneNode *)child.node;

		// calculate the distance to the node. at the moment we do this the
		// slow linear way instead of using the distance squared method
		core::vector3df vectorNode = node->getAbsolutePosition();
		float distance = vectorNode.getDistanceFrom( vectorCam );

		// itterate through all of the LOD levels and find the lod distance
		// that is appropriate for this distance
		lod = 0xFFFFFFFF;
		for (j=0; j < lods.size(); ++j)
		{
			if ( distance >= lods[j].distance )
			{
				lod = j;
			}
		}

        // if a LOD level was found
		if ( lod != 0xFFFFFFFF )
		{
            // if this lod is associated with a mesh
            if ( lods[lod].mesh )
            {
                // if this lod differs from the child lod
                if ( lod != children[i].lod )
                {
                    children[i].lod = lod;

                    // if the node is an animated mesh node
                    if ( ( node->getType()) == ESNT_ANIMATED_MESH )
                    {
                        // set the new mesh to be used
                        node->setMeshClean( lods[lod].mesh );
                    }
                }
                // handle instances where the node is faded
                switch ( children[i].mode )
                {
                    case LOD_INVISIBLE:
                        // make the node visible
                        node->setVisible( true );
                        children[i].mode = LOD_FADE_IN;
                        children[i].fade = time;
                    break;

                    // we are partially faded we need to fade back in
                    case LOD_FADE_IN:
                        // fade the node in by 1 multiplied by the time passed
                        fade = (time - children[i].fade) / fadeScale;
                        if ( fade > 0xFF ) fade = 0xFF;

                        // if the node is fully opaque again
                        if ( fade == 0xFF )
                        {
                            // restore the origonal material type
                            node->setMaterialType(children[i].matType);
                            children[i].mode = LOD_OPAQUE;
                            if ( callback ) callback( true, node );
                        }

                        // fade the node through its materials
                        fade *= 0x01010101;
                        material = &node->getMaterial( 0 );
						if ( useAlpha )
						{
							material->DiffuseColor.set( fade );
							material->AmbientColor.set( fade );
						}
						else
						{
							material->DiffuseColor.set( fade & 0xFFFFFF );
							material->AmbientColor.set( fade & 0xFFFFFF );
						}

                    break;

					// we were in the process of fading out
					case LOD_FADE_OUT:
						children[i].fade = time - ( 0xFF * fadeScale - ( time - children[i].fade ));
						children[i].mode = LOD_FADE_IN;
					break;
                }
            }
			else
			{
                // we have a lod without a mesh, this is an instruction to fade
			    switch ( children[i].mode )
			    {
			        // the node is fully opaque start fading
			        case LOD_OPAQUE:
                        children[i].mode = LOD_FADE_OUT;
                        children[i].fade = time;

						// note the material type
                        children[i].matType = node->getMaterial(0).MaterialType;

						// set the material type based on mapping
						node->setMaterialType( matmap[children[i].matType] );
                    //break;

                    // the node is in the process of fading
                    case LOD_FADE_OUT:
                        // fade the node out by 1 multiplied by the time passed
                        fade = (time - children[i].fade) / fadeScale;
                        if ( fade > 0xFF ) fade = 0xFF;

                        // if the node is fully transparent
                        if ( fade == 0xFF )
                        {
                            // make it completely invisible
                            node->setVisible( false );
                            children[i].mode = LOD_INVISIBLE;
                            if ( callback ) callback( false, node );
                        }

                        // fade the node through its materials
						fade *= 0x01010101;
                        fade = 0xFFFFFFFF - fade;
                        material = &node->getMaterial( 0 );
						if ( useAlpha )
						{
							material->DiffuseColor.set( fade );
							material->AmbientColor.set( fade );
						}
						else
						{
							material->DiffuseColor.set( fade & 0xFFFFFF );
							material->AmbientColor.set( fade & 0xFFFFFF );
						}

                    break;

					// we were in the process of fading in
					case LOD_FADE_IN:
						children[i].fade = time - ( 0xFF * fadeScale - ( time - children[i].fade ));
						children[i].mode = LOD_FADE_OUT;
					break;
			    } // switch
			}
		}
		else
		{
            // handle instances where the node is faded
            switch ( children[i].mode )
            {
                case LOD_INVISIBLE:
                    // make the node visible
                    node->setVisible( true );
                    children[i].mode = LOD_FADE_IN;
                    children[i].fade = time;
                    if ( callback ) callback( true, node );
                break;

                // we are partially faded we need to fade back in
                case LOD_FADE_IN:
                    // fade the node in by 1 multiplied by the time passed
                    fade = (time - children[i].fade) / fadeScale;
                    if ( fade > 255 ) fade = 255;

                    // if the node is fully opaque again
                    if ( fade == 0xFF )
                    {
                        // restore the origonal material type
                        node->setMaterialType(children[i].matType);
                        children[i].mode = LOD_OPAQUE;
                    }

                    // fade the node through its materials
					fade *= 0x01010101;
                    material = &node->getMaterial( 0 );
					if ( useAlpha )
					{
						material->DiffuseColor.set( fade );
						material->AmbientColor.set( fade );
					}
					else
					{
						material->DiffuseColor.set( fade & 0xFFFFFF );
						material->AmbientColor.set( fade & 0xFFFFFF );
					}

                break;

				// we were in the process of fading out
				case LOD_FADE_OUT:
					children[i].fade = time - ( 0xFF * fadeScale - ( time - children[i].fade ));
					children[i].mode = LOD_FADE_IN;
				break;
            }
		}
	}

	ISceneNode::OnRegisterSceneNode();
}


void CLODSceneNode::render()
{
    // Nothing to render for this node yet
}

const irr::core::aabbox3df& CLODSceneNode::getBoundingBox() const
{
	return Box;
}

} // scene
} // irr
