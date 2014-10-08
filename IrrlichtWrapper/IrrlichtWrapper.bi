''
'' A Freebasic Irrlicht Interface Test
'' F.Dodd (2006)
''
'' This is a pure test of creating a wrapper DLL for Irrlicht simplifying its
'' C++ architecture and providing a basic but functional 3D SDK for languages
'' that are not object oriented. At the moment this provides very few calls and
'' is merely a test for implementing such an interface.
''
'' This source uses Irrlicht definitions created by the Irrlicht authors
''

'' ////////////////////////////////////////////////////////////////////////////
'' Instructions to link the required DLL's
#inclib "IrrlichtWrapper"
#inclib "Irrlicht"

'' ////////////////////////////////////////////////////////////////////////////
'' Enumerated Type Definitions

' Rendering Device Types
ENUM IRR_DEVICE_TYPES
    IRR_EDT_NULL = 0            ' a NULL device with no display
    IRR_EDT_SOFTWARE            ' Irrlichts default software renderer
    IRR_EDT_SOFTWARE2           ' An improved quality software renderer
    IRR_EDT_OPENGL              ' hardware accelerated OpenGL renderer
    IRR_EDT_DIRECT3D8           ' hardware accelerated DirectX 8 renderer
    IRR_EDT_DIRECT3D9           ' hardware accelerated DirectX 9 renderer
END ENUM

' Material Flags
ENUM IRR_MATERIAL_FLAGS
    IRR_EMF_WIREFRAME = 0       ' Render as wireframe outline.
    IRR_EMF_POINTCLOUD          ' Draw a point cloud instead of polygons.
    IRR_EMF_GOURAUD_SHADING     ' Render smoothly across polygons.
    IRR_EMF_LIGHTING            ' Material is effected by lighting.
    IRR_EMF_ZBUFFER             ' Enable z-buffer.
    IRR_EMF_ZWRITE_ENABLE       ' Can write as well as read z-buffer.
    IRR_EMF_BACK_FACE_CULLING   ' Cull polygons facing away.
    IRR_EMF_FRONT_FACE_CULLING  ' Cull polygons facing front.
    IRR_EMF_BILINEAR_FILTER     ' Enable bilinear filtering.
    IRR_EMF_TRILINEAR_FILTER    ' Enable trilinear filtering.
    IRR_EMF_ANISOTROPIC_FILTER  ' Reduce blur in distant textures.
    IRR_EMF_FOG_ENABLE          ' Enable fogging in the distance.
    IRR_EMF_NORMALIZE_NORMALS   ' Use when scaling dynamically lighted models.
    IRR_EMF_TEXTURE_WRAP        ' Gives access to all layers texture wrap settings.
                                ' Overwrites separate layer settings. 
    IRR_EMF_ANTI_ALIASING       ' Anti-aliasing mode. 
    IRR_EMF_COLOR_MASK          ' ColorMask bits, for enabling the color planes. 
    IRR_EMF_COLOR_MATERIAL      ' ColorMaterial enum for vertex color interpretation. 
END ENUM

' Material Types
ENUM IRR_MATERIAL_TYPES
    IRR_EMT_SOLID = 0           ' Standard solid rendering uses one texture
    IRR_EMT_SOLID_2_LAYER       ' 2 blended textures using vertex alpha value
    IRR_EMT_LIGHTMAP            ' 2 textures: 0=color 1=lighting level and ignores vertex lighting
    IRR_EMT_LIGHTMAP_ADD        ' ... as above but adds levels instead of modulating between them
    IRR_EMT_LIGHTMAP_M2         ' ... as above but color levels are multiplied by 2 for brightening
    IRR_EMT_LIGHTMAP_M4         ' ... as above but color leels are multiplied by 4 for brightening
    IRR_EMT_LIGHTMAP_LIGHTING   ' 2 textures: 0=color 1=lighting level but supports dynamic lighting
    IRR_EMT_LIGHTMAP_LIGHTING_M2    ' ... as above but color levels are multiplied by 2 for brightening
    IRR_EMT_LIGHTMAP_LIGHTING_M4    ' ... as above but color leels are multiplied by 4 for brightening
    IRR_EMT_DETAIL_MAP          ' 2 blended textures: the first is a color map the second at a different scale adds and subtracts from the color to add detail
    IRR_EMT_SPHERE_MAP          ' makes the material appear reflective
    IRR_EMT_REFLECTION_2_LAYER  ' a reflective material blended with a color texture
    IRR_EMT_TRANSPARENT_ADD_COLOR   ' a transparency effect that simply adds a color texture to the background. the darker the color the more transparent it is.
    IRR_EMT_TRANSPARENT_ALPHA_CHANNEL   ' a transparency effect that uses the color textures alpha as a transparency level
    IRR_EMT_TRANSPARENT_ALPHA_CHANNEL_REF   ' a transparency effect that uses the color textures alpha, the pixel is only drawn if the alpha is > 127. this is a fast effect that does not blur edges and is ideal for leaves & grass etc.
    IRR_EMT_TRANSPARENT_VERTEX_ALPHA    ' a transparency effect that uses the vertex alpha value
    IRR_EMT_TRANSPARENT_REFLECTION_2_LAYER  ' a transparent & reflecting effect. the first texture is a reflection map, the second a color map. transparency is from vertex alpha
    IRR_EMT_NORMAL_MAP_SOLID    ' A solid normal map renderer. First texture is color, second is normal map. Only use nodes added with IrrAddStaticMeshForNormalMappingToScene. Only supports nearest two lights. Requires vertex and pixel shaders 1.1
    IRR_EMT_NORMAL_MAP_TRANSPARENT_ADD_COLOR    ' ... as above only with a transparency effect that simply adds the color to the background. the darker the color the more transparent it is.
    IRR_EMT_NORMAL_MAP_TRANSPARENT_VERTEX_ALPHA ' ... as above only with a transparency effect that uses the vertex alpha value
    IRR_EMT_PARALLAX_MAP_SOLID  ' similar to the solid normal map but more realistic providing virtual displacement of the surface. Uses the alpha channel of the normal map for height field displacement. Requires vertex shader 1.1 and pixel shader 1.4.
    IRR_EMT_PARALLAX_MAP_TRANSPARENT_ADD_COLOR  ' ... as above only with a transparency effect that simply adds the color to the background. the darker the color the more transparent it is.
    IRR_EMT_PARALLAX_MAP_TRANSPARENT_VERTEX_ALPHA   ' ... as above only wiht a transparency effect that uses the vertex alpha value
    IRR_EMT_ONE_TEXTURE_BLEND
    IRR_EMT_FOUR_DETAIL_MAP  ' 4 grayscale images in the channels of the first texture mixed with the vertex channels as alpha images
    IRR_EMT_TRANSPARENT_ADD_ALPHA_CHANNEL_REF ' as above only it adds the texture color rather than replacing it
    IRR_EMT_TRANSPARENT_ADD_ALPHA_CHANNEL
    IRR_EMT_FORCE_32BIT = &h7fffffff
END ENUM

' blend factors for the ONE_TEXTURE_BLEND material
ENUM IRR_BLEND_FACTOR
    EBF_ZERO = 0
    EBF_ONE
    EBF_DST_COLOR
    EBF_ONE_MINUS_DST_COLOR
    EBF_SRC_COLOR
    EBF_ONE_MINUS_SRC_COLOR
    EBF_SRC_ALPHA
    EBF_ONE_MINUS_SRC_ALPHA
    EBF_DST_ALPHA
    EBF_ONE_MINUS_DST_ALPHA
    EBF_SRC_ALPHA_SATURATE          
END ENUM

' Mouse events
ENUM IRR_MOUSE_EVENTS
    IRR_EMIE_LMOUSE_PRESSED_DOWN = 0
    IRR_EMIE_RMOUSE_PRESSED_DOWN
    IRR_EMIE_MMOUSE_PRESSED_DOWN
    IRR_EMIE_LMOUSE_LEFT_UP
    IRR_EMIE_RMOUSE_LEFT_UP
    IRR_EMIE_MMOUSE_LEFT_UP
    IRR_EMIE_MOUSE_MOVED
    IRR_EMIE_MOUSE_WHEEL
END ENUM

' Event types
enum IRR_EEVENT_TYPE
    IRR_EET_GUI_EVENT            = 0
    IRR_EET_MOUSE_INPUT_EVENT    = 1
    IRR_EET_KEY_INPUT_EVENT      = 2
    IRR_EET_JOYSTICK_INPUT_EVENT = 3
    IRR_EET_LOG_TEXT_EVENT       = 4
    IRR_EET_USER_EVENT           = 5
End enum

' MD2 Animation sequences
ENUM IRR_MD2_ANIM_SEQUENCES
    IRR_EMAT_STAND = 0
    IRR_EMAT_RUN
    IRR_EMAT_ATTACK
    IRR_EMAT_PAIN_A
    IRR_EMAT_PAIN_B
    IRR_EMAT_PAIN_C
    IRR_EMAT_JUMP
    IRR_EMAT_FLIP
    IRR_EMAT_SALUTE
    IRR_EMAT_FALLBACK
    IRR_EMAT_WAVE
    IRR_EMAT_POINT
    IRR_EMAT_CROUCH_STAND
    IRR_EMAT_CROUCH_WALK
    IRR_EMAT_CROUCH_ATTACK
    IRR_EMAT_CROUCH_PAIN
    IRR_EMAT_CROUCH_DEATH
    IRR_EMAT_DEATH_FALLBACK
    IRR_EMAT_DEATH_FALLFORWARD
    IRR_EMAT_DEATH_FALLBACKSLOW
    IRR_EMAT_BOOM
END ENUM

' For the FPS camera
Enum EKEY_ACTION
    EKA_MOVE_FORWARD = 0
    EKA_MOVE_BACKWARD
    EKA_STRAFE_LEFT
    EKA_STRAFE_RIGHT
    EKA_JUMP_UP
    EKA_COUNT
    EKA_FORCE_32BIT = &H7fffffff
End Enum

' Light types
Enum E_LIGHT_TYPE
    ELT_POINT = 0
    ELT_SPOT
    ELT_DIRECTIONAL
End Enum

' Joint animation modes
Enum IRR_JOINT_MODE
    IRR_JOINT_MODE_NONE = 0
    IRR_JOINT_MODE_READ
    IRR_JOINT_MODE_CONTROL
End Enum

' shadow modes for lighting
Enum E_SHADOW_MODE
	ESM_RECEIVE
	ESM_CAST
	ESM_BOTH
	ESM_EXCLUDE
	ESM_COUNT
End Enum

' filter types, up to 16 samples PCF.
Enum E_FILTER_TYPE
	EFT_NONE
	EFT_4PCF
	EFT_8PCF
	EFT_12PCF
	EFT_16PCF
	EFT_COUNT
End Enum

' Pre-programmed shader constants
Enum IRR_SHADER_CONSTANTS
    IRR_NO_PRESET = 0
    IRR_INVERSE_WORLD
    IRR_WORLD_VIEW_PROJECTION
    IRR_CAMERA_POSITION
    IRR_TRANSPOSED_WORLD
End Enum

' Vertex shader program versions
Enum IRR_VERTEX_SHADER_VERSION
    EVST_VS_1_1 = 0
    EVST_VS_2_0
    EVST_VS_2_a
    EVST_VS_3_0
End Enum

' Pixel shader program versions
Enum IRR_PIXEL_SHADER_VERSION
    EPST_PS_1_1 = 0
    EPST_PS_1_2
    EPST_PS_1_3
    EPST_PS_1_4
    EPST_PS_2_0
    EPST_PS_2_a
    EPST_PS_2_b
    EPST_PS_3_0
End Enum

' enumeration for querying features of the video driver. 
Enum IRR_VIDEO_FEATURE_QUERY
    ' Is driver able to render to a surface?
    EVDF_RENDER_TO_TARGET = 0
    
    ' Is hardeware transform and lighting supported?
    EVDF_HARDWARE_TL
    
    ' Are multiple textures per material possible?
    EVDF_MULTITEXTURE
    
    ' Is driver able to render with a bilinear filter applied?
    EVDF_BILINEAR_FILTER
    
    ' Can the driver handle mip maps?
    EVDF_MIP_MAP
    
    ' Can the driver update mip maps automatically?
    EVDF_MIP_MAP_AUTO_UPDATE
    
    ' Are stencilbuffers switched on and does the device support stencil buffers?
    EVDF_STENCIL_BUFFER
    
    ' Is Vertex Shader 1.1 supported?
    EVDF_VERTEX_SHADER_1_1
    
    ' Is Vertex Shader 2.0 supported?
    EVDF_VERTEX_SHADER_2_0
    
    ' Is Vertex Shader 3.0 supported?
    EVDF_VERTEX_SHADER_3_0
    
    ' Is Pixel Shader 1.1 supported?
    EVDF_PIXEL_SHADER_1_1
    
    ' Is Pixel Shader 1.2 supported?
    EVDF_PIXEL_SHADER_1_2
    
    ' Is Pixel Shader 1.3 supported?
    EVDF_PIXEL_SHADER_1_3
    
    ' Is Pixel Shader 1.4 supported?
    EVDF_PIXEL_SHADER_1_4
    
    ' Is Pixel Shader 2.0 supported?
    EVDF_PIXEL_SHADER_2_0
    
    ' Is Pixel Shader 3.0 supported?
    EVDF_PIXEL_SHADER_3_0
    
    ' Are ARB vertex programs v1.0 supported?
    EVDF_ARB_VERTEX_PROGRAM_1
    
    ' Are ARB fragment programs v1.0 supported?
    EVDF_ARB_FRAGMENT_PROGRAM_1
    
    ' Is GLSL supported?
    EVDF_ARB_GLSL
    
    ' Is HLSL supported?
    EVDF_HLSL
    
    ' Are non-square textures supported?
    EVDF_TEXTURE_NSQUARE
    
    ' Are non-power-of-two textures supported?
    EVDF_TEXTURE_NPOT
    
    ' Are framebuffer objects supported?
    EVDF_FRAMEBUFFER_OBJECT
    
    ' Are vertex buffer objects supported?
    EVDF_VERTEX_BUFFER_OBJECT
    
    ' Supports Alpha To Coverage
    EVDF_ALPHA_TO_COVERAGE
    
    ' Supports Color masks (disabling color planes in output)
    EVDF_COLOR_MASK
    
    ' Supports multiple render targets at once
    EVDF_MULTIPLE_RENDER_TARGETS
    
    ' Supports separate blend settings for multiple render targets
    EVDF_MRT_BLEND
    
    ' Supports separate color masks for multiple render targets
    EVDF_MRT_COLOR_MASK
    
    ' Supports separate blend functions for multiple render targets
    EVDF_MRT_BLEND_FUNC
    
    ' Supports geometry shaders
    EVDF_GEOMETRY_SHADER
End Enum

' Enumeration flags defining the file format supported loading and saving
Enum IRR_MESH_FILE_FORMAT
    EMWT_IRR_MESH = 0            ' Irrlicht Native mesh writer, for static .irrmesh files.  
    EMWT_COLLADA                 ' COLLADA mesh writer for .dae and .xml files.  
    EMWT_STL                     ' STL mesh writer for .stl files.  
End Enum

' Enumeration flags defining the size of a patch in the terrain
Enum IRR_TERRAIN_PATCH_SIZE
    ETPS_9 = 9                    ' patch size of 9, at most, use 4 levels of detail with this patch size.  
    ETPS_17 = 17                  ' patch size of 17, at most, use 5 levels of detail with this patch size.  
    ETPS_33 = 33                  ' patch size of 33, at most, use 6 levels of detail with this patch size.  
    ETPS_65 = 65                  ' patch size of 65, at most, use 7 levels of detail with this patch size.  
    ETPS_129 = 129                ' patch size of 129, at most, use 8 levels of detail with this patch size. 
End Enum

