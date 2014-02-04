/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 1.1

import "../js/GoogleAnalytics.js" as GoogleAnalytics

Item {
    id: behavior

    property variant analitics: GoogleAnalyticsEvent{}

    property alias cursor: mouseArea.cursor
    property alias enabled: mouseArea.enabled
    property bool buttonPressed: false
    property alias acceptedButtons: mouseArea.acceptedButtons

    property bool checkable: false
    property bool checked: false

    property alias toolTip: mouseArea.toolTip
    property alias tooltipPosition: mouseArea.tooltipPosition
    property alias tooltipGlueCenter: mouseArea.tooltipGlueCenter

    property alias hoverEnabled: mouseArea.hoverEnabled
    property alias containsMouse: mouseArea.containsMouse

    signal entered()
    signal exited()
    signal pressed(variant mouse)
    signal clicked(variant mouse)

    onCheckableChanged: {
        if (!checkable) {
            checked = false;
        }
    }

    CursorMouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: behavior.hoverEnabled
        enabled: behavior.enabled

        onPressed: {
            behavior.pressed(mouse);
            behavior.buttonPressed = true;
        }
        onReleased: {
            if (behavior.enabled && behavior.buttonPressed) {
                behavior.buttonPressed = false;
                if (behavior.checkable) {
                    behavior.checked = !behavior.checked;
                }
                if (analitics && analitics.isValid()) {
                    GoogleAnalytics.trackEvent(analitics.page,
                                               analitics.category,
                                               analitics.action,
                                               analitics.label);
                }
                behavior.clicked(mouse);
            }
        }
        onEntered: {
            behavior.entered();
        }
        onExited: {
            behavior.exited();
            behavior.buttonPressed = false;
        }
        onCanceled: behavior.buttonPressed = false;
    }
}
