/// <reference path="lib/headjs/head.js" />
/// <reference path="lib/dat-gui/dat.gui.js" />

// Namespace 
var battlespace = {};

(function (options) {

    // Load css 
    head.load('/css/app.css');

    // Load Referneces
    head.load('/scripts/lib/jquery/jquery.min.js',
              '/scripts/lib/dat-gui/dat.gui.min.js',
              '/scripts/lib/threejs/three.min.js',
              '/scripts/lib/wayjs/way.min.js'
    );

    // Load Application
    head.load('/scripts/app/app.js');


    head.ready(function (document) {
        
    });
})({


});