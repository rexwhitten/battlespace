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
    
    self.LoadScene = function (complete_callback) {
        self.scene = new THREE.Scene();
        self.scene.add(self.Camera);

        // start the renderer
        self.renderer.setSize(self.Width, self.Height);
        // Empty the container
        self.$container.empty();
        // attach the render-supplied DOM element
        self.$container.append(self.renderer.domElement);

        // draw!
        self.renderer.render(self.scene, self.Camera);

        self.ResetCamera();

        // Execute callback when loaded
        if (complete_callback) {
            complete_callback();
        }
    }

    self.ResetCamera = function () {
        self.Camera.position.z = 300;
    }

    // Collection - Lights
    self.Lights = {};
    self.AddLight = function (name, color) {

        self.Lights[name] = new THREE.PointLight(0xFFFFFF);
        self.Lights[name].position.x = 10;
        self.Lights[name].position.y = 50;
        self.Lights[name].position.z = 130;

        // Add light info to Gui
        var light = Application.ui.gui.addFolder(name);
        
        light.add(self.Lights[name].position, "x");
        light.add(self.Lights[name].position, "y");
        light.add(self.Lights[name].position, "z");

        // add to the scene
        self.scene.add(self.Lights[name]);
    }

    // Collection - Meshes
    self.Meshs = {};
    self.AddMesh = function (name) {
        // create default material
        var sphereMaterial =
          new THREE.MeshLambertMaterial(
            {
                color: 0xCC0000
            });

        // set up the sphere vars
        var radius = 100,
            segments = 32,
            rings = 32;

        self.Meshs[name] = new THREE.Mesh(new THREE.SphereGeometry(radius,segments,rings),sphereMaterial);
        self.Meshs[name].position.x = 10;

        // Add to UI 
        var mesh = Application.ui.gui.addFolder(name);
        mesh.add(self.Meshs[name].position, "x");
        mesh.add(self.Meshs[name].position, "y");
        mesh.add(self.Meshs[name].position, "z");

        // add the sphere to the scene
        self.scene.add(self.Meshs[name]);
    };



    self.LoadScene(function () {
        self.AddMesh("planet");
        self.AddMesh("moon1");
        self.AddMesh("moon2");
        self.AddLight("main");
    });  

    return self;
};