' Enumeration flags telling the video driver in which format textures should be created. 
Enum IRR_TEXTURE_CREATION_FLAG
    ETCF_ALWAYS_16_BIT          = &h1  ' Forces the driver to create 16 bit textures always, independent of which format the file on disk has. When choosing this you may loose some color detail, but gain much speed and memory. 16 bit textures can be transferred twice as fast as 32 bit textures and only use half of the space in memory. When using this flag, it does not make sense to use the flags ETCF_ALWAYS_32_BIT, ETCF_OPTIMIZED_FOR_QUALITY, or ETCF_OPTIMIZED_FOR_SPEED at the same time.  
    ETCF_ALWAYS_32_BIT          = &h2  ' Forces the driver to create 32 bit textures always, independent of which format the file on disk has. Please note that some drivers (like the software device) will ignore this, because they are only able to create and use 16 bit textures. When using this flag, it does not make sense to use the flags ETCF_ALWAYS_16_BIT, ETCF_OPTIMIZED_FOR_QUALITY, or ETCF_OPTIMIZED_FOR_SPEED at the same time.  
    ETCF_OPTIMIZED_FOR_QUALITY  = &h4  ' Lets the driver decide in which format the textures are created and tries to make the textures look as good as possible. Usually it simply chooses the format in which the texture was stored on disk. When using this flag, it does not make sense to use the flags ETCF_ALWAYS_16_BIT, ETCF_ALWAYS_32_BIT, or ETCF_OPTIMIZED_FOR_SPEED at the same time.  
    ETCF_OPTIMIZED_FOR_SPEED    = &h8  ' Lets the driver decide in which format the textures are created and tries to create them maximizing render speed. When using this flag, it does not make sense to use the flags ETCF_ALWAYS_16_BIT, ETCF_ALWAYS_32_BIT, or ETCF_OPTIMIZED_FOR_QUALITY, at the same time.  
    ETCF_CREATE_MIP_MAPS        = &h10 ' Automatically creates mip map levels for the textures.  
    ETCF_NO_ALPHA_CHANNEL       = &h20 ' Discard any alpha layer and use non-alpha color format.  
    ETCF_ALLOW_NON_POWER_2      = &h40 ' Allow non power of two dimention textures
End Enum

' A color format specifies how color information is stored
Enum IRR_COLOR_FORMAT
    ECF_A1R5G5B5 = 0    ' 16 bit color format used by the software driver, and thus preferred by all other irrlicht engine video drivers. There are 5 bits for every color component, and a single bit is left for alpha information.  
    ECF_R5G6B5          ' Standard 16 bit color format.  
    ECF_R8G8B8          ' 24 bit color, no alpha channel, but 8 bit for red, green and blue.  
    ECF_A8R8G8B8        ' Default 32 bit color format. 8 bits are used for every component: red, green, blue and alpha.  
End Enum

Enum IRR_TEXTURE_BLEND
    BLEND_SCREEN = 0
    BLEND_ADD
    BLEND_SUBTRACT
    BLEND_MULTIPLY
    BLEND_DIVIDE
End Enum

Enum IRR_COLOR_MATERIAL
    ECM_NONE = 0            ' Dont use vertex color for lighting
    ECM_DIFFUSE             ' Use vertex color for diffuse light, (default)
    ECM_AMBIENT             ' Use vertex color for ambient light
    ECM_EMISSIVE            ' Use vertex color for emissive light
    ECM_SPECULAR            ' Use vertex color for specular light
    ECM_DIFFUSE_AND_AMBIENT ' Use vertex color for both diffuse and ambient light
End Enum

Enum IRR_DEBUG
    EDS_OFF = 0
    EDS_BBOX = 1
    EDS_NORMALS = 2
    EDS_SKELETON = 4
    EDS_MESH_WIRE_OVERLAY = 8
    EDS_HALF_TRANSPARENCY = 16
    EDS_BBOX_BUFFERS = 32
    EDS_FULL = &hffffffff
End Enum

Enum IRR_EGUI_EVENT_TYPE
    ' A gui element has lost its focus.
    EGET_ELEMENT_FOCUS_LOST = 0,
    ' A gui element has got the focus.
    EGET_ELEMENT_FOCUSED
    ' The mouse cursor hovered over a gui element.
    EGET_ELEMENT_HOVERED
    ' The mouse cursor left the hovered element.
    EGET_ELEMENT_LEFT
    ' An element would like to close.
    EGET_ELEMENT_CLOSED
    ' A button was clicked.
    EGET_BUTTON_CLICKED
    ' A scrollbar has changed its position.
    EGET_SCROLL_BAR_CHANGED
    ' A checkbox has changed its check state.
    EGET_CHECKBOX_CHANGED
    ' A new item in a listbox was seleted.
    EGET_LISTBOX_CHANGED
    ' An item in the listbox was selected, which was already selected.
    EGET_LISTBOX_SELECTED_AGAIN
    ' A file has been selected in the file dialog
    EGET_FILE_SELECTED
    ' A directory has been selected in the file dialog
    EGET_DIRECTORY_SELECTED
    ' A file open dialog has been closed without choosing a file
    EGET_FILE_CHOOSE_DIALOG_CANCELLED
    ' 'Yes' was clicked on a messagebox
    EGET_MESSAGEBOX_YES
    ' 'No' was clicked on a messagebox
    EGET_MESSAGEBOX_NO
    ' 'OK' was clicked on a messagebox
    EGET_MESSAGEBOX_OK
    ' 'Cancel' was clicked on a messagebox
    EGET_MESSAGEBOX_CANCEL
    ' In an editbox 'ENTER' was pressed
    EGET_EDITBOX_ENTER
    ' The text in an editbox was changed. This does not include automatic changes in text-breaking.
    EGET_EDITBOX_CHANGED
    ' The marked area in an editbox was changed.
    EGET_EDITBOX_MARKING_CHANGED
    ' The tab was changed in an tab control
    EGET_TAB_CHANGED
    ' A menu item was selected in a (context) menu
    EGET_MENU_ITEM_SELECTED
    ' The selection in a combo box has been changed
    EGET_COMBO_BOX_CHANGED
    ' The value of a spin box has changed
    EGET_SPINBOX_CHANGED
    ' A table has changed
    EGET_TABLE_CHANGED
    EGET_TABLE_HEADER_CHANGED
    EGET_TABLE_SELECTED_AGAIN
    ' A tree view node lost selection. See IGUITreeView::getLastEventNode().
    EGET_TREEVIEW_NODE_DESELECT
    ' A tree view node was selected. See IGUITreeView::getLastEventNode().
    EGET_TREEVIEW_NODE_SELECT
    ' A tree view node was expanded. See IGUITreeView::getLastEventNode().
    EGET_TREEVIEW_NODE_EXPAND
    ' A tree view node was collapsed. See IGUITreeView::getLastEventNode().
    EGET_TREEVIEW_NODE_COLLAPS
    ' No real event. Just for convenience to get number of events
    EGET_COUNT
End Enum

Enum IRR_GUI_COLOR_ELEMENT
    EGDC_3D_DARK_SHADOW = 0     ' Dark shadow for three-dimensional display elements.  
    EGDC_3D_SHADOW              ' Shadow color for three-dimensional display elements (for edges facing away from the light source).  
    EGDC_3D_FACE                ' Face color for three-dimensional display elements and for dialog box backgrounds.  
    EGDC_3D_HIGH_LIGHT          ' Highlight color for three-dimensional display elements (for edges facing the light source.).  
    EGDC_3D_LIGHT               ' Light color for three-dimensional display elements (for edges facing the light source.).  
    EGDC_ACTIVE_BORDER          ' Active window border.  
    EGDC_ACTIVE_CAPTION         ' Active window title bar text.  
    EGDC_APP_WORKSPACE          ' Background color of multiple document interface (MDI) applications.  
    EGDC_BUTTON_TEXT            ' Text on a button.  
    EGDC_GRAY_TEXT              ' Grayed (disabled) text.  
    EGDC_HIGH_LIGHT             ' Item(s) selected in a control.  
    EGDC_HIGH_LIGHT_TEXT        ' Text of item(s) selected in a control.  
    EGDC_INACTIVE_BORDER        ' Inactive window border.  
    EGDC_INACTIVE_CAPTION       ' Inactive window caption.  
    EGDC_TOOLTIP                ' Tool tip text color.  
    EGDC_TOOLTIP_BACKGROUND     ' Tool tip background color.  
    EGDC_SCROLLBAR              ' Scrollbar gray area.  
    EGDC_WINDOW                 ' Window background.  
    EGDC_WINDOW_SYMBOL          ' Window symbols like on close buttons, scroll bars and check boxes.  
    EGDC_ICON                   ' Icons in a list or tree.  
    EGDC_ICON_HIGH_LIGHT        ' Selected icons in a list or tree.  
    EGDC_COUNT                  ' this value is not used, it only specifies the amount of default colors available.  
End Enum

#Include "IrrlichtKeyEnum.bi"

'' ////////////////////////////////////////////////////////////////////////////
'' Constant Definitions

' No value, usually used when you do not wish to pass an object to a call
#define IRR_NO_OBJECT 0

' Parenting of nodes
#define IRR_NO_PARENT 0

' Flag definition
#define IRR_OFF 0
#define IRR_ON 1

' Input definitions
#define IRR_KEY_UP 0
#define IRR_KEY_DOWN 1

' The number of bits per pixel in the display
#define IRR_BITS_PER_PIXEL_16 16
#define IRR_BITS_PER_PIXEL_32 32

' System Device definitions
#define IRR_WINDOWED 0
#define IRR_FULLSCREEN 1

#define IRR_NO_SHADOWS 0
#define IRR_SHADOWS 1

#define IRR_IGNORE_EVENTS 0
#define IRR_CAPTURE_EVENTS 1

#define IRR_LINEAR_FOG 0
#define IRR_EXPONENTIAL_FOG 1

#define IRR_VERTICAL_SYNC_OFF 0
#define IRR_VERTICAL_SYNC_ON 1

' Filing system definitions
#define IRR_USE_CASE 0
#define IRR_IGNORE_CASE 1
#define IRR_USE_PATHS 0
#define IRR_IGNORE_PATHS 1

' 2D image definitions
#define IRR_IGNORE_ALPHA 0
#define IRR_USE_ALPHA 1

' Node definitions
#define IRR_INVISIBLE 0
#define IRR_VISIBLE 1

#define IRR_ONE_SHOT 0
#define IRR_LOOP 1

' Particle definitions
#define IRR_NO_EMITTER 0
#define IRR_DEFAULT_EMITTER 1

#define IRR_ATTRACT 1
#define IRR_REPEL 0

' GUI Interface definitions
#define IRR_GUI_NO_BORDER 0
#define IRR_GUI_BORDER 1
#define IRR_GUI_NO_WRAP 0
#define IRR_GUI_WRAP 1
#define IRR_GUI_HORIZONTAL 1
#define IRR_GUI_VERTICAL 0
#define IRR_GUI_MODAL 1
#define IRR_GUI_NOT_MODAL 0
#define IRR_GUI_DRAW_BACKGROUND 1
#define IRR_GUI_EMPTY_BACKGROUND 0
#define IRR_GUI_PASSWORD 1
#define IRR_GUI_NOT_PASSWORD 0

' Spherical Terrain Faces
#define IRR_TOP_FACE 0
#define IRR_FRONT_FACE 1
#define IRR_BACK_FACE 2
#define IRR_LEFT_FACE 3
#define IRR_RIGHT_FACE 4
#define IRR_BOTTOM_FACE 5


'' ////////////////////////////////////////////////////////////////////////////
'' Type Definitions

' Irrlicht Keyboard and Mouse Event Structures
TYPE IRR_MOUSE_EVENT
    action as uinteger
    delta as single
    x as integer
    y as integer
END TYPE

TYPE IRR_KEY_EVENT
    key as uinteger
    direction as uinteger
    flags as uinteger
END TYPE

TYPE IRR_GUI_EVENT
    id as integer
    event as IRR_EGUI_EVENT_TYPE
    x as integer
    y as integer
END TYPE

' Particle emitter properties
TYPE IRR_PARTICLE_EMITTER
    min_box_x as single     ' The bounding box for the emitter
    min_box_y as single
    min_box_z as single

    max_box_x as single
    max_box_y as single
    max_box_z as single

    direction_x as single
    direction_y as single
    direction_z as single

    min_paritlcles_per_second as uinteger
    max_paritlcles_per_second as uinteger

    min_start_color_red as integer
    min_start_color_green as integer
    min_start_color_blue as integer

    max_start_color_red as integer
    max_start_color_green as integer
    max_start_color_blue as integer
    
    min_lifetime as uinteger
    max_lifetime as uinteger
    
    min_start_sizeX as single
    min_start_sizeY as single
    
    max_start_sizeX as single
    max_start_sizeY as single
    
    max_angle_degrees as integer
END TYPE

' a vertex used in creating custom static mesh objects
TYPE IRR_VERT
    x as single             ' The x position of the vertex
    y as single             ' The y position of the vertex
    z as single             ' The z position of the vertex
    normal_x as single      ' The x normal of the vertex
    normal_y as single      ' The y normal of the vertex
    normal_z as single      ' The z normal of the vertex
    vcolor as uinteger      ' The 32bit ARGB color of the vertex
    texture_x as single     ' the x co-ordinate of the vertex on the texture (0 to 1)
    texture_y as single     ' the y co-ordinate of the vertex on the texture (0 to 1)
END TYPE

' a vector consisting of 3 float values
TYPE IRR_VECTOR
    x as single
    y as single
    z as single
END TYPE

' a size consisting of 2 float values
TYPE IRR_SIZE
    x as single
    y as single
END TYPE

' the contents of a key event
Type SKeyMap
    Action As EKEY_ACTION
    KeyCode As EKEY_CODE
End Type

' a material representing a new shader
Type IRR_SHADER
    ' use the material type in a call to IrrSetNodeMaterialType
    material_type as INTEGER
    ' the following properties are reserved for internal use changing them can
    ' result in crashes and memory leakage
    material_object as UINTEGER PTR
    next_shader as UINTEGER PTR
End Type

Type SBillboard
    Position as IRR_VECTOR
    Size as IRR_SIZE
    Roll as single
    Axis as IRR_VECTOR
    HasAxis as integer
    sColor as integer
    
    vertexIndex as uinteger
    sprev as any ptr
    snext as any ptr
End Type


' .............................................................................
' Irrlicht Object Types - these are used to represent objects in the Irrlicht
' engine and their purpose is to warn the programmer of type errors
' (thanks to v1ctor for the advice on this correction)
TYPE irr_mesh as UINTEGER PTR

TYPE irr_image as UINTEGER PTR

TYPE irr_texture as UINTEGER PTR

TYPE irr_material as UINTEGER PTR

TYPE irr_node as UINTEGER PTR

TYPE irr_camera as UINTEGER PTR

TYPE irr_terrain as UINTEGER PTR

TYPE irr_selector as UINTEGER PTR

TYPE irr_particle_system as UINTEGER PTR

TYPE irr_emitter as UINTEGER PTR

TYPE irr_affector as UINTEGER PTR

TYPE irr_animator as UINTEGER PTR

TYPE irr_font as UINTEGER PTR

Type irr_scene_node As uInteger Ptr

Type irr_gui_object as Any Ptr

UNION irr_model
    node as irr_node
    camera as irr_camera
    terrain as irr_terrain
    particles as irr_particle_system
END UNION


Extern "c"

'' ////////////////////////////////////////////////////////////////////////////
'' System Functions

' Start the Irrlicht interface (depreciated command)
Declare Sub IrrStart Alias "IrrStart" ( _
    ByVal device_type As IRR_DEVICE_TYPES, _
    ByVal iwidth As Integer, _
    ByVal iheight As Integer, _
    ByVal bitsperpixel As unSigned Integer, _
    ByVal fullscreen As Integer, _
    ByVal use_shadows As Integer, _
    ByVal iCaptureMouse As Integer, _
    ByVal vsync as Integer = IRR_OFF )

' an advanced method of starting the irrlicht interface
declare function IrrStartAdvanced Alias "IrrStartAdvanced" ( _
    byval drivertype as IRR_DEVICE_TYPES, _
    byval scrWidth as integer, _
    byval scrHeight as integer, _
    byval bits as uinteger, _
    byval fullscreen as uinteger, _
    byval shadows as uinteger, _
    byval dontignoreinput as uinteger, _
    byval vsyncenabled as uinteger = IRR_OFF, _
    byval devicetype as uinteger = 0, _
    byval doublebufferenabled as uinteger = IRR_ON, _
    byval antialiasenabled as uinteger = 0, _
    byval highprecisionfpu as uinteger = IRR_OFF ) as uinteger

' allow transparency to write to the z buffer
Declare Sub IrrTransparentZWrite Alias "IrrTransparentZWrite" ()

' determine if the Irrlicht viewport is running. 0 = No 1 = Yes
declare function IrrRunning alias "IrrRunning" () as integer

' limit drawing to a specific area of the screen
declare sub IrrSetViewPort alias "IrrSetViewPort" ( byval topX as integer, byval topY as integer, byval botX as integer, byval botY as integer )

