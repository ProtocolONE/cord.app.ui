/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

.pragma library

var popupWindow,
    popupInstance,
    popupCount = 0,
    maxPopupItem = 3,
    shownObject = {};

function init(parent) {
    var component = Qt.createComponent('./Popup.qml');
    if (component.status != 1) {
        throw new Error('Can\'t create component Popup.qml, reason: ' + component.errorString());
    }

    popupInstance = component.createObject(parent);
    if (popupInstance) {
        popupWindow = popupInstance.getPopupContentParent();
    }
}

function clearAll() {
    popupCount = 0;
    shownObject = {};
}

function removeOldPopupItem() {
    var item, oldestTime = Infinity;
    for (var key in shownObject) {
        if (!shownObject.hasOwnProperty(key)) {
            continue;
        }

        if (shownObject[key].shownDate < oldestTime) {
            oldestTime = shownObject[key].shownDate;
            item = key;
        }
    }

    if (item) {
        shownObject[item].closeFunction();
    }
}

function isAlreadyShown(itemId) {
    for (var object in shownObject) {
        if (!shownObject.hasOwnProperty(object))
            continue;

        if (shownObject[object].id == itemId)
            return true;
    }

    return false;
}

function showPopup(component, context, itemId) {
    if (!component.hasOwnProperty('createObject')) {
        return;
    }

    if (component.status != 1) {
        return;
    }

    if (isAlreadyShown(itemId)) {
        return;
    }

    var object = component.createObject(null, context);
    if (popupCount >= maxPopupItem) {
        // close old one and show new one
        removeOldPopupItem();
    }

    object.parent = popupInstance.getPopupContentParent();
    object.isShown = true;

    shownObject[object] = {
        id: itemId,
        shownDate: +(new Date()),
        closeFunction: object.anywhereClickDestroy,
        obj: object
    }
    popupCount++;
    return object;
}

function destroy(destroyedObject) {
    if (!shownObject.hasOwnProperty(destroyedObject)) {
        return;
    }

    delete shownObject[destroyedObject];
    popupCount--;
}

