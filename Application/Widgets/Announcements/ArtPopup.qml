/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1
import Tulip 1.0

import Application.Controls 1.0 as AppControls
import GameNet.Controls 1.0
import "../../Core/App.js" as App


AppControls.TrayPopupBase {
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

                CursorMouseArea {
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

                Text {
                    id: buttonText

                    anchors { verticalCenter: parent.verticalCenter; horizontalCenter: parent.horizontalCenter }
                    font {family: "Tahoma"; pixelSize: 18 }
                    wrapMode: Text.WordWrap
                    smooth: true
                    color: "#ffffff"
                }

                CursorMouseArea {
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
