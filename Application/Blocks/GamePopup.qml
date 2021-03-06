import QtQuick 2.4
import Tulip 1.0
import ProtocolOne.Controls 1.0
import Application.Controls 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0

TrayPopupBase {
    id: root

    property variant gameItem
    property string message
    property string image
    property string buttonCaption: qsTr("PLAY_NOW") // "Играть"

    signal closeButtonClicked()
    signal playClicked()

    width: 240
    height: 28 +  content.height

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
                id: content

                width: parent.width
                height: root.image ? externalImage.height : 220;
                color: Styles.trayPopupBackground
                clip: true

                Image {
                    anchors {
                        top: parent.top
                        topMargin: 22
                        horizontalCenter: parent.horizontalCenter
                    }
                    source: gameItem.imageLogoSmall
                    visible: !root.image
                }

                Image {
                    id: externalImage

                    asynchronous: true
                    cache: false
                    fillMode: Image.Stretch
                    width: 238
                    height: Math.max(220, Math.min(308, externalImage.sourceSize.height));
                    source: root.image
                    visible: root.image
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
                    color: Styles.trayPopupText
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
                        normal: Styles.trayPopupButtonNormal
                        hover:  Styles.trayPopupButtonHover
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
