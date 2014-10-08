'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 96 : Shadow Maps
'' This example provides a sandbox for playing around with lighting switching
'' lights on and off and enabling baked shadows in a shadow map.
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"
#include "IrrlichtShaders.bas"

Type colorStruct
    Red as Single
    Green as Single
    Blue as Single
    
    FallOff as Single
End Type

'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' irrlicht objects
DIM KeyEvent as IRR_KEY_EVENT PTR
DIM MD2Mesh as irr_mesh
DIM MeshTexture as irr_texture
DIM SceneNode as irr_node
DIM OurCamera as irr_camera
DIM Material as irr_material


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 640, 480, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_CAPTURE_EVENTS, IRR_VERTICAL_SYNC_ON )

' set the window caption
IrrSetWindowCaption( "Example 96: Shadow Maps" )

' load a mesh this acts as a blue print for the model
MD2Mesh = IrrGetMesh( "./media/pot.obj" )
IrrScaleMesh( MD2Mesh, 20.0 )

' load texture resources for texturing the scene nodes
IrrSetTextureCreationFlag( ETCF_CREATE_MIP_MAPS, IRR_OFF )
MeshTexture = IrrGetTexture( "./media/PotLightMap.jpg" )

' add the mesh to the scene as a new node, the node is an instance of the
' mesh object supplied here
SceneNode = IrrAddMeshToScene( MD2Mesh )

' apply a material to the node to give its surface color
IrrSetNodeMaterialTexture( SceneNode, MeshTexture, 0 )

' Create a billboard representing the Sun
' load the texture resource for the billboard
Dim as irr_texture BillboardTexture = IrrGetTexture( "./media/sun.tga" )

' add the billboard to the scene
Dim as irr_node Sun = IrrAddBillBoardToScene( 256.0, 256.0,  300.0, 275.0, 500.0 )

' now we apply the loaded texture to the billboard using node material index 0
IrrSetNodeMaterialTexture( Sun, BillboardTexture, 0 )

' hide transparent areas
IrrSetNodeMaterialFlag( Sun, IRR_EMF_LIGHTING, IRR_OFF )
IrrSetNodeMaterialType ( Sun, IRR_EMT_TRANSPARENT_ALPHA_CHANNEL )

' Create a billboard representing the Moon
' load the texture resource for the billboard
BillboardTexture = IrrGetTexture( "./media/moon.tga" )

' add the billboard to the scene
Dim as irr_node Moon = IrrAddBillBoardToScene( 128.0, 128.0,  300.0, 0.0, 500.0 )

' now we apply the loaded texture to the billboard using node material index 0
IrrSetNodeMaterialFlag( Moon, IRR_EMF_LIGHTING, IRR_OFF )
IrrSetNodeMaterialTexture( Moon, BillboardTexture, 0 )

' hide transparent areas
IrrSetNodeMaterialType ( Moon, IRR_EMT_TRANSPARENT_ALPHA_CHANNEL )



' add a camera into the scene
OurCamera = IrrAddFPSCamera( IRR_NO_OBJECT, 100.0f, 0.1f )
IrrSetNodePosition( OurCamera, -40, 25, 40 )
IrrSetCameraTarget( OurCamera, 0, 0, 0 )

'DIM as irr_node KeyLight =  IrrAddLight( IRR_NO_PARENT,  100, 100, 100,  0.9, 0.7, 0.3, 1200.0 )
DIM as irr_node KeyLight =  IrrAddLight( IRR_NO_PARENT,  0, 0, 0,  0.9, 0.7, 0.3, 1200.0 )
IrrAddChildToParent( KeyLight, Sun )

IrrHideMouse

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
Dim as Single frameTime = timer + 0.0167
Dim as Single Red = 0.2, Green = 0.2, Blue = 0.3, FallOff = 100.0, SunHeight = 25.0
Dim as Single RedInc, GreenInc, BlueInc, FallOffInc, SunHeightInc
Dim as integer Index = 0, Blend = 0
Dim as Single Circling = 0.0
Dim Lighting(6) as colorStruct => { _
        (0.2, 0.2, 0.3,  100.0), _
        (0.6, 0.4, 0.4,  200.0), _
        (0.9, 0.8, 0.6,  400.0), _
        (1.0, 1.0, 0.9,  600.0), _
        (1.0, 1.0, 0.9,  400.0), _
        (0.7, 0.6, 0.3,  200.0), _
        (0.2, 0.2, 0.3,  100.0)_
}
WHILE IrrRunning
    ' is it time for another frame
    if timer > frameTime then
        ' calculate the time the next frame starts
        frameTime = timer + 0.0167

        ' begin the scene, erasing the canvas with sky-blue before rendering
        IrrBeginScene( 192*Red, 192*Green, 256*Blue )

        ' Blend colors
        if Blend = 0 Then
            Index += 1
            if Index > 6 Then
                Index = 0
                Circling = 0.0
            End If
            
            RedInc = (Lighting(Index).Red - Red ) / 200
            GreenInc = (Lighting(Index).Green - Green ) / 200
            BlueInc = (Lighting(Index).Blue - Blue ) / 200
            
            FallOffInc = (Lighting(Index).FallOff - FallOff ) / 200
            
            Blend = 200
        End If

        Blend -= 1
        
        Red += RedInc
        Green += GreenInc
        Blue += BlueInc
        FallOff += FallOffInc

        ' change the color of the lighting
        IrrSetLightDiffuseColor( KeyLight, Red, Green, Blue )
        IrrSetLightFalloff( KeyLight, FallOff )
        
        ' Change the Position of the Sun and Moon
        IrrSetNodePosition( Sun,  Cos((FallOff-300)/200)*310.0f, _
                                  Sin((FallOff-300)/200)*480.0f, _
                                  Cos((FallOff-300)/200)*510.0f)
        IrrSetNodePosition( Moon, Cos((300-FallOff)/200)*350.0f, _
                                  Sin((300-FallOff)/200)*475.0f, _
                                  Cos((300-FallOff)/200)*400.0f)
        Circling += 3.1427/(6*200)

        ' draw the scene
        IrrDrawScene
        
        ' end drawing the scene and render it
        IrrEndScene
    End If
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
