import QtQuick 1.1
import Tulip 1.0
import GameNet.Controls 1.0

Item {
    id: root

    property alias text: caption.text
    property alias icon: iconImage.source
    property alias externalLink: externalLinkIcon.visible

    property bool current: false

    property variant style: ButtonStyleColors {
        normal: "#092135"
        hover: "#243148"
    }

    property variant selectedStyle: ButtonStyleColors {
        normal: "#071828"
        hover: "#243148"
    }

    implicitHeight: 37
    implicitWidth: 178

    signal clicked();

    Button {
        width: parent.width
        height: 35
        style: root.current ? root.selectedStyle : root.style

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

                    color: "#FFFFFF"
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
            color: "#FFCA02"
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
    }
}
