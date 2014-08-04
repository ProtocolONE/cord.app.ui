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
var _popupComponent,
    _popupObj,
    _currentWidget,
    _queue = [],
    _internalPopupId = 0;

if (!_popupComponent) {
    _popupComponent = Qt.createComponent('./Popup.qml');
    _popupObj = _popupComponent.createObject(null);
    if (!_popupObj) {
        throw new Error('FATAL: error creating Popup.qml - ' + component.errorString());
    }

    _popupObj.close.connect(function() {
        refresh();
    });
}

function init(layer) {
    _popupObj.parent = layer;
}

function show(widgetName, view, priority) {
    _queue.push({widgetName: widgetName, view: view || '', priority: priority || 0, popupId: ++_internalPopupId});
    _queue.sort(function(a, b){
        if (a.priority < b.priority){
            return 1;
        }
        if (a.priority == b.priority) {
            return 0;
        }
        return -1;
    });

    if (!_popupObj.isShown) {
        refresh();
    }

    return _internalPopupId;
}

function refresh() {
    if (_queue.length == 0) {
        _popupObj.hide();
        return;
    }

    var _currentWidget = _queue.shift();

    _popupObj.activateWidget(_currentWidget.widgetName, _currentWidget.view, _currentWidget.popupId);
}

function isPopupOpen() {
    return _popupObj.isShown;
}

function signalBus() {
    return _popupObj;
}

