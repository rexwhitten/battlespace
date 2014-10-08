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
unsigned int uiReadKeyEvent = 0;
unsigned int uiWriteKeyEvent = 0;
ARCHIVED_KEY_EVENT archivekey[MAX_ARCHIVED_EVENTS];

unsigned int uiReadMouseEvent = 0;
unsigned int uiWriteMouseEvent = 0;
ARCHIVED_MOUSE_EVENT archivemouse[MAX_ARCHIVED_EVENTS];

unsigned int uiReadGUIEvent = 0;
unsigned int uiWriteGUIEvent = 0;
ARCHIVED_GUI_EVENT archivegui[MAX_ARCHIVED_EVENTS];

ARCHIVED_KEY_EVENT keyblank = {0,0,0};
ARCHIVED_MOUSE_EVENT mouseblank = {0,0,0};
ARCHIVED_GUI_EVENT guiblank = {0,0,0};

wchar_t cptrSelectedFile[512];


/* ////////////////////////////////////////////////////////////////////////////
external variables
*/
extern IrrlichtDevice *device;
extern IVideoDriver* driver;
extern ISceneManager* smgr;
extern IGUIEnvironment* guienv;
extern StackedEventReceiver receiver;


/* ////////////////////////////////////////////////////////////////////////////
Class Function Declarations
*/

