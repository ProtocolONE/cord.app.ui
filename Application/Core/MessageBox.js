.pragma library
/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
var _model,
    _layer,
    _queue = [],
    _currentWidget,
    _messageId = 0,
    buttonNames,
    button = {
        'NoButton'           : 0x00000000,
        'Ok'                 : 0x00000400,
        'Save'               : 0x00000800,
        'SaveAll'            : 0x00001000,
        'Open'               : 0x00002000,
        'Yes'                : 0x00004000,
        'YesToAll'           : 0x00008000,
        'No'                 : 0x00010000,
        'NoToAll'            : 0x00020000,
        'Abort'              : 0x00040000,
        'Retry'              : 0x00080000,
        'Ignore'             : 0x00100000,
        'Close'              : 0x00200000,
        'Cancel'             : 0x00400000,
        'Discard'            : 0x00800000,
        'Help'               : 0x01000000,
        'Apply'              : 0x02000000,
        'Reset'              : 0x04000000,
        'RestoreDefaults'    : 0x08000000
    };

function init(layer) {
    var component = Qt.createComponent('./MessageBox.qml');

    _layer = component.createObject(layer);
    if (!_layer) {
        throw new Error('FATAL: error creating MessageBox.qml - ' + component.errorString());
    }

    _layer.close.connect(function() {
        refresh();
    });

    _layer.viewReady.connect(function() {
        _model.activate(_currentWidget);
    });

    _layer.blink.connect(function() {
        _model.blink();
    });
}

function registerModel(model) {
    _model = model;
    _model.callback.connect(function(button) {
        _currentWidget.callback(button);
        refresh();
    });
}

function show(message, text, buttons, callback) {
    _queue.push({id: _messageId++, message: message, text: text, buttons: buttons, callback: callback});
    if (!_layer.isShown) {
        refresh();
    }
}

function refresh() {
    if (_queue.length == 0) {
        _layer.hide();
        return;
    }

    _currentWidget = _queue.shift();
    _layer.activateWidget('AlertAdapter');
}
