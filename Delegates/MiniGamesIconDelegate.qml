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
import "../Elements" as Elements

Item {
    id: gameIconDelegate

    width: gameIconImageDelegate.width + 1
    height: gameIconImageDelegate.height + 1
    scale: normalScale

    signal mouseHover(int num);
    signal noMouseAtItem();
    signal mouseClicked(int num);

    property bool isActive: false
    property double normalScale: 0.985
    property double activeScale: 1.0575
    property string imgSource;
    property bool imageSmooth: true;

    onIsActiveChanged: {
        if (isActive)
            activateAnimation.start();
        else
            deactivateAnimation.start();
    }

    NumberAnimation { id: mouseOutAnimation; easing.type: Easing.OutQuad;
        target: gameIconDelegate;
        property: "scale"; from: activeScale; to: normalScale; duration: 105;
        running: false;
        onStarted: gameBoxItemBg.visible = true;
    }

    NumberAnimation { id: mouseInAnimation; easing.type: Easing.OutQuad;
        target: gameIconDelegate;
        property: "scale"; from: normalScale; to: activeScale; duration: 105;
        running: false;
        onStarted: gameBoxItemBg.visible = false;
    }

    NumberAnimation { id: activateAnimation; easing.type: Easing.OutQuad;
        target: gameIconDelegate;
        property: "scale"; from: activeScale; to: 0.95 * normalScale; duration: 105;
        running: false;
        onStarted: gameBoxItemBg.visible = false;
    }

    NumberAnimation { id: deactivateAnimation; easing.type: Easing.OutQuad;
        target: gameIconDelegate;
        property: "scale"; from: 0.95 * normalScale; to: normalScale; duration: 50;
        running: false;
        onStarted: gameBoxItemBg.visible = true;
    }

    Rectangle {
        visible: true;
        id: gameBoxItemBg
        color: "#fff"
        anchors.fill: parent
        opacity: 0.3
    }

    Image {
        id: gameIconImageDelegate
        x: 1
        y: 1

        Elements.Border {
            id: borderRectangleDelegate;
            visible: !gameBoxItemBg.visible
            borderColor: "#ef8e0c";
            anchors.fill: parent
            anchors.rightMargin: 1
            anchors.bottomMargin: 1
        }

        smooth: imageSmooth
        source: imgSource
        fillMode: Image.PreserveAspectFit
    }

    Elements.CursorMouseArea {
        id: mouser
        anchors.fill: parent
        hoverEnabled: true
        visible: !isActive

        onEntered: if (!isActive) mouseInAnimation.start();
        onExited:  if (!isActive) mouseOutAnimation.start();
        onClicked: mouseClicked(index);
    }
}