/* ----------------------------------------------------------------------------
This implementation of the Irrlicht event receiver receives events as they
happen and stores them in a circular buffer. the caller can then pop the
events out of the buffer at their convienence. if the events are unattended
and the buffer filled the oldest event is discarded
*/
bool StackedEventReceiver::OnEvent(const SEvent &event)
{
	const wchar_t *cptrFile;

    // arbitrate based on the type of event received
    switch ( event.EventType )
    {
    // Key strokes
    case EET_KEY_INPUT_EVENT:
		// archive the event information
		archivekey[uiWriteKeyEvent].uikey = (unsigned int)event.KeyInput.Key;
		archivekey[uiWriteKeyEvent].uidirection = (unsigned int)event.KeyInput.PressedDown;
		archivekey[uiWriteKeyEvent].uiflags =
				(unsigned int)event.KeyInput.Control * 2 +
				(unsigned int)event.KeyInput.Shift;

		// move to the next event buffer slot
		// if we have reached the end of the buffer
		if ( ++uiWriteKeyEvent >= MAX_ARCHIVED_EVENTS )
			// roll back to the start
			uiWriteKeyEvent = 0;

		// if the read and write positions are the same
		if ( uiReadKeyEvent == uiWriteKeyEvent )
		{
			// our buffer has overflowed, erase the oldest event
			// if we have reached the end of the buffer
			if ( ++uiReadKeyEvent >= MAX_ARCHIVED_EVENTS )
				// roll back to the start
				uiReadKeyEvent = 0;
		}

		// pass on the key event to the active camera
//			activeCamera = smgr->getActiveCamera();
//			if ( activeCamera )
//				activeCamera->OnEvent(event);
		break;

    // Mouse actions
    case EET_MOUSE_INPUT_EVENT:
		// archive the event information
		archivemouse[uiWriteMouseEvent].uiaction = (unsigned int)event.MouseInput.Event;
		archivemouse[uiWriteMouseEvent].fdelta = (float)event.MouseInput.Wheel;
		archivemouse[uiWriteMouseEvent].ix = (unsigned int)event.MouseInput.X;
		archivemouse[uiWriteMouseEvent++].iy = (unsigned int)event.MouseInput.Y;

		// if we have filled the buffer
		if ( uiWriteMouseEvent >= MAX_ARCHIVED_EVENTS )
			// roll back to the start
			uiWriteMouseEvent = 0;

		// pass on the key event to the active camera
//		activeCamera = smgr->getActiveCamera();
//		if ( activeCamera )
//			activeCamera->OnEvent(event);
		break;

	// GUI actions
    case EET_GUI_EVENT:
		// handle the event type
		switch(event.GUIEvent.EventType)
		{
		case EGET_SCROLL_BAR_CHANGED:
			// archive the event information
			archivegui[uiWriteGUIEvent].id = event.GUIEvent.Caller->getID();
			archivegui[uiWriteGUIEvent].event = (int)event.GUIEvent.EventType;
			archivegui[uiWriteGUIEvent].x = ((IGUIScrollBar*)event.GUIEvent.Caller)->getPos();
			uiWriteGUIEvent++;
			break;

        case EGET_ELEMENT_FOCUS_LOST:
        case EGET_ELEMENT_FOCUSED:
        case EGET_ELEMENT_HOVERED:
        case EGET_FILE_CHOOSE_DIALOG_CANCELLED:
			// archive the event information but dont consume the event
			archivegui[uiWriteGUIEvent].id = event.GUIEvent.Caller->getID();
			archivegui[uiWriteGUIEvent].event = (int)event.GUIEvent.EventType;
			uiWriteGUIEvent++;
			break;

		case EGET_BUTTON_CLICKED:
		case EGET_EDITBOX_ENTER:
		case EGET_EDITBOX_CHANGED:
			// archive the event information
			archivegui[uiWriteGUIEvent].id = event.GUIEvent.Caller->getID();
			archivegui[uiWriteGUIEvent].event = (int)event.GUIEvent.EventType;
			uiWriteGUIEvent++;
			break;

		case EGET_CHECKBOX_CHANGED:
			// archive the event information
			archivegui[uiWriteGUIEvent].id = event.GUIEvent.Caller->getID();
			archivegui[uiWriteGUIEvent].event = (int)event.GUIEvent.EventType;
			archivegui[uiWriteGUIEvent].x = ((IGUICheckBox*)event.GUIEvent.Caller)->isChecked();
			uiWriteGUIEvent++;
			break;

		case EGET_LISTBOX_CHANGED:
		case EGET_LISTBOX_SELECTED_AGAIN:
			// archive the event information
			archivegui[uiWriteGUIEvent].id = event.GUIEvent.Caller->getID();
			archivegui[uiWriteGUIEvent].event = (int)event.GUIEvent.EventType;
			archivegui[uiWriteGUIEvent].x = ((IGUIListBox*)event.GUIEvent.Caller)->getSelected();
			uiWriteGUIEvent++;
			break;

		case EGET_FILE_SELECTED:
			// archive the event information
			cptrFile = ((IGUIFileOpenDialog*)event.GUIEvent.Caller)->getFileName();
			if ( cptrFile ) wcscpy( cptrSelectedFile, cptrFile );
			archivegui[uiWriteGUIEvent].id = event.GUIEvent.Caller->getID();
			archivegui[uiWriteGUIEvent].event = (int)event.GUIEvent.EventType;
			uiWriteGUIEvent++;
			// allow the system to handle the event too
			break;

		default:
			break;
		}

        // if we have filled the buffer
        if ( uiWriteGUIEvent >= MAX_ARCHIVED_EVENTS )
            // roll back to the start
            uiWriteGUIEvent = 0;
		break;

    // these events are not archived at this time
    case EET_LOG_TEXT_EVENT:
    case EET_USER_EVENT:
        break;
    }
    // consume all events
    return false;
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
INPUT EVENT OPERATIONS
*/
/* ----------------------------------------------------------------------------
determine if a key event is available return true if one is
*/
bool DLL_EXPORT IrrKeyEventAvailable( void )
{
    return ( uiReadKeyEvent != uiWriteKeyEvent );
}

/* ----------------------------------------------------------------------------
read the oldest key event in the buffer
*/
ARCHIVED_KEY_EVENT *DLL_EXPORT IrrReadKeyEvent( void )
{
    ARCHIVED_KEY_EVENT *report;

    // if there are any events evailable
    if ( uiReadKeyEvent != uiWriteKeyEvent )
    {
        // return the oldest event
        report = &archivekey[uiReadKeyEvent];

        // consume the event and if we exceed the buffer
        if ( ++uiReadKeyEvent >= MAX_ARCHIVED_EVENTS )
            // roll back to the start
            uiReadKeyEvent = 0;
    }
    else
        // there are no events available return a blank object
        report = &keyblank;

    return report;
}

/* ----------------------------------------------------------------------------
discover if a mouse event is available return true if one is
*/
bool DLL_EXPORT IrrMouseEventAvailable( void )
{
    return ( uiReadMouseEvent != uiWriteMouseEvent );
}

/* ----------------------------------------------------------------------------
read the oldest mouse event in the buffer
*/
ARCHIVED_MOUSE_EVENT *DLL_EXPORT IrrReadMouseEvent( void )
{
    ARCHIVED_MOUSE_EVENT *report;

    // if there are any events available
    if ( uiReadMouseEvent != uiWriteMouseEvent )
    {
        // return the oldest event
        report = &archivemouse[uiReadMouseEvent];

        // consume the event and if we exceed the buffer
        if ( ++uiReadMouseEvent >= MAX_ARCHIVED_EVENTS )
            // roll back to the start
            uiReadMouseEvent = 0;
    }
    else
        // there are no evente available return a blank object
        report = &mouseblank;

    return report;
}

/* ----------------------------------------------------------------------------
determine whether the GUI consumes events or not
*/
void DLL_EXPORT IrrGUIEvents( bool gui )
{
	// Redundant
}

/* ----------------------------------------------------------------------------
determine if a GUI event is available return true if one is
*/
bool DLL_EXPORT IrrGUIEventAvailable( void )
{
    return ( uiReadGUIEvent != uiWriteGUIEvent );
}

/* ----------------------------------------------------------------------------
read the oldest GUI event in the buffer
*/
ARCHIVED_GUI_EVENT *DLL_EXPORT IrrReadGUIEvent( void )
{
    ARCHIVED_GUI_EVENT *report;

    // if there are any events evailable
    if ( uiReadGUIEvent != uiWriteGUIEvent )
    {
        // return the oldest event
        report = &archivegui[uiReadGUIEvent];

        // consume the event and if we exceed the buffer
        if ( ++uiReadGUIEvent >= MAX_ARCHIVED_EVENTS )
            // roll back to the start
            uiReadGUIEvent = 0;
    }
    else
        // there are no events available return a blank object
        report = &guiblank;

    return report;
}

/* ----------------------------------------------------------------------------
return the file select buffer
*/
const wchar_t * DLL_EXPORT IrrGetLastSelectedFile( void )
{
	return cptrSelectedFile;
}

/* ----------------------------------------------------------------------------
show and hide the mouse pointer
*/
void DLL_EXPORT IrrDisplayMouse( bool boShow )
{
	device->getCursorControl()->setVisible(boShow);
}

/* ----------------------------------------------------------------------------
set the position of the mouse pointer and return the relative change in position
*/
void DLL_EXPORT IrrSetMousePosition( float &x, float &y )
{
	core::position2d<f32> cursor = device->getCursorControl()->getRelativePosition();
	device->getCursorControl()->setPosition( x, y );
	x = cursor.X;
	y = cursor.Y;
}

/* ----------------------------------------------------------------------------
Gets the absoloute position of the mouse pointer.
*/
void DLL_EXPORT IrrGetAbsoluteMousePosition( int &x, int &y )
{
    irr::core::position2d<s32> cursor = device->getCursorControl()->getPosition();
    x = cursor.X;
    y = cursor.Y;
}

/* ////////////////////////////////////////////////////////////////////////////
all of the above functions are declared as C functions and are exposed without
any mangled names
*/
}
