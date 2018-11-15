import QtQuick 2.4
import Tulip 1.0

import ProtocolOne.Controls 1.0
import Application.Controls 1.0

import Application.Core 1.0

Item {
    id: root

    property variant currentItem
    property variant gameSettingsModelInstance: App.gameSettingsModelInstance() || {}

    function save() {
        root.gameSettingsModelInstance.setOverlayEnabled(root.currentItem.serviceId, enableOverlay.checked);
    }

    function load() {
        enableOverlay.checked = enableOverlay.isOverlayEnabled();
    }

    Column {
        anchors {
            fill: parent
            leftMargin: 30
        }
        spacing: 20

        CheckBox {
            id: enableOverlay

            function isOverlayEnabled() {
                if (!root.currentItem || !root.currentItem.hasOverlay) {
                    return false;
                }

                return root.gameSettingsModelInstance.isOverlayEnabled(root.currentItem.serviceId);
            }

            text: qsTr("USE_OVERLAY")
            checked: enableOverlay.isOverlayEnabled();
        }
    }
}
