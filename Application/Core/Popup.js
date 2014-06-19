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
var _tultipObj,
    _currentWidget,
    _queue = [];

function init(layer) {
    var component = Qt.createComponent('./Popup.qml');

    _tultipObj = component.createObject(layer);
    if (!_tultipObj) {
        throw new Error('FATAL: error creating Popup.qml - ' + component.errorString());
    }

    _tultipObj.close.connect(function() {
        refresh();
    });
}

function show(widgetName, view, priority) {
    _queue.push({widgetName: widgetName, view: view, priority: priority || 0});
    _queue.sort(function(a, b){
        if (a.priority < b.priority){
            return 1;
        }
        if (a.priority == b.priority) {
            return 0;
        }
        return -1;
    });

    if (!_tultipObj.isShown) {
        refresh();
    }
}

function refresh() {
    if (_queue.length == 0) {
        _tultipObj.hide();
        return;
    }

    var _currentWidget = _queue.shift();

    _tultipObj.activateWidget(_currentWidget.widgetName, _currentWidget.view);
}

function isPopupOpen() {
    return _tultipObj.isShown;
}





