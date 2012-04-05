import QtQuick 1.1
import Tulip 1.0

import "../Elements" as Elements
import "../Blocks" as Blocks
import "../js/support.js" as Support

Blocks.MoveUpPage {
    id: page

    property variant currentItem;

    signal openUrl(string url);

    openHeight: 400

    Item {
        width: parent.width
        height: 400

        Image {
            source: installPath  + "images/backImage.png"
            anchors.centerIn: parent
        }

        Text {
            anchors { top: parent.top; topMargin: 26; left: parent.left; leftMargin: 42 }
            text: qsTr("GAME_FAILED_TITLE")
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
                source: installPath + "images/gameFailIcon.png"
            }
        }

        Item {
            anchors { top: parent.top; left: parent.left; right: parent.right }
            anchors { leftMargin: 274; rightMargin: 60; topMargin: 118 }

            Column {
                anchors.fill: parent

                Text {
                    width: parent.width
                    text: qsTr("GAME_FAILED_HELP_TEXT1").arg(page.currentItem ? page.currentItem.name : '')
                    wrapMode: Text.WordWrap
                    color: "#ffffff"
                    font.pixelSize: 14
                    lineHeight: 1.3
                }

                Item {
                    width: 1
                    height: 24
                }

                Text {
                    width: parent.width
                    text: qsTr("GAME_FAILED_HELP_TEXT2")
                    wrapMode: Text.WordWrap
                    color: "#ffffff"
                    font { pixelSize: 14; bold: true }
                }

                Item {
                    width: 1
                    height: 14
                }

                Row {
                    width: parent.width
                    height: childrenRect.height
                    spacing: 10

                    Elements.Button2 {
                        buttonText: qsTr("GAME_FAILED_BUTTON_SUPPORT")
                        onClicked: {
                            Support.show(page, page.currentItem.name);
                            page.closeMoveUpPage();
                            Marketing.send(Marketing.ProblemAfterGameStart, page.currentItem.serviceId, { action: "support" } );
                        }
                    }

                    Elements.Button2 {
                        buttonText: qsTr("GAME_FAILED_BUTTON_CLOSE")
                        onClicked: {
                            page.closeMoveUpPage()
                            Marketing.send(Marketing.ProblemAfterGameStart, page.currentItem.serviceId, { action: "close" } );
                        }
                    }
                }
            }
        }
    }
}