' initialise the frame drawing cycle, erasing the canvas ready for drawing
declare sub IrrBeginScene overload alias "IrrBeginScene" ( byval red as integer, byval green as integer, byval blue as integer)

' Readies a scene for rendering, erasing the canvas and setting a background color.
declare Sub IrrBeginSceneAdvanced overload Alias "IrrBeginSceneAdvanced" ( _
    Byval sceneBackgroundColor As Uinteger, _
    Byval clearBackBuffer As Ubyte = 1, _
    Byval clearZBuffer As Ubyte = 1)

' draw the scene to the canvas
declare sub IrrDrawScene alias "IrrDrawScene" ()

' draw scene manager objects to a texture surface, the texture must have been
' created with a call to IrrCreateRenderTargetTexture
declare sub IrrDrawSceneToTexture alias "IrrDrawSceneToTexture" ( byval texture as irr_texture )

' Sets a texture as a render target, or sets the device if the pointer is 0.
Declare Sub IrrSetRenderTarget Alias "IrrSetRenderTarget" (Byval texture As irr_texture, Byval sceneBackgroundColor As Uinteger = 0, Byval clearBackBuffer As Ubyte = 1, Byval clearZBuffer As Ubyte = 1)

' draw the user interface to the canvas
declare sub IrrDrawGUI alias "IrrDrawGUI" ()

' end all drawing operations and display the rendered frame
declare sub IrrEndScene alias "IrrEndScene" ()

' Stop the Irrlicht engine freeing up its resources
declare sub IrrClose alias "IrrClose" ()

' Stop the Irrlicht engine freeing up its resources
declare sub IrrStop alias "IrrStop" ()

' Query a feature of the video card, returns 1 if it is supported and 0 if it isnt
declare function IrrQueryFeature alias "IrrQueryFeature" ( byval Feature as IRR_VIDEO_FEATURE_QUERY ) as uinteger

' Disable a feature of the video card
declare sub IrrDisableFeature alias "IrrDisableFeature" ( byval Feature as IRR_VIDEO_FEATURE_QUERY, byval state as uinteger )

' get the current time in milliseconds
declare function IrrGetTime alias "IrrGetTime" () as uinteger

' set the current time in milliseconds
declare sub IrrSetTime alias "IrrSetTime" ( newTime as uinteger )

' get the current frame rate
declare function IrrGetFPS alias "IrrGetFPS" () as integer

' get the number of primitives (mostly triangles) drawn in the last frame
declare function IrrGetPrimitivesDrawn alias "IrrGetPrimitivesDrawn" () as uinteger


' set the caption in the irrlicht window
declare sub IrrSetWindowCaption alias "IrrSetWindowCaption" ( byval text as wstring ptr )

' make 32 bit representation of an Alpha, Red, Green, Blue color
function IrrMakeARGB ( Alpha as integer, Red as integer, Green as integer, Blue as integer ) as uinteger
    IrrMakeARGB = (Alpha SHL 24) + (Red SHL 16) + (Green SHL 8) + Blue
end function

' Gets the screen size.
declare sub irrGetScreenSize alias "IrrGetScreenSize" (byref width as integer, byref height as integer)

' Checks if the Irrlicht window is running in fullscreen mode.
declare function IrrIsFullscreen alias "IrrIsFullscreen" () as integer

' Returns if the window is active.
declare function IrrIsWindowActive alias "IrrIsWindowActive" () as integer

'Checks if the Irrlicht window has focus.
declare function IrrIsWindowFocused alias "IrrIsWindowFocused" () as integer

' Checks if the Irrlicht window is minimized.
declare function IrrIsWindowMinimized alias "IrrIsWindowMinimized" () as integer

' Maximizes the window if possible.
declare sub IrrMaximizeWindow alias "IrrMaximizeWindow" ()

' Minimizes the window if possible.
declare sub IrrMinimizeWindow alias "IrrMinimizeWindow" ()

' Restore the window to normal size if possible. 
declare sub IrrRestoreWindow alias "IrrRestoreWindow" ()

' Make the window resizable.
declare sub IrrSetResizableWindow alias "IrrSetResizableWindow" ( byval resizable as integer )


'' ////////////////////////////////////////////////////////////////////////////
'' Bitplanes XEffect Extension

' start the XEffects system
declare sub IrrXEffectsStart alias "IrrXEffectsStart" ( _
        byval vsm as integer = 0, _
        byval softShadows as integer = 0, _
        byval bitdepth32 as integer = 0 )

' enable XEffects depth pass
declare sub IrrXEffectsEnableDepthPass alias "IrrXEffectsEnableDepthPass" ( _
        byval enable as integer )

' add a shader program effect from a file
declare sub IrrXEffectsAddPostProcessingFromFile alias "IrrXEffectsAddPostProcessingFromFile" ( _
        byval name as zstring ptr, _
        byval effectType as integer = 0 )

' Sets the user defined post processing texture. This is used internally for
' the SSAO shader but is used primarily for the water shader where it defines
' the specular surface pattern of the water.
declare sub IrrXEffectsSetPostProcessingUserTexture alias "IrrXEffectsSetPostProcessingUserTexture" ( _
        byval texture as irr_texture )

' adds a shadowing effect to a node
declare sub IrrXEffectsAddShadowToNode alias "IrrXEffectsAddShadowToNode" ( _
        byval node as irr_node, _
        byval filterType as E_FILTER_TYPE = EFT_NONE, _
        byval shadowType as E_SHADOW_MODE = ESM_BOTH )

' remove a shadowing effect from a node
declare sub IrrXEffectsRemoveShadowFromNode alias "IrrXEffectsRemoveShadowFromNode" ( _
        byval node as irr_node )

' exclude a node from being calculated in shadowing equations
declare sub IrrXEffectsExcludeNodeFromLightingCalculations alias "IrrXEffectsExcludeNodeFromLightingCalculations" ( _
        byval node as irr_node )

' adds a node to the list of nodes used for calculating the depth pass
declare sub IrrXEffectsAddNodeToDepthPass alias "IrrXEffectsAddNodeToDepthPass" ( _
        byval node as irr_node )

' sets the ambient lighting procuded in the scene by the XEffects system
declare sub IrrXEffectsSetAmbientColor alias "IrrXEffectsSetAmbientColor" ( _
        byval R as uinteger, byval G as uinteger, byval B as uinteger, byval Alpha as uinteger )

' the XEffects system uses a different background color to the one specified in
' the IrrBeginScene call use this call to set this default background color
declare sub IrrXEffectsSetClearColor alias "IrrXEffectsSetClearColor" ( _
        byval R as uinteger, byval G as uinteger, byval B as uinteger, byval Alpha as uinteger )

' Add a special dynamic shadow casting light
' The first parameter specifies the shadow map resolution for the shadow light.
' The shadow map is always square, so you need only pass 1 dimension, preferably
' a power of two between 512 and 2048, maybe larger depending on your quality
' requirements and target hardware.
' The second parameter is the light position, the third parameter is the (look at)
' target, the next is the light color, and the next two are very important
' values, the nearValue and farValue, be sure to set them appropriate to the current
' scene. The last parameter is the FOV (Field of view), since the light is similar to
' a spot light, the field of view will determine its area of influence. Anything that
' is outside of a lights frustum (Too close, too far, or outside of it's field of view)
' will be unlit by this particular light, similar to how a spot light works.
declare sub IrrXEffectsAddShadowLight alias "IrrXEffectsAddShadowLight" ( _
	byval shadowDimen as uinteger, _
	byVal posX as single, byVal posY as single, byVal posZ as single, _
	byVal targetX as single, byVal targetY as single, byVal targetZ as single, _
	byval R as single, byval G as single, byval B as single, byval Alpha as single, _
	byval lightNearDist as single, byval lightFarDist as single, _
	byval angleDegrees as single )

' Set the position of a shadow light. the index refers to the numerical order
' in which the lights were added.
declare sub IrrXEffectsSetShadowLightPosition alias "IrrXEffectsSetShadowLightPosition" ( _
    byval index as uinteger, byVal posX as single, byVal posY as single, byVal posZ as single )

' Get the position of a shadow light. the index refers to the numerical order
' in which the lights were added.
declare sub IrrXEffectsGetShadowLightPosition alias "IrrXEffectsGetShadowLightPosition" ( _
	byval index as uinteger, byref posX as single, byref posY as single, byref posZ as single )

' Set the target location of a shadow light. the index refers to the numerical
' order in which the lights were added.
declare sub IrrXEffectsSetShadowLightTarget alias "IrrXEffectsSetShadowLightTarget" ( _
	byval index as uinteger, byVal posX as single, byVal posY as single, byVal posZ as single )

' Get the target location of a shadow light. the index refers to the numerical
' order in which the lights were added.
declare sub IrrXEffectsGetShadowLightTarget alias "IrrXEffectsGetShadowLightTarget" ( _
	byval index as uinteger, byref posX as single, byref posY as single, byref posZ as single )

' Set the target location of a shadow light. the index refers to the numerical
' order in which the lights were added.
declare sub IrrXEffectsSetShadowLightColor alias "IrrXEffectsSetShadowLightColor" ( _
	byval index as uinteger, byval R as single, byval G as single, byval B as single, _
    byval Alpha as single )

' Get the target location of a shadow light. the index refers to the numerical
' order in which the lights were added.
declare sub IrrXEffectsGetShadowLightColor alias "IrrXEffectsGetShadowLightColor" ( _
	byval index as uinteger, byref R as single, byref G as single, byref B as single, _
    byref Alpha as single )


'' ////////////////////////////////////////////////////////////////////////////
'' Input Event Functions

' find out if there is a key event ready to be read. returns 1 if there is an
' event available (the event receiver must have been started when the system
' was initialised)
declare function IrrKeyEventAvailable alias "IrrKeyEventAvailable" () as integer

' read a key event out
declare function IrrReadKeyEvent alias "IrrReadKeyEvent" () as IRR_KEY_EVENT PTR

' find out if there is a mouse event ready to be read. returns 1 if there is an
' event available (the event receiver must have been started when the system
' was initialised)
declare function IrrMouseEventAvailable alias "IrrMouseEventAvailable" () as integer

' read a mouse event out
declare function IrrReadMouseEvent alias "IrrReadMouseEvent" () as IRR_MOUSE_EVENT PTR

' whether keyboard and mouse events should be used by the GUI
declare function IrrGUIEvents alias "IrrGUIEvents" (eventsForGUI as integer ) as integer

' find out if there is a GUI event ready to be read. returns 1 if there is an
' event available (the event receiver must have been started when the system
' was initialised)
declare function IrrGUIEventAvailable alias "IrrGUIEventAvailable" () as integer

' read a GUI event out
declare function IrrReadGUIEvent alias "IrrReadGUIEvent" () as IRR_GUI_EVENT PTR

' show and hide the mouse pointer
#define IrrHideMouse IrrDisplayMouse(0)
#define IrrShowMouse IrrDisplayMouse(1)
declare sub IrrDisplayMouse alias "IrrDisplayMouse" ( byval show_mouse as uinteger)

' set the position of the mouse pointer and return the relative change in position
declare sub IrrSetMousePosition alias "IrrSetMousePosition" ( byref x as single, byref y as single )

' Gets the position of the mouse pointer.
declare sub IrrGetAbsoluteMousePosition alias "IrrGetAbsoluteMousePosition" ( byref x as integer, byref y as integer )



'' ////////////////////////////////////////////////////////////////////////////
'' Filing System Functions

' add zip archive to the filing system allowing you to load files straight out
' of the zip file. common pk3 files are simply zip files
declare sub IrrAddZipFile alias "IrrAddZipFile" ( byval path as zstring ptr, byval ignore_case as uinteger, byval ignore_paths as uinteger)

' set irrlicht current working directory
declare sub IrrChangeWorkingDirectory alias "IrrChangeWorkingDirectory" ( byval path as zstring ptr )

' get irrlicht current working directory
declare function IrrGetWorkingDirectory alias "IrrGetWorkingDirectory" () as zstring ptr



'' ////////////////////////////////////////////////////////////////////////////
'' 2D Functions

' sets texture creation flags, use IRR_ON and IRR_OFF to set the flag value
declare sub IrrSetTextureCreationFlag alias "IrrSetTextureCreationFlag" ( byval flag as IRR_TEXTURE_CREATION_FLAG, byval value as uinteger)

' load an image (images do not use video memory and cannot texture objects
declare function IrrGetImage alias "IrrGetImage" ( byval path as zstring ptr ) as irr_image

' load a texture object
declare function IrrGetTexture alias "IrrGetTexture" ( byval path as zstring ptr ) as irr_texture

' create a blank texture
declare function IrrCreateTexture alias "IrrCreateTexture" ( byval Name as zstring ptr, byval x as integer, byval y as integer, byval format as IRR_COLOR_FORMAT ) as irr_texture

' create a blank image
declare function IrrCreateImage alias "IrrCreateImage" ( byval x as integer, byval y as integer, byval format as IRR_COLOR_FORMAT ) as irr_image

' create a texture that is suitable for the scene manager to use as a surface to
' which it can render its 3d object. each the dimentions must be a power of two
' for example 128x128 or 256x256
declare function IrrCreateRenderTargetTexture alias "IrrCreateRenderTargetTexture" ( byval x as integer, byval y as integer ) as irr_texture

' remove a texture freeing its resources
declare sub IrrRemoveTexture alias "IrrRemoveTexture" ( byval texture as irr_texture )

' remove an image freeing its resources
declare sub IrrRemoveImage alias "IrrRemoveImage" ( byval image as irr_image )

' create a normal map from a grayscale heightmap texture
declare sub IrrMakeNormalMapTexture alias "IrrMakeNormalMapTexture" ( byval texture as irr_texture, byval amplitude as single)

' locks the texture and returns a pointer to the pixels
declare function IrrLockTexture alias "IrrLockTexture" ( byval texture as irr_texture ) as uinteger ptr

' unlock the texture, presumably after it has been modified and recreate the mipmap levels
declare sub IrrUnlockTexture alias "IrrUnlockTexture" ( byval texture as irr_texture )

' locks the image and returns a pointer to the pixels
declare function IrrLockImage alias "IrrLockImage" ( byval image as irr_image ) as uinteger ptr

' unlock the image, presumably after it has been modified
declare sub IrrUnlockImage alias "IrrUnlockImage" ( byval image as irr_image )

' blend the source texture into the destination texture to create a single texture
declare function IrrBlendTextures alias "IrrBlendTextures" ( byval destination_texture as irr_texture, byval source_texture as irr_texture, byval x_offset as integer, byval y_offset as integer, byval operation as integer ) as integer

' color key the image making parts of it transparent
declare sub IrrColorKeyTexture alias "IrrColorKeyTexture" ( byval texture as irr_texture, byval red as integer, byval green as integer, byval blue as integer)

' draw a 2d image to the display
declare sub IrrDraw2DImage alias "IrrDraw2DImage" ( byval texture as irr_texture, byval x as integer, byval y as integer )

' draw an image to the screen from a specified rectangle in the source image
' this enables you to place lots of images into one texture for 2D drawing. in
' addition this function also uses image alpha channels
declare sub IrrDraw2DImageElement alias "IrrDraw2DImageElement" ( byval texture as irr_texture, byval x as integer, byval y as integer, byval source_tx as integer, byval source_ty as integer, byval source_bx as integer, byval source_by as integer, byval usealpha as integer )

' draw an image to the screen while scaling it
Declare Sub IrrDraw2DImageElementStretch Alias "IrrDraw2DImageElementStretch" ( _
        Byval texture As irr_texture, _
        Byval dest_tx As Integer, _
        Byval dest_ty As Integer, _
        Byval dest_bx As Integer, _
        Byval dest_by As Integer, _
        Byval source_tx As Integer, _
        Byval source_ty As Integer, _
        Byval source_bx As Integer, _
        Byval source_by As Integer, _
        Byval usealpha As Integer )

' load a bitmap based font
declare function IrrGetFont alias "IrrGetFont" ( byval path as zstring ptr ) as irr_font

' draw text to the display using a bitmap font
declare sub Irr2DFontDraw alias "Irr2DFontDraw" ( byval font as irr_font, byval text as wstring ptr, byval top_x as integer, byval top_y as integer, byval bottom_x as integer, byval bottom_y as integer )

' save a screenshot out to a file
declare sub IrrSaveScreenShot alias "IrrSaveScreenShot" ( byval text as zstring ptr )

' save a screenshot out to a file
declare function IrrGetScreenShot alias "IrrGetScreenShot" ( x as uinteger, y as uinteger, w as uinteger, h as uinteger ) as irr_texture

