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
var _tultipComponent,
    _tultipObj,
    _currentWidget,
    _queue = [],
    _internalPopupId = 0;

if (!_tultipComponent) {
    _tultipComponent = Qt.createComponent('./Popup.qml');
    _tultipObj = _tultipComponent.createObject(null);
    if (!_tultipObj) {
        throw new Error('FATAL: error creating Popup.qml - ' + component.errorString());
    }

    _tultipObj.close.connect(function() {
        refresh();
    });
}

function init(layer) {
    _tultipObj.parent = layer;
}

function show(widgetName, view, priority) {
    _queue.push({widgetName: widgetName, view: view, priority: priority || 0, popupId: ++_internalPopupId});
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

    return _internalPopupId;
}

function refresh() {
    if (_queue.length == 0) {
        _tultipObj.hide();
        return;
    }

    var _currentWidget = _queue.shift();

    _tultipObj.activateWidget(_currentWidget.widgetName, _currentWidget.view, _currentWidget.popupId);
}

function isPopupOpen() {
    return _tultipObj.isShown;
}

function signalBus() {
    return _tultipObj;
}

