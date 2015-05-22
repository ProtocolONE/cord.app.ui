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

import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import "../../Core/App.js" as App
import "../../Core/Styles.js" as Styles
import "../../Core/User.js" as User
import "../../Core/MessageBox.js" as MessageBox
import "../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics

WidgetModel {
    id: root

    property string defaultTrayIcon: "Assets/Images/Application/Widgets/TrayMenu/tray.ico"
    property bool isFullMenu: User.isAuthorized()

    signal activate()

    function menuClick(name) {
        switch(name) {
        case 'Profile': {
            GoogleAnalytics.trackEvent('/Tray', 'Open External Link', 'User Profile');

            var userId = User.getTechName() == undefined ? User.userId() : User.getTechName();

            App.openProfile(userId);
            break;
        }
        case 'Balance': {
            GoogleAnalytics.trackEvent('/Tray', 'Open External Link', 'Money');

            App.openExternalUrlWithAuth("https://gamenet.ru/money/")
            break;
        }
        case 'Settings': {
            GoogleAnalytics.trackEvent('/Tray', 'Navigation', 'Switch To Settings');
            App.activateWindow();
            App.navigate('ApplicationSettings');
        }
        break;
        case 'Quit': {
            var services = Object.keys(App.runningService).filter(function(e) {
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
                            MessageBox.button.Ok | MessageBox.button.Cancel, function(result) {
                                if (result != MessageBox.button.Ok) {
                                    return;
                                }

                                quitTrigger();
                            });
            break;
        }
        }
    }

    function quitTrigger() {
        GoogleAnalytics.trackEvent('/Tray', 'Application', 'Quit');
        App.exitApplication();
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
        target: App.signalBus()

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
            window.activate();
        }

        function hide() {
            window.visible = false;
        }

        deleteOnClose: false
        flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint | Qt.Popup

        width: 180
        //  HACK: минимальная высота окна должна быть >= 69
        height: isFullMenu ? 34 + (28 + menuView.spacing) * 4 : 69

        onHeightChanged: {
            if (!visible) {
                return;
            }

            moveToTray(_mouseX, _mouseY);
        }

        visible: false
        topMost: true

        Border {
            y: isFullMenu ? 0 : 6
            borderColor: Styles.style.trayMenuBorder
            width: window.width
            //  HACK: минимальная высота окна должна быть >= 69
            //      из-за этого делаем сдвиг
            height: isFullMenu ? window.height : 63

            Rectangle {
                width: parent.width
                height: parent.height
                opacity: Styles.style.darkBackgroundOpacity
                color: Styles.style.contentBackgroundLight

                Rectangle {
                    id: menuHeader

                    width: parent.width
                    height: 32
                    color: Styles.style.menuHeaderBackground

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

                        Rectangle {
                            anchors.fill: parent
                            opacity: Styles.style.baseBackgroundOpacity
                            color: Styles.style.applicationBackground
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
                                color: Styles.style.menuText
                                text: qsTr(label)
                            }
                        }
                        MouseArea {
                            id: mouseArea

                            hoverEnabled: true
                            anchors { fill: parent }
                            onClicked: {
                                root.menuClick(name);
                                window.hide();
                            }
                        }
                    }

                    model: ListModel {
                        ListElement {
                            name: 'Profile'
                            icon: 'profile.png'
                            iconActive: 'profileActive.png'
                            label: QT_TR_NOOP("MENU_ITEM_PROFILE")
                        }

                        ListElement {
                            name: 'Balance'
                            icon: 'balance.png'
                            iconActive: 'balanceActive.png'
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
        }
    }
}
