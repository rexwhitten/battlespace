/*
    Written by Asger Feldthaus modified to include billboard removal

    February 2007
    June 2010
*/

#include <irrlicht.h>
#include "CBillboardGroupSceneNode.h"

#include <ICameraSceneNode.h>
#include <IVideoDriver.h>

namespace irr
{
namespace scene
{

CBillboardGroupSceneNode::CBillboardGroupSceneNode( ISceneNode* parent, ISceneManager* manager, s32 id,
        const core::vector3df& position,
        const core::vector3df& rotation,
        const core::vector3df& scale )
    : ISceneNode( parent, manager, id, position, rotation, scale )
{
    Billboards = NULL;
    FarDistance = 256.0f;
    Radius = 0.0f;

	// set the material parameter and transparrent alpha channel
//	setAutomaticCulling(scene::EAC_OFF);
//	Material.MaterialTypeParam = 0.01f;
//	Material.ZWriteEnable = false;

}

CBillboardGroupSceneNode::~CBillboardGroupSceneNode()
{
    SBillboard * bill = Billboards;
    s32 i = 0;

    while ( bill )
    {
        bill = (SBillboard * )Billboards->next;
        delete Billboards;
        Billboards = bill;
        i++;
    }
}

CBillboardGroupSceneNode::SBillboard * CBillboardGroupSceneNode::addBillboard( const core::vector3df& position, const core::dimension2df& size, f32 roll, video::SColor vertexColor )
{
    SBillboard * bill = new( SBillboard );
    if ( Billboards )
    {
        Billboards->prev = bill;
        bill->next = Billboards;
    }
    else
    {
        bill->next = NULL;
    }

    Billboards = bill;
    count++;

    bill->Position = position;
    bill->Size = size;
    bill->Roll = roll;
    bill->Color = vertexColor;
    bill->prev = NULL;
    bill->HasAxis = false;
//    Billboards.push_back( SBillboard( position, size, roll, vertexColor ) );

    s32 vertexIndex = MeshBuffer.Vertices.size();
    bill->vertexIndex = vertexIndex;


    f32 maxDimension = size.Width;
    if ( size.Height > maxDimension )
        maxDimension = size.Height;

    core::vector3df vDim = core::vector3df(maxDimension,maxDimension,maxDimension);

    BoundingBox.addInternalBox( core::aabbox3df(
            position - vDim,
            position + vDim
        ));

    Radius = BoundingBox.getExtent().getLength() / 2.0f;

    // Don't bother setting correct positions here, they are updated in OnPreRender anyway
    MeshBuffer.Vertices.push_back( video::S3DVertex( position, core::vector3df(0,1,0), vertexColor, core::vector2df(0,0) ) );
    MeshBuffer.Vertices.push_back( video::S3DVertex( position, core::vector3df(0,1,0), vertexColor, core::vector2df(1,0) ) );
    MeshBuffer.Vertices.push_back( video::S3DVertex( position, core::vector3df(0,1,0), vertexColor, core::vector2df(1,1) ) );
    MeshBuffer.Vertices.push_back( video::S3DVertex( position, core::vector3df(0,1,0), vertexColor, core::vector2df(0,1) ) );

    /*
        Vertices are placed like this:
            0---1
            |   |
            3---2
    */

    MeshBuffer.Indices.push_back( vertexIndex );
    MeshBuffer.Indices.push_back( vertexIndex + 1 );
    MeshBuffer.Indices.push_back( vertexIndex + 2 );

    MeshBuffer.Indices.push_back( vertexIndex + 2 );
    MeshBuffer.Indices.push_back( vertexIndex + 3 );
    MeshBuffer.Indices.push_back( vertexIndex );

    return Billboards;
}

CBillboardGroupSceneNode::SBillboard * CBillboardGroupSceneNode::addBillboardWithAxis( const core::vector3df& position, const core::dimension2df& size, const core::vector3df& axis, f32 roll, video::SColor vertexColor )
{
//    s32 index = Billboards.size();

    SBillboard * bill = addBillboard( position, size, roll, vertexColor );

//    Billboards[index].HasAxis = true;
//    Billboards[index].Axis = axis;

    bill->HasAxis = true;
    bill->Axis = axis;

    return bill;
}

void CBillboardGroupSceneNode::removeBillboard( CBillboardGroupSceneNode::SBillboard * bill )
{
    if ( bill )
    {
        // copy the billboards data into this slot as billboards is always the last set of verticies
        MeshBuffer.Vertices[bill->vertexIndex    ] = MeshBuffer.Vertices[Billboards->vertexIndex];
        MeshBuffer.Vertices[bill->vertexIndex + 1] = MeshBuffer.Vertices[Billboards->vertexIndex + 1];
        MeshBuffer.Vertices[bill->vertexIndex + 2] = MeshBuffer.Vertices[Billboards->vertexIndex + 2];
        MeshBuffer.Vertices[bill->vertexIndex + 3] = MeshBuffer.Vertices[Billboards->vertexIndex + 3];

        Billboards->vertexIndex = bill->vertexIndex;

        MeshBuffer.Vertices.set_used( MeshBuffer.Vertices.size() - 4 );
        MeshBuffer.Indices.set_used( MeshBuffer.Indices.size() - 6 );

        // if there is more than one link
        if ( Billboards->next )
        {
            SBillboard * replacement = Billboards;
            ((SBillboard *)Billboards->next)->prev = NULL;
            Billboards = (SBillboard *)Billboards->next;

            if ( bill->next )
            {
                ((SBillboard *)bill->next)->prev = replacement;
                replacement->next = bill->next;
            }
            else
            {
                replacement->next = NULL;
            }

            if ( bill->prev )
            {
                ((SBillboard *)bill->prev)->next = replacement;
                replacement->prev = bill->prev;
            }
            else
            {
                replacement->prev = NULL;
            }
        }
        else
        {
            Billboards = NULL;
        }

        count--;
        delete bill;
    }
}



s32 CBillboardGroupSceneNode::getBillboardCount() const
{
//    return Billboards.size();
    return count;
}

void CBillboardGroupSceneNode::OnRegisterSceneNode()
{
    if ( IsVisible )
    {
        SceneManager->registerNodeForRendering( this );
    }
}

void CBillboardGroupSceneNode::render()
{
    updateBillboards();

    video::IVideoDriver* driver = SceneManager->getVideoDriver();

    driver->setTransform( video::ETS_WORLD, core::matrix4() );

    driver->setMaterial( Material );

    driver->drawMeshBuffer( &MeshBuffer );
}

const core::aabbox3df& CBillboardGroupSceneNode::getBoundingBox() const
{
    return BoundingBox;
}

video::SMaterial& CBillboardGroupSceneNode::getMaterial(u32 i)
{
    return Material;
}

u32 CBillboardGroupSceneNode::getMaterialCount() const
{
    return 1;
}

void CBillboardGroupSceneNode::applyVertexShadows( const core::vector3df& lightDir, f32 intensity, f32 ambient )
{
//    for ( s32 i=0; i<(s32)Billboards.size(); i++ )
    SBillboard * bill = Billboards;
    s32 i = 0;

    while ( bill )
    {
//        core::vector3df normal = Billboards[i].Position;
        core::vector3df normal = bill->Position;

        normal.normalize();

        f32 light = -lightDir.dotProduct(normal)*intensity + ambient;

        if ( light < 0 )
            light = 0;

        if ( light > 1 )
            light = 1;

        video::SColor color;

//        color.setRed( (u8)(Billboards[i].Color.getRed() * light) );
//        color.setGreen( (u8)(Billboards[i].Color.getGreen() * light) );
//        color.setBlue( (u8)(Billboards[i].Color.getBlue() * light) );
//        color.setAlpha( (u8)Billboards[i].Color.getAlpha() );

        color.setRed( (u8)(bill->Color.getRed() * light) );
        color.setGreen( (u8)(bill->Color.getGreen() * light) );
        color.setBlue( (u8)(bill->Color.getBlue() * light) );
        color.setAlpha( (u8)bill->Color.getAlpha() );

        for ( s32 j=0; j<4; j++ )
        {
            MeshBuffer.Vertices[i*4+j].Color = color;
        }
        i++;
        bill = (SBillboard * )bill->next;
    }
}

//! Gives vertices back their original color.
void CBillboardGroupSceneNode::resetVertexShadows()
{
//    for ( s32 i=0; i<(s32)Billboards.size(); i++ )
    SBillboard * bill = Billboards;
    s32 i = 0;

    while ( bill )
    {
        for ( s32 j=0; j<4; j++ )
        {
//            MeshBuffer.Vertices[i*4+j].Color = Billboards[i].Color;
            MeshBuffer.Vertices[i*4+j].Color = bill->Color;
        }
        i++;
        bill = (SBillboard * )bill->next;
    }
}

int countI = 0;
void CBillboardGroupSceneNode::updateBillboards()
{
    ICameraSceneNode* camera = SceneManager->getActiveCamera();

    if ( !camera )
        return;

    core::vector3df camPos = camera->getAbsolutePosition();

    core::vector3df ref = core::vector3df(0,1,0);

    camera->getAbsoluteTransformation().rotateVect(ref);

    core::vector3df view, right, up;

    bool farAway = false;

    core::vector3df center = BoundingBox.getCenter();
    AbsoluteTransformation.transformVect(center);

    core::vector3df camDir = camPos - center;

    if ( camDir.getLengthSQ() >= (FarDistance + Radius)*(FarDistance + Radius) )
    {
        farAway = true;
        view = center - camPos;
        view.normalize();

        right = ref.crossProduct( view );

        up = view.crossProduct( right );
    }
	// if a refresh is being forced
	if ( refresh )
	{
		farAway = false;
	}

    core::vector3df rotatedCamDir = camDir;
    AbsoluteTransformation.inverseRotateVect( rotatedCamDir );

    if ( farAway && (rotatedCamDir - LastCamDir).getLengthSQ() < camDir.getLengthSQ()/100.0 )
    {
        return;
    }
//printf( "Updating %d\n", countI++ );
    LastCamDir = rotatedCamDir;

    // Update the position of every billboard
//    for ( s32 i=0; i<(s32)Billboards.size(); i++ )
    SBillboard * bill = Billboards;
    s32 i = 0;

    while ( bill )
    {
        if ( !farAway )
        {
//            core::vector3df pos = Billboards[i].Position;
            core::vector3df pos = bill->Position;

            AbsoluteTransformation.transformVect( pos );

            view = pos - camPos;

            view.normalize();
        }

        core::vector3df thisRight = right;
        core::vector3df thisUp = up;

//        if ( Billboards[i].HasAxis )
        if ( bill->HasAxis )
        {
//            core::vector3df axis = Billboards[i].Axis;
            core::vector3df axis = bill->Axis;

            AbsoluteTransformation.rotateVect(axis);

            thisRight = axis.crossProduct( view );

            thisUp = axis;
        }
        else if ( !farAway )
        {
            thisRight = ref.crossProduct( view );

            thisUp = view.crossProduct( thisRight );
        }

//        f32 rollrad = Billboards[i].Roll * core::DEGTORAD;
        f32 rollrad = bill->Roll * core::DEGTORAD;
        f32 cos_roll = cos( rollrad );
        f32 sin_roll = sin( rollrad );

        core::vector3df a =  cos_roll * thisRight + sin_roll * thisUp;
        core::vector3df b = -sin_roll * thisRight + cos_roll * thisUp;

//        a *= Billboards[i].Size.Width / 2.0f;
//        b *= Billboards[i].Size.Height / 2.0f;
        a *= bill->Size.Width / 2.0f;
        b *= bill->Size.Height / 2.0f;

        s32 vertexIndex = bill->vertexIndex;  // 4 vertices per billboard

//        core::vector3df billPos = Billboards[i].Position;
        core::vector3df billPos = bill->Position;
        AbsoluteTransformation.transformVect(billPos);

        MeshBuffer.Vertices[vertexIndex  ].Pos = billPos - a + b;
        MeshBuffer.Vertices[vertexIndex+1].Pos = billPos + a + b;
        MeshBuffer.Vertices[vertexIndex+2].Pos = billPos + a - b;
        MeshBuffer.Vertices[vertexIndex+3].Pos = billPos - a - b;

        i++;
        bill = (SBillboard * )bill->next;
    }
}

} // namespace scene
} // namespace irr
