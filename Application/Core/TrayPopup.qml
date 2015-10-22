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

Item {
    id: root

    property int spacing: 5
    property int itemSpacing: 10

    // using for auto destroy when main window closed
    property variant rootWindow

    function init(rootWindow) {
        root.rootWindow = rootWindow;
    }

    function removeOldPopupItem() {
        var item, oldestTime = Infinity;
        for (var key in Js.shownObject) {
            if (!Js.shownObject.hasOwnProperty(key)) {
                continue;
            }

            if (Js.shownObject[key].obj._closed) {
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

        if (Js.popupCount >= Js.maxPopupItem) {
            // close old one and show new one
            removeOldPopupItem();
        }

        context.opacity = 0;
        var object = component.createObject(root.rootWindow, context);
        var startY = trayWindow.height - object.height;
        var objectContext = itemContext.createObject(root.rootWindow, { y: startY, x: 0, opacity: 0 });

        objectContext.vanished.connect(function() {
            d.destroyItem(object);
        });

        object.closed.connect(function() {
            d.popupClosed(object);
        });

        object.y = Qt.binding(function() { return trayWindow.y + objectContext.y; })
        object.x = Qt.binding(function() { return trayWindow.x + objectContext.x; })
        object.opacity = Qt.binding(function() { return objectContext.opacity; });
        object.isShown = Qt.binding(function() { return objectContext.isShown; });
        object.visible = true;

        Js.shownObject[object] = {
            id: itemId,
            shownDate: +(Date.now()),
            closeFunction: object.forceDestroy,
            obj: object,
            context: objectContext
        }

        Js.items.push(object);
        d.itemsLength++;
        Js.popupCount++;

        objectContext.fadeIn();
        d.requestRecalc();
        return object;
    }

    function hidePopup(popupId) {
        for (var object in Js.shownObject) {
            if (!Js.shownObject.hasOwnProperty(object))
                continue;

            if (Js.shownObject[object].id == popupId) {
                Js.shownObject[object].closeFunction();
                break;
            }
        }
    }

    function closeAll() {
        for (var key in Js.shownObject) {
            if (Js.shownObject.hasOwnProperty(key)) {
                Js.shownObject[key].closeFunction();
            }
        }
    }

    width: 250
    height: 600

    QtObject {
        id: d

        property int itemsLength: 0
        property int totalHeight: d.totalHeightCalc()

        function requestRecalc() {
            recalcTimer.restart();
        }

        function totalHeightCalc() {
            var q = d.itemsLength;
            return Js.items.reduce(function(acc, item) {
                return acc + item.height;
             }, 0);
        }

        function recalc() {
            var y = 0
            , context
            , item
            , i;

            y = trayWindow.height;

            for (i = Js.items.length - 1; i >= 0 ; --i) {
                item = Js.items[i];
                if (!Js.shownObject.hasOwnProperty(item)) {
                    continue;
                }

                y -= item.height;
                context = Js.shownObject[item];
                context.context.y = y;
                y -= root.itemSpacing;
            }
        }

        function popupClosed(item) {
            var context = Js.shownObject[item];
            Js.popupCount--;
            context.context.fadeOut();
        }

        function destroyItem(destroyedObject) {
            var context = Js.shownObject[destroyedObject].context;
            var index = Js.items.indexOf(destroyedObject);
            if (index != -1) {
                Js.items.splice(index, 1);
                d.itemsLength--;
            }

            context.destroy();
            destroyedObject.destroy();
            delete Js.shownObject[destroyedObject];
            d.requestRecalc();
        }

        onTotalHeightChanged: {
            d.requestRecalc();
        }
    }

    QtObject {
        id: trayWindow

        function getTrayWindowX() {
            return Desktop.primaryScreenAvailableGeometry.x
                    + Desktop.primaryScreenAvailableGeometry.width
                    - trayWindow.width
                    - root.spacing;
        }

        function getTrayWindowY() {
            return Desktop.primaryScreenAvailableGeometry.y
                    + Desktop.primaryScreenAvailableGeometry.height
                    - trayWindow.height
                    - root.spacing;
        }

        property int x: trayWindow.getTrayWindowX()
        property int y: trayWindow.getTrayWindowY()
        property int width: 300
        property int height: 400
    }

    Component {
        id: itemContext

        Item {
            id: ctx

            property bool isShown: false
            property int animationDelay: 250

            signal vanished();

            function fadeIn() {
                fadeInAnimation.start();
            }

            function fadeOut() {
                fadeOutAnimation.start();
            }

            SequentialAnimation {
                id: fadeOutAnimation

                onStopped: ctx.vanished();

                NumberAnimation {
                    target: ctx
                    property: "opacity"
                    from: 1
                    to: 0.2
                    duration: animationDelay
                }
            }

            SequentialAnimation {
                id: fadeInAnimation

                PauseAnimation {
                    duration: animationDelay
                }

                NumberAnimation {
                    target: ctx
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: animationDelay
                }

                onStopped: ctx.isShown = true;
            }

            Behavior on y {
                NumberAnimation {
                    duration: animationDelay
                    easing.type: Easing.OutCubic
                }
            }
        }
    }

    Timer {
        id: recalcTimer

        interval: 50
        running: false
        repeat: false
        onTriggered: d.recalc();
    }

}
