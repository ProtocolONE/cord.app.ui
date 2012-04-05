.pragma library

var popupWindow,
    popupCount = 0,
    maxPopupItem = 3,
    shownObject = {};

function initialize(window) {
    popupWindow = window;
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

    if (isAlreadyShown(itemId)) {
        return;
    }

    var object = component.createObject(null, context);
    if (popupCount >= maxPopupItem) {
        // close old one and show new one
        removeOldPopupItem();
    }

    object.parent = popupWindow;
    object.isShown = true;

    shownObject[object] = {
        id: itemId,
        shownDate: +(new Date()),
        closeFunction: object.forceDestroy
    }

    popupCount++;
}

function destroy(destroyedObject) {
    delete shownObject[destroyedObject];
    popupCount--;
}

