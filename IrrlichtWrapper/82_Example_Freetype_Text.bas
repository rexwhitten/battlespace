'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 82: Drawing Truetype fonts with Freetype
''
'' This example creates a blank texture and then uses the Freetype library to
'' render a string of characters from a truetype font copying each of them
'' over in a pixelwise manner.
''
'' All due credit to the Author that created the FreeBASIC freetype headers
'' and examples and the work of the Freetype team that made this example
'' possible
''
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"
#include "freetype2/freetype.bi" 


'' ////////////////////////////////////////////////////////////////////////////
'' Declarations for support functions

' handle a critical error that must stop the program
declare Sub CriticalError( errorMessage as String, errorVal as Integer )

' Transfer a string of characters to the textures pixels
declare Function FT_Draw_String( Text as String, _
                                 Face As FT_Face, _
                                 penX as Integer, _
                                 penY as Integer, _
                                 baseline As Integer, _
                                 Kerning As Integer, _
                                 textureWidth As Integer, _
                                 textureHeight As Integer, _
                                 pixels As UInteger ptr ) As Integer

' Transfer a single character from the face to the textures pixels
declare Function FT_Draw_Character( Face As FT_Face, _
                                    penX as Integer, _
                                    penY as Integer, _
                                    baseline As Integer, _
                                    textureWidth As Integer, _
                                    textureHeight As Integer, _
                                    pixels As UInteger ptr ) As Integer


