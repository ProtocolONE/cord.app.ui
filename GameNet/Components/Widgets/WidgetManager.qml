pragma Singleton

import QtQuick 2.4
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
    id: root

    function registerWidget(name) {
        return WidgetManager.registerWidget(name);
    }

    function getWidgetByName(name) {
        return WidgetManager.getWidgetByName(name);
    }

    function init(parent) {
        WidgetManager.init(parent || root);
    }

    function getWidgetSettings(name) {
        return WidgetManager.getWidgetSettings(name);
    }

    function hasWidgetByName(name) {
        return WidgetManager.hasWidgetByName(name);
    }

}
