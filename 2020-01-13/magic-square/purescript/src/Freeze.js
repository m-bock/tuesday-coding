
exports.freeze = function (o) {
    Object.freeze(o);
    return o;
}

exports.someDangerousJS = function (o) {
    o.age++;
    return o;
}