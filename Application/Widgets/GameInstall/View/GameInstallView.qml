/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1

import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import "../../../Core/App.js" as App

WidgetView {
    id: root

    property variant currentGameItem: App.currentGame()
    property alias createDesktopShortcut: desktopShortcut.checked
    property alias createStartMenuShortcut: startMenuShortcut.checked

    width: parent.width
    height: parent.height
    clip: true

    Rectangle {
        anchors.fill: parent
        color: "#F0F5F8"
    }

    Column {
        y: 20
        spacing: 20

        Text {
            anchors {
                left: parent.left
                leftMargin: 20
            }
            font {
                family: 'Arial'
                pixelSize: 20
            }
            color: '#343537'
            smooth: true
            text: qsTr("INSTALL_VIEW_TITLE").arg(currentGameItem.name)
        }

        HorizontalSplit {
            width: root.width

            style: SplitterStyleColors {
                main: "#ECECEC"
                shadow: "#FFFFFF"
            }
        }

        Item {
            width: 500
            height: 68
            anchors {
                left: parent.left
                leftMargin: 20
            }

            Text {
                width: parent.width
                height: 16
                font {
                    family: 'Arial'
                    pixelSize: 16
                }
                color: '#5c6d7d'
                smooth: true
                text: qsTr("DESTINATION_FOLDER_CAPTION")
            }

            PathInput {
                id: installationPath

                y: 22
                width: root.width - 40
                height: 48
                path: App.getExpectedInstallPath(currentGameItem.serviceId);
                readOnly: true
                onBrowseClicked: {
                    var result = App.browseDirectory(currentGameItem.serviceId,
                                                                   currentGameItem.name,
                                                                   installationPath.path);
                    if (result) {
                        installationPath.path = result;
                    }
                }
            }
        }

        CheckBox {
            id: desktopShortcut

            width: 300
            anchors {
                left: parent.left
                leftMargin: 20
            }
            fontSize: 15
            checked: true
            text: qsTr("CREATE_DESKTOP_SHORTCUT")
            style: ButtonStyleColors {
                normal: "#1ABC9C"
                hover: "#019074"
            }
        }

        CheckBox {
            id: startMenuShortcut

            width: 300
            anchors {
                left: parent.left
                leftMargin: 20
            }
            fontSize: 15
            checked: true
            text: qsTr("CREATE_STARTMENU_SHORTCUT")
            style: ButtonStyleColors {
                normal: "#1ABC9C"
                hover: "#019074"
            }
        }

        Item {
            width: root.width
            height: 20

            Text {
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: 20
                    bottom: parent.bottom
                }
                text: qsTr("LICENSE_TIP")
                font {
                    family: 'Arial'
                    pixelSize: 12
                }
                color: '#5c6d7d'
                onLinkActivated: App.openExternalUrl(currentGameItem.licenseUrl)
            }
        }

        HorizontalSplit {
            width: root.width
            style: SplitterStyleColors {
                main: "#ECECEC"
                shadow: "#FFFFFF"
            }
        }

        Button {
            width: 200
            height: 48
            anchors {
                left: parent.left
                leftMargin: 20
            }
            text: qsTr("INSTALL_BUTTON_CAPTION")
            onClicked: App.installService(currentGameItem.serviceId, {
                                                createDesktopShortCut: desktopShortcut.checked,
                                                createStartMenuShortCut: startMenuShortcut.checked
                                            });
        }
    }
}
