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
import Tulip 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import "../../../Core/App.js" as App

WidgetView {
    id: root

    property variant currentItem: App.currentGame();

    width: 630
    height: allContent.height + 40
    clip: true

    Rectangle {
        anchors.fill: parent
        color: "#F0F5F8"
    }

    Column {
        id: allContent

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
            text: qsTr("GAME_FAILED_TITLE")
        }

        HorizontalSplit {
            width: root.width

            style: SplitterStyleColors {
                main: "#ECECEC"
                shadow: "#FFFFFF"
            }
        }

        Item {
            id: body

            anchors {
                left: parent.left
                leftMargin: 20
                right: parent.right
                rightMargin: 20
            }
            width: root.width - 40
            height: childrenRect.height

            Row {
                spacing: 20

                Image {
                    source: installPath + "Assets/Images/Application/Widgets/GameFailed/gameFailed.png"
                }

                Column {
                    spacing: 20

                    Text {
                        width: 400
                        font {
                            family: 'Arial'
                            pixelSize: 14
                        }
                        color: '#343537'
                        smooth: true
                        wrapMode: Text.WordWrap
                        text: qsTr("GAME_FAILED_TIP").arg(root.currentItem ? root.currentItem.name : '')
                    }

                    Text {
                        width: 400
                        font {
                            family: 'Arial'
                            pixelSize: 14
                        }
                        color: '#343537'
                        smooth: true
                        wrapMode: Text.WordWrap
                        text: qsTr("GAME_FAILED_DESCRIPTION")
                    }
                }
            }
        }

        HorizontalSplit {
            width: root.width
            style: SplitterStyleColors {
                main: "#ECECEC"
                shadow: "#FFFFFF"
            }
        }

        Row {
            spacing: 20
            anchors {
                left: parent.left
                leftMargin: 20
            }

            Button {
                id: needSupportButton

                width: 300
                height: 48

                text: qsTr("GAME_FAILED_BUTTON_SUPPORT")
                onClicked: {
                    App.openExternalUrl("http://support.gamenet.ru");
                    Marketing.send(Marketing.ProblemAfterGameStart, root.currentItem.serviceId, { action: "support" } );
                    root.close();
                }
            }

            Button {
                id: cancelButton

                width: 200
                height: 48

                text: qsTr("GAME_FAILED_BUTTON_CLOSE")
                onClicked: {
                    Marketing.send(Marketing.ProblemAfterGameStart, root.currentItem.serviceId, { action: "close" } );
                    root.close();
                }
            }
        }
    }
}
