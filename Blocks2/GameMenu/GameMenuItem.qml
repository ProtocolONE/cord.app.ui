import QtQuick 1.1
import Tulip 1.0
import GameNet.Controls 1.0

import "../../Core/Styles.js" as Styles

Item {
    id: root

    property alias text: caption.text
    property alias icon: iconImage.source
    property alias externalLink: externalLinkIcon.visible

    property bool current: false

    implicitHeight: 37
    implicitWidth: 178

    signal clicked();

    Button {
        width: parent.width
        height: 35
        style {
            normal: root.current ? Styles.style.gameMenuButtonSelectedNormal : Styles.style.gameMenuButtonNormal
            hover: root.current ? Styles.style.gameMenuButtonSelectedHover : Styles.style.gameMenuButtonHover
        }

        onClicked: root.clicked();

        Row {
            anchors.fill: parent
            spacing: 7

            Item {
                width: height
                height: parent.height

                Image {
                    id: iconImage

                    anchors.centerIn: parent
                }
            }

            Item {
                height: parent.height
                width: parent.width - height*2 - 14

                Text {
                    id: caption

                    color: Styles.style.gameMenuButtonText
                    font { family: "Arial"; pixelSize: 14 }
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Item {
                id: externalLinkIcon

                width: height
                height: parent.height

                Image {
                    anchors.centerIn: parent
                    source: installPath + "Assets/Images/Application/Blocks/GameMenu/ExternalLink.png"
                }
            }
        }

        Rectangle {
            width: 2
            color: Styles.style.gameMenuSelectedIndicator
            height: parent.height
            anchors.right: parent.right
            visible: root.current
            opacity: visible ? 1 : 0

            Behavior on visible {
                NumberAnimation { duration: 150 }
            }

            Behavior on opacity {
                NumberAnimation { duration: 150 }
            }
        }
    }

    HorizontalSplit {
        width: parent.width
        anchors.bottom: parent.bottom

        style: SplitterStyleColors {
            main: Qt.darker(Styles.style.gameMenuBackground, Styles.style.darkerFactor)
            shadow: Qt.lighter(Styles.style.gameMenuBackground, Styles.style.darkerFactor)
        }
    }
}
