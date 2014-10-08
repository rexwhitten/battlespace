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
GUI FUNCTIONS
*/

/* ----------------------------------------------------------------------------
remove all GUI objects from the display
*/
void DLL_EXPORT IrrGUIClear( void )
{
	guienv->clear();
}

/* ----------------------------------------------------------------------------
remove a GUI object from the display
*/
void DLL_EXPORT IrrGUIRemove( IGUIElement *element )
{
	if ( element )
	{
		IGUIElement * parent = element->getParent();
		if ( parent ) parent->removeChild( element );
	}
}

/* ----------------------------------------------------------------------------
gets gui object text
*/
void DLL_EXPORT IrrGUIGetText( IGUIElement *element, const wchar_t * wcptrText )
{
	if ( element )
		element->getText();
}

/* ----------------------------------------------------------------------------
sets gui object text
*/
void DLL_EXPORT IrrGUISetText( IGUIElement *element, const wchar_t * wcptrText )
{
	if ( element )
		element->setText( wcptrText );
}


/* ----------------------------------------------------------------------------
add a window frame object to the GUI
*/
void * DLL_EXPORT IrrAddWindow(
                                const wchar_t * wcptrTitle,
                                int iTopX, int iTopY, int iBotX, int iBotY,
                                bool modal, IGUIElement *parent )
{
	return guienv->addWindow(
			rect<s32>(iTopX, iTopY, iBotX, iBotY),
			modal, wcptrTitle, parent );
}

/* ----------------------------------------------------------------------------
add a static text object to the GUI
*/
void * DLL_EXPORT IrrAddStaticText(
                                const wchar_t * wcptrText,
                                int iTopX, int iTopY, int iBotX, int iBotY,
                                bool boBorder, bool boWordWrap, IGUIElement *parent )
{
	return guienv->addStaticText(
            wcptrText,
            rect<int>(iTopX, iTopY, iBotX, iBotY),
            boBorder, boWordWrap, parent );
}

/* ----------------------------------------------------------------------------
adds a clickable button object
*/
void * DLL_EXPORT IrrAddButton( s32 x, s32 y, s32 w, s32 h, s32 id,
							  const wchar_t * wcptrLabel,
							  const wchar_t * wcptrTip,
							  IGUIElement *parent )
{
	return guienv->addButton(
			rect<s32>(x,y,w,h), parent, id,
			wcptrLabel, wcptrTip );
}

/* ----------------------------------------------------------------------------
adds a scroll bar object
*/
void * DLL_EXPORT IrrAddScrollBar( bool Horizontal,
								   s32 xt, s32 yt, s32 xb, s32 yb,
								   s32 id,
								   s32 pos,
								   s32 max,
								   IGUIElement *parent )
{
	IGUIScrollBar* scrollbar = guienv->addScrollBar(
			Horizontal,
			rect<s32>(xt, yt, xb, yb), parent, id);
	scrollbar->setMax(max);
	scrollbar->setPos(pos);

	return scrollbar;
}


/* ----------------------------------------------------------------------------
adds a list box object
*/
void * DLL_EXPORT IrrAddListBox( s32 xt, s32 yt, s32 xb, s32 yb,
								 s32 id,
								 bool background,
								 IGUIElement *parent )
{
	return guienv->addListBox(rect<s32>(xt, yt, xb, yb), parent, id, background);
}

/* ----------------------------------------------------------------------------
adds a list box object
*/
void DLL_EXPORT IrrAddListBoxItem( IGUIElement *element, const wchar_t * wcptrText )
{
	if ( element )
		((IGUIListBox* )element)->addItem( wcptrText );
}

/* ----------------------------------------------------------------------------
adds a list box object
*/
void DLL_EXPORT IrrInsertListBoxItem( IGUIElement *element, const wchar_t * wcptrText, u32 index )
{
	if ( element )
		((IGUIListBox* )element)->insertItem( index, wcptrText, 0 );
}

/* ----------------------------------------------------------------------------
adds a list box object
*/
void DLL_EXPORT IrrRemoveListBoxItem( IGUIElement *element, u32 index )
{
	if ( element )
		((IGUIListBox* )element)->removeItem( index );
}

/* ----------------------------------------------------------------------------
adds a list box object
*/
void DLL_EXPORT IrrSelectListBoxItem( IGUIElement *element, u32 index )
{
	if ( element )
		((IGUIListBox* )element)->setSelected( index );
}

/* ----------------------------------------------------------------------------
adds an edit box object
*/
void * DLL_EXPORT IrrAddEditBox( const wchar_t * wcptrText,
								   s32 xt, s32 yt, s32 xb, s32 yb,
								   s32 id,
								   bool border,
								   bool password,
								   IGUIElement *parent )
{
	IGUIEditBox * editbox= guienv->addEditBox(
			wcptrText, rect<s32>(xt, yt, xb, yb), border, parent, id );
	if ( password )
		editbox->setPasswordBox( true );
	return editbox;
}

/* ----------------------------------------------------------------------------
adds a scroll bar object
*/
void * DLL_EXPORT IrrAddImage(  ITexture * texture,
								s32 x, s32 y,
								bool useAlpha,
								s32 id,
								IGUIElement *parent )
{
	// add the engine logo
	return guienv->addImage( texture, position2d<int>(x,y), useAlpha, parent, id );
}

/* ----------------------------------------------------------------------------
adds a check box object
*/
void * DLL_EXPORT IrrAddCheckBox( const wchar_t * wcptrText,
								  s32 xt, s32 yt, s32 xb, s32 yb,
								  s32 id,
								   bool checked,
								   IGUIElement *parent )
{
	return guienv->addCheckBox(checked, rect<s32>(xt, yt, xb, yb), parent, id, wcptrText);
}

/* ----------------------------------------------------------------------------
check the check box object
*/
void DLL_EXPORT IrrCheckCheckBox( IGUIElement *element, bool checked )
{
	if ( element )
		((IGUICheckBox *)element)->setChecked( checked );
}


/* ----------------------------------------------------------------------------
adds a scroll bar object
*/
void * DLL_EXPORT IrrAddFileOpen( const wchar_t * wcptrLabel, s32 id, bool modal, IGUIElement *parent )
{
	return guienv->addFileOpenDialog( wcptrLabel, modal, parent, id );
}

/* ----------------------------------------------------------------------------
set the font used by the GUI
*/
void DLL_EXPORT IrrGUISetFont( IGUIFont* font )
{
	IGUISkin* skin = guienv->getSkin();
	if (font)
		skin->setFont(font);
}

/* ----------------------------------------------------------------------------
set the font used by the GUI
*/
void DLL_EXPORT IrrGUISetColor( EGUI_DEFAULT_COLOR element, s32 red, s32 green, s32 blue, s32 alpha )
{
	IGUISkin* skin = guienv->getSkin();
	skin->setColor(element, video::SColor(alpha, red, green, blue ));
}


/* ////////////////////////////////////////////////////////////////////////////
all of the above functions are declared as C functions and are exposed without
any mangled names
*/
}
