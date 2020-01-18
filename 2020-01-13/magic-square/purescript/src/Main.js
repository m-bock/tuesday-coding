"use strict";
exports.__esModule = true;
var ReactDOM = require("react-dom");
exports.mountApp = function (callback) { return function () {
    var mount = function () {
        var elementApp = window.document.createElement("div");
        if (module.hot) {
            module.hot.accept();
            module.hot.dispose(function () {
                ReactDOM.unmountComponentAtNode(elementApp);
                elementApp.remove();
            });
        }
        window.document.body.append(elementApp);
        window.document.removeEventListener("DOMContentLoaded", mount);
        callback(elementApp)();
    };
    window.document.addEventListener("DOMContentLoaded", mount);
}; };
