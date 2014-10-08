'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 84: GUI Functions
'' This example demonstrates the use of a range of GUI objects
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' global variables
DIM GUIEvent as IRR_GUI_EVENT PTR
DIM guiStatic as IRR_GUI_OBJECT
DIM guiEdit as IRR_GUI_OBJECT
DIM guiPassword as IRR_GUI_OBJECT
DIM guiWindow as IRR_GUI_OBJECT
DIM guiListbox as IRR_GUI_OBJECT
DIM redBackground as integer = 255
DIM greenBackground as integer = 255
DIM imageTexture as irr_texture
DIM fileName as string
DIM displayString as wstring * 32
DIM BitmapFont as irr_font

#define MY_GUI_BUTTON_FILE      101
#define MY_GUI_BUTTON_WINDOW    102
#define MY_GUI_BUTTON_QUIT      103
#define MY_GUI_BUTTON_CLOSE     104
#define MY_GUI_SCROLLBAR_RED    105
#define MY_GUI_SCROLLBAR_GREEN  106
#define MY_GUI_LISTBOX          107
#define MY_GUI_CHECKBOX         108
#define MY_GUI_EDITBOX          109
#define MY_GUI_PASSWORD         110
#define MY_GUI_FILEOPEN         111

'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface. The scene will be rendered using the Irrlicht,
' software renderer, the display will be a window 400 x 200 pixels in size, the
' display will not support shadows and we will not capture any keyboard and
' mouse events and finally vertical syncronisation to smoothen the display
' is switched on, by default it is off
IrrStart( IRR_EDT_OPENGL, 512, 256, IRR_BITS_PER_PIXEL_32,_
          IRR_WINDOWED, IRR_NO_SHADOWS, IRR_CAPTURE_EVENTS,_
          IRR_VERTICAL_SYNC_ON )

' Set the title of the display
IrrSetWindowCaption( "Example 84: GUI Functions" )

' set the font used by the GUI
BitmapFont = IrrGetFont ( "./media/fonthaettenschweiler.bmp" )
IrrGUISetFont( BitmapFont )

' set the colors used by GUI controls
IrrGUISetColor( EGDC_3D_FACE, 192, 255, 255, 255 )
IrrGUISetColor( EGDC_BUTTON_TEXT, 0, 64, 64, 255 )

' add a static text object to the graphical user interface. The text will be
' drawn inside the defined rectangle, the box will not have a border and the
' text will not be wrapped around if it runs off the end
guiStatic = IrrAddStaticText( _
                   "Hello World", _     ' Text to display
                   4,0,256,16, _        ' Size
                   IRR_GUI_NO_BORDER, _ ' no border around the text
                   IRR_GUI_NO_WRAP )    ' text does not wrap

' add a button to the graphical user interface
IrrAddButton( 16, 16, 112, 32, _                ' Size
                          MY_GUI_BUTTON_FILE, _ ' ID of the button
                          "Select File", _      ' Text on the button
                          "Select a bitmap" )   ' label when over button

' add a couple of more buttons to the graphical user interface
IrrAddButton( 128, 16, 224, 32,   MY_GUI_BUTTON_WINDOW, "Open a window" )
IrrAddButton( 240, 16, 336, 32,  MY_GUI_BUTTON_QUIT, "Close the GUI" )

' add a horizontal scroll bar to the graphical user interface
IrrAddScrollBar( IRR_GUI_HORIZONTAL, _
                 32, 48, 320, 64, _       ' Size
                 MY_GUI_SCROLLBAR_RED, _  ' ID of the button
                 255, _                   ' The position of the scrollbar
                 255 )                    ' The maximum value of the scrollbar

' add a vertical scroll bar to the graphical user interface
IrrAddScrollBar( IRR_GUI_VERTICAL, _
                 16, 64, 32, 240, _         ' Size
                 MY_GUI_SCROLLBAR_GREEN, _  ' ID of the button
                 255, _                     ' The position of the scrollbar
                 255 )                      ' The maximum value of the scrollbar

' add a listbox to the display
guiListbox = IrrAddListBox( 48, 64, 320, 128, _
                            MY_GUI_LISTBOX, _
                            IRR_GUI_DRAW_BACKGROUND )

' add three items to the listbox
IrrAddListBoxItem( guiListbox, "Apples" )
IrrAddListBoxItem( guiListbox, "Oranges" )
IrrAddListBoxItem( guiListbox, "Pears" )

' select item 1 oranges
IrrSelectListBoxItem( guiListbox, 1 )

' add a normal editbox to the display
guiEdit = IrrAddEditBox( "Editable text", _
                         48,128, 320,144, _
                         MY_GUI_EDITBOX, _
                         IRR_GUI_BORDER, IRR_GUI_NOT_PASSWORD )

