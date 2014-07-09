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

/**
 * WidgetManager
 *
 * Simple wrapper for WidgetManager.js. Should be used to widget initialization if you do not want to directly
 * incluide js file to your file.
 *
 * See WidgetTestSuite.qml for usage example.
 */
Item {
    function registerWidget(name) {
        return WidgetManager.registerWidget(name);
    }

    function getWidgetByName(name) {
        return WidgetManager.getWidgetByName(name);
    }

    function init() {
        WidgetManager.init();
    }
}
