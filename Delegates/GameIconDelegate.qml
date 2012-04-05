/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.0
import "../Elements" as Elements
import "../Delegates" as Delegates

Delegates.FlowViewDelegate {
    id: gameIconDelegate

    signal mouseHover(int num);
    signal noMouseAtItem();
    signal mouseClicked(variant item);

    property bool isActive: false
    property bool isAnimationStart: true
    property bool imageSmooth: true;

    function activeAnimation(active) {
        if (active)
            mouseOutAnimation.start();
        else
            mouseInAnimation.start();
    }

    width: gameIconImageDelegate.width + 1
    height: gameIconImageDelegate.height + 1

    SequentialAnimation {
        running: true
        onStarted: {
            gameIconImageDelegate.anchors.leftMargin = model.size === "big" ? -150 : 200
            gameIconImageDelegate.opacity = 0
        }

        PauseAnimation { duration: animationPause }

        ParallelAnimation {
            NumberAnimation {
                target: gameIconImageDelegate;
                easing.type: Easing.OutQuad;
                property: "anchors.leftMargin";
                from: model.size === "big" ? -150 : 200
                to: 0
                duration: model.size === "big" ? 250 : 150
            }

            NumberAnimation {
                target: gameIconImageDelegate;
                easing.type: Easing.OutQuad;
                property: "opacity";
                from: 0.1
                to: 1
                duration: 250
            }
        }
    }

    PropertyAnimation {
        id: mouseOutAnimation;

        easing.type: Easing.OutQuad;
        alwaysRunToEnd: true
        target: rotation;
        property: "angle";
        from: 180; to: 360
        duration: 300
        onCompleted: rotation.angle = 0
    }

    PropertyAnimation {
        //Хак, но без него тоже никак. Дело в том, что только такой
        //подход гарантирует что mouseOutAnimation выполнится всегда
        //после mouseInAnimation.
        running: mouser.containsMouse
        id: mouseInAnimation;
        easing.type: Easing.OutQuad;
        alwaysRunToEnd: false
        target:  rotation;
        property: "angle";
        from: 0;
        to: 180;
        duration: 300
        onCompleted: rotation.angle = 180
    }

    Flipable {
        id: flipable

        anchors.top: parent.top
        anchors.left: parent.left

        transform: Rotation {
            id: rotation

            origin.x: gameIconImageDelegate.width / 2
            origin.y: gameIconImageDelegate.height / 2
            axis.x: 0; axis.y: 1; axis.z: 0
            angle: 0
        }

        front: Image {
            id: gameIconImageDelegate

            anchors { top: parent.top; left: parent.left }
            smooth: imageSmooth
            source: installPath + (model.size === "big" ? model.imageBig :
                                                          model.size === "doubleHorizontal" ? model.imageHorizontal
                                                                                            : model.imageSmall)

            Elements.Border {
                anchors { fill: parent; leftMargin: -1; topMargin: -1; }
                borderColor: "#55ffffff"
                visible: true
            }
        }

        back: Item {
            anchors { top: parent.top; left: parent.left }
            width: gameIconImageDelegate.width
            height: gameIconImageDelegate.height

            Rectangle {
                anchors { top: parent.top; left: parent.left; right: parent.right }
                height: gameIconImageDelegate.height * 0.75
                color: "#fc9700"

                Image {
                    anchors.centerIn: parent
                    source: installPath + (model.size === "big" ? model.imageLogoBig : model.imageLogoSmall)
                }
            }

            Rectangle {
                anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
                height: gameIconImageDelegate.height * 0.35
                color: "#d67d00"

                Text {
                    width: parent.width * 0.9
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    font { family: "Tahoma"; pixelSize: (model.size === "big") ? 32 : 16 }
                    wrapMode: Text.WordWrap
                    color: "#FFFFFF"
                    smooth: true
                    //Слудующая линия - мерзкий хак, но по другому не получить
                    //локализованный текст. См. примечания в моделе.
                    text: gamesListModel.logoText(model.gameId)
                }
            }
        }
    }

    MouseArea {
        id: mouser

        anchors.fill: parent
        hoverEnabled: true
        onExited: {
            mouseOutAnimation.start();
            noMouseAtItem();
        }

        onClicked: mouseClicked(model);
    }
}

