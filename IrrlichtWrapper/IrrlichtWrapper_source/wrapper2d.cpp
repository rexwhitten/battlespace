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


#define BLEND_SCREEN        0
#define BLEND_ADD           1
#define BLEND_SUBTRACT      2
#define BLEND_MULTIPLY      3
#define BLEND_DIVIDE        4


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
2D FUNCTIONS
*/

/* ----------------------------------------------------------------------------
sets texture creation flags
*/
void DLL_EXPORT IrrSetTextureCreationFlag( E_TEXTURE_CREATION_FLAG flag, bool value )
{
	driver->setTextureCreationFlag( flag, value );
}

/* ----------------------------------------------------------------------------
load an image object (this does not use video memory)
*/
void * DLL_EXPORT IrrGetImage( char *cptrFile )
{
    return (void *)driver->createImageFromFile (cptrFile);
}

/* ----------------------------------------------------------------------------
load a texture object
*/
void * DLL_EXPORT IrrGetTexture( char *cptrFile )
{
	return (void *)driver->getTexture( cptrFile );
}

/* ----------------------------------------------------------------------------
create a texture that is suitable for the scene manager to use as a surface to
which it can render its 3d objects
*/
ITexture * DLL_EXPORT IrrCreateRenderTargetTexture( int x, int y )
{
	// create render target
	video::ITexture* renderTexture = 0;

	if ( driver->queryFeature( EVDF_RENDER_TO_TARGET ))
	{
		renderTexture = driver->addRenderTargetTexture ( dimension2d<u32>( x, y ));
	}

	return renderTexture;
}

/* ----------------------------------------------------------------------------
create a blank texture
*/
ITexture * DLL_EXPORT IrrCreateTexture( char *name, int x, int y, ECOLOR_FORMAT format )
{
	return driver->addTexture(  dimension2d< u32 >( x, y ), name, format );
}


/* ----------------------------------------------------------------------------
create a blank image
*/
IImage * DLL_EXPORT IrrCreateImage( int x, int y, ECOLOR_FORMAT format )
{
	return driver->createImage(  format, dimension2d< u32 >( x, y ) );
}


/* ----------------------------------------------------------------------------
removes a texture freeing the resources it used
*/
void DLL_EXPORT IrrRemoveTexture( video::ITexture *texture )
{
	driver->removeTexture( texture );
}

/* ----------------------------------------------------------------------------
removes an image freeing the resources it used
*/
void DLL_EXPORT IrrRemoveImage( video::IImage *image )
{
		image->drop();
}

/* ----------------------------------------------------------------------------
locks the texture and returns a pointer to the pixels
*/
void * DLL_EXPORT IrrLockTexture( video::ITexture *texture )
{
	return (void *)texture->lock();
}

/* ----------------------------------------------------------------------------
unlock the texture, presumably after it has been modified and recreate the
mipmap levels
*/
void DLL_EXPORT IrrUnlockTexture( video::ITexture *texture )
{
	texture->unlock();
	texture->regenerateMipMapLevels();
}

/* ----------------------------------------------------------------------------
locks the image and returns a pointer to the pixels
*/
void * DLL_EXPORT IrrLockImage( video::IImage *image )
{
	return (void *)image->lock();
}

/* ----------------------------------------------------------------------------
unlock the image, presumably after it has been modified and recreate the
mipmap levels
*/
void DLL_EXPORT IrrUnlockImage( video::IImage *image )
{
	image->unlock();
}

/* ----------------------------------------------------------------------------
locks the texture and returns a pointer to the pixels
*/
/*
void * DLL_EXPORT IrrLockOpenGLTexture( video::ITexture *texture )
{
    //bind the texture
    glBindTexture(GL_TEXTURE_2D, TextureName);

    //get the subimage
    glGetTexImage(GL_TEXTURE_2D, 0, format, GL_BYTE, ImageData);

	return (void *)texture->lock();
}
*/

/* ----------------------------------------------------------------------------
create a normal map from a grayscale heightmap texture
*/
void DLL_EXPORT IrrMakeNormalMapTexture( video::ITexture *texture, float amplitude )
{
    driver->makeNormalMapTexture ( texture, amplitude );

}

