import QtQuick 1.1
import Tulip 1.0
import "../../../Elements" as Elements

import "../../../Proxy/App.js" as App

Elements.PopupItemBase {
    id: popUp

    signal closeButtonClicked();
    signal playClicked();

    property alias message: messageText.text
    property alias buttonCaption: buttonText.text
    property alias messageFontSize : messageText.font.pixelSize
    property variant gameItem

    width: 210
    height: 297

    Rectangle {
        anchors.fill: parent
        color: "#33FFFFFF"

        Item {
            anchors { fill: parent; margins: 1 }

            Image {
                id: background

                anchors.horizontalCenter: parent.horizontalCenter
                source: installPath + gameItem.imagePopupArt
            }

            Image {
                id: closeButtonImage

                anchors { right: parent.right; top: parent.top; rightMargin: 9; topMargin: 9 }
                visible: containsMouse || closeButtonImageMouser.containsMouse || buttonPlayMouser.containsMouse
                source: installPath + "Assets/Images/CloseGrayBackground.png"
                opacity: 0.5

                NumberAnimation {
                    id: closeButtonDownAnimation;
                    running: false;
                    target: closeButtonImage;
                    property: "opacity";
                    from: 0.9;
                    to: 0.5;
                    duration: 225
                }

                NumberAnimation {
                    id: closeButtonUpAnimation;
                    running: false;
                    target: closeButtonImage;
                    property: "opacity";
                    from: 0.5;
                    to: 0.9;
                    duration: 225
                }

                Elements.CursorMouseArea {
                    id: closeButtonImageMouser

                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        closeButtonClicked();
                        shadowDestroy();
                    }

                    onEntered: closeButtonUpAnimation.start()
                    onExited: closeButtonDownAnimation.start()
                }
            }

            Rectangle {
                anchors { left: parent.left; right: parent.right; bottom: parent.bottom }

                height: 43
                color: buttonPlayMouser.containsMouse ? "#007922" : "#00822a"

                Elements.TextH2 {
                    id: buttonText

                    anchors { verticalCenter: parent.verticalCenter; horizontalCenter: parent.horizontalCenter }
                    color: "#ffffff"
                }

                Elements.CursorMouseArea {
                    id: buttonPlayMouser

                    anchors.fill: parent
                    hoverEnabled: true

                    onClicked: {
                        playClicked();
                        shadowDestroy();
                    }
                }
            }

            Item {
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                    bottomMargin: 43
                }

                height: messageText.height + 20

                Rectangle {
                    anchors.fill: parent
                    color: "#000000"
                    opacity: 0.6
                }

                Text {
                    id: messageText

                    textFormat: Text.RichText
                    wrapMode: Text.WordWrap
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                        topMargin: 10
                        leftMargin: 5
                        rightMargin: 5
                    }

                    horizontalAlignment: Text.AlignHCenter
                    color: "#FFFFFF"
                    onLinkActivated: App.openExternalUrl(link)
                }
            }
        }
    }
}
