#ifndef fb
Namespace fb
 enum
  SC_ESCAPE       = &h01
  SC_1
  SC_2
  SC_3
  SC_4
  SC_5
  SC_6
  SC_7
  SC_8
  SC_9
  SC_0
  SC_MINUS
  SC_EQUALS
  SC_BACKSPACE
  SC_TAB
  SC_Q
  SC_W
  SC_E
  SC_R
  SC_T
  SC_Y
  SC_U
  SC_I
  SC_O
  SC_P
  SC_LEFTBRACKET
  SC_RIGHTBRACKET
  SC_ENTER
  SC_CONTROL
  SC_A
  SC_S
  SC_D
  SC_F
  SC_G
  SC_H
  SC_J
  SC_K
  SC_L
  SC_SEMICOLON
  SC_QUOTE
  SC_TILDE
  SC_LSHIFT
  SC_BACKSLASH
  SC_Z
  SC_X
  SC_C
  SC_V
  SC_B
  SC_N
  SC_M
  SC_COMMA
  SC_PERIOD
  SC_SLASH
  SC_RSHIFT
  SC_MULTIPLY
  SC_ALT
  SC_SPACE
  SC_CAPSLOCK
  SC_F1
  SC_F2
  SC_F3
  SC_F4
  SC_F5
  SC_F6
  SC_F7
  SC_F8
  SC_F9
  SC_F10
  SC_NUMLOCK
  SC_SCROLLLOCK
  SC_HOME
  SC_UP   
  SC_PAGEUP
  SC_LEFT         = &h4B
  SC_RIGHT        = &h4D
  SC_PLUS
  SC_END
  SC_DOWN
  SC_PAGEDOWN
  SC_INSERT
  SC_DELETE
  SC_F11          = &h57
  SC_F12
  SC_LWIN         = &h5B
  SC_RWIN
  SC_MENU
 End enum
End Namespace
#endif

#define multikeyold multikey

#undef multikey
Dim Shared global_keyEvent_irrlicht As IRR_KEY_EVENT Ptr
Dim Shared multikey(0 To 255) As Byte
Dim Shared from_irrlicht_multikey(0 To 255) As Ubyte

Scope
Using fb

