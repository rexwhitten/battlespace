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
FILING SYSTEM FUNCTIONS
*/
/* ----------------------------------------------------------------------------
add zip archive to the filing system allowing you to load files straight out of
the zip file.
*/
void DLL_EXPORT IrrAddZipFile( char *cptrFile, bool boIgnoreCase, bool boIgnorePaths )
{
    // add an archive to the file system
    device->getFileSystem()->addZipFileArchive( cptrFile, boIgnoreCase, boIgnorePaths);
}

/* ----------------------------------------------------------------------------
set irrlicht current working directory
*/
void DLL_EXPORT IrrChangeWorkingDirectory( char *cptrPath )
{
    // Changes the current Working Directory to the overgiven string.
    device->getFileSystem()->changeWorkingDirectoryTo( cptrPath );
}

/* ----------------------------------------------------------------------------
get irrlicht current working directory
*/
const char * DLL_EXPORT IrrGetWorkingDirectory( void )
{
    // Returns the string of the current working directory.
    return device->getFileSystem()->getWorkingDirectory().c_str();
}


/* ////////////////////////////////////////////////////////////////////////////
all of the above functions are declared as C functions and are exposed without
any mangled names
*/
}
