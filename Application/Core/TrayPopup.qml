/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
pragma Singleton

import QtQuick 2.4
import QtQuick.Window 2.2

import Tulip 1.0

import "./TrayPopup.js" as Js

Window {
    id: root

    property int spacing: 5

    function removeOldPopupItem() {
        var item, oldestTime = Infinity;
        for (var key in Js.shownObject) {
            if (!Js.shownObject.hasOwnProperty(key)) {
                continue;
            }

            if (Js.shownObject[key].shownDate < oldestTime) {
                oldestTime = Js.shownObject[key].shownDate;
                item = key;
            }
        }

        if (item) {
            Js.shownObject[item].closeFunction();
        }
    }

    function isAlreadyShown(itemId) {
        for (var object in Js.shownObject) {
            if (!Js.shownObject.hasOwnProperty(object))
                continue;

            if (Js.shownObject[object].id == itemId)
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
        if (Js.popupCount >= Js.maxPopupItem) {
            // close old one and show new one
            removeOldPopupItem();
        }

        object.parent = popupColumn;
        object.isShown = true;

        Js.shownObject[object] = {
            id: itemId,
            shownDate: +(new Date()),
            closeFunction: object.forceDestroy,
            obj: object
        }
        Js.popupCount++;
        return object;
    }

    function hidePopup(popupId) {
        var popupObject;
        for (var object in Js.shownObject) {
            if (!Js.shownObject.hasOwnProperty(object))
                continue;

            if (Js.shownObject[object].id == popupId) {
                popupObject = Js.shownObject[object];
                break;
            }
        }

        if (popupObject) {
            popupObject.closeFunction();
            destroy(popupObject);
        }
    }

    function destroyItem(destroyedObject) {
        delete Js.shownObject[destroyedObject];
        Js.popupCount--;
    }

    function closeAll() {
        for (var key in Js.shownObject) {
            if (Js.shownObject.hasOwnProperty(key)) {
                Js.shownObject[key].closeFunction();
                destroy(Js.shownObject[key]);
            }
        }
    }

    x: Desktop.primaryScreenAvailableGeometry.x + Desktop.primaryScreenAvailableGeometry.width - width - spacing
    y: Desktop.primaryScreenAvailableGeometry.y + Desktop.primaryScreenAvailableGeometry.height - height - spacing

    flags: Qt.Window | Qt.FramelessWindowHint | Qt.Tool | Qt.WindowMinimizeButtonHint
           | Qt.WindowMaximizeButtonHint | Qt.WindowSystemMenuHint | Qt.WindowStaysOnTopHint

    width: popupColumn.width
    height: popupColumn.height
    visible: popupColumn.children.length > 0

    opacity: 1
    color: "#00000000"

    Column {
        id: popupColumn

        anchors.top: parent.bottom
        width: 250

        spacing: 10
        transform: [
            Rotation { angle: 180 }
        ]
        move: Transition {
            NumberAnimation {
                properties: "x,y"
                duration: 100
                easing.type: Easing.OutCubic
            }
        }
    }
}