' get information on a texture
declare sub IrrGetTextureInformation alias "IrrGetTextureInformation" ( _
        Byval texture as irr_texture, _
        Byref textureWidth as unsigned integer, _
        Byref textureHeight as unsigned integer, _
        Byref texturePitch as unsigned integer, _
        Byref textureFormat as IRR_COLOR_FORMAT )

' get information on a image
declare sub IrrGetImageInformation alias "IrrGetImageInformation" ( _
        Byval image as irr_image, _
        Byref imageWidth as unsigned integer, _
        Byref imageHeight as unsigned integer, _
        Byref imagePitch as unsigned integer, _
        Byref imageFormat as IRR_COLOR_FORMAT )


'' ////////////////////////////////////////////////////////////////////////////
'' Material and GPU Programming Functions

' Set material properties for a node.
Declare Sub IrrSetNodeAmbientColor Alias "IrrSetNodeAmbientColor" (Byval node As irr_node, Byval uColor As Uinteger)
Declare Sub IrrSetNodeDiffuseColor Alias "IrrSetNodeDiffuseColor" (Byval node As irr_node, Byval uColor As Uinteger)
Declare Sub IrrSetNodeSpecularColor Alias "IrrSetNodeSpecularColor" (Byval node As irr_node, Byval uColor As Uinteger)
Declare Sub IrrSetNodeEmissiveColor Alias "IrrSetNodeEmissiveColor" (Byval node As irr_node, Byval uColor As Uinteger)

' Set whether vertex color or material color is used to shade the surface of a node
declare sub IrrSetNodeColorByVertex alias "IrrSetNodeColorByVertex" ( byval node as irr_node, byval colorMaterial as IRR_COLOR_MATERIAL )

' Set whether vertex color or material color is used to shade the surface
declare sub IrrMaterialVertexColorAffects alias "IrrMaterialVertexColorAffects" ( byval material as irr_material, byval colorMaterial as IRR_COLOR_MATERIAL )

' Set how shiny the material is the higher the value the more defined the highlights
declare sub IrrMaterialSetShininess alias "IrrMaterialSetShininess" ( byval material as irr_material, byval shininess as single )

' The color of specular highlights on the object
declare sub IrrMaterialSetSpecularColor alias "IrrMaterialSetSpecularColor" ( byval material as irr_material, byval Alpha as uinteger, byval Red as uinteger, byval Green as uinteger, byval Blue as uinteger )

' The color of diffuse lighting on the object
declare sub IrrMaterialSetDiffuseColor alias "IrrMaterialSetDiffuseColor" ( byval material as irr_material, byval Alpha as uinteger, byval Red as uinteger, byval Green as uinteger, byval Blue as uinteger )

' The color of ambient light reflected by the object
declare sub IrrMaterialSetAmbientColor alias "IrrMaterialSetAmbientColor" ( byval material as irr_material, byval Alpha as uinteger, byval Red as uinteger, byval Green as uinteger, byval Blue as uinteger )

' The color of light emitted by the object
declare sub IrrMaterialSetEmissiveColor alias "IrrMaterialSetEmissiveColor" ( byval material as irr_material, byval Alpha as uinteger, byval Red as uinteger, byval Green as uinteger, byval Blue as uinteger )

' set material specific parameter
declare sub IrrMaterialSetMaterialTypeParam alias "IrrMaterialSetMaterialTypeParam" ( byval material as irr_material, byval value as single )

' set the blend functions for the ONETEXTURE_BLEND material type
declare sub IrrSetMaterialBlend alias "IrrSetMaterialBlend" ( byval material as irr_material, byval blendSrc as IRR_BLEND_FACTOR, byval blendDest as IRR_BLEND_FACTOR )

' set the vertex thickness of the material
declare sub IrrSetMaterialLineThickness alias "IrrSetMaterialLineThickness" ( byval material as irr_material, byval value as single)


' Creates a Vertex shader constant that allows you to change the value of a
' constant inside a GLSL shader during the execution of the program simply
' assign one of the preset constants to the constant name or attach the constant
' to an array of floats and change the constant simply by changing the values
' in your array
' Returns: 1 if the constant was sucessfully created
declare function IrrCreateNamedVertexShaderConstant alias "IrrCreateNamedVertexShaderConstant" ( byval shader as IRR_SHADER ptr, byval const_name as zstring ptr, byval const_preset as integer, byval const_data as single ptr, byval data_count as integer ) as integer

' Creates a Pixel shader constant, the operation of the function is the same
' as that of the vertex shader constant above.
' Returns: 1 if a constant was sucessfully created
declare function IrrCreateNamedPixelShaderConstant alias "IrrCreateNamedPixelShaderConstant" ( byval shader as IRR_SHADER ptr, byval const_name as zstring ptr, byval const_preset as integer, byval const_data as single ptr, byval data_count as integer ) as integer

' the same as IrrCreateNamedVertexShaderConstant but uses an address instead
' of a name for low level shaders
' Returns: 1 if a constant was sucessfully created
declare function IrrCreateAddressedVertexShaderConstant alias "IrrCreateAddressedVertexShaderConstant" ( byval shader as IRR_SHADER ptr, byval const_address as integer, byval const_preset as integer, byval const_data as single ptr, byval data_count as integer ) as integer

' the same as IrrCreateNamedPixelShaderConstant but uses an address instead
' of a name for low level shaders
' Returns: 1 if a constant was sucessfully created
declare function IrrCreateAddressedPixelShaderConstant alias "IrrCreateAddressedPixelShaderConstant" ( byval shader as IRR_SHADER ptr, byval const_address as integer, byval const_preset as integer, byval const_data as single ptr, byval data_count as integer ) as integer

' creates a new material using a high level shading language. these programs
' that run on the graphics card can greatly add to the realism of the output
' but only modern cards will support them. Currently only the HLSL/D3D9 and
' GLSL/OpenGL is supported.
' 
' vertex program:
'	String containing the source of the vertex shader program. This can be 0 if
'	no vertex program shall be used.  
' vertex_start_function:
'	Name of the entry function of the vertex shader program
' vertex_program_type:
'	Vertex shader version used to compile the GPU program
' pixel_program:
'	String containing the source of the pixel shader program. This can be 0 if
'	no pixel shader shall be used.  
' pixel_start_function:
'	Entry name of the function of the pixel shader program
' pixel_program_type:
'	Pixel shader version used to compile the GPU program
' baseMaterial:
'	Base material which renderstates will be used to shade the material.  
'
' Return:
'   Returns a type that contains a material_type number that can be used to
' shade nodes with this new material. If the shader could not be created it
' will return 0
'
declare function IrrAddHighLevelShaderMaterial alias "IrrAddHighLevelShaderMaterial" ( _
        byval vertex_program as zstring ptr, _
        byval vertex_start_function as zstring ptr, _
        byval vertex_prog_type as uinteger, _
        byval pixel_program as zstring ptr, _
        byval pixel_start_function as zstring ptr, _
        byval pixel_prog_type as uinteger, _
        byval material_type as uinteger ) as IRR_SHADER ptr

' Identical to IrrAddHighLevelShaderMaterial only this varient attempts to load
' the GPU programs from files
declare function IrrAddHighLevelShaderMaterialFromFiles alias "IrrAddHighLevelShaderMaterialFromFiles" ( _
        byval vertex_program_filename as zstring ptr, _
        byval vertex_start_function as zstring ptr, _
        byval vertex_prog_type as uinteger, _
        byval pixel_program_filename as zstring ptr, _
        byval pixel_start_function as zstring ptr, _
        byval pixel_prog_type as uinteger, _
        byval material_type as uinteger ) as IRR_SHADER ptr

' creates a new material using a high level shading language. these programs
' that run on the graphics card can greatly add to the realism of the output
' but only modern cards will support them. Currently only the HLSL/D3D9 and
' GLSL/OpenGL is supported.
' 
' vertex program:
'	String containing the source of the vertex shader program. This can be 0 if
'	no vertex program shall be used. For DX8 programs, the will always input
'	registers look like this: v0: position, v1: normal, v2: color, v3: texture
'	cooridnates, v4: texture coordinates 2 if available. For DX9 programs, you
'	can manually set the registers using the dcl_ statements.  
' pixel_program:
'	String containing the source of the pixel shader program. This can be 0 if
'	no pixel shader shall be used.  
' pixel_start_function:
'	Entry name of the function of the pixel shader program
' pixel_program_type:
'	Pixel shader version used to compile the GPU program
' baseMaterial:
'	Base material which renderstates will be used to shade the material.  
'
' Return:
'   Returns a type that contains a material_type number that can be used to
' shade nodes with this new material. If the shader could not be created it
' will return 0
'
declare function IrrAddShaderMaterial alias "IrrAddShaderMaterial" ( _
        byval vertex_program as zstring ptr, _
        byval pixel_program as zstring ptr, _
        byval material_type as uinteger ) as IRR_SHADER ptr

' Identical to IrraddShaderMaterial only this varient attempts to load the GPU
' programs from file.
declare function IrrAddShaderMaterialFromFiles alias "IrrAddShaderMaterialFromFiles" ( _
        byval vertex_program_filename as zstring ptr, _
        byval pixel_program_filename as zstring ptr, _
        byval material_type as uinteger ) as IRR_SHADER ptr



'' ////////////////////////////////////////////////////////////////////////////
'' Scene Manager Functions

' load a mesh from a file
declare function IrrGetMesh alias "IrrGetMesh" ( byval path as zstring ptr ) as irr_mesh

' create a mesh from an array of verticies, an array of incidies to those
' verticies that connect them to form triangles and finally texture co-ordinates
' to map the verticies against a texture plane
declare function IrrCreateMesh alias "IrrCreateMesh" (byval mesh_name as zstring ptr, byval vertex_count as integer, byref vertices as IRR_VERT, byval indices_count as integer, byref indices as ushort) as irr_mesh

' adds a hill plane mesh to the mesh pool
declare Function IrrAddHillPlaneMesh Alias "IrrAddHillPlaneMesh" ( ByVal mesh_name As zString Ptr, ByVal tileSizeX As Single, ByVal tileSizeY As Single, ByVal tileCountX As Integer, ByVal tileCountY As Integer, ByVal material As uInteger Ptr = 0, ByVal hillHeight As Single = 0, ByVal countHillsX As Single = 0, ByVal countHillsY As Single = 0, ByVal textureRepeatCountX As Single = 1, ByVal textureRepeatCountY As Single = 1 ) as irr_mesh

' create a batching mesh that will be a collection of other meshes
declare function IrrCreateBatchingMesh Alias "IrrCreateBatchingMesh" () as irr_mesh

' add a mesh to the batch of meshes
declare sub IrrAddToBatchingMesh Alias "IrrAddToBatchingMesh" ( _
        byval meshBatch as irr_mesh, _
        byval mesh as irr_mesh, _
        byval posX as single = 0.0f, byval posY as single = 0.0f, byval posZ as single = 0.0f, _
        byval rotX as single = 0.0f, byval rotY as single = 0.0f, byval rotZ as single = 0.0f, _
        byval scaleX as single = 1.0f, byval scaleY as single = 1.0f, byval scaleZ as single = 1.0f )

' finish adding meshes to the batch mesh and create an animated mesh from it
declare function IrrFinalizeBatchingMesh Alias "IrrFinalizeBatchingMesh" ( byval meshBatch as irr_mesh ) as irr_mesh


' write the first frame of the supplied animated mesh out to a file using the specified file format
declare function IrrWriteMesh alias "IrrWriteMesh" ( byval mesh as irr_mesh, byval file_format as IRR_MESH_FILE_FORMAT, byval path as zstring ptr ) as uinteger

' remove a loaded mesh from the scene cache useful if you are dealing with large
' numbers of meshes that you dont want cached in memory at the same time (for
' example when swapping between BSP maps for levels
declare sub IrrRemoveMesh alias "IrrRemoveMesh" (byval mesh as irr_mesh)


' rename a loaded mesh through the scene cache, the mesh can then subsequently be
' loaded again as a different mesh
declare sub IrrRenameMesh alias "IrrRenameMesh" (byval mesh as irr_mesh, byval newName as zstring ptr )

' Clears all meshes that are held in the mesh cache but not used anywhere else.
declare sub IrrClearUnusedMeshes alias "IrrClearUnusedMeshes" ()

' set a mesh to be a vertex buffer object offloaded to the graphics card. VBOs
' are only supported for meshes of 500 verticies and over and only on modern
' graphics cards
declare sub IrrSetMeshHardwareAccelerated alias "IrrSetMeshHardwareAccelerated" ( byval mesh as irr_mesh, byval frame as integer = 0 )

' associate a texture with a mesh
declare sub IrrSetMeshMaterialTexture alias "IrrSetMeshMaterialTexture" ( _
        byval mesh as irr_mesh, _
        byval texture as irr_texture, _
        byval material_index as integer, _
        byval buffer as integer = 0 )

' get the number of frames in the mesh
declare function IrrGetMeshFrameCount alias "IrrGetMeshFrameCount" ( byval mesh as irr_mesh ) as uinteger

' get the number of mesh buffers in the mesh
declare function IrrGetMeshBufferCount alias "IrrGetMeshBufferCount" ( byval mesh as irr_mesh, byval frame as integer ) as uinteger

' get the number of indicies in the mesh buffer
declare function IrrGetMeshIndexCount alias "IrrGetMeshIndexCount" ( byval mesh as irr_mesh, byval frame as integer, byval meshBuffer as integer = 0 ) as integer

' copy the indicies of a mesh into the supplied buffer, the caller must ensure
' that the buffer is big enough to store the data
declare sub IrrGetMeshIndices alias "IrrGetMeshIndices" ( byval mesh as irr_mesh, byval frame as integer, byref indicies as ushort, byval meshBuffer as integer = 0 )

' copy the indicies in the supplied buffer into the mesh , the caller must
' ensure that the buffer is big enough to supply all of the data
declare sub IrrSetMeshIndices alias "IrrSetMeshIndices" ( byval mesh as irr_mesh, byval frame as integer, byref indicies as ushort, byval meshBuffer as integer = 0 )

' get the number of vertices in the mesh buffer
declare function IrrGetMeshVertexCount alias "IrrGetMeshVertexCount" ( byval mesh as irr_mesh, byval frame as integer, byval meshBuffer as integer = 0 ) as integer

' copy the vertices of a mesh into the supplied buffer, the caller must ensure
' that the buffer is big enough to store the data
declare sub IrrGetMeshVertices alias "IrrGetMeshVertices" ( byval mesh as irr_mesh, byval frame as integer, byref verticies as IRR_VERT, byval meshBuffer as integer = 0 )

' copy the vertices in the supplied buffer into the mesh , the caller must
' ensure that the buffer is big enough to supply all of the data
declare sub IrrSetMeshVertices alias "IrrSetMeshVertices" ( byval mesh as irr_mesh, byval frame as integer, byref verticies as IRR_VERT, byval meshBuffer as integer = 0 )

' copy the vertices in the supplied buffer into the mesh , the caller must
' ensure that the buffer is big enough to supply all of the data
declare function IrrGetMeshVertexMemory alias "IrrGetMeshVertexMemory" ( _
        byval mesh as irr_mesh, _
        byval frame as integer = 0, _
        byval meshBuffer as integer = 0 ) as any ptr

' scale the co-ordinates of verticies in a mesh without affecting the normals
declare sub IrrScaleMesh alias "IrrScaleMesh" ( _
        byval mesh as irr_mesh, _
        byval scale as single, _
        byval frame as integer = 0, _
        byval meshBuffer as integer = 0, _
        byval mesh as irr_mesh = 0 )

' Copy only the color vertex data into the mesh.
declare sub IrrSetMeshVertexColors alias "IrrSetMeshVertexColors" ( _
    byval mesh as irr_mesh, _
    byval frame as uinteger, _
    byval vertexColor as uinteger ptr, _
    byval groupAmount as uinteger = 0, _
    byval startPos as uinteger ptr = 0, _
    byval endPos as uinteger ptr = 0, _
    byval meshbuffer as uinteger = 0 )

' Copy only the position vertex data into the mesh.
declare sub IrrSetMeshVertexCoords alias "IrrSetMeshVertexCoords" ( _
    byval mesh as irr_mesh, _
    byval frame as uinteger, _
    byval vertexCoord as irr_vector ptr, _
    byval groupAmount as uinteger = 0, _
    byval startPos as uinteger ptr = 0, _
    byval endPos as uinteger ptr = 0, _
    byval meshbuffer as uinteger = 0 )

