.pragma library

var _tooltipObject = null;

function init(layer) {
    var component = Qt.createComponent('./Tooltip.qml');

    _tooltipObject = component.createObject(layer);
    if (!_tooltipObject) {
        throw new Error('FATAL: error creating Tooltip.qml - ' + component.errorString());
    }
}

 function isItemValid(item) {
    return (typeof item === 'object')
            && item.toString().indexOf('QML') !== -1
            && item.hasOwnProperty('entered')
            && typeof item.entered === 'function'
            && item.hasOwnProperty('exited')
            && typeof item.exited === 'function'
            && item.hasOwnProperty('toolTip')
            && typeof item.toolTip === 'string';
}

function track(item) {
    if (!isItemValid(item)) {
        console.log('FATAL: Invalid tooltip item object ' + item);
        return;
    }

    item.entered.connect(function() {
        entered(item)
    });

    item.exited.connect(function() {
        exited(item);
    });
}

function entered(item) {
    if (_tooltipObject) {
        _tooltipObject.entered(item);
    }
}

function exited(item) {
    if (_tooltipObject) {
        _tooltipObject.exited(item);
    }
}

function animationDuration() {
    if (_tooltipObject) {
        return _tooltipObject.animationDuration;
    }

    return 0;
}

function release(item) {
    if (!this.isItemValid(item)) {
        console.log('FATAL: Could not release tooltip item object ' + item);
        return;
    }

    if (_tooltipObject) {
        _tooltipObject.release(item);
    }
}

function releaseAll() {
    if (_tooltipObject) {
        _tooltipObject.releaseAll();
    }
}

