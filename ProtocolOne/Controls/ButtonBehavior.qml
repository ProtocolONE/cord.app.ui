import QtQuick 2.4

import ProtocolOne.Core 1.0

Item {

    id: behavior

    property GoogleAnalyticsEvent analytics: GoogleAnalyticsEvent{}

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
    signal doubleClicked(variant mouse);

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
        visible: behavior.enabled

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
        onDoubleClicked: behavior.doubleClicked(mouse);

        onClicked: {
            if (behavior.enabled) {
                var analytics = behavior.analytics;
                if (analytics && analytics.isValid()) {
                    Ga.trackEvent(analytics.category, analytics.action, analytics.label, analytics.value);
                }
                behavior.clicked(mouse);
            }
        }
    }
}