' Copy only the color vertex data into the mesh -- a single color.
declare sub IrrSetMeshVertexSingleColor alias "IrrSetMeshVertexSingleColor" ( _
    byval mesh as irr_mesh, _
    byval frame as uinteger, _
    byval vertexColor as uinteger, _
    byval groupAmount as uinteger = 0, _
    byval startPos as uinteger ptr = 0, _
    byval endPos as uinteger ptr = 0, _
    byval meshbuffer as uinteger = 0 )

' Gets the bounding box of a mesh.
declare sub IrrGetMeshBoundingBox alias "IrrGetMeshBoundingBox" ( _
    byval mesh as irr_mesh, _
    byref minX as single, _
    byref minY as single, _
    byref minZ as single, _
    byref maxX as single, _
    byref maxY as single, _
    byref maxZ as single ) 

' gets the scenes root node, all scene nodes are children of this node
declare function IrrGetRootSceneNode alias "IrrGetRootSceneNode" () as irr_node

' add a loaded mesh to the scene as a new node
declare function IrrAddMeshToScene alias "IrrAddMeshToScene" ( byval mesh as irr_mesh) as irr_node

' add a loaded mesh to the scene as an octtree. this is an efficient method
' for large complex meshes like BSP maps that occlude themselves a lot
declare function IrrAddMeshToSceneAsOcttree alias "IrrAddMeshToSceneAsOcttree" (byval mesh as irr_mesh) as irr_node

' add a loaded mesh to the irrlicht scene manager using a static mesh buffer,
' tangent vertex information is added to allow the scene node to be used with
' normal and parallax mapping materials
declare function IrrAddStaticMeshForNormalMappingToScene alias "IrrAddStaticMeshForNormalMappingToScene" ( byval mesh as irr_mesh) as irr_node


' load a scene created by irrEdit
declare Sub IrrLoadScene Alias "IrrLoadScene" (ByVal filename As zstring ptr) 

' save the current scene into a file that can be loaded by irrEdit
declare Sub IrrSaveScene Alias "IrrSaveScene" (ByVal filename As zstring ptr) 

' get a scene node based on its ID and returns null if no node is found
declare function IrrGetSceneNodeFromId alias "IrrGetSceneNodeFromId" ( byval id as integer) as irr_node

' get a node in the scene based upon its name and returns null is no node is found
declare function IrrGetSceneNodeFromName alias "IrrGetSceneNodeFromName" ( byval name as zstring ptr) as irr_node

' adds a billboard to the scene this is a flat 3D textured sprite
declare function IrrAddBillBoardGroupToScene alias "IrrAddBillBoardGroupToScene" ( ) as irr_node

' adds a billboard to a group of billboards this is a flat 3D textured sprite
declare function IrrAddBillBoardToGroup alias "IrrAddBillBoardToGroup" ( _
        byval group as irr_node, _
        byval sizex as single, byval sizey as single, _
        byval x as single = 0, byval y as single = 0, byval z as single = 0, _
        byval roll as single = 0, _
        byval A as uinteger = 255, byval R as uinteger = 255, byval G as uinteger = 255, byval B as uinteger = 255 ) as any ptr

' adds a billboard to a group of billboards this is a flat 3D textured sprite
declare function IrrAddBillBoardByAxisToGroup alias "IrrAddBillBoardByAxisToGroup" ( _
        byval group as irr_node, _
        byval sizex as single, byval sizey as single, _
        byval x as single = 0, byval y as single = 0, byval z as single = 0, _
        byval roll as single = 0, _
        byval A as uinteger = 255, byval R as uinteger = 255, byval G as uinteger = 255, byval B as uinteger = 255, _
        byval axis_x as single = 0, byval axis_y as single = 0, byval axis_z as single = 0 ) as any ptr

' adds a billboard to a group of billboards this is a flat 3D textured sprite
declare sub IrrRemoveBillBoardFromGroup alias "IrrRemoveBillBoardFromGroup" ( _
        byval node as irr_node, byval billboard as any ptr )

' adds a billboard to a group of billboards this is a flat 3D textured sprite
declare sub IrrBillBoardGroupShadows alias "IrrBillBoardGroupShadows" ( _
        byval group as irr_node, _
        byval x as single = 1.0, byval y as single = 0, byval z as single = 0, _
        byval intensity as single = 1.0, byval ambient as single = 0.0 )

' adds a billboard to a group of billboards this is a flat 3D textured sprite
declare function IrrGetBillBoardGroupCount alias "IrrGetBillBoardGroupCount" ( byval group as irr_node ) as uinteger

' force an update of the billboard system
declare sub IrrBillBoardForceUpdate alias "IrrBillBoardForceUpdate" ( byval group as irr_node )

' adds a billboard to the scene this is a flat 3D textured sprite
declare function IrrAddBillBoardToScene alias "IrrAddBillBoardToScene" ( byval sizex as single, byval sizey as single, byval x as single = 0, byval y as single = 0, byval z as single = 0 ) as irr_node

' sets the color of a billboard node
declare sub IrrSetBillBoardColor alias "IrrSetBillBoardColor" ( byval node as irr_node, byval topColor as uinteger, byval bottomColor as integer )

' sets the size of a billboard node
declare sub IrrSetBillBoardSize alias "IrrSetBillBoardSize" ( byval node as irr_node, byval BillWidth as single, byval BillHeight as single )

' Adds a text scene node, which uses billboards. The node, and the text on it,
' will scale with distance.
declare function IrrAddBillboardTextSceneNode alias "IrrAddBillboardTextSceneNode" ( _
        byval font as irr_font, _
        byval text as wstring ptr, _
        byval sizex as single, _
        byval sizey as single, _
        byval x as single = 0, _
        byval y as single = 0, _
        byval z as single = 0, _
        ByVal parent As irr_node = 0, _
        byval topRGBA as uinteger = &hFFFFFFFF, _
        byval bottomRGBA as uinteger = &hFFFFFFFF ) as irr_node

' add a particle system to the irrlicht scene manager
Declare Function IrrAddParticleSystemToScene Alias "IrrAddParticleSystemToScene" ( ByVal add_emitter As Integer, ByVal parent As irr_node = 0, ByVal id As Integer = -1, ByVal posX As Single = 0, ByVal posY As Single = 0, ByVal posZ As Single = 0, ByVal rotX As Single = 0, ByVal rotY As Single = 0, ByVal rotZ As Single = 0, ByVal scaleX As Single = 1, ByVal scaleY As Single = 1, ByVal scaleZ As Single = 1) As irr_particle_system

' add a skybox to the irrlicht scene manager based on six pictures
declare function IrrAddSkyBoxToScene alias "IrrAddSkyBoxToScene" ( byval up_texture as irr_texture, byval down_texture as irr_texture, byval left_texture as irr_texture, byval right_texture as irr_texture, byval front_texture as irr_texture, byval back_texture as irr_texture ) as irr_node

' add a skydome to the irrlicht scene manager
declare Function IrrAddSkyDomeToScene Alias "IrrAddSkyDomeToScene" ( ByVal the_texture As irr_texture, ByVal horizontal_res As uInteger, ByVal vertical_res As uInteger, ByVal texture_percentage As Double, ByVal sphere_percentage As Double, ByVal radius as Double = 1000.0 ) As irr_node 

' adds an empty scene node.
Declare Function IrrAddEmptySceneNode Alias "IrrAddEmptySceneNode" () As irr_node

' adds a test node to the scene, the node is a simple cube
declare function IrrAddTestSceneNode alias "IrrAddTestSceneNode" () as irr_node

' adds a simple cube node to the scene
declare function IrrAddCubeSceneNode alias "IrrAddCubeSceneNode" ( byval size as single ) as irr_node

' adds a simple sphere node to the scene
declare function IrrAddSphereSceneNode alias "IrrAddSphereSceneNode" ( ByVal redius as single, ByVal polyCount as integer ) as irr_node

' adds a simple sphere node to the scene
declare function IrrAddSphereSceneMesh alias "IrrAddSphereSceneMesh" ( byval name as zstring ptr, ByVal redius as single, ByVal polyCount as integer ) as irr_mesh

' add a scene node for rendering an animated water surface mesh
declare Function IrrAddWaterSurfaceSceneNode Alias "IrrAddWaterSurfaceSceneNode" ( ByVal mesh As irr_mesh, ByVal waveHeight As Single = 2.0, ByVal waveSpeed As Single = 300.0, ByVal waveLength As Single = 10.0, ByVal parent As irr_scene_node = 0, ByVal id As Integer = -1, ByVal positionX As Single = 0, ByVal positionY As Single = 0, ByVal positionZ As Single = 0, ByVal rotationX As Single = 0, ByVal rotationY As Single = 0, ByVal rotationZ As Single = 0, ByVal scaleX As Single = 1.0, ByVal scaleY As Single = 1.0, ByVal scaleZ As Single = 1.0) as irr_node

' add a scene node for rendering an animated water surface mesh
declare Function IrrAddClouds Alias "IrrAddClouds" (byval texture as irr_texture, byval lod as uinteger, byval depth as uinteger, byval density as uinteger ) as irr_node

' add a cloud to a cloud scene node
declare Sub IrrAddCloud Alias "IrrAddCloud" (byval cloudNode as irr_node, byval X as single, byval Y as single, byval Z as single  )



' add a scene node for rendering a lens flare effect
declare Function IrrAddLensFlare Alias "IrrAddLensFlare" (byval texture as irr_texture) as irr_node

' add a scene node for rendering a patch of grass
declare Function IrrAddGrass Alias "IrrAddGrass" ( _
        byval terrain as irr_terrain, _
        byval x as integer, _
        byval y as integer, _
        byval patchSize as integer, _
        byval fadeDistance as single, _
        byval crossed as integer, _
        byval grassScale as single, _
        byval maxDensity as uinteger, _
        byval dataPositionX as integer, _
        byval dataPositionY as integer, _
        byval heightMap as irr_image, _
        byval textureMap as irr_image, _
        byval grassMap as irr_image, _
        byval grassTexture as irr_texture ) as irr_node

' adds a zonemanagement object
declare function IrrAddZoneManager alias "IrrAddZoneManager" ( _
        byval nearDistance as single = 0, _
        byval farDistance as single = 12000 ) as irr_node

declare sub IrrSetZoneManagerProperties alias "IrrSetZoneManagerProperties" ( _
        byval zoneNode as irr_node, _
        byval nearDistance as single, _
        byval farDistance as single, _
        byval accumulateChildBoxes as uinteger )

declare sub IrrSetZoneManagerBoundingBox alias "IrrSetZoneManagerBoundingBox" ( _
        byval zoneNode as irr_node, _
        byval x as single, _
        byval y as single, _
        byval z as single, _
        byval boxWidth as single, _
        byval boxHeight as single, _
        byval boxDepth as single )

declare sub IrrSetZoneManagerAttachTerrain alias "IrrSetZoneManagerAttachTerrain" ( _
        byval zoneNode as irr_node, _
        byval terrain as irr_terrain, _
        byval structureMapFile as zstring ptr, _
        byval colorMapFile as zstring ptr, _
        byval detailMapFile as zstring ptr, _
        byval ImageX as integer, _
        byval ImageY as integer, _
        byval sliceSize as integer )

' set grass density
declare sub IrrSetGrassDensity alias "IrrSetGrassDensity" ( byval grass as irr_node, byval density as integer, byval distance as single )

' set wind effect on grass
declare sub IrrSetGrassWind alias "IrrSetGrassWind" ( byval grass as irr_node, byval strength as single, byval resolution as single )

declare function IrrGetGrassDrawCount alias "IrrGetGrassDrawCount" ( byval grass as irr_node ) as uinteger

declare sub IrrSetFlareScale alias "IrrSetFlareScale" ( byval flare as irr_node, byval source as single, byval optics as single )

' set the color of shadows in the scene
declare sub IrrSetShadowColor alias "IrrSetShadowColor" ( byval Alpha as integer, byval R as integer, byval G as integer, byval B as integer )

' set the scene fog
declare sub IrrSetFog alias "IrrSetFog" ( byval R as integer, byval G as integer, byval B as integer, byval fogtype as integer, byval fog_start as single, byval fog_end as single, byval density as single )

' draw a 3D line into the display
declare sub IrrDraw3DLine alias "IrrDraw3DLine" ( byval xStart as single, byval yStart as single, byval zStart as single, byval xEnd as single, byval yEnd as single, byval zEnd as single, byval R as uinteger, byval G as uinteger, byval B as uinteger )

declare sub IrrSetSkyDomeColor alias "IrrSetSkyDomeColor" ( _
        byval dome as irr_node, _
        byval horizontalRed as uinteger, _
        byval horizontalGreen as uinteger, _
        byval horizontalBlue as uinteger, _
        byval zenithRed as uinteger, _
        byval zenithGreen as uinteger, _
        byval zenithBlue as uinteger )

' apply a colored band to the skydome this can be used to represent a change in
' lighting at the horizon
declare sub IrrSetSkyDomeColorBand alias "IrrSetSkyDomeColorBand" ( _
        byval dome as irr_node, _
        byval horizontalRed as uinteger, _
        byval horizontalGreen as uinteger, _
        byval horizontalBlue as uinteger, _
        byval bandVerticalPosition as integer, _
        byval bandFade as single, _
        byval addative as uinteger )

declare sub IrrSetSkyDomeColorPoint alias "IrrSetSkyDomeColorPoint" ( _
        byval dome as irr_node, _
        byval Red as uinteger, _
        byval Green as uinteger, _
        byval Blue as uinteger, _
        byval pointXPosition as single, _
        byval pointYPosition as single, _
        byval pointZPosition as single, _
        byval pointRadius as single, _
        byval pointFade as single, _
        byval addative as uinteger )

' add an imposter node to the scene
declare function IrrAddImpostor alias "IrrAddImpostor" () As irr_node

' add a level of detail manager to the scene
declare function IrrAddLODManager alias "IrrAddLODManager" ( byval fadeScale as uinteger = 4, byval useAlpha as uinteger = IRR_ON, byval callback as any ptr = 0 ) As irr_node

' add a mesh to the level of detail manager to be used at a specific range
declare sub IrrAddLODMesh alias "IrrAddLODMesh" ( byval node as irr_node, byval distance as single, byval mesh as irr_mesh )

' sets material mapping for fading nodes
declare sub IrrSetLODMaterialMap alias "IrrSetLODMaterialMap" ( byval node as irr_node, byval source as IRR_MATERIAL_TYPES, byval target as IRR_MATERIAL_TYPES )

' add a bolt node to the scene
declare function IrrAddBoltSceneNode alias "IrrAddBoltSceneNode" () As irr_node

' aset the properties of the bolt node
declare sub IrrSetBoltProperties alias "IrrSetBoltProperties" ( _
        byval bolt as irr_node, _
        byval sx as single, byval sy as single, byval sz as single, _
        byval ex as single, byval ey as single, byval ez as single, _
        byval updateTime as uinteger = 50, _
        byval height as uinteger = 10, _
        byval thickness as single = 5.0, _
        byval parts as uinteger = 10, _
        byval bolts as uinteger = 6, _
        byval steadyend as uinteger = IRR_OFF, _
        byval boltColor as uinteger = RGBA(0,0,255,255))

' add a beam node to the scene
declare function IrrAddBeamSceneNode alias "IrrAddBeamSceneNode" () As irr_node

' set the size of a beam
declare sub IrrSetBeamSize alias "IrrSetBeamSize" ( byval beam as irr_node, byval size as single )

' set the position of a beam
declare sub IrrSetBeamPosition alias "IrrSetBeamPosition" ( _
        byval bolt as irr_node, _
        byval sx as single, byval sy as single, byval sz as single, _
        byval ex as single, byval ey as single, byval ez as single )


'' ////////////////////////////////////////////////////////////////////////////
'' Scene Node Functions

' Get the number of materials associated with the node
declare function IrrGetMaterialCount alias "IrrGetMaterialCount" ( byval node as irr_node) as uinteger

' Get the material associated with the node at the particular index
declare function IrrGetMaterial alias "IrrGetMaterial" ( byval node as irr_node, byval index as uinteger) as irr_material

' apply an image file as a texturing material to a node
declare sub IrrSetNodeMaterialTexture alias "IrrSetNodeMaterialTexture" ( byval node as irr_node, byval texture as irr_texture, byval material_index as integer )

' set a material flag property on a node. the value can be either 0 or 1
declare sub IrrSetNodeMaterialFlag alias "IrrSetNodeMaterialFlag" ( byval node as irr_node, byval flag as IRR_MATERIAL_FLAGS, byval value as uinteger )

