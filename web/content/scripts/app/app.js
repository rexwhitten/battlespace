/// <reference path="_references.js" />
/// <reference path="../lib/dat-gui/dat.gui.js" />
var Application = {};

(function (options) {


    head.load("scripts/app/app.ui.js", function () {
        Application.ui = new Ui(options);
    });

    head.load("scripts/app/app.api.js", function () {
        Application.api = new Api(options);
    });
    
head
})({
    title : "Battlespace Client",
    version : "0.0.0"
});

