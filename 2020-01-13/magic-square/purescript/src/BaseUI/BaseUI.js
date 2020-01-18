"use strict";
exports.__esModule = true;
var styletron_react_1 = require("styletron-react");
var styletron_engine_atomic_1 = require("styletron-engine-atomic");
var baseui_1 = require("baseui");
var React = require("react");
exports.ui_wrapper = (function () {
    var engine = new styletron_engine_atomic_1.Client();
    return function (_a) {
        var children = _a.children;
        return (React.createElement(styletron_react_1.Provider, { value: engine },
            React.createElement(baseui_1.BaseProvider, { theme: baseui_1.LightTheme }, children)));
    };
})();
