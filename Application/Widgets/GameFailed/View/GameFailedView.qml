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
import Application.Controls 1.0
import GameNet.Controls 1.0

import "../../../Core/App.js" as App

PopupBase {
    id: root

    property variant currentItem: App.serviceItemByServiceId(model.lastStoppedServiceId);

    title: qsTr("GAME_FAILED_TITLE")
    clip: true

    Item {
        id: body

        anchors {
            left: parent.left
            right: parent.right
        }
        height: childrenRect.height

        Row {
            spacing: 20
            anchors {
                left: parent.left
                right: parent.right
            }

            Image {
                id: gameFailedImage

                source: installPath + "Assets/Images/Application/Widgets/GameFailed/gameFailed.png"
            }

            Column {
                width: parent.width - parent.spacing - gameFailedImage.width
                spacing: 20

                Text {
                    width: parent.width
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
                    width: parent.width
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

    Row {
        spacing: 10

        PrimaryButton {
            text: qsTr("GAME_FAILED_BUTTON_SUPPORT")
            onClicked: {
                App.openExternalUrl("https://support.gamenet.ru/kb");
                Marketing.send(Marketing.ProblemAfterGameStart, root.currentItem.serviceId, { action: "support" } );
                root.close();
            }
        }

        MinorButton {
            text: qsTr("GAME_FAILED_BUTTON_CLOSE")
            onClicked: {
                Marketing.send(Marketing.ProblemAfterGameStart, root.currentItem.serviceId, { action: "close" } );
                root.close();
            }
        }
    }
}