' set the way the materials applied to the node are rendered
declare sub IrrSetNodeMaterialType alias "IrrSetNodeMaterialType" ( byval node as irr_node, byval mat_type as IRR_MATERIAL_TYPES )


' move a node in the scene to a new position
declare sub IrrSetNodePosition alias "IrrSetNodePosition" ( byval node as irr_node, byval X as single, byval Y as single, byval Z as single )

' rotate a node in the scene
declare sub IrrSetNodeRotation alias "IrrSetNodeRotation" ( byval node as irr_node, byval X as single, byval Y as single, byval Z as single )

' scale a node in the scene
declare sub IrrSetNodeScale alias "IrrSetNodeScale" ( byval node as irr_node, byval X as single, byval Y as single, byval Z as single )

' apply a change in rotation and a directional force. we can also optionally 
' recover pointers to a series of vectors.
' the first is a pointer to a vector pointing forwards
' the second is a pointer a vector pointing upwards
' following this are any number of points that will also be rotated
' (the effect on these points is NOT accumulative)
declare Sub IrrSetNodeRotationPositionChange Alias "IrrSetNodeRotationPositionChange" ( _
        byval camera as irr_camera, _
        byval yaw as single, _
        byval pitch as single, _
        byval roll as single, _
        byval drive as single = 0.0, _
        byval strafe as single = 0.0, _
        byval elevate as single = 0.0, _
        byval forwardVect as IRR_VECTOR ptr = 0, _
        byval upVect as IRR_VECTOR ptr = 0, _
        byval numOffsetVectors as uinteger, _
        byval offsetVect as IRR_VECTOR ptr = 0 )

'render debugging information for nodes to the display
declare sub IrrDebugDataVisible alias "IrrDebugDataVisible" ( byval node as irr_node, byval visible as integer = &hFFFFFFFF )


' get the position of the node in the scene
declare sub IrrGetNodePosition alias "IrrGetNodePosition" ( byval node as irr_node, byref X as single, byref Y as single, byref Z as single )

' get the absolute position of the node in the scene rather than its relative
' position in relation to its parent
declare sub IrrGetNodeAbsolutePosition alias "IrrGetNodeAbsolutePosition" ( byval node as irr_node, byref X as single, byref Y as single, byref Z as single )

' get the rotation of the node in the scene
declare sub IrrGetNodeRotation alias "IrrGetNodeRotation" ( byval node as irr_node, byref X as single, byref Y as single, byref Z as single )

' get the scale of the node in the scene
declare sub IrrGetNodeScale alias "IrrGetNodeScale" ( byval node as irr_node, byref X as single, byref Y as single, byref Z as single )


' set the portion of the animation sequence in the node that is to be played
declare sub IrrSetNodeAnimationRange alias "IrrSetNodeAnimationRange" ( byval node as irr_node, byval startFrame as integer, byval iEndFrame as integer )

' set the MD2 animation sequence to playback in the animation
declare sub IrrPlayNodeMD2Animation alias "IrrPlayNodeMD2Animation" ( byval node as irr_node, byval sequence as uinteger )

' set the speed of animation playback
declare sub IrrSetNodeAnimationSpeed alias "IrrSetNodeAnimationSpeed" ( byval node as irr_node, byval speed as single )

' get the current frame number being played in the animation
declare function IrrGetNodeAnimationFrame alias "IrrGetNodeAnimationFrame" ( byval node as irr_node ) as uinteger

' set the current frame number being played in the animation
declare sub IrrSetNodeAnimationFrame alias "IrrSetNodeAnimationFrame" ( byval node as irr_node, byval frame as single )

' set the time in seconds across which two animation frames are blended
declare sub IrrSetTransitionTime alias "IrrSetTransitionTime" ( byval node as irr_node, byval speed as single )

'Animates the mesh based on the position of the joints, this should be used at
'the end of any manual joint operations including blending and joints animated
'using IRR_JOINT_MODE_CONTROL and IrrSetNodeRotation on a bone node
declare sub IrrAnimateJoints alias "IrrAnimateJoints" ( byval node as irr_node )

' Sets the animation mode of joints in a node
' IRR_JOINT_MODE_NONE will result in no animation of the model based on bones
' IRR_JOINT_MODE_READ will result in automatic animation based upon 
' IRR_JOINT_MODE_CONTROL will allow the position of the bones to be set through code
' When using the control mode IrrAnimateJoints must be called before IrrDrawScene
declare sub IrrSetJointMode alias "IrrSetJointMode" ( byval node as irr_node, byval mode as uinteger )


' get a node that represents the position of a joint in a Milkshape skeleton
declare function IrrGetJointNode alias "IrrGetJointNode" ( byval node as irr_node, byval joint_name as zstring ptr ) as irr_node

' get a node that represents the position of a joint in a Milkshape skeleton
' (note this function is now redundant please use IrrGetJointNode instead)
declare function IrrGetMS3DJointNode alias "IrrGetMS3DJointNode" ( byval node as irr_node, byval joint_name as zstring ptr ) as irr_node

' get a node that represents the position of a joint in a Direct X skeleton
' (note this function is now redundant please use IrrGetJointNode instead)
declare function IrrGetDirectXJointNode alias "IrrGetDirectXJointNode" ( byval node as irr_node, byval joint_name as zstring ptr ) as irr_node

' adds a node to another node as a child to a parent
declare sub IrrAddChildToParent alias "IrrAddChildToParent" ( byval child as irr_node, byval parent as irr_node )


' add a shadow to a node
declare sub IrrAddNodeShadow alias "IrrAddNodeShadow" ( byval node as irr_node, byval mesh as irr_mesh = 0 )

' set whether a node is visible or not
declare sub IrrSetNodeVisibility alias "IrrSetNodeVisibility" ( byval node as irr_node, byval visible as integer )

' delete this node from the scene
declare sub IrrRemoveNode alias "IrrRemoveNode" ( byval node as irr_node )

' Clears the entire scene, any references to nodes in the scene will become invalid
declare sub IrrRemoveAllNodes alias "IrrRemoveAllNodes" ()


' get the parent of this node, returns 0 if there is no parent
declare function IrrGetNodeParent alias "IrrGetNodeParent" ( byval node as irr_node ) as irr_node

' set the parent of this node
declare sub IrrSetNodeParent alias "IrrSetNodeParent" ( byval node as irr_node, byval parent as irr_node )

' get the first child node of this node, returns 0 if there is no child
declare function IrrGetNodeFirstChild alias "IrrGetNodeFirstChild" ( _
        byval node as irr_node, byref position as any ptr ) as irr_node

' get the next child node of this node, returns 0 if there is no child
declare function IrrGetNodeNextChild alias "IrrGetNodeNextChild" ( _
        byval node as irr_node, byref position as any ptr ) as irr_node

' returns true if this is the last child of the parent
declare function IrrIsNodeLastChild alias "IrrIsNodeLastChild" ( _
        byval node as irr_node, byref position as any ptr ) as irr_node

' get the ID of this node
declare function IrrGetNodeID alias "IrrGetNodeID" ( byval node as irr_node ) as integer

' set the ID of this node
declare sub IrrSetNodeID alias "IrrSetNodeID" ( byval node as irr_node, byval id as integer )

' get the name of this node
declare function IrrGetNodeName alias "IrrGetNodeName" ( byval node as irr_node ) as const zstring ptr

' set the name of this node
declare sub IrrSetNodeName alias "IrrSetNodeName" ( byval node as irr_node, byval name as zstring ptr )

' get the mesh from a node
declare function IrrGetNodeMesh alias "IrrGetNodeMesh" ( byval node as irr_node ) as irr_mesh

' set the mesh of a node
declare sub IrrSetNodeMesh alias "IrrSetNodeMesh" ( byval node as irr_node, byval mesh as irr_mesh )

' get the bounding box of a node
declare sub IrrGetNodeBoundingBox alias "IrrGetNodeBoundingBox" ( _
        byval node as irr_node, _
        byref minX as single, _
        byref minY as single, _
        byref minZ as single, _
        byref maxX as single, _
        byref maxY as single, _
        byref maxZ as single )

' Gets the transformed (absolute value) bounding box of a node.
declare sub IrrGetNodeTransformedBoundingBox alias "IrrGetNodeTransformedBoundingBox" ( _
    byval node as irr_node, _
    byref minX as single, _
    byref minY as single, _
    byref minZ as single, _
    byref maxX as single, _
    byref maxY as single, _
    byref maxZ as single ) 


'' ////////////////////////////////////////////////////////////////////////////
'' Animator Functions

' add a collision animator to a node
declare function IrrAddCollisionAnimator alias "IrrAddCollisionAnimator" ( byval selector as irr_selector, byval node as irr_node, byval radiusx as single, byval radiusy as single, byval radiusz as single, byval gravityx as single, byval gravityy as single, byval gravityz as single, byval offsetx as single, byval offsety as single, byval offsetz as single ) as irr_animator

' add a deletion animator to a node
declare function IrrAddDeleteAnimator alias "IrrAddDeleteAnimator" ( byval node as irr_node, byval delete_after_n_milliseconds as integer ) as irr_animator

' add a fly-in-circle animator to a node
declare function IrrAddFlyCircleAnimator alias "IrrAddFlyCircleAnimator" ( byval node as irr_node, byval centre_x as single, byval centre_y as single, byval centre_z as single, byval radius as single, byval speed as single ) as irr_animator

' add a fly-straight animator to a node
declare function IrrAddFlyStraightAnimator alias "IrrAddFlyStraightAnimator" ( byval node as irr_node, byval start_x as single, byval start_y as single, byval start_z as single, byval end_x as single, byval end_y as single, byval end_z as single, byval time_to_complete as uinteger, byval loop_path as integer ) as irr_animator

' add a rotation animator to a node
declare function IrrAddRotationAnimator alias "IrrAddRotationAnimator" ( byval node as irr_node, byval x as single, byval y as single, byval z as single )as irr_animator

' add a spline animator to a node
declare function IrrAddSplineAnimator alias "IrrAddSplineAnimator" ( byval node as irr_node, byval array_size as integer, byref x as single, byref y as single, byref z as single, byval time_to_start as integer, byval speed as single, byval tightness as single ) as irr_animator

' add a fade, scale and delete animator to a node
declare function IrrAddFadeAnimator alias "IrrAddFadeAnimator" ( byval node as irr_node, byval delete_after_n_milliseconds as integer, byval scale as single = 1.0 ) as irr_animator

' remove an animator from a node
declare sub IrrRemoveAnimator alias "IrrRemoveAnimator" ( byval node as irr_node, byval node as irr_animator )



'' ////////////////////////////////////////////////////////////////////////////
'' Collision Functions

' gets a collision object from an animated mesh
declare function IrrGetCollisionGroupFromMesh alias "IrrGetCollisionGroupFromMesh" ( _
        byval mesh as irr_mesh, _
        byval node as irr_node, _
        byval frame as integer = 0 ) as irr_selector

' gets a collision object from a complex mesh like a map
declare function IrrGetCollisionGroupFromComplexMesh alias "IrrGetCollisionGroupFromComplexMesh" ( _
        byval mesh as irr_mesh, _
        byval node as irr_node, _
        byval frame as integer = 0 ) as irr_selector

' creates a collision object from triangles in a node defined by its
' bounding box
declare function IrrGetCollisionGroupFromBox alias "IrrGetCollisionGroupFromBox" ( byval node as irr_node ) as irr_selector

' creates a collision selector from a terrain node
declare function IrrGetCollisionGroupFromTerrain alias "IrrGetCollisionGroupFromTerrain" ( byval node as irr_node, byval level_of_detail as integer ) as irr_selector

' attach a collision object to a node. recommended by agamemnus
declare sub IrrAttachCollisionGroupToNode alias "IrrAttachCollisionGroupToNode" ( _
        byval collision as irr_selector, _
        byval node as irr_node )

' remove a collision selector
declare sub IrrRemoveCollisionGroup alias "IrrRemoveCollisionGroup" ( byval collision as irr_selector, byval node as irr_node )

' assign a triangle selector to a node
declare sub IrrSetNodeTriangleSelector alias "IrrSetNodeTriangleSelector" ( byval node as irr_node, byval collision as irr_selector )

' creates a combined collision object that is a group of collision objects
' for example you could combine a map and a terrain
declare function IrrCreateCombinedCollisionGroup alias "IrrCreateCombinedCollisionGroup" () as irr_selector

' adds a collision object to a combined collision object
declare sub IrrAddCollisionGroupToCombination alias "IrrAddCollisionGroupToCombination" ( byval combined_collision_group as irr_selector, byval collision_group as irr_selector )

' remove all collision objects from the combined collision object
declare sub IrrRemoveAllCollisionGroupsFromCombination alias "IrrRemoveAllCollisionGroupsFromCombination" ( byval combined_collision_group as irr_selector )

' remove a particular collision object from the combined collision object
declare sub IrrRemoveCollisionGroupFromCombination alias "IrrRemoveCollisionGroupFromCombination" ( byval combined_collision_group as irr_selector, byval collision_group as irr_selector )

' detect the collision point of a ray in the scene with a collision object if a
' collision was detected 1 is returned and vector collision contains the
' co-ordinates of the point of collision
declare function IrrGetCollisionPoint alias "IrrGetCollisionPoint" ( byref start as IRR_VECTOR, byref line_end as IRR_VECTOR, byval collision_group as irr_selector, byref collision_point as IRR_VECTOR ) as integer

' get a ray that goes from the specified camera and through the screen
' coordinates the information is coppied into the supplied start and end vectors
declare sub IrrGetRayFromScreenCoordinates alias "IrrGetRayFromScreenCoordinates" ( byval screen_x as integer, byval screen_y as integer, byval camera as irr_camera, byref start as IRR_VECTOR, byref line_end as IRR_VECTOR )

' a ray is cast through the camera and the nearest node that is hit by the ray
' is returned. if no node is hit zero is returned for the object
declare function IrrGetCollisionNodeFromCamera alias "IrrGetCollisionNodeFromCamera" ( byval camera as irr_camera ) as irr_node

' a ray is cast through the supplied coordinates and the nearest node that is
' hit by the ray is returned. if no node is hit zero is returned for the object
declare function IrrGetCollisionNodeFromRay alias "IrrGetCollisionNodeFromRay" ( byref start as IRR_VECTOR, byref line_end as IRR_VECTOR ) as irr_node

' a ray is cast through the supplied coordinates and the nearest node that is hit
' by the ray is returned. if no node is hit zero is returned for the object, only
' a subset of objects are tested, i.e. the children of the supplied node that
' match the supplied id. if the recurse option is enabled the entire tree of child
' objects connected to this node are tested
declare function IrrGetChildCollisionNodeFromRay alias "IrrGetChildCollisionNodeFromRay" ( _
        byval node as irr_node, _
        byval idMask as integer, _
        byval recurse as uinteger, _
        byref start as IRR_VECTOR, _
        byref line_end as IRR_VECTOR ) as irr_node

' the node and its children are recursively tested and the first node that contains
' the matched point is returned. if no node is hit zero is returned for the object,
' only a subset of objects are tested, i.e. the children of the supplied node that
' match the supplied id. if the recurse option is enabled the entire tree of child
' objects connected to this node are tested
declare function IrrGetChildCollisionNodeFromPoint alias "IrrGetChildCollisionNodeFromPoint" ( _
        byval node as irr_node, _
        byval idMask as integer, _
        byval recurse as uinteger, _
        byref point as IRR_VECTOR ) as irr_node

' a ray is cast through the screen at the specified co-ordinates and the nearest
' node that is hit by the ray is returned. if no node is hit zero is returned
' for the object
declare function IrrGetCollisionNodeFromScreenCoordinates alias "IrrGetCollisionNodeFromScreenCoordinates" ( byval screen_x as integer, byval screen_y as integer ) as irr_node

' a ray is cast through the specified co-ordinates and the nearest node that has
' a collision selector object that is hit by the ray is returned along with the
' coordinate of the collision and the normal of the triangle that is hit. if no
' node is hit zero is returned for the object
declare sub IrrGetNodeAndCollisionPointFromRay alias "IrrGetNodeAndCollisionPointFromRay" ( _
        byref vectorStart as IRR_VECTOR, _
        byref vectorEnd as IRR_VECTOR, _
        byref node as irr_node, _
        byref posX as single, _
        byref posY as single, _
        byref posZ as single, _
        byref normalX as single, _
        byref normalY as single, _
        byref normalZ as single, _
        byval id as integer = 0, _
        byval rootNode as irr_node = IRR_NO_OBJECT )

