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

import "../../../Application/Core/App.js" as App

Item {
    id: root

    property bool isFullMenu: true

    signal menuClick(string name)
    signal activate()

    onMenuClick: window.hide();

    Component.onCompleted: {
        console.log("TrayMenu::onCompleted()");

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
                            onClicked: root.menuClick(name);
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
