Original code and artwork by Paulo Oliveira (ProSoft, http://br.geocities.com/paulo_cmv/)
The code is Public Domain.
gammaray updated the code to Irrlicht 1.3.1, Torleif (Pippy) updated it for irrlicht v1.4.1
The example and artwork used for it (which is not necessary for the lens flare node) is
taken from the Irrlicht Engine. That artwork can be found in the media directory.

Changes: 
  Now node remembers starting point, so you can set it to move with the camera
  more comments
  setTexture(), not accessing raw array
  force converting primitive types so no warnings

To use it:

 #1 copy source and flares.jpg into your source folder (or change "flares.jpg" to where art is)

 #2 put this in your includes with all the other #includes:
#include "CLensFlareSceneNode.h"

 #3 put this when loading your files (after driver init)
ILensFlareSceneNode* flare = new CLensFlareSceneNode(smgr->getRootSceneNode(), smgr);
flare->getMaterial(0).setTexture(0, driver->getTexture("flares.jpg"));


Hint: to get it to align with a sky box use setPosition and play around with the constructors position parameter until it lines up


Enjoy!

