import QtQuick 2.4
import Dev 1.0
import Tulip 1.0
import ProtocolOne.Components.Widgets 1.0
import ProtocolOne.Controls 1.0

import Application.Blocks 1.0
import Application 1.0
import Application.Core 1.0
import Application.Core.Popup 1.0
import Application.Core.Styles 1.0

Rectangle {
    id: root

    width: 1000
    height: 600
    color: '#AAAAAA'

    Component.onCompleted: {
        Styles.init();
        Styles.setCurrentStyle('greenStyle');
        WidgetManager.registerWidget('Application.Widgets.SecondAccountAuth');
        WidgetManager.registerWidget('Application.Widgets.PremiumShop');
        WidgetManager.init();
    }

    Connections {
        target: SignalBus

        onSecondAuthDone: {
            console.log('--- Second auth done ', userId, appKey, cookie)
        }
    }

    Bootstrap {
        anchors.fill: parent
    }

    Component {
        id: baseAuthComp

        AuthIndex {
            id: baseAuth

            anchors.fill: parent;
        }
    }

    Component {
        id: emptyComp

        Item {
            anchors.fill: parent;
        }
    }

    Timer {
        interval: 100
        repeat: false
        running: true
        onTriggered: swicher.sourceComponent = baseAuthComp;
    }

    PageSwitcher {
        id: swicher

        anchors.fill: parent
    }

    Connections {
        target: SignalBus

        onAuthDone: {
            swicher.sourceComponent = emptyComp;
        }

        onLogoutDone: {
            swicher.sourceComponent = baseAuthComp;
        }
    }


    Item {
        anchors.fill: parent
        anchors.margins: 10
        anchors.leftMargin: 5

        Column {
            anchors.fill: parent
            spacing: 0

            Item {
                width: 250
                height: 250

                Column {
                    anchors.fill: parent
                    spacing: 10


                    Button {
                        visible: User.isAuthorized()
                        width: 150
                        height: 30
                        text: "Buy premium"

                        onClicked: Popup.show('PremiumShop', 'PremiumShopView')
                    }

                    Button {
                        visible: User.isAuthorized()
                        width: 150
                        height: 30
                        text: "Logout Base " + User.getNickname();

                        onClicked: SignalBus.logoutRequest();
                    }

                    Button {
                        visible: User.isSecondAuthorized()
                        width: 250
                        height: 30
                        text: "Logout Second " + User.getSecondNickname();

                        onClicked: SignalBus.logoutSecondRequest();
                    }

                    Button {
                        width: 150
                        height: 30
                        text: "Open Second Auth"
                        visible: User.isAuthorized() && User.isPremium() && !User.isSecondAuthorized()

                        onClicked: Popup.show('SecondAccountAuth', 'SecondAccountAuthView')
                    }
                }
            }

            Rectangle {
                width: container.width
                height: container .height
                color: "#082135"

                WidgetContainer {
                    id: container
                    visible: User.isAuthorized() && User.isPremium()

                    widget: "SecondAccountAuth"
                    view: "SecondAccountView"
                }
            }
        }
    }
}
