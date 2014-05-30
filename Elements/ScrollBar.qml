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
import "." as Elements

Rectangle {
    // HACK
    //property string installPath: "../"

    id: scrollBarElement
    color: "#00000000"

    property variant flickable
    property bool vertical: true
    property bool hideScrollBarsWhenStopped: true
    property int scrollbarWidth: 19

    width: vertical ? scrollbarWidth : parent.width
    height: vertical ? parent.height : scrollbarWidth
    x: vertical ? parent.width - width : 0
    y: vertical ? 0 : parent.height - height

    property real cHeight: flickable.contentHeight
    property real cContentY: 0
    property bool acceptToScroll: false
    property alias baseRect: baseRect

    property int wheelTo

    clip: true

    NumberAnimation {
        id: downScrollAnimation
        target: flickable;
        property: "contentY";
        duration: (cHeight - cContentY) * 3 < 0 ? 0 : (cHeight - cContentY) * 3;
        from: cContentY;
        to: flickable.contentHeight - parent.height;
        easing.type: Easing.Linear
        onStarted: cContentY = flickable.contentY;
    }

    NumberAnimation {
        id: upScrollAnimation
        target: flickable;
        property: "contentY";
        duration: cContentY * 3;
        from: cContentY;
        to: 0;
        easing.type: Easing.Linear
        onStarted: cContentY = flickable.contentY;
    }

    NumberAnimation {
        id: downFastScrollAnimation
        target: flickable;
        property: "contentY";
        duration: (cHeight - cContentY) < 0 ? 0 : (cHeight - cContentY);
        from: cContentY;
        to: flickable.contentHeight - parent.height;
        easing.type: Easing.Linear
        onStarted: cContentY = flickable.contentY;
    }

    NumberAnimation {
        id: upFastScrollAnimation
        target: flickable;
        property: "contentY";
        duration: cContentY;
        from: cContentY;
        to: 0;
        easing.type: Easing.Linear
        onStarted: cContentY = flickable.contentY;
    }

    function stopScroll() {
        cContentY = flickable.contentY;
        upFastScrollAnimation.stop();
        downFastScrollAnimation.stop();
        flickable.contentY = cContentY;
    }

    function startFastScroll() {
        if ((fastScrollMouseArea.mouseY) > (flickable.visibleArea.yPosition * (parent.height - scrollbarWidth*2))) {
            downFastScrollAnimation.start();
        }
        else {
            upFastScrollAnimation.start();
        }
    }

    Rectangle {
        id: baseRect

        anchors.fill: parent
        color: "white"
        opacity: 0.2
        clip: true
    }

    Rectangle {
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        height: scrollbarWidth
        color: "#00000000"

        Image {
            id: upArrowId
            source: installPath + "Assets/Images/upArrowWhite.png"
            anchors.top: parent.top
            anchors.topMargin: 7
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: 0.5
        }

        Elements.CursorMouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: upArrowId.opacity = 1
            onExited: upArrowId.opacity = 0.5
            onPressed: {
                upScrollAnimation.start();
            }
            onReleased: {
                cContentY = flickable.contentY;
                upScrollAnimation.stop();
                flickable.contentY = cContentY;
            }
        }
    }


    Rectangle {
        id: downArrowId

        anchors { bottom: parent.bottom; left: parent.left; right: parent.right }
        height: scrollbarWidth
        color: "#00000000"
        opacity: 0.5

        Image {
            source: installPath + "Assets/Images/downArrowWhite.png"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 7
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Elements.CursorMouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: downArrowId.opacity = 1
            onExited: downArrowId.opacity = 0.5
            onPressed: { downScrollAnimation.start(); }
            onReleased: {
                cContentY = flickable.contentY;
                downScrollAnimation.stop();
                flickable.contentY = cContentY;
            }
        }
    }

    Rectangle {
        anchors { fill: parent; bottomMargin: scrollbarWidth; topMargin: scrollbarWidth }
        color: "#00000000"
        clip: true

        NumberAnimation {
            id: downWheelScrollAnimation
            target: flickable; property: "contentY";
            duration: (cHeight - cContentY) / 10;
            from: cContentY;
            to: wheelTo;
            easing.type: Easing.OutCubic
            onStarted: cContentY = wheelTo;
        }

        NumberAnimation {
            id: upWheelScrollAnimation
            target: flickable;
            property: "contentY";
            duration: cContentY / 10;
            from: cContentY;
            to: wheelTo;
            easing.type: Easing.OutCubic
            onStarted: cContentY = wheelTo;
        }

        Elements.WheelArea {
            anchors.fill: parent
            onVerticalWheel: {
                var newValue = flickable.contentY - delta;
                if (newValue < 0)
                    newValue = 0;
                if (newValue > flickable.contentHeight - scrollBarElement.height)
                    newValue = flickable.contentHeight - scrollBarElement.height;

                wheelTo = newValue;
                if (!downWheelScrollAnimation.running)
                    downWheelScrollAnimation.start();
            }

            onHorizontalWheel: {
                var newValue = flickable.contentY - delta;
                if (newValue < 0)
                    newValue = 0;
                if (newValue > flickable.contentHeight)
                    newValue = flickable.contentHeight;

                wheelTo = newValue;
                if (!upWheelScrollAnimation.running)
                upWheelScrollAnimation.start();
            }
        }

        MouseArea {
            id: fastScrollMouseArea

            anchors.fill: parent
            hoverEnabled: true
            onPressed: {
                if (mouseY >= (navigationRectangle.y - 1) && mouseY <= navigationRectangle.y + navigationRectangle.height)
                    acceptToScroll = true;
                else
                    startFastScroll();
            }
            onReleased: {
                acceptToScroll = false;
                stopScroll();
            }

            onExited: stopScroll();
            onEntered: {
                if (pressed && fastScrollMouseArea.pressedButtons & Qt.LeftButton && !acceptToScroll)
                    startFastScroll();
            }

            onMousePositionChanged: {
                if (acceptToScroll && mouseY >= 0 && mouseY <= height - navigationRectangle.height) {
                    flickable.contentY = (flickable.contentHeight / height) * (mouseY);
                }
            }
        }

        Rectangle {
            id: navigationRectangle

            visible: true
            color: "#ffffff"
            opacity: 0.3

            width: vertical ? scrollbarWidth : flickable.visibleArea.widthRatio * parent.width
            height: vertical ? flickable.visibleArea.heightRatio * parent.height : scrollbarWidth

            x: vertical ? parent.width - width : flickable.visibleArea.xPosition * parent.width
            y: vertical ? flickable.visibleArea.yPosition * parent.height : parent.height - height

            Behavior on opacity { NumberAnimation { duration: 200 }}

            Elements.CursorShapeArea { anchors.fill: parent }

            onYChanged: {
                if ( downFastScrollAnimation.running && navigationRectangle.y >= fastScrollMouseArea.mouseY - (height/2) )
                    downFastScrollAnimation.stop();
                else if ( upFastScrollAnimation.running && navigationRectangle.y <= fastScrollMouseArea.mouseY - (height/2) )
                    upFastScrollAnimation.stop();
            }
        }
    }
}
