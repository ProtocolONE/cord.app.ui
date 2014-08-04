/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1
import "WidgetManager.js" as WidgetManager

FocusScope {
    id: root

    signal viewReady();

    property string widget: ''
    property string view: ''

    property alias viewInstance: d.viewObj //@readonly

    onViewChanged: delayedUpdate.restart()
    onWidgetChanged: delayedUpdate.restart()
    Component.onDestruction: root.clear()

    implicitWidth: childrenRect.width
    implicitHeight: childrenRect.height

    function clear() {
        if (d.viewObj === root) {
            //INFO Мы только инициализированы и в viewObj находится прокси объект
            return;
        }

        if (d.viewObj) {
            d.viewObj.clear();
            d.viewObj.destroy();
        }
    }

    function reset() {
        root.widget = '';
        root.view = '';
    }

    function force(widgetName, widgetView) {
        if (widgetName !== widget || view !== widgetView ) {
            d.ignoreUpdate = true;
            widget = widgetName;
            view = widgetView;
            d.ignoreUpdate = false;
        }

        d.updateView();
    }

    Timer {
        id: delayedUpdate

        interval: 0
        triggeredOnStart: false
        onTriggered: d.updateView()
    }

    Connections {
        target: WidgetManager._internal.getPrivateWrapper()
        onWidgetsReady: d.updateView()
    }

    QtObject {
        id: d

        property variant viewObj: root
        property bool ignoreUpdate: false

        function updateView() {
            if (!WidgetManager.isReady() || ignoreUpdate) {
                return;
            }

            console.log('update', root.widget, root.view)

            root.clear();
            if (root.widget === '') {
                return;
            }


            console.log('create', root.widget, root.view)
            d.viewObj = (root.view !== '')
                ? WidgetManager.createNamedView(root.widget, root.view, root)
                : WidgetManager.createView(root.widget, root);

            root.viewReady();
        }
    }
}