' add a password editbox to the display
guiPassword = IrrAddEditBox( "Hidden Password", _
               48,144, 320,160, _
               MY_GUI_PASSWORD, _
               IRR_GUI_BORDER, _
               IRR_GUI_PASSWORD )

' add a checkbox to the display
IrrAddCheckBox( "Clickable Option", _
                48,160, 320,176, _
                MY_GUI_CHECKBOX, _
                1 )

' Let the GUI system handle the events
IrrGUIEvents( 1 )

' while the scene is still running
WHILE IrrRunning
    ' begin the scene, erasing the canvas to white before rendering
    IrrBeginScene( redBackground, greenBackground, 255 )

    ' draw the Graphical User Interface
    IrrDrawGUI

    ' if there are GUI events available
    If IrrGUIEventAvailable then

        ' read the GUI event out 
        GUIEvent = IrrReadGUIEvent

        ' process the particular control
        select case GUIEvent->id
        
        case MY_GUI_BUTTON_FILE
            ' if the button has been pressed
            If GUIEvent->event = EGET_BUTTON_CLICKED then
                ' open a file open dialog
                IrrAddFileOpen( "Select an image file", MY_GUI_FILEOPEN, IRR_GUI_MODAL  )
            End If

        case MY_GUI_BUTTON_WINDOW
            ' if the button has been pressed
            If GUIEvent->event = EGET_BUTTON_CLICKED then
                ' open a small modal window
                guiWindow = IrrAddWindow( "Window", 80, 80, 160, 144, IRR_GUI_MODAL )
                ' with a button that can close the window
                IrrAddButton( 16, 32, 64, 48, 104, "Close me", "", guiWindow )
            End If

        case MY_GUI_BUTTON_QUIT
            ' if the button has been pressed
            If GUIEvent->event = EGET_BUTTON_CLICKED then
                ' all GUI elements from the display
                IrrGUIClear
                ' let the system handle mouse and key events now
                IrrGUIEvents( 0 )
            End If

        case MY_GUI_BUTTON_CLOSE
            ' if the button has been pressed
            If GUIEvent->event = EGET_BUTTON_CLICKED then
                ' remove the window and its child button from the display
                IrrGUIRemove( guiWindow )
            End If

        case MY_GUI_SCROLLBAR_RED
            ' if the position of the scrollbar has been changed
            If GUIEvent->event = EGET_SCROLL_BAR_CHANGED then
                ' set the red value of the background color
                redBackground = GUIEvent->x
            End If

        case MY_GUI_SCROLLBAR_GREEN
            ' if the position of the scrollbar has been changed
            If GUIEvent->event = EGET_SCROLL_BAR_CHANGED then
                ' set the red value of the background color
                greenBackground = GUIEvent->x
            End If

        case MY_GUI_LISTBOX
            ' if the listbox selection has changed
            If GUIEvent->event = EGET_LISTBOX_CHANGED then
                ' change the text to show which item is selected
                if GUIEvent->x = 0 then IrrGUISetText( guiStatic, "Selected apples" )
                if GUIEvent->x = 1 then IrrGUISetText( guiStatic, "Selected oranges" )
                if GUIEvent->x = 2 then IrrGUISetText( guiStatic, "Selected pears" )
            End If

        case MY_GUI_EDITBOX
            ' if the editbox contents have changed
            If GUIEvent->event = EGET_EDITBOX_CHANGED then
                ' set the static text object to the contents of the edit box
                IrrGUISetText( guiStatic, IrrGUIGetText( guiEdit ))
            End If

        case MY_GUI_PASSWORD
            ' if the password editbox contents have changed
            If GUIEvent->event = EGET_EDITBOX_CHANGED then
                ' set the static text object to the contents of the edit box
                IrrGUISetText( guiStatic, IrrGUIGetText( guiPassword ))
            End If

        case MY_GUI_CHECKBOX
            ' if the checkbox state has changed
            If GUIEvent->event = EGET_CHECKBOX_CHANGED then
                ' set the static text object to represent the checkbox state
                if GUIEvent->x = 0 then
                    IrrGUISetText( guiStatic, "Checkbox is Cleared" )
                else
                    IrrGUISetText( guiStatic, "Checkbox is Checked" )
                End if
            End If

        case MY_GUI_FILEOPEN
            ' if the event was from a file being selected
            If GUIEvent->event = EGET_FILE_SELECTED then
                imageTexture = IrrGetTexture( Str(*IrrGetLastSelectedFile ))
                if NOT imageTexture = 0 then
                    IrrAddImage( imageTexture, 352, 16, IRR_USE_ALPHA, 140 )
                end if
            End If

        End Select
    End if

    ' end drawing the scene and render it
    IrrEndScene
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
