/// <reference path="_references.js" />
/// <reference path="../lib/dat-gui/dat.gui.js" />
var Application = {};

(function (options) {

    

    head.load("scripts/app/app._.ui.js", function () {
        Application.ui = new Ui(options);
    });

    head.load("scripts/app/app._.api.js", function () {
        Application.api = new Api(options);
    });
    
    head.load("scripts/app/app._.client.js", function () {
        Application.client = new Client(options);
    });

    
    // Load gui 

    head.ready(function (document) {
        
    });

})({
    title : "Battlespace Client",
    version : "0.0.0"
});

