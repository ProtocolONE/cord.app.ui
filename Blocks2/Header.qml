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

import "../Controls" as Controls
import "Header"
Rectangle {
    implicitWidth: 1000
    implicitHeight: 42
    color: "#092135"

    Item {
        anchors { fill: parent; bottomMargin: 2 }

        Row {
            anchors.fill: parent

            Item {
                height: parent.height
                width: 178

                Image {
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: 10
                    }

                    source: installPath + "images/Blocks2/Header/GamenetLogo.png"
                }
            }

            Controls.VerticalSplit {
                height: parent.height
            }

            ListView {
                height: parent.height
                width: parent.width - 180

                orientation: ListView.Horizontal
                interactive: false
                model: ListModel {
                    ListElement {
                        icon: "images/Blocks2/Header/MyGames.png"
                        text: QT_TR_NOOP("HEADER_BUTTON_MY_GAMES")
                        action: "mygame"
                    }

                    ListElement {
                        icon: "images/Blocks2/Header/AllGames.png"
                        text: QT_TR_NOOP("HEADER_BUTTON_ALL_GAMES")
                        action: "allgame"
                    }

                    ListElement {
                        icon: "images/Blocks2/Header/Support.png"
                        text: QT_TR_NOOP("HEADER_BUTTON_SUPPORT")
                        action: "support"
                    }
                }

                delegate: Item {
                    height: parent.height
                    width: headerButton.width + 2

                    Row {
                        anchors.fill: parent

                        HeaderButton {
                            id: headerButton

                            icon: installPath + model.icon
                            text: qsTr(model.text)
                            onClicked: console.log("Header clicked ", model.action)
                        }

                        Controls.VerticalSplit {
                            height: parent.height
                        }
                    }
                }
            }
        }

        Item {
            width: 140
            height: parent.height
            anchors { right: parent.right; rightMargin: 10 }

            Row {
                anchors.fill: parent
                layoutDirection: Qt.RightToLeft

                HeaderControlButton {
                    width: 26
                    height: parent.height
                    source: installPath + "images/Blocks2/Header/Close.png"
                    anchors.verticalCenter: parent.verticalCenter
                }

                HeaderControlButton {
                    width: 26
                    height: parent.height
                    source: installPath + "images/Blocks2/Header/Settings.png"
                    anchors.verticalCenter: parent.verticalCenter
                }

                Item {
                    width: 10
                    height: 1
                }

                HeaderControlButton {
                    width: 26
                    height: parent.height
                    source: installPath + "images/Blocks2/Header/Logout.png"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }

    Controls.HorizontalSplit {
        anchors.bottom: parent.bottom
        width: parent.width
    }
}
