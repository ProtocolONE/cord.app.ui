import QtQuick 2.4
import Application.Core.Styles 1.0

Item {
    id: root

    property alias text: textElement.text

    Rectangle {
        anchors.fill: parent
        color: Styles.trayPopupBackground

        Column {
            spacing: 1
            anchors {
                fill: parent
                margins: 1
            }

            Rectangle {
                width: parent.width
                height: 25

                color: Styles.trayPopupHeaderBackground

                Image {
                    anchors {
                        left: parent.left
                        leftMargin: 6
                        verticalCenter: parent.verticalCenter
                    }

                    source: installPath + "Assets/Images/Application/Widgets/Announcements/logo.png"
                }
            }

            Item {
                id: bodyItem

                width: parent.width
                height: textElement.height

                Text {
                    id: textElement

                    anchors {
                        left: parent.left
                        top: parent.top
                        topMargin: 12
                        right: parent.right
                        leftMargin: 10
                        rightMargin: 10
                    }

                    text: model.body
                    color: Styles.trayPopupText
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    font {
                        pixelSize: 13
                        family: "Arial"
                    }
                }
            }
        }
    }

    Rectangle {
        width: parent.width
        height: 2
        anchors {
            margins: 1
            bottom: parent.bottom
        }
        color: Styles.trayPopupHeaderBackground
    }
}

