/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1
import "../Delegates" as Delegates
import "../Elements" as Elements

import "../js/Core.js" as Core
import "../Proxy/App.js" as App

Delegates.FlowViewDelegate {
    id: root

    signal mouseClicked(variant item, bool force);

    width: (model.size === "doubleHorizontal" ? 348 : 168) + 2
    height: 168 + 2
    opacity: 0.1

    onVisibleChanged: {
        root.opacity = 0;
        textBlock.opacity = 0;

        if (visible) {
            openAnim.start();
        } else {
            openAnim.stop();
        }
    }

    SequentialAnimation {
        id: openAnim

        running: false

        PauseAnimation { duration: animationPause }

        ParallelAnimation {

            NumberAnimation {
                target: gameIcon
                easing.type: Easing.OutBack
                property: "width"
                from: (model.size === "doubleHorizontal" ? 348 : 168) * 0.50
                to: model.size === "doubleHorizontal" ? 348 : 168
                duration: 500
            }

            NumberAnimation {
                target: gameIcon
                easing.type: Easing.OutBack
                property: "height"
                from: 168 * 0.50
                to: 168
                duration: 500
            }

            NumberAnimation {
                target: root
                easing.type: Easing.InOutQuad
                property: "opacity"
                from: 0.1
                to: 1
                duration: 500
            }

            SequentialAnimation {

                PauseAnimation { duration: 350 }

                PropertyAnimation {
                    target: textBlock
                    property: "opacity"
                    to: 1
                    duration: 250
                }
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#ffffff"
        opacity: 0.15
    }

    Image {
        id: gameIcon

        anchors { verticalCenter: parent.verticalCenter; horizontalCenter: parent.horizontalCenter }
        smooth: true
        source: installPath + (model.size === "doubleHorizontal" ? model.imageHorizontal: model.imageSmall)
    }

    Item {
        id: textBlock

        visible: !mouser.containsMouse
        anchors { verticalCenter: parent.verticalCenter; horizontalCenter: parent.horizontalCenter }
        width: gameIcon.width
        height: gameIcon.height

        Rectangle {
            id: opacityBlock

            anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
            height: 32
            color: "#000000"
            opacity: 0.3
        }

        Text {
            width: opacityBlock.width * 0.9
            anchors.centerIn: opacityBlock
            horizontalAlignment: Text.AlignHCenter
            font { family: "Tahoma"; pixelSize : 15 }
            color: "#FFFFFF"
            smooth: true
            text: model.logoText
        }
    }

    Image {
        visible: mouser.containsMouse
        anchors { left: parent.left; top: parent.top; leftMargin: 1; topMargin: 1 }
        fillMode: Image.Tile
        width: gameIcon.width
        height: gameIcon.height
        source: installPath + "images/hoverClone.png"
    }

    Elements.CursorMouseArea {
        id: mouser

        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            var buttonPlayObj = mouser.mapToItem(buttonPlay,mouseX,mouseY);
            var buttonDetailsObj = mouser.mapToItem(buttonDetails,mouseX,mouseY);

            if (buttonPlayObj.x >= 0 && buttonPlayObj.x <= buttonPlay.width && buttonPlayObj.y >= 0 && buttonPlayObj.y <= buttonPlay.height) { // кнопка Play
                if (!model) {
                    return;
                }

                // HACK Отключаем ферму от запуска
                var status = model.status;
                if (status !== "Downloading" && status !== "Started") {
                    App.downloadButtonStart(model.serviceId);
                }

                mouseClicked(model,false);
            } else if (buttonDetailsObj.x >= 0 && buttonDetailsObj.x <= buttonDetails.width && buttonDetailsObj.y >= 0 && buttonDetailsObj.y <= buttonDetails.height) { // кнопка Details
                mouseClicked(model,true);
            } else {
                mouseClicked(model,false);
            }
        }
    }

    Row {
        id: rowButtons

        visible: mouser.containsMouse
        anchors { bottom: parent.bottom; bottomMargin: 5; horizontalCenter: parent.horizontalCenter }

        spacing: 4

        Item {
            id: buttonPlay

            width: 64
            height: 28

            Item {
                anchors.fill: parent

                Rectangle {
                    color: "#ffffff"
                    opacity: 0.5
                    anchors.fill: parent
                }

                Rectangle {
                    anchors { left: parent.left; top: parent.top; leftMargin: 1; topMargin: 1 }
                    width: 62
                    height: 26
                    color: "#339900"

                    Text {
                        color: "#fff"
                        text: qsTr("TO_PLAY")
                        anchors.centerIn: parent
                        smooth: true
                        font { family: "Arial"; pixelSize: 12 }
                    }

                }
            }
        }

        Item {
            id: buttonDetails

            width: 92
            height: 28

            Item {
                anchors.fill: parent

                Rectangle {
                    color: "#ffffff"
                    opacity: 0.5
                    anchors.fill: parent
                }

                Rectangle {
                    color: "#114400"
                    anchors { left: parent.left; top: parent.top; leftMargin: 1; topMargin: 1 }
                    width: 90
                    height: 26

                    Text {
                        color: "#fff"
                        text: qsTr("DETAILS")
                        anchors { centerIn: parent }
                        smooth: true
                        font { family: "Arial"; pixelSize: 12 }
                    }
                }
            }
        }
    }
}

