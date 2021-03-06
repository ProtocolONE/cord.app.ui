import QtQuick 2.4
import QtQuick.Window 2.2

import Tulip 1.0

import ProtocolOne.Core 1.0
import ProtocolOne.Components.Widgets 1.0
import ProtocolOne.Controls 1.0

import Application.Controls 1.0
import Application.Core 1.0
import Application.Core.Styles 1.0
import Application.Core.MessageBox 1.0
import Application.Core.Popup 1.0
import Application.Core.Config 1.0

WidgetModel {
    id: root

    property string defaultTrayIcon: "Assets/Images/Application/Widgets/TrayMenu/tray.ico"
    property bool isFullMenu: User.isAuthorized()

    signal activate()

    function menuClick(name) {
        switch(name) {
        case 'Profile':
            var userId = !!!User.getTechName()
                    ? User.userId()
                    : User.getTechName();

            App.openProfile(userId);

            Ga.trackEvent('Tray', 'outer link', 'Profile');
            break;
        case 'Balance':
            App.openExternalUrlWithAuth(Config.site("/pay/"))

            Ga.trackEvent('Tray', 'outer link', 'Money');
            break;
        case 'Settings':
            App.activateWindow();
            Popup.show('ApplicationSettings');

            Ga.trackEvent('Tray', 'click', 'ApplicationSettings');
            break;
        case 'Quit':
            var services = Object.keys(App.getRunningServices()).filter(function(e) {
                var obj = App.serviceItemByServiceId(e);
                return obj.gameType != 'browser';
            }), firstGame;

            if (!services || services.length === 0) {
                quitTrigger();
                break;
            }

            firstGame = App.serviceItemByServiceId(services[0]);

            MessageBox.show(qsTr("CLOSE_APP_TOOLTIP_MESSAGE"),
                            qsTr("CLOSE_APP_TOOLTIP_MESSAGE_DESC").arg(firstGame.name),
                            MessageBox.button.ok | MessageBox.button.cancel, function(result) {
                                if (result != MessageBox.button.ok) {
                                    return;
                                }

                                quitTrigger();
                            });
            break;
        }
    }

    function quitTrigger() {
        Ga.trackEvent('Tray', 'click', 'Quit');
        SignalBus.exitApplication();
    }

    function setTrayIcon(source) {
        if (source !== "") {
            TrayWindow.setIcon(preparePath(source));
            return;
        }

        TrayWindow.setIcon(preparePath(root.defaultTrayIcon));
    }

    function setAnimatedTrayIcon(source) {
        if (source !== "") {
            TrayWindow.animatedSource = preparePath(source);
            return;
        }

        TrayWindow.setIcon(preparePath(root.defaultTrayIcon));
    }

    function preparePath(path) {
        var iconPath = installPath + path;
        return iconPath.replace('file:///', '');
    }

    function hideTrayIcon() {
        TrayWindow.hide();
    }

    Connections {
        target: SignalBus

        onSetTrayIcon: {
            root.setTrayIcon(source);
        }

        onSetAnimatedTrayIcon: {
            root.setAnimatedTrayIcon(source);
        }

        onBeforeCloseUI: {
            root.hideTrayIcon();
        }
    }

    Component.onCompleted: {
        TrayWindow.setIcon(preparePath(root.defaultTrayIcon));
        TrayWindow.setToolTip(qsTr('TRAY_TOOLTIP'));
        TrayWindow.activate.connect(window.activateWindow);
        TrayWindow.activateWindow.connect(window.moveToTray);
    }

    Window {
        id: window

        property int _mouseX
        property int _mouseY

        function activateWindow() {
            SignalBus.trayIconClicked();
            App.activateWindow();
        }

        function moveToTray(mouseX, mouseY) {
            var space = 10
            , screenGeometry = Desktop.screenGeometry(Desktop.screenNumber(mouseX, mouseY))
            , xLimit = screenGeometry.x + screenGeometry.width
            , yLimit = screenGeometry.y + screenGeometry.height;

            window._mouseX = mouseX;
            window._mouseY = mouseY;

            window.x = (mouseX + window.width > xLimit) ? (xLimit - window.width - space) : mouseX
            window.y = (mouseY + window.height > yLimit) ? (yLimit - window.height - space) : mouseY

            window.visible = true;
        }

        function hide() {
            window.visible = false;
        }

        flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint | Qt.Popup

        width: 180
        height: 34 + (28 + menuView.spacing) * (isFullMenu ? menuView.count : 1)
        onHeightChanged: {
            if (!visible) {
                return;
            }

            moveToTray(_mouseX, _mouseY);
        }

        onActiveChanged: {
            if (!active) {
                hide();
            }

        }

        visible: false

        color: "#00000000"

        Rectangle {
            height: parent.height - 2

            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                margins: 1
            }

            opacity: Styles.darkBackgroundOpacity
            color: Styles.contentBackground

            Rectangle {
                id: menuHeader

                width: parent.width
                height: 32
                color: Styles.trayMenuHeaderBackground

                Image {
                    anchors {
                        left: parent.left
                        leftMargin: 14
                        verticalCenter: parent.verticalCenter
                    }

                    source: installPath + "Assets/Images/Application/Widgets/TrayMenu/trayLogo.png"
                }
            }

            ListView {
                id: menuView

                function fullMenuAvailable(name) {
                    return (root.isFullMenu || name == 'Quit') ? true : false
                }

                y: 33
                width: parent.width
                height: parent.height - 32

                interactive: false
                spacing: isFullMenu ? 1 : 0

                delegate: Item {
                    property bool isCurrent: mouseArea.containsMouse

                    width: menuView.width
                    height: menuView.fullMenuAvailable(name) ? 28 : 0
                    visible: menuView.fullMenuAvailable(name)

                    ContentBackground {
                        anchors.fill: parent
                        visible: isCurrent
                    }

                    Row {
                        anchors { verticalCenter: parent.verticalCenter }

                        Item {
                            height: 28
                            width: 44

                            Image {
                                function getIconPath() {
                                    if (!icon) {
                                        return "";
                                    }

                                    if (isCurrent) {
                                        return installPath + 'Assets/Images/Application/Widgets/TrayMenu/' + iconActive;
                                    }

                                    return installPath + 'Assets/Images/Application/Widgets/TrayMenu/' + icon;
                                }

                                anchors.centerIn: parent
                                source: getIconPath();
                                visible: !!icon
                            }
                        }

                        Text {
                            anchors { verticalCenter: parent.verticalCenter }
                            font { family: "Arial"; bold: true; pixelSize: 13 }
                            color: Styles.menuText
                            text: qsTr(label)
                        }

                        Item {
                            height: 28
                            width: 30

                            Image {
                                anchors.centerIn: parent
                                source: installPath + Styles.linkIconTray
                                visible: iconLink
                            }
                        }
                    }

                    MouseArea {
                        id: mouseArea

                        hoverEnabled: true
                        anchors { fill: parent }
                        onClicked: {
                            window.hide();
                            root.menuClick(name);
                        }
                    }
                }

                model: ListModel {
                    ListElement {
                        name: 'Profile'
                        icon: 'profile.png'
                        iconActive: 'profileActive.png'
                        iconLink: true
                        label: QT_TR_NOOP("MENU_ITEM_PROFILE")
                    }

                    ListElement {
                        name: 'Balance'
                        icon: 'balance.png'
                        iconActive: 'balanceActive.png'
                        iconLink: true
                        label: QT_TR_NOOP("MENU_ITEM_MONEY")
                    }

                    ListElement {
                        name: 'Settings'
                        icon: 'settings.png'
                        iconActive: 'settingsActive.png'
                        label: QT_TR_NOOP("MENU_ITEM_SETTINGS")
                    }

                    ListElement {
                        name: 'Quit'
                        icon: 'quit.png'
                        iconActive: 'quitActive.png'
                        label: QT_TR_NOOP("MENU_ITEM_QUIT")
                    }
                }
            }
        }

        Rectangle {
            color: "#00000000"
            border {
                color: Styles.trayMenuBorder
                width: 1
            }

            width: parent.width
            anchors.fill: parent
        }
    }
}