from_irrlicht_multikey(KEY_ESCAPE)    = SC_ESCAPE
from_irrlicht_multikey(KEY_KEY_1)     = SC_1
from_irrlicht_multikey(KEY_KEY_2)     = SC_2
from_irrlicht_multikey(KEY_KEY_3)     = SC_3
from_irrlicht_multikey(KEY_KEY_4)     = SC_4
from_irrlicht_multikey(KEY_KEY_5)     = SC_5
from_irrlicht_multikey(KEY_KEY_6)     = SC_6
from_irrlicht_multikey(KEY_KEY_7)     = SC_7
from_irrlicht_multikey(KEY_KEY_8)     = SC_8
from_irrlicht_multikey(KEY_KEY_9)     = SC_9
from_irrlicht_multikey(KEY_KEY_0)     = SC_0
from_irrlicht_multikey(KEY_NUMPAD1)   = SC_1
from_irrlicht_multikey(KEY_NUMPAD2)   = SC_2
from_irrlicht_multikey(KEY_NUMPAD3)   = SC_3
from_irrlicht_multikey(KEY_NUMPAD4)   = SC_4
from_irrlicht_multikey(KEY_NUMPAD5)   = SC_5
from_irrlicht_multikey(KEY_NUMPAD6)   = SC_6
from_irrlicht_multikey(KEY_NUMPAD7)   = SC_7
from_irrlicht_multikey(KEY_NUMPAD8)   = SC_8
from_irrlicht_multikey(KEY_NUMPAD9)   = SC_9
from_irrlicht_multikey(KEY_NUMPAD0)   = SC_0
from_irrlicht_multikey(KEY_SUBTRACT)  = SC_MINUS
from_irrlicht_multikey(109)           = SC_MINUS
from_irrlicht_multikey(187)           = SC_EQUALS
from_irrlicht_multikey(KEY_BACK)      = SC_BACKSPACE
from_irrlicht_multikey(KEY_TAB)       = SC_TAB
from_irrlicht_multikey(KEY_KEY_Q)     = SC_Q
from_irrlicht_multikey(KEY_KEY_W)     = SC_W
from_irrlicht_multikey(KEY_KEY_E)     = SC_E
from_irrlicht_multikey(KEY_KEY_R)     = SC_R
from_irrlicht_multikey(KEY_KEY_T)     = SC_T
from_irrlicht_multikey(KEY_KEY_Y)     = SC_Y
from_irrlicht_multikey(KEY_KEY_U)     = SC_U
from_irrlicht_multikey(KEY_KEY_I)     = SC_I
from_irrlicht_multikey(KEY_KEY_O)     = SC_O
from_irrlicht_multikey(KEY_KEY_P)     = SC_P
from_irrlicht_multikey(219)           = SC_LEFTBRACKET
from_irrlicht_multikey(221)           = SC_RIGHTBRACKET
from_irrlicht_multikey(KEY_RETURN)    = SC_ENTER
from_irrlicht_multikey(KEY_CONTROL)   = SC_CONTROL
from_irrlicht_multikey(KEY_KEY_A)     = SC_A
from_irrlicht_multikey(KEY_KEY_S)     = SC_S
from_irrlicht_multikey(KEY_KEY_D)     = SC_D
from_irrlicht_multikey(KEY_KEY_F)     = SC_F
from_irrlicht_multikey(KEY_KEY_G)     = SC_G
from_irrlicht_multikey(KEY_KEY_H)     = SC_H
from_irrlicht_multikey(KEY_KEY_J)     = SC_J
from_irrlicht_multikey(KEY_KEY_K)     = SC_K
from_irrlicht_multikey(KEY_KEY_L)     = SC_L
from_irrlicht_multikey(KEY_ATTN)      = SC_SEMICOLON
from_irrlicht_multikey(222)           = SC_QUOTE
from_irrlicht_multikey(192)           = SC_TILDE
from_irrlicht_multikey(KEY_LSHIFT)    = SC_LSHIFT
from_irrlicht_multikey(KEY_SEPARATOR) = SC_BACKSLASH
from_irrlicht_multikey(KEY_KEY_Z)     = SC_Z
from_irrlicht_multikey(KEY_KEY_X)     = SC_X
from_irrlicht_multikey(KEY_KEY_C)     = SC_C
from_irrlicht_multikey(KEY_KEY_V)     = SC_V
from_irrlicht_multikey(KEY_KEY_B)     = SC_B
from_irrlicht_multikey(KEY_KEY_N)     = SC_N
from_irrlicht_multikey(KEY_KEY_M)     = SC_M
from_irrlicht_multikey(KEY_COMMA)     = SC_COMMA
from_irrlicht_multikey(KEY_PERIOD)    = SC_PERIOD
from_irrlicht_multikey(110)           = SC_PERIOD
from_irrlicht_multikey(KEY_DIVIDE)    = SC_SLASH
from_irrlicht_multikey(191)           = SC_SLASH
from_irrlicht_multikey(KEY_RSHIFT)    = SC_RSHIFT
from_irrlicht_multikey(KEY_MULTIPLY)  = SC_MULTIPLY
from_irrlicht_multikey(KEY_MENU)      = SC_ALT
from_irrlicht_multikey(KEY_SPACE)     = SC_SPACE
from_irrlicht_multikey(KEY_CAPITAL)   = SC_CAPSLOCK
from_irrlicht_multikey(KEY_F1)        = SC_F1
from_irrlicht_multikey(KEY_F2)        = SC_F2
from_irrlicht_multikey(KEY_F3)        = SC_F3
from_irrlicht_multikey(KEY_F4)        = SC_F4
from_irrlicht_multikey(KEY_F5)        = SC_F5
from_irrlicht_multikey(KEY_F6)        = SC_F6
from_irrlicht_multikey(KEY_F7)        = SC_F7
from_irrlicht_multikey(KEY_F8)        = SC_F8
from_irrlicht_multikey(KEY_F9)        = SC_F9
from_irrlicht_multikey(KEY_F10)       = SC_F10
from_irrlicht_multikey(KEY_NUMLOCK)   = SC_NUMLOCK
from_irrlicht_multikey(KEY_SCROLL)    = SC_SCROLLLOCK
from_irrlicht_multikey(KEY_HOME)      = SC_HOME
from_irrlicht_multikey(KEY_UP)        = SC_UP
from_irrlicht_multikey(KEY_PRIOR)     = SC_PAGEUP
from_irrlicht_multikey(KEY_LEFT)      = SC_LEFT
from_irrlicht_multikey(KEY_RIGHT)     = SC_RIGHT
from_irrlicht_multikey(KEY_ADD)       = SC_PLUS
from_irrlicht_multikey(KEY_END)       = SC_END
from_irrlicht_multikey(KEY_DOWN)      = SC_DOWN
from_irrlicht_multikey(KEY_NEXT)      = SC_PAGEDOWN
from_irrlicht_multikey(KEY_INSERT)    = SC_INSERT
from_irrlicht_multikey(KEY_DELETE)    = SC_DELETE
from_irrlicht_multikey(KEY_F11)       = SC_F11
from_irrlicht_multikey(KEY_F12)       = SC_F12
from_irrlicht_multikey(KEY_LWIN)      = SC_LWIN
from_irrlicht_multikey(KEY_RWIN)      = SC_RWIN
from_irrlicht_multikey(KEY_RMENU)     = SC_MENU
End Scope

