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
import Application.Blocks.Popup 1.0
import GameNet.Controls 1.0

import "../../../Core/App.js" as App

PopupBase {
    id: root

    property variant currentItem: App.currentGame();

    title: qsTr("GAME_FAILED_TITLE")
    clip: true

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
                    color: defaultTextColor
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
                    color: defaultTextColor
                    smooth: true
                    wrapMode: Text.WordWrap
                    text: qsTr("GAME_FAILED_DESCRIPTION")
                }
            }
        }
    }

    PopupHorizontalSplit {
        width: root.width
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
                App.openExternalUrl("https://support.gamenet.ru/kb");
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
