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

import "../../Core/App.js" as App
import "../../Core/User.js" as User
import "../../Core/MessageBox.js" as MessageBox
import "../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics

//  UNDONE: на момент 04.07.2014 не ясно как прятать ненужные пункты меню в трее если приложение
//  находится в состояни Loading, Authorization
//  Возможные варианты решения - ввести в App.js методы позволяющие получить текущее глобальное состояние
//  приложения, по типу getGlobalState()

Item {
    id: root

    property bool isFullMenu: true

    signal activate()

    //  INFO: обязательно обернуть вызов в функцию, если написать прям внутри обработчика Connections,
    //  то получим ошибку 'Result of expression 'TrayWindow.hide' [undefined] is not a function.'
    function hideTrayIcon() {
        TrayWindow.hide();
    }

    function menuClick(name) {
        switch(name) {
            case 'Profile': {
                GoogleAnalytics.trackEvent('/Tray', 'Open External Link', 'User Profile');

                var userId = User.getTechName() == undefined ? User.userId() : User.getTechName();

                App.openExternalUrlWithAuth("http://www.gamenet.ru/users/" + userId);
                break;
            }
            case 'Balance': {
                GoogleAnalytics.trackEvent('/Tray', 'Open External Link', 'Money');

                App.openExternalUrlWithAuth("http://www.gamenet.ru/money")
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

    Connections {
        target: App.signalBus()
        onExitApplication: root.hideTrayIcon();
    }

    Component.onCompleted: {
        var iconPath = installPath + 'Assets/Images/Application/Widgets/TrayMenu/tray.ico';
        iconPath = iconPath.replace('file:///', '');

        TrayWindow.install(iconPath);
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

        width: 205
        height: isFullMenu ? 128 : (22 + menuView.spacing) * 3

        onHeightChanged: {
            if (!visible) {
                return;
            }

            moveToTray(_mouseX, _mouseY);
        }

        visible: false
        topMost: true

        Rectangle {
            width:  window.width - 1
            height: window.height - 1

            color: '#06335a'

            border { width: 1; color: '#3276c3' }

            Column {
                anchors { fill: parent; margins: 1 }
                spacing: 1

                Rectangle {
                    width: parent.width
                    height: 28
                    color: '#04243f'

                    Text {
                        anchors { left: parent.left; top: parent.top }
                        anchors { leftMargin: 14; topMargin: 3 }
                        text: 'GameNet'
                        font { family: 'Segue UI'; pixelSize: 18 }
                        color: '#ececec'
                    }
                }

                ListView {
                    id: menuView

                    function fullMenuAvailable(name) {
                        return (isFullMenu || name == 'Quit') ? true : false
                    }

                    width: parent.width
                    height: parent.height - 28
                    interactive: false

                    spacing: 2

                    delegate: Rectangle {

                        width: menuView.width
                        height: menuView.fullMenuAvailable(name) ? 22 : 0
                        color: '#00000000'
                        visible: menuView.fullMenuAvailable(name)

                        Image {
                            source: installPath + 'Assets/Images/Application/Widgets/TrayMenu/hover.png'
                            visible: mouseArea.containsMouse
                        }

                        Image {
                            anchors { verticalCenter: parent.verticalCenter }
                            x: 5

                            source: icon ? installPath + 'Assets/Images/Application/Widgets/TrayMenu/' + icon : ''
                            visible: !!icon
                        }

                        Text {
                            anchors { verticalCenter: parent.verticalCenter }
                            x: 30
                            font { family: 'Segue UI'; pixelSize: 18 }
                            color: '#ececec'
                            text: qsTr(label)
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
                            label: QT_TR_NOOP("MENU_ITEM_PROFILE")
                        }

                        ListElement {
                            name: 'Balance'
                            icon: 'balance.png'
                            label: QT_TR_NOOP("MENU_ITEM_MONEY")
                        }

                        ListElement {
                            name: 'Settings'
                            icon: 'settings.png'
                            label: QT_TR_NOOP("MENU_ITEM_SETTINGS")
                        }

                        ListElement {
                            name: 'Quit'
                            icon: ''
                            label: QT_TR_NOOP("MENU_ITEM_QUIT")
                        }
                    }
                }
            }
        }
    }
}