#macro readMultikeyIrrlicht()
 Do
  If irrKeyEventAvailable = 0 Then Exit Do
  global_keyEvent_irrlicht = irrReadKeyEvent
  If global_keyEvent_irrlicht->direction = IRR_KEY_DOWN Then
   multikey(from_irrlicht_multikey(global_keyEvent_irrlicht->key)) = -1
  Else
   multikey(from_irrlicht_multikey(global_keyEvent_irrlicht->key)) = 0
  End If
 Loop
#endmacro

#define getmouseold getmouse

#undef getmouse
Dim Shared global_mouseEvent_irrlicht As IRR_MOUSE_EVENT Ptr
Dim Shared global_GUIEvent_irrlicht As IRR_GUI_EVENT Ptr
Function getMouse ( Byref x As Integer, Byref y As Integer, _
Byref wheel As Integer = 0, Byref buttons As Integer = 0, _
Byref clip As Integer = 0) As Integer
 Dim As Integer xAbsolute, yAbsolute, screenWidth, screenHeight

 Do
  If irrMouseEventAvailable = 0 Then Exit Do
  global_mouseEvent_irrlicht = irrReadMouseEvent
  ' If this is a mouse move event...
  Select Case global_mouseEvent_irrlicht->action
   Case IRR_EMIE_LMOUSE_PRESSED_DOWN : buttons Or= 1  ': continue do
   Case IRR_EMIE_RMOUSE_PRESSED_DOWN : buttons Or= 2  : Continue Do
   Case IRR_EMIE_MMOUSE_PRESSED_DOWN : buttons Or= 4  : Continue Do
   Case IRR_EMIE_LMOUSE_LEFT_UP      : buttons Xor= 1 : Continue Do
   Case IRR_EMIE_RMOUSE_LEFT_UP      : buttons Xor= 2 : Continue Do
   Case IRR_EMIE_MMOUSE_LEFT_UP      : buttons Xor= 4 : Continue Do
   Case IRR_EMIE_MOUSE_WHEEL   : wheel += global_mouseEvent_irrlicht -> delta : Continue Do
  End Select
    x = global_mouseEvent_irrlicht -> x
    y = global_mouseEvent_irrlicht -> y
 Loop
 irrGetScreenSize (screenWidth, screenHeight)
 irrGetAbsoluteMousePosition(xAbsolute, yAbsolute)
 If xAbsolute < 0 orelse yAbsolute < 0 orelse (xabsolute >= screenWidth) orelse (yabsolute >= screenHeight) Then clip = 0 Else clip = 1
 Return 1
End Function