' screen co-ordinates are returned for the position of the specified 3d
' co-ordinates if an object were drawn at them on the screen, this is ideal for
' drawing 2D bitmaps or text around or on your 3D object on the screen
declare sub IrrGetScreenCoordinatesFrom3DPosition alias "IrrGetScreenCoordinatesFrom3DPosition" ( byref screen_x as integer, byref screen_y as integer, byval at_position as IRR_VECTOR )

' Calculates the intersection between a ray projected through the specified
' screen co-ordinates and a plane defined a normal and distance from the
' world origin (contributed by agamemnus)
Declare Sub IrrGet3DPositionFromScreenCoordinates Alias "IrrGet3DPositionFromScreenCoordinates" ( _
        Byval screenx as integer, _
        Byval screeny as integer, _
        Byref x as single, _
        Byref y as single, _
        Byref z as single, _
        Byval camera as irr_camera, _
        Byval normalX as single = 0.0, _
        Byval normalY as single = 0.0, _
        byval normalZ as single = 1.0, _
        Byval distanceFromOrigin as single = 0.0 )

' Calculates the intersection between a ray projected through the specified
' screen co-ordinates and a flat surface plane (contributed by agamemnus)
Declare Sub IrrGet2DPositionFromScreenCoordinates Alias "IrrGet2DPositionFromScreenCoordinates" ( _
        Byval screenx As integer, _
        Byval screeny As integer, _
        Byref x As Single, _
        Byref y As Single, _
        camera As irr_camera )

' an all-inclusive collision routine for .irr scenes
Declare Sub IrrSetupIrrSceneCollision Alias "IrrSetupIrrSceneCollision" ( ByVal camera As irr_camera ) 

' get the distance between two nodes using a customised squareroot function
Declare function IrrGetDistanceBetweenNodes Alias "IrrGetDistanceBetweenNodes" ( _
        Byval nodeA as IRR_NODE, Byval nodeB as IRR_NODE ) as single

' determine if the axis aligned bounding boxes of two nodes are in contact
Declare function IrrAreNodesIntersecting Alias "IrrAreNodesIntersecting" ( _
        Byval nodeA as IRR_NODE, Byval nodeB as IRR_NODE ) as uinteger

' determine if the specified point is inside the bounding box of the node
Declare function IrrIsPointInsideNode Alias "IrrIsPointInsideNode" ( _
        Byval nodeA as IRR_NODE, _
        Byval X as single, Byval Y as single, Byval Z as single ) as uinteger

' Collides a moving ellipsoid with a 3d world with gravity and returns the
' resulting new position of the ellipsoid. (contributed by The Car)
Declare Sub IrrGetCollisionResultPosition Alias "IrrGetCollisionResultPosition" (_
        Byval selector As irr_selector, _
        Byref ellipsoidPosition As IRR_VECTOR, _
        Byref ellipsoidRadius As IRR_VECTOR, _
        Byref velocity As IRR_VECTOR, _
        Byref gravity As IRR_VECTOR, _
        Byval slidingSpeed As single, _
        Byref outPosition As IRR_VECTOR, _
        Byref outHitPosition As IRR_VECTOR, _
        Byref outFalling As Integer )


'' ////////////////////////////////////////////////////////////////////////////
'' Camera Functions

' add a configurable first person perspective camera to the scene
Declare Function IrrAddFPSCamera Alias "IrrAddFPSCamera" ( ByVal parent As irr_scene_node = 0, ByVal rotateSpeed As Single = 100.0, ByVal moveSpeed As Single = 0.5, ByVal id As Integer = -1, ByVal keyMapArray As SKeyMap Ptr = 0, ByVal keyMapSize As Integer = 0, ByVal noVericalMovement As Byte = 0, ByVal jumpSpeed As Single = 0.0) As irr_camera

' add a regular camera
declare function IrrAddCamera alias "IrrAddCamera" ( byval cameraX as single, byval cameraY as single, byval cameraZ as single, byval targetX as single, byval targetY as single, byval targetZ as single ) as irr_camera

' add a maya style camera to the scene
declare function IrrAddMayaCamera alias "IrrAddMayaCamera" ( ByVal parent As irr_scene_node = 0, ByVal rotateSpeed As Single = 1500.0, ByVal zoomSpeed As Single = 200.0, ByVal moveSpeed as Single = 1500.0) as irr_camera
'declare function IrrAddMayaCamera alias "IrrAddMayaCamera" ( byval parent as irr_scene


' reposition the target location of a camera
declare sub IrrSetCameraTarget alias "IrrSetCameraTarget" ( byval camera as irr_camera, byval X as single, byval Y as single, byval Z as single )

' get the current target location of a camera, the location is copied into the
' supplied variables
declare sub IrrGetCameraTarget alias "IrrGetCameraTarget" ( byval camera as irr_camera, byref X as single, byref Y as single, byref Z as single )

' Get the up vector.
declare Sub IrrGetCameraUpDirection alias "IrrGetCameraUpDirection" ( Byval camera As irr_camera, Byref X As Single, Byref Y As Single, Byref Z As Single )

' set the up vector of a camera object, this controls the upward direction of
' the camera and allows you to roll it for free flight action
declare sub IrrSetCameraUpDirection alias "IrrSetCameraUpDirection" ( byval camera as irr_camera, byval X as single, byval Y as single, byval Z as single )

' get the vectors describing the camera direction useful after the camera has been revolved
declare sub IrrGetCameraOrientation alias "IrrGetCameraOrientation" ( _
        byval camera as irr_camera, _
        byref X as IRR_VECTOR, _
        byref Y as IRR_VECTOR, _
        byref Z as IRR_VECTOR )

' set the distance at which the camera starts to clip polys
declare sub IrrSetCameraClipDistance alias "IrrSetCameraClipDistance" ( _
        byval camera as irr_camera, _
        byval farDistance as single, _
        byval nearDistance as single = 1.0 )

' set the active camera in the scene
declare sub IrrSetActiveCamera alias "IrrSetActiveCamera" ( byval camera as irr_camera )

'sets the field of view (Default: PI / 2.5f). 
declare sub IrrSetCameraFOV alias "IrrSetCameraFOV" ( byval camera as irr_camera, byval fov as single )

' set the aspect ratio of a camera
declare sub IrrSetCameraAspectRatio alias "IrrSetCameraAspectRatio" ( byval camera as irr_camera, byval aspectRatio as single )

'revolve the camera using quaternion calculations, this will help avoid gimbal
'lock associated with normal Rotations many thanks to RogerBorg for this
declare sub IrrRevolveCamera alias "IrrRevolveCamera" ( _
        byval camera as irr_camera, _
        byval yaw as single, _
        byval pitch as single, _
        byval roll as single, _
        byval drive as single, _
        byval strafe as single, _
        byval elevate as single )

declare sub IrrSetCameraUpAtRightAngle alias "IrrSetCameraUpAtRightAngle" ( byval camera as irr_camera )

' set the projection of the camera to an orthagonal view, where there is no
' sense of perspective
declare sub IrrSetCameraOrthagonal alias "IrrSetCameraOrthagonal" ( _
        camera as irr_camera, _
        distanceX as single, _
        distanceY as single, _
        distanceZ as single )


'' ////////////////////////////////////////////////////////////////////////////
'' Lighting Functions

'add a light to the  scene
Declare Function IrrAddLight Alias "IrrAddLight" ( ByVal parent As irr_node = 0, ByVal x As Single, ByVal y As Single, ByVal z As Single, ByVal red As Single, ByVal green As Single, ByVal blue As Single, ByVal size As Single ) As irr_node

' set the scene ambient lighting
declare sub IrrSetAmbientLight alias "IrrSetAmbientLight" ( byval R as single, byval G as single, byval B as single )


' Ambient color emitted by the light.
declare sub IrrSetLightAmbientColor alias "IrrSetLightAmbientColor" ( byval light as irr_node, byval R as single, byval G as single, byval B as single )

' Changes the light strength fading over distance. Good values for distance
' effects use ( 1.0, 0.0, 0.0) and simply add small values to the second and
' third element.
declare sub IrrSetLightAttenuation alias "IrrSetLightAttenuation" ( byval light as irr_node, byval constant as single, byval linear as single, byval quadratic as single )

' Does the light cast shadows?
declare sub IrrSetLightCastShadows alias "IrrSetLightCastShadows" ( byval light as irr_node, byval cast_shadows as uinteger )

' Diffuse color emitted by the light.
declare sub IrrSetLightDiffuseColor alias "IrrSetLightDiffuseColor" ( byval light as irr_node, byval R as single, byval G as single, byval B as single )

' The light strength's decrease between Outer and Inner cone.
declare sub IrrSetLightFalloff alias "IrrSetLightFalloff" ( byval light as irr_node, byval Falloff as single )

' The angle of the spot's inner cone. Ignored for other lights.
declare sub IrrSetLightInnerCone alias "IrrSetLightInnerCone" ( byval light as irr_node, byval InnerCone as single )

' The angle of the spot's outer cone. Ignored for other lights.
declare sub IrrSetLightOuterCone alias "IrrSetLightOuterCone" ( byval light as irr_node, byval OuterCone as single )

' Radius of light. Everything within this radius be be lighted.
declare sub IrrSetLightRadius alias "IrrSetLightRadius" ( byval light as irr_node, byval Radius as single )

' Specular color emitted by the light.
declare sub IrrSetLightSpecularColor alias "IrrSetLightSpecularColor" ( byval light as irr_node, byval R as single, byval G as single, byval B as single )

' Type of the light. Default: ELT_POINT.
declare sub IrrSetLightType alias "IrrSetLightType" ( byval light as irr_node, byval light_type as E_LIGHT_TYPE )



'' ////////////////////////////////////////////////////////////////////////////
'' Terrain Functions

' create a terrain node from a highfield map
'declare function IrrAddTerrain alias "IrrAddTerrain" ( byval path as zstring ptr ) as irr_terrain

' create a terrain node from a highfield map
declare function IrrAddSphericalTerrain alias "IrrAddSphericalTerrain" ( _
        byval topPath as zstring ptr, _
        byval frontPath as zstring ptr, _
        byval backPath as zstring ptr, _
        byval leftPath as zstring ptr, _
        byval rightPath as zstring ptr, _
        byval bottomPath as zstring ptr, _
        byval xPosition as single = 0.0, _
        byval yPosition as single = 0.0, _
        byval zPosition as single = 0.0, _
        byval xRotation as single = 0.0, _
        byval yRotation as single = 0.0, _
        byval zRotation as single = 0.0, _
        byval xScale as single = 1.0, _
        byval yScale as single = 1.0, _
        byval zScale as single = 1.0, _
        byval vertexAlpha as integer = 255, _
        byval vertexRed as integer = 255, _
        byval vertexGreen as integer = 255, _
        byval vertexBlue as integer = 255, _
        byval smoothing as integer = 0, _
        byval spherical as integer = 0, _
        byval maxLOD as integer = 5, _
        byval patchSize as IRR_TERRAIN_PATCH_SIZE = ETPS_17 ) as irr_terrain

' create a tiled terrain node from a highfield map
declare function IrrAddTiledTerrain alias "IrrAddTiledTerrain" ( _
        byval heightMapPath as zstring ptr, _
        byval texturePath as zstring ptr, _
        byval followNode as irr_node, _
        byval terrainWidth as integer = 1000, _
        byval terrainHeight as integer = 1000, _
        byval tileSize as single = 1.0, _
        byval meshSize as integer = 100, _
        byval heightmapScale as single = 10.0, _
        byval smoothing as integer = 0.0, _
        byval materialType as IRR_MATERIAL_TYPES = IRR_EMT_DETAIL_MAP ) as irr_node

' create a terrain node from a highfield map
declare function IrrAddTerrain alias "IrrAddTerrain" ( _
        byval path as zstring ptr, _
        byval xPosition as single = 0.0, _
        byval yPosition as single = 0.0, _
        byval zPosition as single = 0.0, _
        byval xRotation as single = 0.0, _
        byval yRotation as single = 0.0, _
        byval zRotation as single = 0.0, _
        byval xScale as single = 1.0, _
        byval yScale as single = 1.0, _
        byval zScale as single = 1.0, _
        byval vertexAlpha as integer = 255, _
        byval vertexRed as integer = 255, _
        byval vertexGreen as integer = 255, _
        byval vertexBlue as integer = 255, _
        byval smoothing as integer = 0, _
        byval maxLOD as integer = 5, _
        byval patchSize as IRR_TERRAIN_PATCH_SIZE = ETPS_17 ) as irr_terrain


' scale the texture on a terrain node
declare sub IrrScaleTexture alias "IrrScaleTexture" ( byval terrain as irr_terrain, byval X as single, byval Y as single )

' set the textures on all six faces of a spherical terrain
declare sub IrrSetSphericalTerrainTexture alias "IrrSetSphericalTerrainTexture" ( _
        byval terrain as irr_terrain, _
        byval topTexture as irr_texture, _
        byval frontTexture as irr_texture, _
        byval backTexture as irr_texture, _
        byval leftTexture as irr_texture, _
        byval rightTexture as irr_texture, _
        byval bottomTexture as irr_texture, _
        byval materialIndex as uinteger )
        
' load the vertex colors on all six faces of a spherical terrain from images
declare sub IrrLoadSphericalTerrainVertexColor alias "IrrLoadSphericalTerrainVertexColor" ( _
        byval terrain as irr_terrain, _
        byval topImage as irr_image, _
        byval frontImage as irr_image, _
        byval backImage as irr_image, _
        byval leftImage as irr_image, _
        byval rightImage as irr_image, _
        byval bottomImage as irr_image )

' scale the texture on a spherical terrain node
declare sub IrrScaleSphericalTexture alias "IrrScaleSphericalTexture" ( byval terrain as irr_terrain, byval X as single, byval Y as single )

' get the height of a co-ordinate on a terrain node
declare function IrrGetTerrainHeight alias "IrrGetTerrainHeight" ( byval terrain as irr_terrain, byval X as single, byval Z as single ) as single

' get the height of a co-ordinate on a tiled terrain node
declare function IrrGetTiledTerrainHeight alias "IrrGetTiledTerrainHeight" ( byval terrain as irr_terrain, byval X as single, byval Z as single ) as single

' get the surface position of a co-ordinate on a spherical terrain node
declare sub IrrGetSphericalTerrainSurfacePosition alias "IrrGetSphericalTerrainSurfacePosition" ( _
        byval terrain as irr_terrain, _
        byval face as integer, _
        byval logicalX as single, _
        byval logicalZ as single, _
        byref X as single, _
        byref Y as single, _
        byref Z as single )

' get the surface angle of a co-ordinate on a spherical terrain node
declare sub IrrGetSphericalTerrainSurfacePositionAndAngle alias "IrrGetSphericalTerrainSurfacePositionAndAngle" ( _
        byval terrain as irr_terrain, _
        byval face as integer, _
        byval logicalX as single, _
        byval logicalZ as single, _
        byref positionX as single, _
        byref positionY as single, _
        byref positionZ as single, _
        byref angleX as single, _
        byref angleY as single, _
        byref angleZ as single )

' get the logical position on a surface based on a real co-ordinate
declare sub IrrGetSphericalTerrainLogicalSurfacePosition alias "IrrGetSphericalTerrainLogicalSurfacePosition" ( _
        byval terrain as irr_terrain, _
        byval X as single, _
        byval Y as single, _
        byval Z as single, _
        byref face as integer, _
        byref logicalX as single, _
        byref logicalZ as single )

' create a terrain node from a highfield map
declare function IrrAddTerrainTile alias "IrrAddTerrainTile" ( _
        byval image as irr_image, _
        byval tileSize as integer = 256, _
        byval dataX as integer = 0, _
        byval dataY as integer = 0, _
        byval xPosition as single = 0.0, _
        byval yPosition as single = 0.0, _
        byval zPosition as single = 0.0, _
        byval xRotation as single = 0.0, _
        byval yRotation as single = 0.0, _
        byval zRotation as single = 0.0, _
        byval xScale as single = 1.0, _
        byval yScale as single = 1.0, _
        byval zScale as single = 1.0, _
        byval smoothing as integer = 1, _
        byval maxLOD as integer = 5, _
        byval patchSize as IRR_TERRAIN_PATCH_SIZE = ETPS_17 ) as irr_terrain

' get the height of a point on a terrain tile node
declare function IrrGetTerrainTileHeight alias "IrrGetTerrainTileHeight" ( byval terrain as irr_terrain, byval X as single, byval Z as single ) as single

