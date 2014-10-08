namespace irr
{

class ITimer;

namespace gui
{
	class IGUIFont;
}
namespace scene
{

class CLODSceneNode : public ISceneNode
{
public:
	CLODSceneNode(ISceneNode* parent, s32 id=-1);
	~CLODSceneNode();


	/*
	 * node functions
	 */

	// render the actual object
	virtual void render();

	// get the bounding box
	const irr::core::aabbox3df& getBoundingBox() const;

	// redirect renders here,
	virtual void OnRegisterSceneNode();

	// render to texture here,
	virtual void OnAnimate(u32 timeMs);

	// deal with children
	virtual void addChild(ISceneNode* child);
	virtual bool removeChild(ISceneNode* child);

	void AddLODMesh( float distance, IAnimatedMesh *mesh );

	void SetMaterialMapping( E_MATERIAL_TYPE source, E_MATERIAL_TYPE target );

    enum lodMode
    {
        LOD_OPAQUE,
        LOD_FADE_OUT,
		LOD_FADE_IN,
        LOD_INVISIBLE
    };

	// link for a child node recording level of detail
	struct SChildLink
	{
		SChildLink() : node(0), lod(0), fade(0x0), mode( LOD_OPAQUE ) {}

		// the scene node
		ISceneNode *	    node;

		// about the object
		s32				    lod;
        E_MATERIAL_TYPE     matType;
        u32                 fade;
        lodMode             mode;

		bool operator == (const SChildLink& other) const { return node == other.node; }
	};

	struct SLOD
	{
		SLOD(): mesh(NULL), distance(0.0f){}
		IAnimatedMesh *	mesh;
		float			distance;

		bool operator == (const SLOD& other) const { return distance == other.distance; }
	};

	core::aabbox3df Box;
	core::array<SChildLink> children;
	core::array<SLOD> lods;
	u32 fadeScale;
	void (*callback)(u32, ISceneNode *);
	bool useAlpha;
	E_MATERIAL_TYPE matmap[EMT_TRANSPARENT_ADD_ALPHA_CHANNEL+1];
};

} // scene
} // irr
