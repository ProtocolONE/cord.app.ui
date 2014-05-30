import QtQuick 1.1
import Tulip 1.0

import "../Elements" as Elements
import "../Blocks/GameSwitch"
import "../Blocks" as Blocks

import "../js/Core.js" as Core

Blocks.MoveUpPage {
    id: page

    property variant currentItem: Core.currentGame();

    signal launchGame(string serviceId);

    function setupButton(button, serviceId) {
        var item = Core.serviceItemByServiceId(serviceId);
        button.source = installPath + item.imageHorizontalSmall;
        button.name = item.name;
        button.serviceId = item.serviceId ;
    }

    openHeight: 550
    onCurrentItemChanged: {
        if (!!page.currentItem) {
            page.setupButton(button1, page.currentItem.maintenanceProposal1);
            page.setupButton(button2, page.currentItem.maintenanceProposal2);
        }
    }

    Item {
        width: parent.width
        height: 550

        Image {
            source: installPath  + "Assets/Images/backImage.png"
            anchors.centerIn: parent
        }

        Text {
            anchors { top: parent.top; topMargin: 26; left: parent.left; leftMargin: 42 }
            text: qsTr("GAME_BORING_TITLE")
            font.family: "Segoe UI Light"
            color: "#ffffff"
            font.pixelSize: 42
        }

        Item {
            width: 232
            height: 230
            anchors { top: parent.top; topMargin: 118; left: parent.left; leftMargin: 42 }

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                source: installPath + "Assets/Images/gameIsBoringIcon.png"
            }
        }

        Item {
            anchors { top: parent.top; left: parent.left; right: parent.right }
            anchors { leftMargin: 274; rightMargin: 60; topMargin: 118 }

            Column {
                anchors.fill: parent
                spacing: 10

                Text {
                    width: parent.width
                    text: qsTr("GAME_BORING_HELP_TEXT1").arg(!!currentItem ? currentItem.name : "")
                    wrapMode: Text.WordWrap
                    color: "#ffffff"
                    textFormat: Text.StyledText
                    font.pixelSize: 14
                    lineHeight: 1.3
                }

                Row {
                    spacing: 10

                    ImageButton {
                        id: button1

                        onClicked: {
                            page.closeMoveUpPage();
                            page.launchGame(serviceId);
                            Marketing.send(Marketing.NotLikeTheGame, page.currentItem.serviceId, { serviceId: serviceId });
                        }
                    }

                    ImageButton {
                        id: button2

                        onClicked: {
                            page.closeMoveUpPage();
                            page.launchGame(serviceId);
                            Marketing.send(Marketing.NotLikeTheGame, page.currentItem.serviceId, { serviceId: serviceId });
                        }
                    }
                }
                Text {
                    width: parent.width
                    text: qsTr("GAME_BORING_HELP_TEXT2")
                    wrapMode: Text.WordWrap
                    color: "#ffffff"
                    font { pixelSize: 14; bold: true }
                }

                Item {
                    width: 1
                    height: 14
                }

                Elements.Button2 {
                    buttonText: qsTr("GAME_FAILED_BUTTON_CLOSE")
                    onClicked: {
                        page.closeMoveUpPage()
                        Marketing.send(Marketing.NotLikeTheGame, page.currentItem.serviceId, { serviceId: 0 });
                    }
                }

            }
        }
    }
}
