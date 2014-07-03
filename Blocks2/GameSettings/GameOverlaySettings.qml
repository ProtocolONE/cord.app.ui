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
import Tulip 1.0
import GameNet.Controls 1.0

import "../../Core/App.js" as App

Item {
    id: root

    property variant currentItem: App.currentGame()

    function save() {
        Settings.setValue('gameExecutor/serviceInfo/' + root.currentItem.serviceId + "/",
                                                  'overlayEnabled',
                                                  enableOverlay.checked ? 1 : 0);
    }

    Column {
        x: 30
        spacing: 20

        CheckBox {
            id: enableOverlay

            function isOverlayEnabled() {
                if (!root.currentItem || !root.currentItem.hasOverlay) {
                    return false;
                }

                var overlayEnabled = Settings.value(
                            'gameExecutor/serviceInfo/' + root.currentItem.serviceId + "/",
                            "overlayEnabled",
                            1) != 0;

                return !!overlayEnabled;
            }

            text: qsTr("USE_OVERLAY")
            style: ButtonStyleColors {
                normal: "#1ABC9C"
                hover: "#019074"
            }
            checked: enableOverlay.isOverlayEnabled();
        }
    }
}
