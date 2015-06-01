import QtQuick 1.1
import Tulip 1.0
import GameNet.Controls 1.0
import Application.Controls 1.0

import "../Core/Styles.js" as Styles

TrayPopupBase {
    id: root

    property variant gameItem
    property string message
    property string buttonCaption: qsTr("PLAY_NOW") // "Играть"

    signal closeButtonClicked()
    signal playClicked()

    width: 240
    height: 247

    Rectangle {
        anchors.fill: parent
        color: Styles.style.trayPopupBackground

        Column {
            spacing: 1
            anchors {
                fill: parent
                margins: 1
            }

            Rectangle {
                width: parent.width
                height: 25
                color: Styles.style.trayPopupHeaderBackground

                Image {
                    anchors {
                        left: parent.left
                        leftMargin: 6
                        verticalCenter: parent.verticalCenter
                    }

                    source: installPath + "Assets/Images/Application/Widgets/Announcements/logo.png"
                }

                ImageButton {
                    id: closeButtonImage

                    anchors {
                        right: parent.right
                        rightMargin: 6
                        verticalCenter: parent.verticalCenter
                    }
                    width: 12
                    height: 12

                    style {
                        normal: "#00000000"
                        hover: "#00000000"
                        disabled: "#00000000"
                    }
                    styleImages {
                        normal: installPath + "Assets/Images/Application/Widgets/Announcements/closeButton.png"
                    }

                    opacity: containsMouse ? 1 : 0.5
                    onClicked: {
                        root.closeButtonClicked();
                        root.shadowDestroy();
                    }

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 250
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 219
                color: Styles.style.trayPopupHeaderBackground

                Image {
                    id: gradient

                    anchors.bottom: parent.bottom
                    width: 238
                    height: 210
                    source: installPath + "Assets/Images/Application/Blocks/gradient.png"
                }

                Image {
                    anchors {
                        top: parent.top
                        topMargin: 22
                        horizontalCenter: parent.horizontalCenter
                    }
                    source: gameItem.imageLogoSmall
                }

                Text {
                    id: messageText

                    anchors {
                        bottom: actionButton.top
                        bottomMargin: 20

                        left: actionButton.left
                        leftMargin: 5
                        right: actionButton.right
                        rightMargin: 5
                    }
                    wrapMode: TextEdit.WordWrap
                    font {
                        family: "Arial"
                        pixelSize: 15
                    }
                    text: root.message
                    color: Styles.style.trayPopupText
                    horizontalAlignment: Text.AlignHCenter
                }

                Button {
                    id: actionButton

                    anchors {
                        left: parent.left
                        leftMargin: 8
                        right: parent.right
                        rightMargin: 8
                        bottom: parent.bottom
                        bottomMargin: 8
                    }

                    style {
                        normal: Styles.style.trayPopupButtonNormal
                        hover:  Styles.style.trayPopupButtonHover
                    }

                    text: root.buttonCaption
                    height: 44
                    fontSize: 18

                    onClicked: {
                        root.playClicked();
                        root.shadowDestroy();
                    }
                }
            }
        }
    }
}