/* ----------------------------------------------------------------------------
blend the source texture into the destination texture to create a single texture
*/
int DLL_EXPORT IrrBlendTextures(
								 video::ITexture *texturedest,
								 video::ITexture *texturesrc,
								 int xoffset,
								 int yoffset,
								 int operation )
{
	int fromx, fromy, tox, toy, columns, rows;
	int pixeldest, rdest, gdest, bdest, adest;
	int pixelsrc, rsrc, gsrc, bsrc, asrc;
	int blenderrorcode = 0;		/* no error */

	/* determine the texture metrics */
	ECOLOR_FORMAT formatdest = texturedest->getColorFormat();
	ECOLOR_FORMAT formatsrc = texturesrc->getColorFormat();

	/* the textures must be of compatible formats */
	if ( formatdest == formatsrc )
	{
		/* the textures must be 32 bit format at the moment */
		if ( formatdest == ECF_A8R8G8B8 )
		{
			/* determine the boundaries of the operation */
			const dimension2d<u32>*sizedest = &texturedest->getSize();
			const dimension2d<u32>*sizesrc = &texturedest->getSize();
			fromx = xoffset;
			fromy = yoffset;
			tox = sizesrc->Width;
			toy = sizesrc->Height;

			/* lock the textures and get their surfaces */
			unsigned int *pixelsdest = (unsigned int *)texturedest->lock();
			unsigned int *pixelssrc = (unsigned int *)texturesrc->lock();

			/* perform the requested operation */
			switch( operation )
			{
			case BLEND_SCREEN:
				/* itterate texture pixel columns */
				for ( columns = fromy; columns < toy; columns++ )
				{
					/* itterate a row of pixels */
					for ( rows = fromx; rows < tox; rows++ )
					{
						/* extract the pixels */
						pixeldest = *pixelsdest;
						rdest = (pixeldest >> 24 );
						gdest = (pixeldest >> 16 ) & 0xFF;
						bdest = (pixeldest >>  8 ) & 0xFF;
						adest = (pixeldest       ) & 0xFF;

						pixelsrc = *pixelssrc;
						rsrc = (pixelsrc >> 24 );
						gsrc = (pixelsrc >> 16 ) & 0xFF;
						bsrc = (pixelsrc >>  8 ) & 0xFF;
						asrc = (pixelsrc       ) & 0xFF;

						/* blend the pixels */
						rdest = 255 - ((255 - rsrc )*(255 - rdest)/255);
						gdest = 255 - ((255 - gsrc )*(255 - gdest)/255);
						bdest = 255 - ((255 - bsrc )*(255 - bdest)/255);
						adest = 255 - ((255 - asrc )*(255 - adest)/255);

						/* write the destination pixel */
						*pixelsdest = (rdest << 24) + (gdest << 16) + (bdest << 8) + adest;

						/* next pixels */
						pixelsdest++;
						pixelssrc++;
					}
				}
				break;

				/* pixel color values are added together overbright areas are clipped to white */
			case BLEND_ADD:
				/* itterate texture pixel columns */
				for ( columns = fromy; columns < toy; columns++ )
				{
					/* itterate a row of pixels */
					for ( rows = fromx; rows < tox; rows++ )
					{
						/* extract the pixels */
						pixeldest = *pixelsdest;
						rdest = (pixeldest >> 24 );
						gdest = (pixeldest >> 16 ) & 0xFF;
						bdest = (pixeldest >>  8 ) & 0xFF;
						adest = (pixeldest       ) & 0xFF;

						pixelsrc = *pixelssrc;
						rsrc = (pixelsrc >> 24 );
						gsrc = (pixelsrc >> 16 ) & 0xFF;
						bsrc = (pixelsrc >>  8 ) & 0xFF;
						asrc = (pixelsrc       ) & 0xFF;

						/* blend the pixels */
						rdest = rsrc + rdest; if ( rdest > 255 ) rdest = 255;
						gdest = gsrc + gdest; if ( gdest > 255 ) gdest = 255;
						bdest = bsrc + bdest; if ( bdest > 255 ) bdest = 255;
						adest = asrc + adest; if ( adest > 255 ) adest = 255;

						/* write the destination pixel */
						*pixelsdest = (rdest << 24) + (gdest << 16) + (bdest << 8) + adest;

						/* next pixels */
						pixelsdest++;
						pixelssrc++;
					}
				}
				break;

				/* pixel color values are subtracted under dark areas are clipped to white */
			case BLEND_SUBTRACT:
				/* itterate texture pixel columns */
				for ( columns = fromy; columns < toy; columns++ )
				{
					/* itterate a row of pixels */
					for ( rows = fromx; rows < tox; rows++ )
					{
						/* extract the pixels */
						pixeldest = *pixelsdest;
						rdest = (pixeldest >> 24 );
						gdest = (pixeldest >> 16 ) & 0xFF;
						bdest = (pixeldest >>  8 ) & 0xFF;
						adest = (pixeldest       ) & 0xFF;

						pixelsrc = *pixelssrc;
						rsrc = (pixelsrc >> 24 );
						gsrc = (pixelsrc >> 16 ) & 0xFF;
						bsrc = (pixelsrc >>  8 ) & 0xFF;
						asrc = (pixelsrc       ) & 0xFF;

						/* blend the pixels */
						rdest = rsrc - rdest; if ( rdest < 0 ) rdest = 0;
						gdest = gsrc - gdest; if ( gdest < 0 ) gdest = 0;
						bdest = bsrc - bdest; if ( bdest < 0 ) bdest = 0;
						adest = asrc - adest; if ( adest < 0 ) adest = 0;

						/* write the destination pixel */
						*pixelsdest = (rdest << 24) + (gdest << 16) + (bdest << 8) + adest;

						/* next pixels */
						pixelsdest++;
						pixelssrc++;
					}
				}
				break;

			case BLEND_MULTIPLY:
				/* itterate texture pixel columns */
				for ( columns = fromy; columns < toy; columns++ )
				{
					/* itterate a row of pixels */
					for ( rows = fromx; rows < tox; rows++ )
					{
						/* extract the pixels */
						pixeldest = *pixelsdest;
						rdest = (pixeldest >> 24 );
						gdest = (pixeldest >> 16 ) & 0xFF;
						bdest = (pixeldest >>  8 ) & 0xFF;
						adest = (pixeldest       ) & 0xFF;

						pixelsrc = *pixelssrc;
						rsrc = (pixelsrc >> 24 );
						gsrc = (pixelsrc >> 16 ) & 0xFF;
						bsrc = (pixelsrc >>  8 ) & 0xFF;
						asrc = (pixelsrc       ) & 0xFF;

						/* blend the pixels */
						rdest = (rsrc * rdest) / 255;
						gdest = (gsrc * gdest) / 255;
						bdest = (bsrc * bdest) / 255;
						adest = (asrc * adest) / 255;

						/* write the destination pixel */
						*pixelsdest = (rdest << 24) + (gdest << 16) + (bdest << 8) + adest;

						/* next pixels */
						pixelsdest++;
						pixelssrc++;
					}
				}
				break;

			case BLEND_DIVIDE:
				/* itterate texture pixel columns */
				for ( columns = fromy; columns < toy; columns++ )
				{
					/* itterate a row of pixels */
					for ( rows = fromx; rows < tox; rows++ )
					{
						/* extract the pixels */
						pixeldest = *pixelsdest;
						rdest = (pixeldest >> 24 );
						gdest = (pixeldest >> 16 ) & 0xFF;
						bdest = (pixeldest >>  8 ) & 0xFF;
						adest = (pixeldest       ) & 0xFF;

						pixelsrc = *pixelssrc;
						rsrc = (pixelsrc >> 24 );
						gsrc = (pixelsrc >> 16 ) & 0xFF;
						bsrc = (pixelsrc >>  8 ) & 0xFF;
						asrc = (pixelsrc       ) & 0xFF;

						/* blend the pixels */
						if ( rsrc > 0 ) rdest = rdest / rsrc; else rdest = 255;
						if ( gsrc > 0 ) gdest = gdest / gsrc; else gdest = 255;
						if ( bsrc > 0 ) bdest = bdest / bsrc; else bdest = 255;
						if ( asrc > 0 ) adest = adest / asrc; else adest = 255;

						/* write the destination pixel */
						*pixelsdest = (rdest << 24) + (gdest << 16) + (bdest << 8) + adest;

						/* next pixels */
						pixelsdest++;
						pixelssrc++;
					}
				}
				break;
			}

			/* the blend is complete unlock the texture surfaces */
			texturedest->unlock();
			texturesrc->unlock();

			/* regenerate mip map levels in the modified destination texture */
			texturedest->regenerateMipMapLevels();
		}
		else
			/* unsupported texture format, must be 32bit */
			blenderrorcode = 2;
	}
	else
		/* incompatible texture types */
		blenderrorcode = 1;

	return blenderrorcode;
}

