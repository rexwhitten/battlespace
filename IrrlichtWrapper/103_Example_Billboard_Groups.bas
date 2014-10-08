'' ----------------------------------------------------------------------------
'' Irrlicht Wrapper for Imperative Languages - Freebasic Examples
'' Frank Dodd (2006)
'' ----------------------------------------------------------------------------
'' Example 103: Billboard Groups
'' This example demonstrated Billboard groups. While billboards are already
'' very efficient large numbers of them can be made even more efficient by
'' collecting them up into a single group.
'' ----------------------------------------------------------------------------

'' ////////////////////////////////////////////////////////////////////////////
'' Includes for extension libraries
#include "IrrlichtWrapper.bi"


'' ////////////////////////////////////////////////////////////////////////////
'' global variables

' Particle controls
'#define REMOVE_OVER_TIME
'#define RUN_FLAT_OUT
#define PARTICLE_COUNT 5
#define PARTICLE_LAYERS 15
#define SPACING 75.0
#define SCALE 100.0
#define CAMERA_SPEED 0.1f


' irrlicht objects
DIM metrics as string
DIM Billboard as irr_node
DIM BillboardTexture as irr_texture
Dim as irr_node Sun
DIM Camera as irr_camera
DIM as SBillboard ptr particles( PARTICLE_COUNT * PARTICLE_LAYERS )


'' ////////////////////////////////////////////////////////////////////////////
'' GDB debugger main() function

' -----------------------------------------------------------------------------
' start the irrlicht interface
IrrStart( IRR_EDT_OPENGL, 640, 480, IRR_BITS_PER_PIXEL_32, _
        IRR_WINDOWED, IRR_SHADOWS, IRR_IGNORE_EVENTS, IRR_VERTICAL_SYNC_ON )

' add a skybox with a space theme to the scene as a backdrop
Dim as irr_node SkyBox = IrrAddSkyBoxToScene( _
        IrrGetTexture("./media/starbox1.jpg"),_
        IrrGetTexture("./media/starbox1.jpg"),_
        IrrGetTexture("./media/starbox1.jpg"),_
        IrrGetTexture("./media/starbox1.jpg"),_
        IrrGetTexture("./media/starbox1.jpg"),_
        IrrGetTexture("./media/starbox1.jpg"))

' Create a billboard representing the Sun
' load the texture resource for the billboard
BillboardTexture = IrrGetTexture( "./media/sun.tga" )

' add the billboard to the scene
Sun = IrrAddBillBoardToScene( 256.0, 256.0,  0.0, 0.0, 998.0 )

' now we apply the loaded texture to the billboard using node material index 0
IrrSetNodeMaterialTexture( Sun, BillboardTexture, 0 )

' hide transparent areas
IrrSetNodeMaterialFlag( Sun, IRR_EMF_LIGHTING, IRR_OFF )
IrrSetNodeMaterialType ( Sun, IRR_EMT_TRANSPARENT_ALPHA_CHANNEL )

' Create a billboard representing the Moon
' load the texture resource for the billboard
BillboardTexture = IrrGetTexture( "./media/moon.tga" )

' add the billboard to the scene
Dim as irr_node Moon = IrrAddBillBoardToScene( 20.0, 20.0,  0.0, 0.0, 1200.0 )

' now we apply the loaded texture to the billboard using node material index 0
IrrSetNodeMaterialFlag( Moon, IRR_EMF_LIGHTING, IRR_OFF )
IrrSetNodeMaterialTexture( Moon, BillboardTexture, 0 )

' hide transparent areas
IrrSetNodeMaterialType ( Moon, IRR_EMT_TRANSPARENT_ALPHA_CHANNEL_REF )

' make the moon orbit the sun
IrrAddFlyCircleAnimator( Moon, 0.0,0.0,1000.0, 800.0, 0.0001 )


' load the texture resource for the billboard
BillboardTexture = IrrGetTexture( "./media/cloudtest.bmp" )

' add a billboard group to the scene
Billboard = IrrAddBillBoardGroupToScene

Dim i as integer
Dim j as integer


