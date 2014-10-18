/// <reference path="_references.js" />
/// <reference path="app._.js" />
/// <reference path="app._.ui.js" />
/// <reference path="app._.api.js" />
/// <reference path="app._.client.js" />


var Client = function (options) {
    var self = {};

    self.$container = $('#container');
    
    self.Width = self.$container.width();
    self.Height = self.$container.height();
    self.ViewAngle = 45;
    self.Aspect = function () {
        return self.Width / self.Height;
    }
    self.Near = 0.1;
    self.Far = 10000;
    self.Camera = new THREE.PerspectiveCamera(
        self.ViewAngle,
        self.Aspect(),
        self.Near,
        self.Far);

    self.renderer = new THREE.WebGLRenderer();

    self.scene = new THREE.Scene();
    
    self.LoadScene = function () {
        self.scene = new THREE.Scene();
        self.scene.add(self.Camera);

        // start the renderer
        self.renderer.setSize(self.Width, self.Height);
        // Empty the container
        self.$container.empty();
        // attach the render-supplied DOM element
        self.$container.append(renderer.domElement);
    }

    self.ResetCamera = function () {
        self.camera.position.z = 300;

    }

    
    

    

    self.AddLight = function () {
        // create a point light
        var pointLight =
          new THREE.PointLight(0xFFFFFF);

        // set its position
        pointLight.position.x = 10;
        pointLight.position.y = 50;
        pointLight.position.z = 130;

        // add to the scene
        scene.add(pointLight);
    }

    self.MakeMesh = function () {
        // create the sphere's material
        var sphereMaterial =
          new THREE.MeshLambertMaterial(
            {
                color: 0xCC0000
            });

        // set up the sphere vars
        var radius = 500,
            segments = 16,
            rings = 16;

        // create a new mesh with
        // sphere geometry - we will cover
        // the sphereMaterial next!
        var sphere = new THREE.Mesh(

          new THREE.SphereGeometry(
            radius,
            segments,
            rings),

          sphereMaterial);

        sphere.position.x = 10;

        // add the sphere to the scene
        scene.add(sphere);
    };

    self.MakeMesh();
    self.AddLight();

    

    // draw!
    renderer.render(scene, camera);

    return self;
};