/* ----------------------------------------------------------------------------
color key the image making parts of it transparent
*/
void DLL_EXPORT IrrColorKeyTexture( video::ITexture *texture, int red, int green, int blue )
{
	driver->makeColorKeyTexture(texture, video::SColor(255, 255, 255, 255));
}

/* ----------------------------------------------------------------------------
draw the image to the screen
*/
void DLL_EXPORT IrrDraw2DImage(
                                video::ITexture *texture,
                                int iX, int iY )
{
    driver->draw2DImage(texture, core::position2d<s32>(iX,iY));
}

/* ----------------------------------------------------------------------------
draw an image to the screen from a specified rectangle in the source image this
enables you to place lots of images into one texture for 2D drawing. in
addition this function also includes transparency and uses image alpha channels
*/
void DLL_EXPORT IrrDraw2DImageElement(
                                video::ITexture *texture,
                                int X, int Y,
                                int TX, int TY, int BX, int BY,
                                bool usealpha )
{
    driver->draw2DImage(
            texture,
            position2d< s32 >(X,Y),
            rect< s32 >(TX,TY,BX,BY),
            NULL,
            video::SColor( 255, 255, 255, 255),
            usealpha
    );
}

/* ----------------------------------------------------------------------------
draw an image to the screen from a specified rectangle in the source image  and
into a specified destination rectangle, scaling the image if nessecary.
*/
void DLL_EXPORT IrrDraw2DImageElementStretch(
                                video::ITexture *texture,
                                int dTX, int dTY, int dBX, int dBY,
                                int TX, int TY, int BX, int BY,
                                bool usealpha )
{
    driver->draw2DImage(
            texture,
            rect<s32>(dTX,dTY,dBX,dBY),
            rect<s32>(TX,TY,BX,BY),
            NULL,
            NULL,
            usealpha
    );
}