for j = 1 to PARTICLE_LAYERS
    for i = 1 to PARTICLE_COUNT

        ' Generate a random co-ordinate in a cube
        Dim as single x = rnd - 0.5
        Dim as single y = rnd - 0.5
        Dim as single z = rnd - 0.5
        
        ' normalise the co-ordinate. this scales the x,y,z so they are
        ' exactly a distance of 1 * SCALE from origin and when they are
        ' all the same distance they appear as points on a sphere
        Dim as single factor = 1 / sqr( x*x + y*y + z*z )
        x *= factor * SPACING * j
        y *= factor * SPACING * j
        z *= factor * SPACING * j

        ' calculate a couple of color values
        Dim as integer small = (255 \ PARTICLE_LAYERS) * j / 3
        DIm as integer big   = (255 \ PARTICLE_LAYERS) * j

        ' the particle can be one of two colors to add some tone to the cloud
        select case i MOD 2
        Case 0
            ' add a billboard to the group. the parameters are as follows: -
            ' The billboard group node
            ' the X,Y scale of the billboard
            ' X,Y,Z co-ordinates for the billboard
            ' a roll for the billboard that allows each billboard to be rotated
            ' A,R,G,B color values
            particles(i+(j-1)*PARTICLE_COUNT) = IrrAddBillBoardToGroup( Billboard, _
                    15.0*SCALE - 3.0*SCALE*j, 15.0*SCALE - 3.0*SCALE*j, _
                    x,y,z, _
                    0.0, _
                    255, 255-big, 255, 255-small )
        Case 1
            ' this billboard is slightly bigger and more yellow
            particles(i+(j-1)*PARTICLE_COUNT) = IrrAddBillBoardToGroup( Billboard, _
                    20.0*SCALE - 3.0*SCALE*j, 20.0*SCALE - 3.0*SCALE*j, _
                    x,y,z, _
                    0.0, _
                    255, 255-small, 255, 255-big )
        End Select
    next i
next j


' just move the particles forward so we can have a good look at them
IrrSetNodePosition( Billboard, 0.0, 0.0, 1000.0 )

' this can be used to apply a graduated shading to billboards color
'IrrBillBoardGroupShadows( BillBoard, 1, 0, 0, 1.0, 0.5 )

' apply the loaded texture to the billboard group using node material index 0
IrrSetNodeMaterialTexture( Billboard, BillboardTexture, 0 )

' disabling lighting
IrrSetNodeMaterialFlag( Billboard, IRR_EMF_LIGHTING, IRR_OFF )

' layer the colour upon what is already there (works well for clouds)
IrrSetNodeMaterialType( Billboard, IRR_EMT_TRANSPARENT_ADD_COLOR )

' add a first person perspective camera into the scene so we can move around
' the billboard and see how it reacts
Camera = IrrAddFPSCamera( IRR_NO_OBJECT, 100.0f, CAMERA_SPEED )
IrrSetCameraClipDistance( Camera, 128000 )

' hide the mouse pointer
IrrHideMouse

dim as SBillboard ptr particle = particles(1)

print "Pos: ";particle->Position.X;",";particle->Position.Y;",";particle->Position.Z
print particle->Size.X;",";particle->Size.Y
print "Roll: ";particle->Roll
print "Axis: ";particle->Axis.X;",";particle->Axis.Y;",";particle->Axis.Z
Print "Has Axis: ";particle->HasAxis
Print "Color: ";particle->sColor
Print "Indicies: ";particle->vertexIndex

' -----------------------------------------------------------------------------
' while the irrlicht environment is still running
i = PARTICLE_COUNT*PARTICLE_LAYERS
Dim as Single timeElapsed, currentTime, frameTime = timer
WHILE IrrRunning
#ifndef RUN_FLAT_OUT
    ' is it time for another frame
    currentTime = timer
    timeElapsed = currentTime - frameTime
    if timeElapsed > 0.0167 then
        ' record the start time of this frame
        frameTime = currentTime
#endif
#ifdef REMOVE_OVER_TIME
        ' remove particles over time
        if i > 0 then
            IrrRemoveBillBoardFromGroup( Billboard, particles( i ))
            i -= 1
        End if
#endif

        ' begin the scene, erasing the canvas with sky-blue before rendering
        IrrBeginScene( 240, 255, 255 )

        ' Change the title to show the frame rate
        metrics = "Example 103: Billboard groups ("+str(IrrGetBillBoardGroupCount( Billboard ))+" clouds) ("+str( IrrGetFPS )+" fps)"
        IrrSetWindowCaption( metrics )

        ' we are drawing in two passes first the sun, moon and sky
        IrrSetNodeVisibility( Billboard, IRR_INVISIBLE )
        IrrSetNodeVisibility( Sun, IRR_VISIBLE )
        IrrSetNodeVisibility( Moon, IRR_VISIBLE )
        IrrSetNodeVisibility( SkyBox, IRR_VISIBLE )

        ' draw the scene
        IrrDrawScene

        ' on the second pass we are just drawing the clouds. by doing this we
        ' ensure that if billboards get in front of the clouds origin but are
        ' still IN the clouds they are still covered by cloud
        IrrSetNodeVisibility( Billboard, IRR_VISIBLE )
        IrrSetNodeVisibility( Sun, IRR_INVISIBLE )
        IrrSetNodeVisibility( Moon, IRR_INVISIBLE )
        IrrSetNodeVisibility( SkyBox, IRR_INVISIBLE )

        ' draw the scene
        IrrDrawScene
    
        ' end drawing the scene and render it
        IrrEndScene
#ifndef RUN_FLAT_OUT
    End If
#endif
WEND

' -----------------------------------------------------------------------------
' Stop the irrlicht engine and release resources
IrrStop
