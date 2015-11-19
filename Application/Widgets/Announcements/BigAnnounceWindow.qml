/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 2.4
import Tulip 1.0
import QtQuick.Window 2.2

import GameNet.Core 1.0
import GameNet.Controls 1.0
import Application.Blocks 1.0
import Application.Core 1.0
import Application.Controls 1.0

Window {
    id: bigAnnounceWindow

    property string imageUrl: ""
    property variant announceItem
    property int buttonStyle: 1
    property alias buttonMessage: windowAnnounceButtonText.text

    signal announceClosed(variant announceItem);
    signal announceActionClicked(variant announceItem);

    property Gradient hoverGradientStyle1: Gradient {
        GradientStop { position: 0; color: "#257f02" }
        GradientStop { position: 1; color: "#257f02" }
    }

    property Gradient normalGradientStyle1: Gradient {
        GradientStop { position: 0; color: "#4ab120" }
        GradientStop { position: 1; color: "#257f02" }
    }

    property Gradient hoverGradientStyle2: Gradient {
        GradientStop { position: 0; color: "#e5761c" }
        GradientStop { position: 1; color: "#e5761c" }
    }

    property Gradient normalGradientStyle2: Gradient {
        GradientStop { position: 0; color: "#f29b55" }
        GradientStop { position: 1; color: "#e5761c" }
    }

    width: 900
    height: 500
    x: Desktop.primaryScreenAvailableGeometry.x + (Desktop.primaryScreenAvailableGeometry.width - width) / 2
    y: Desktop.primaryScreenAvailableGeometry.y + (Desktop.primaryScreenAvailableGeometry.height - height) / 2

    flags: Qt.FramelessWindowHint
    modality: Qt.WindowModal

    onClosing: bigAnnounceWindow.announceClosed(bigAnnounceWindow.announceItem);

    DragWindowArea {
        anchors.fill: parent
        rootWindow: bigAnnounceWindow
    }

    Connections {
        target: SignalBus

        onApplicationActivated: bigAnnounceWindow.requestActivate();
    }

    Item {
        anchors.fill: parent

        WebImage {
            anchors.fill: parent
            source: bigAnnounceWindow.imageUrl
        }

        CursorMouseArea {
            id: closeButtonImageMouser

            width: 40
            height: 40
            hoverEnabled: true
            anchors { right: parent.right; top: parent.top; }
            onClicked: bigAnnounceWindow.close()
        }

        Image {
            id: closeButtonImage

            anchors { right: parent.right; top: parent.top; rightMargin: 2; topMargin: 2 }
            source: installPath + "Assets/Images/CloseGrayBackground.png"
            opacity: closeButtonImageMouser.containsMouse ? 0.9 : 0.5

            Behavior on opacity {
                NumberAnimation { duration: 225 }
            }
        }

        Image {
            anchors {
                top: parent.top
                topMargin: 2
                left: parent.left
                leftMargin: 2
            }

            source: installPath + "Assets/Images/GameNetLogoGrayBackground.png"

            CursorMouseArea {
                anchors.fill: parent
                onClicked: App.openExternalUrl("https://gamenet.ru")
            }
        }

        Item {
            width: parent.width
            height: 107
            anchors.bottom: parent.bottom

            Rectangle {
                anchors.fill: parent
                color: "#000000"
                opacity: 0.5
            }

            Rectangle {
                anchors.centerIn: parent
                width: Math.max(40 + windowAnnounceButtonText.width, 300)
                height: 64
                color: "#FFFFFF"

                Rectangle {
                    id: windowAnnounceButton

                    property Gradient hover: bigAnnounceWindow.buttonStyle == 1
                                             ? bigAnnounceWindow.hoverGradientStyle1
                                             : bigAnnounceWindow.hoverGradientStyle2

                    property Gradient normal: bigAnnounceWindow.buttonStyle == 1
                                             ? bigAnnounceWindow.normalGradientStyle1
                                             : bigAnnounceWindow.normalGradientStyle2

                    anchors { fill: parent; margins: 2 }
                    gradient: windowAnnounceButtonMouser.containsMouse
                              ? windowAnnounceButton.hover
                              : windowAnnounceButton.normal

                    Text {
                        id: windowAnnounceButtonText

                        anchors.centerIn: parent
                        color: "#ffffff"
                        font { family: "Arial"; pixelSize: 28}
                    }

                    CursorMouseArea {
                        id: windowAnnounceButtonMouser

                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: bigAnnounceWindow.announceActionClicked(bigAnnounceWindow.announceItem);
                    }
                }
            }
        }

        Rectangle {
            anchors {
                fill: parent
            }

            color: "#00000000"
            border {
                width: 1
                color: "#1e1b1b"
            }
        }
    }
}