' scale the texture detail on a tiled terrain node
declare sub IrrScaleTileTexture alias "IrrScaleTileTexture"  ( byval terrain as irr_terrain, byval X as single, byval Y as single )

' attach a tile onto this tile
#define TOP_EDGE 0
#define BOTTOM_EDGE 1
#define LEFT_EDGE 2
#define RIGHT_EDGE 3
declare sub IrrAttachTile alias "IrrAttachTile"  ( byval terrain as irr_terrain, byval neighbour as irr_terrain, byval Edge as uinteger )

' load the vertex color information of a tile
declare sub IrrSetTileColor alias "IrrSetTileColor"  ( _
        byval terrain as irr_terrain, _
        byval image as irr_image, _
        byval dataX as integer = 0, _
        byval dataY as integer = 0 )

' load the height and UV data from an image
declare sub IrrSetTileStructure alias "IrrSetTileStructure"  ( _
        byval terrain as irr_terrain, _
        byval image as irr_image, _
        byval dataX as integer = 0, _
        byval dataY as integer = 0 )



'' ////////////////////////////////////////////////////////////////////////////
'' Particle Functions

' set the minimum and maximum start size of a particle in the particle system
declare sub IrrSetParticleSize alias "IrrSetParticleMinSize" ( byval particle_emitter as irr_emitter, byval X as single, byval Y as single )

' set the minimum size of a particle in the particle system
declare sub IrrSetParticleMinSize alias "IrrSetParticleMinSize" ( byval particle_emitter as irr_emitter, byval X as single, byval Y as single )

' set the maximum size of a particle in the particle system
declare sub IrrSetParticleMaxSize alias "IrrSetParticleMaxSize" ( byval particle_emitter as irr_emitter, byval X as single, byval Y as single )

' create an emitter that can be added to a particle system
declare function IrrAddParticleEmitter alias "IrrAddParticleEmitter" ( byval particle_system as irr_particle_system, byval settings as IRR_PARTICLE_EMITTER ) as irr_emitter

' Creates a particle emitter for an animated mesh scene node
declare function IrrAddAnimatedMeshSceneNodeEmitter alias "IrrAddAnimatedMeshSceneNodeEmitter" ( byval particle_system as irr_particle_system, byval node as irr_node, byval use_normal_direction as uinteger, byval normal_direction_modifier as single, byval emit_from_every_vertex as integer, byval settings as IRR_PARTICLE_EMITTER ) as irr_emitter


' Add an affector to the particle system to fade the particles out
declare function IrrAddFadeOutParticleAffector alias "IrrAddFadeOutParticleAffector" ( byval particle_system as irr_particle_system, byval fade_speed as uinteger, byval fade_to_red as uinteger, byval fade_to_green as uinteger, byval fade_to_blue as uinteger ) as irr_affector

' Add an affector to the particle system to alter their position with gravity
declare function IrrAddGravityParticleAffector Alias "IrrAddGravityParticleAffector" ( ByVal particle_system As irr_particle_system, ByVal x As Single, ByVal y As Single, ByVal z As Single, ByVal timeForceLost As uInteger = 1000 ) as irr_affector

' Creates a point attraction affector. This affector modifies the positions of
' the particles and attracts them to a specified point at a specified speed per
' second.
declare function IrrAddParticleAttractionAffector Alias "IrrAddParticleAttractionAffector" ( ByVal particle_system As irr_particle_system, ByVal x As Single, ByVal y As Single, ByVal z As Single, ByVal speed As Single = 1.0, ByVal attract as uinteger = 1, ByVal affectX as uinteger = 1, ByVal affectY as uinteger = 1, ByVal affectZ as uinteger = 1 ) as irr_affector

' Creates a rotation affector. This affector modifies the positions of the
' particles and attracts them to a specified point at a specified speed per second.
declare function IrrAddRotationAffector Alias "IrrAddRotationAffector" ( ByVal particle_system As irr_particle_system, ByVal Speed_X As Single, ByVal Speed_Y As Single, ByVal Speed_Z As Single, ByVal pivot_X As Single, ByVal pivot_Y As Single, ByVal pivot_Z As Single ) as irr_affector

' Creates a Stop Particle Affector that automatically stops the emmision of
' particles from the specified emitter after a period of time
declare function IrrAddStopParticleAffector Alias "IrrAddStopParticleAffector" ( ByVal particle_system As irr_particle_system, ByVal run_time as uinteger, ByVal target_emitter as irr_emitter ) as irr_affector

' adds a push affector with a limited range of effect
declare function IrrAddParticlePushAffector Alias "IrrAddParticlePushAffector" ( _
		ByVal particle_system as irr_particle_system, _
        ByVal x as single, _
		ByVal y as single, _
		ByVal z as single, _
		ByVal speedX as single, _
		ByVal speedY as single, _
		ByVal speedZ as single, _
		ByVal far as single, _
		ByVal near as single, _
        ByVal column as single, _
		ByVal radial as integer ) as irr_affector

' adds a color affector to change the color of particles over time through an
' array of user defined colors
declare function IrrAddColorMorphAffector Alias "IrrAddColorMorphAffector" ( _
		ByVal particle_system as irr_particle_system, _
        ByVal num as uinteger, _
		ByVal particlecolors as uinteger ptr, _
		ByVal particletimes as uinteger ptr, _
		ByVal smooth as uinteger ) as irr_affector

' adds a spline affector to move particles along the path of a user defined
' spline
declare function IrrAddSplineAffector Alias "IrrAddSplineAffector" ( _
		ByVal particle_system as irr_particle_system, _
        ByVal VertexCount as uinteger, _
		ByVal verticies as IRR_VERT ptr, _
		ByVal speed as single, _
        ByVal tightness as single, _
        ByVal attraction as single, _
		ByVal deleteAtEnd as uinteger ) as irr_affector

' remove all effectors from this particle system
declare sub IrrRemoveAffectors alias "IrrRemoveAffectors" ( byval particle_system as irr_particle_system )


' Set direction the emitter emits particles.
declare sub IrrSetParticleEmitterDirection alias "IrrSetParticleEmitterDirection" ( byval particle_system As irr_emitter, byval x as single, byval y as single, byval z as single )

' Set minimum number of particles the emitter emits per second.
declare sub IrrSetParticleEmitterMinParticlesPerSecond alias "IrrSetParticleEmitterMinParticlesPerSecond" ( byval particle_system As irr_emitter, byval minPPS as uinteger )

' Set maximum number of particles the emitter emits per second.
declare sub IrrSetParticleEmitterMaxParticlesPerSecond alias "IrrSetParticleEmitterMaxParticlesPerSecond" ( byval particle_system As irr_emitter, byval maxPPS as uinteger )

' Set minimum starting color for particles.
declare sub IrrSetParticleEmitterMinStartColor alias "IrrSetParticleEmitterMinStartColor" ( byval particle_system As irr_emitter, byval Red as uinteger, byval Green as uinteger, byval Blue as uinteger )

' Set maximum starting color for particles.
declare sub IrrSetParticleEmitterMaxStartColor alias "IrrSetParticleEmitterMaxStartColor" ( byval particle_system As irr_emitter, byval Red as uinteger, byval Green as uinteger, byval Blue as uinteger )


' Enable or disable an affector
declare sub IrrSetParticleAffectorEnable alias "IrrSetParticleAffectorEnable" ( byval affector as irr_affector, byval enable as uinteger )

' Alter the fadeout affector changing the fade out time
declare sub IrrSetFadeOutParticleAffectorTime alias "IrrSetFadeOutParticleAffectorTime" ( byval affector as irr_affector, byval fade_speed as single )

' Alter the fadeout affector changing the target color
declare sub IrrSetFadeOutParticleAffectorTargetColor alias "IrrSetFadeOutParticleAffectorTargetColor" ( byval affector as irr_affector, byval fade_to_red as uinteger, byval fade_to_green as uinteger, byval fade_to_blue as uinteger )

' Alter the direction and force of gravity
declare sub IrrSetGravityParticleAffectorDirection alias "IrrSetGravityParticleAffectorDirection" ( byval affector as irr_affector, byval x as single, byval y as single, byval z as single )

' Set the time in milliseconds when the gravity force is totally lost and the particle does not move any more
declare sub IrrSetGravityParticleAffectorTimeForceLost alias "IrrSetGravityParticleAffectorTimeForceLost" ( byval affector as irr_affector, byval time_Force_Lost as single )

' Set whether or not this will affect particles in the X direction.
declare sub IrrSetParticleAttractionAffectorAffectX alias "IrrSetParticleAttractionAffectorAffectX" ( byval affector as irr_affector, byval affect_x as uinteger )

' Set whether or not this will affect particles in the Y direction.
declare sub IrrSetParticleAttractionAffectorAffectY alias "IrrSetParticleAttractionAffectorAffectY" ( byval affector as irr_affector, byval affect_y as uinteger )

' Set whether or not this will affect particles in the Z direction.
declare sub IrrSetParticleAttractionAffectorAffectZ alias "IrrSetParticleAttractionAffectorAffectZ" ( byval affector as irr_affector, byval affect_z as uinteger )

' Set whether or not the particles are attracting or detracting.
declare sub IrrSetParticleAttractionAffectorAttract alias "IrrSetParticleAttractionAffectorAttract" ( byval affector as irr_affector, byval attract as uinteger )
 
' Set the point that particles will attract to. 
declare sub IrrSetParticleAttractionAffectorPoint alias "IrrSetParticleAttractionAffectorPoint" ( byval affector as irr_affector, byval x as single, byval y as single, byval z as single )

' Set the point that particles will rotate about.
declare sub IrrSetRotationAffectorPivotPoint alias "IrrSetRotationAffectorPivotPoint" ( byval affector as irr_affector, byval x as single, byval y as single, byval z as single )

' Set the furthest distance for the push particle effect
declare sub IrrSetFurthestDistanceOfEffect alias "IrrSetFurthestDistanceOfEffect" ( byval affector as irr_affector, byval NewDistance as single )

' Set the nearest distance for the push particle effect
declare sub IrrSetNearestDistanceOfEffect alias "IrrSetNearestDistanceOfEffect" ( byval affector as irr_affector, byval NewDistance as single )

' Set the column width of the push particle effect
declare sub IrrSetColumnDistanceOfEffect alias "IrrSetColumnDistanceOfEffect" ( byval affector as irr_affector, byval NewDistance as single )

' Set the center of the push particle effect
declare sub IrrSetCenterOfEffect alias "IrrSetCenterOfEffect" ( byval affector as irr_affector, byval x as single, byval y as single, byval z as single )

' Set the strength of the push particle effect
declare sub IrrSetStrengthOfEffect alias "IrrSetStrengthOfEffect" ( byval affector as irr_affector, byval x as single, byval y as single, byval z as single )

' Set the radial effect of the push particle effect
declare sub IrrSetRadialEffect alias "IrrSetRadialEffect" ( byval affector as irr_affector, byval IsRadial as integer )



'' ////////////////////////////////////////////////////////////////////////////
'' GUI Functions

' set the font used by the gui
declare sub IrrGUISetFont alias "IrrGUISetFont"( byval font as irr_font )

' set the color of an element used by the gui
declare sub IrrGUISetColor alias "IrrGUISetColor"( _
        byval element as IRR_GUI_COLOR_ELEMENT, _
        byval red as integer, _
        byval green as integer, _
        byval blue as integer, _
        byval alpha as integer )

' clear all gui objects from the screen
declare sub IrrGUIClear alias "IrrGUIClear"()

' remove a specific GUI object
declare sub IrrGUIRemove alias "IrrGUIRemove" ( byval guiElement as any ptr )

' get the text associated with a GUI object
declare function IrrGUIGetText alias "IrrGUIGetText" ( byval guiElement as any ptr ) as wstring ptr

' set the text associated with a GUI object
declare sub IrrGUISetText alias "IrrGUISetText" ( byval guiElement as any ptr, byval text as wstring ptr )

' add a static text object to the gui display
declare function IrrAddWindow alias "IrrAddWindow" ( _
        byval title as wstring ptr, _
        byval TopX as integer, byval TopY as integer, _
        byval BotX as integer, byval BotY as integer, _
        byval modal as uinteger, _
        byval parent as IRR_GUI_OBJECT = 0 ) as IRR_GUI_OBJECT

' add a static text object to the gui display
declare function IrrAddStaticText alias "IrrAddStaticText" ( _
        byval text as wstring ptr, _
        byval TopX as integer, byval TopY as integer, _
        byval BotX as integer, byval BotY as integer, _
        byval border as uinteger, byval wordwrap as uinteger, _
        byval parent as IRR_GUI_OBJECT = 0 ) as IRR_GUI_OBJECT

' add a clickable button object to the gui display
declare function IrrAddButton alias "IrrAddButton" ( _
        byval TopX as integer, byval TopY as integer, _
        byval BotX as integer, byval BotY as integer, _
        byval ID as integer, _
        byval text as wstring ptr, byval textTip as wstring ptr = 0, _
        byval parent as IRR_GUI_OBJECT = 0 ) as IRR_GUI_OBJECT

' add a scrollbar object to the gui display
declare function IrrAddScrollBar alias "IrrAddScrollBar" ( _
        byval horizontal as integer, _
        byval TopX as integer, byval TopY as integer, _
        byval BotX as integer, byval BotY as integer, _
        byval ID as integer, _
        byval currentValue as integer, _
        byval maxValue as integer, _
        byval parent as IRR_GUI_OBJECT = 0) as IRR_GUI_OBJECT

' add a listbox object containing a list of items to the gui display
declare function IrrAddListBox alias "IrrAddListBox" ( _
        byval TopX as integer, byval TopY as integer, _
        byval BotX as integer, byval BotY as integer, _
        byval ID as integer, _
        byval background as integer, _
        byval parent as IRR_GUI_OBJECT = 0) as IRR_GUI_OBJECT

' add a text element to a list box
declare sub IrrAddListBoxItem alias "IrrAddListBoxItem" ( _
        byval listbox as IRR_GUI_OBJECT, _
        byval text as wstring ptr )

' insert a text element into a list box
declare sub IrrInsertListBoxItem alias "IrrInsertListBoxItem" ( _
        byval listbox as IRR_GUI_OBJECT, _
        byval text as wstring ptr, _
        byval index as uinteger )

' remove a text element from a list box
declare sub IrrRemoveListBoxItem alias "IrrRemoveListBoxItem" ( _
        byval listbox as IRR_GUI_OBJECT, _
        byval index as uinteger )

' select a text element in a list box
declare sub IrrSelectListBoxItem alias "IrrSelectListBoxItem" ( _
        byval listbox as IRR_GUI_OBJECT, _
        byval index as uinteger )

' add an editbox object to the gui display
declare function IrrAddEditBox alias "IrrAddEditBox" ( _
        byval text as wstring ptr, _
        byval TopX as integer, byval TopY as integer, _
        byval BotX as integer, byval BotY as integer, _
        byval ID as integer, _
        byval border as integer, _
        byval password as integer = IRR_GUI_NOT_PASSWORD, _
        byval parent as IRR_GUI_OBJECT = 0) as IRR_GUI_OBJECT

' add an image object to the gui display
declare function IrrAddImage alias "IrrAddImage" ( _
        byval texture as irr_texture, _
        byval X as integer, byval Y as integer, _
        byval useAlpha as integer, _
        byval ID as integer, _
        byval parent as IRR_GUI_OBJECT = 0) as IRR_GUI_OBJECT

' add a checkbox object to the gui display
declare function IrrAddCheckBox alias "IrrAddCheckBox" ( _
        byval text as wstring ptr, _
        byval TopX as integer, byval TopY as integer, _
        byval BotX as integer, byval BotY as integer, _
        byval ID as integer, _
        byval checked as integer, _
        byval parent as IRR_GUI_OBJECT = 0) as IRR_GUI_OBJECT

' set the checked state of a checkbox
declare sub IrrCheckCheckBox alias "IrrCheckCheckBox" ( _
        byval checkbox as IRR_GUI_OBJECT, _
        byval checked as uinteger )

' open a modal file open dialog
declare function IrrAddFileOpen alias "IrrAddFileOpen" ( _
        byval text as wstring ptr, _
        byval ID as integer, _
        byval modal as integer, _
        byval parent as IRR_GUI_OBJECT = 0) as IRR_GUI_OBJECT

' get the last file name selected from a file selection dialog
declare function IrrGetLastSelectedFile alias "IrrGetLastSelectedFile" () as wstring ptr

End Extern
