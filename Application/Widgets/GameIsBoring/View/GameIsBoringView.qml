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

    function setupButton(button, serviceId) {
        button.gameItem = App.serviceItemByServiceId(serviceId);
    }

    onCurrentItemChanged: {
        if (!root.currentItem) {
            return;
        }

        root.setupButton(button1, root.currentItem.maintenanceProposal1);
        root.setupButton(button2, root.currentItem.maintenanceProposal2);
    }

    width: 670
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
            text: qsTr("GAME_BORING_TITLE")
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
                    source: installPath + "Assets/Images/Application/Widgets/GameIsBoring/gameIsBoring.png"
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
                        text: qsTr("GAME_BORING_TIP").arg(root.currentItem ? root.currentItem.name : '')
                    }

                    Row {
                        spacing: 20

                        GameIsBoringButton {
                            id: button1
                            width: 187
                            height: 93
                            onClicked: {
                                root.close();
                            }
                        }

                        GameIsBoringButton {
                            id: button2
                            width: 187
                            height: 93
                            onClicked: {
                                root.close();
                            }
                        }
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
                        text: qsTr("GAME_BORING_TIP_2")
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

        Button {
            id: activateButton

            width: 200
            height: 48
            anchors {
                left: parent.left
                leftMargin: 20
            }
            text: qsTr("GAME_FAILED_BUTTON_CLOSE")
            onClicked: {
                root.close();
                Marketing.send(Marketing.NotLikeTheGame, root.currentItem.serviceId, { serviceId: 0 });
            }
        }
    }
}
