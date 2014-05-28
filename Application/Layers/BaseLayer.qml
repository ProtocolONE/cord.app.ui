import QtQuick 1.1
import GameNet.Controls 1.0 as Controls
import Application.Blocks.Header 1.0
import Application.Blocks.GameMenu 1.0

import "../../js/Core.js" as Core

Item {
    Header {
        width: parent.width
        height: 42
    }

    Item {
        anchors.fill: parent
        anchors.topMargin: 42

        Rectangle { // left
            width: 178
            height: parent.height
            color: "#092135"

            Column {
                anchors.fill: parent

                Rectangle {
                    width: parent.width
                    height: 136
                    color : "green"
                }

                Controls.HorizontalSplit {
                    width: parent.width
                }

                Item {
                    width: parent.width
                    height: 376
                    clip: true

                    GameMenu {
                        id: gameMenu

                        anchors.fill: parent
                        //model: Core.currentGame().menu

                        onUrlClicked: {
                            console.log('Open Url', url)
                            //AppProxy.openExternalUrl(url)
                        }

                        onPageClicked: {
                            //Core.currentGame().currentMenuIndex = gameMenu.currentIndex;
                            console.log('Open Page ', page)
                        }

                    }

//                        Controls.ScrollBar {
//                            id: menuScroll

//                            flickable: gameMenu.flickable

//                            visible: gameMenu.flickable.contentHeight > menuScroll.height
//                            height: parent.height
//                            anchors.right: parent.right
//                            //scrollbarWidth: 2
//                        }

                }
            }

            Rectangle {
                width: parent.width
                height: 44
                color: "red"
                anchors.bottom: parent.bottom
            }
        }

    }
}