/* ----------------------------------------------------------------------------
load a bitmap based font
*/
void *DLL_EXPORT IrrGetFont( char * font )
{
    return device->getGUIEnvironment()->getFont( font );
}

/* ----------------------------------------------------------------------------
draw text to the display using a bitmap font
*/
void DLL_EXPORT Irr2DFontDraw( IGUIFont* font, const wchar_t * wcptrText, int tx, int ty, int bx, int by )
{
    font->draw( wcptrText, core::rect<s32>(tx,ty,bx,by), video::SColor(255,255,255,255));
}


/* ----------------------------------------------------------------------------
save a screenshot out to a file
*/
void DLL_EXPORT IrrSaveScreenShot( const char * file )
{
	IImage* screenshot = driver->createScreenShot();
	if ( screenshot )
	{
		device->getVideoDriver()->writeImageToFile( screenshot, file );
		screenshot->drop();
	}
}

/* ----------------------------------------------------------------------------
grab a screenshot into a texture
*/
ITexture * DLL_EXPORT IrrGetScreenShot( u32 X, u32 Y, u32 W, u32 H )
{
    // grab the screenshot
	IImage *image = driver->createScreenShot();

	// create an image of the same size as the texture
	IImage *transitionImage = driver->createImage( image->getColorFormat(), dimension2d< u32 >( W, H ));

    // copy the pixels from the screenshot to the texture sized image
	image->copyTo( transitionImage, position2d<s32>(0,0), rect<s32>(X,Y,X+W,Y+H));

    // create a texture from the texture sized image
	return driver->addTexture("screenshot", transitionImage);
}

/* ----------------------------------------------------------------------------
get information on a texture
*/
void DLL_EXPORT IrrGetTextureInformation( ITexture * texture, u32 &X, u32 &Y, u32 &pitch, ECOLOR_FORMAT &format )
{
    core::dimension2d< u32 > size = texture->getSize();
    X = size.Width;
    Y = size.Height;
    pitch = texture->getPitch();
    format = texture->getColorFormat();
}

/* ----------------------------------------------------------------------------
get information on a image
*/
void DLL_EXPORT IrrGetImageInformation( IImage * image, u32 &X, u32 &Y, u32 &pitch, ECOLOR_FORMAT &format )
{
    core::dimension2d< u32 > size = image->getDimension();
    X = size.Width;
    Y = size.Height;
    pitch = image->getPitch();
    format = image->getColorFormat();
}


/* ////////////////////////////////////////////////////////////////////////////
all of the above functions are declared as C functions and are exposed without
any mangled names
*/
}
