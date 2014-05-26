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

Item {
    id: root

    signal viewReady();

    property string widget: ''
    property variant view

    property alias viewInstance: d.viewObj //@readonly

    onViewChanged: d.updateView()
    onWidgetChanged: d.updateView()
    Component.onDestruction: root.clear()

    function clear() {
        if (d.viewObj) {
            d.viewObj.clear();
            d.viewObj.destroy();
        }
    }

    function force(widgetName, widgetView) {
         if (widgetName == widget && view == widgetView ) {
               d.updateView();
         } else {
             view = widgetView;
             widget = widgetName;
        }
    }

    Connections {
        target: WidgetManager._internal.getPrivateWrapper()
        onWidgetsReady: d.updateView()
    }

    QtObject {
        id: d

        property variant viewObj

        function updateView() {
            if (!WidgetManager.isReady()) {
                return;
            }

            root.clear();
            if (root.widget === '') {
                return;
            }

            d.viewObj = (root.view !== '')
                ? WidgetManager.createNamedView(root.widget, root.view, root)
                : WidgetManager.createView(root.widget, root);

            root.viewReady();
        }
    }
}
