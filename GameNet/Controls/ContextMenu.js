.pragma library

var _layer = null,
    _instance = null;

function init(layer) {
    _layer = layer;
}

function show(mouse, mouseArea, component, options) {
    var point,
        isValid;

    isValid = mouse.hasOwnProperty('x')
        && mouse.hasOwnProperty('y')
        && component;

    if (!isValid) {
        throw new Error('Invalid arguments');
    }

    hide();

    _instance = component.createObject(_layer, options || {});
    if (!_instance) {
        throw new Error('FATAL: error creating context menu component - ' + component.errorString());
    }

    point = mouseArea.mapToItem(_layer, mouse.x, mouse.y);
    _instance.x = (point.x + _instance.width) > _layer.width ? (_layer.width - _instance.width - 10) : point.x;
    _instance.y = (point.y + _instance.height) > _layer.height ? (_layer.height - _instance.height - 10) : point.y;
}

function clicked(root, globalX, globalY) {
    if (!_instance) {
        return;
    }

    var posInItem = _instance.mapFromItem(root, globalX, globalY),
        contains;

    contains =  posInItem.x >= 0
            && posInItem.y >=0
            && posInItem.x <= _instance.width
            && posInItem.y <= _instance.height;

    if (!contains) {
        hide();
    }
}

function hide() {
    if (_instance) {
        _instance.destroy();
    }
    _instance = null;
}
