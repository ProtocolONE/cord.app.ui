import QtQuick 2.4
import Dev 1.0
import Tulip 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import Application.Blocks 1.0
import Application 1.0
import Application.Core 1.0
import Application.Core.Popup 1.0
import Application.Core.Styles 1.0


Rectangle {
    width: 1000
    height: 600
    color: '#AAAAAA'

    Component.onCompleted: {
        Styles.init();
        Styles.setCurrentStyle('mainStyle');
        Popup.init(popupLayer);
    }

    RequestServices {
        id: services

        onReady: {

            WidgetManager.registerWidget('Application.Widgets.GuestConfirm');
            WidgetManager.init();
            //manager.show();

        }
    }


    Row {
        anchors {
            left: parent.left
            top: parent.top
            margins: 10
        }

        spacing: 10

        Button {
            text: "Confirm"

            onClicked: {
                App.mainWindowInstance().authGuestConfirmRequest("300003010000000000");
            }
        }
    }

    Item {
        id: popupLayer

        anchors.fill: parent
    }
}
