/// <reference path="lib/headjs/head.js" />
/// <reference path="lib/dat-gui/dat.gui.js" />
/// <reference path="lib/jquery/jquery.js" />

// Namespace 
var battlespace = {};

(function (options) {

    // Load css 
    head.load('/css/app.css');

    // Load Referneces
    head.load('/scripts/lib/jquery/jquery.min.js',
              '/scripts/lib/dat-gui/dat.gui.min.js',
              '/scripts/lib/threejs/three.min.js',
              '/scripts/lib/threejs/three.trackballcontrols.js',
              '/scripts/lib/wayjs/way.min.js',
              '/scripts/lib/jstorage/jstorage.min.js'
    );

    // Load Application
    head.load('/scripts/app/app._.js');


    head.ready(function (document) {
        // View Frame 

        var $container = $('#container');
        // Container Element 
        $container.width(head.screen.width);
        $container.height(0.79 * head.screen.height);


    });
})({


});