'' ////////////////////////////////////////////////////////////////////////////
'' global variables
DIM texture_for_font    As irr_texture
DIM pixels              As uinteger ptr
DIM i                   As integer
DIM TotalWidth          As Integer
DIM ErrorMsg            As FT_Error 
DIM Face                As FT_Face 
DIM Library             As FT_Library 


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface. The scene will be rendered using the Irrlicht,
' software renderer, the display will be a window 512 x 512 pixels in size, the
' display will not support shadows and we will not capture any keyboard and
' mouse events
IrrStart( IRR_EDT_OPENGL, 512, 512, IRR_BITS_PER_PIXEL_32, _
          IRR_WINDOWED, IRR_NO_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' Set the title of the display
IrrSetWindowCaption( "Example 82: Truetype Fonts with Freetype" )

' create a new blank texture surface 256 x 256 pixels in 32bit color
texture_for_font = IrrCreateTexture( "freetypeexample", 256, 256, ECF_A8R8G8B8 )

' initialise the freetype library
ErrorMsg = FT_Init_FreeType(@Library) 
If ErrorMsg Then CriticalError( "Error Initializing FreeType", ErrorMsg )

' Load the new face type
ErrorMsg = FT_New_Face(Library, "./media/Vera.ttf", 0, @Face ) 
If ErrorMsg Then CriticalError( "Could not load font", ErrorMsg )

' set the character dimensions of the rendered glyphs to 32 pixels. you can
' scale your font by changing this value changing the 0 will enable you to
' stretch the font
ErrorMsg = FT_Set_Pixel_Sizes(Face, 0, 32) 
If ErrorMsg Then CriticalError( "Could not set pixel sizes", ErrorMsg )

' get the pixels of the texture
pixels = IrrLockTexture( texture_for_font )

' Draw a string to the texture at 0, 0 with baseline 32 pixels down, with 4
' pixels of spacing onto a 256 x 256 set of pixels
TotalWidth = FT_Draw_String( "Truetype Fonts", Face, 0,0, 32, 4, 256, 256, pixels )

' unlock the texture for use by the system
IrrUnlockTexture( texture_for_font )

' while the scene is still running
WHILE IrrRunning
    ' begin the scene, erasing the canvas to Yellow before rendering
    IrrBeginScene( 100, 100, 0 )

    ' draw an area of the texture to the display
    IrrDraw2DImageElement( texture_for_font,_
                           0, 0,_
                           0, 0, TotalWidth, 48, IRR_USE_ALPHA )

    ' end drawing the scene and render it
    IrrEndScene
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop



'' ////////////////////////////////////////////////////////////////////////////
'' Additional Freetype support functions

' handle a critical error that must stop the program
Sub CriticalError( errorMessage as String, errorVal as Integer )
    Print errorMessage;" (";errorVal;")"
    Sleep
    End 
End Sub

' Transfer a string of characters to the textures pixels
Function FT_Draw_String( Text as String, _
                         Face As FT_Face, _
                         penX as Integer, _
                         penY as Integer, _
                         baseline As Integer, _
                         Kerning As Integer, _
                         textureWidth As Integer, _
                         textureHeight As Integer, _
                         pixels As UInteger ptr ) As Integer

    Dim ErrorMsg As FT_Error 
    DIM i as Integer

    ' itterate all of the characters in the string (except the NULL at the end)
    for i = 0 to Len( Text )-1
        ' if the current character is not a space
        if NOT Text[i] = 32 then
            ' load the character from the typeface
            ErrorMsg = FT_Load_Char(Face, Text[i], FT_LOAD_DEFAULT) 
            If ErrorMsg Then CriticalError( "Could not load character", ErrorMsg )

            ' render the character to a bitmap
            ErrorMsg = FT_Render_Glyph(Face->Glyph, FT_RENDER_MODE_NORMAL) 
            If ErrorMsg Then CriticalError( "Could not render character", ErrorMsg )

            ' call our function to copy the pixels from the rendered character
            ' to the supplied pixels from the texture
            penX += FT_Draw_Character( Face, penX, penY, baseline, _
                                       textureWidth, textureHeight, pixels )

            ' leave a gap between characters
            penX += Kerning
        else
            ' the current character is a space
            ' leave a gap that is four times the spacing of intercharacter gaps
            penX += Kerning * 4
        End If
    Next i

    ' return the total length of the string
    Return penX

End Function


' Transfer a single character from the face to the textures pixels
Function FT_Draw_Character( Face As FT_Face, _
                            penX as Integer, _
                            penY as Integer, _
                            baseline As Integer, _
                            textureWidth As Integer, _
                            textureHeight As Integer, _
                            pixels As UInteger ptr ) As Integer

    Dim ErrorMsg As FT_Error 
    Dim Bitmap As FT_Bitmap Ptr 
    Dim BmpWid As Integer 
    Dim BmpHgt As Integer 
    Dim BmpPtr As uByte Ptr 
    Dim BmpClr As uByte 
    Dim As Integer x, y 

    ' Extract metrics from the face
    Bitmap = @Face->Glyph->Bitmap 
    BmpWid = Bitmap->Width - 1  
    BmpHgt = Bitmap->Rows - 1
    BmpPtr = Bitmap->Buffer 

    ' adjust the pen to the baseline and then moved up to the top
    ' of the character
    penY += baseline - Face->glyph->bitmap_top

    ' clip the width and height to the surface of the bitmap
    if ( BmpHgt + penY ) > textureHeight then BmpHgt = textureHeight - penY
    if ( BmpWid + penX ) > textureWidth  then BmpWid = textureWidth - penX

    ' start drawing to the pen position
    pixels += penX + (textureWidth * penY)

    ' itterate all of the rows in the rendered truetype character
    For y = 0 To BmpHgt
        ' itterate all of the columns in the rendered truetype character
        For x = 0 To BmpWid
            ' get the pixel from the rendered truetype character
            BmpClr = BmpPtr[y * Bitmap->Pitch + x] 
            
            ' copy the pixel into the texture
            *pixels = Rgb(BmpClr, BmpClr, BmpClr)
            
            ' if the red luminance of the pixel is less than 16 (very dark)
            ' make the entire pixel black and transparent too
            if *pixels < &hFF100000 then *pixels = &h00000000
            
            ' move on to the next column
            pixels += 1
        Next x

        ' move on to the next row
        pixels += textureWidth-BmpWid-1
    Next y

    ' return the width of this character
    Return BmpWid

End Function
