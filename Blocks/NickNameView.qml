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
import Tulip 1.0
import Application.Blocks 1.0 as Blocks
import "../Elements" as Elements

Item {
    id: nickNameViewClass

    width: getWidgetWidth();
    height: 68

    property string avatarSource
    property string upText
    property string downText
    property string level

    property bool isGuest: false
    property bool isNickNameSaved: false

    property bool isPremium: false

    signal quitClicked();
    signal moneyClicked();
    signal confirmGuest();
    signal requestNickname();
    signal profileClicked();

    function getWidgetWidth() {
        return downRowWidget.width + avatarImage.width + 3 * 5;
    }

    function mouseButtonClick() {
        if (isGuest) {
            confirmGuest();
            return;
        }

        if (!isNickNameSaved) {
            requestNickname();
            return;
        }

        profileClicked();
    }

    function nickNameWidth() {
        if (isGuest) {
            return downRowWidget.width - 30;
        } else if (!isNickNameSaved) {
            return downRowWidget.width - 10;
        } else {
            return downRowWidget.width - 16 - 18 - 8;
        }
    }

    Rectangle {
        anchors.fill: parent;
        opacity: 0.35
        color: "#000000"
    }

    Image {
        width: 15
        height: 11
        anchors { top: parent.top; topMargin: 5; right: parent.right; rightMargin: 1; }
        fillMode: Image.PreserveAspectFit
        source: installPath + "Assets/Images/exit.png"
        smooth: true
        opacity: 0.5

        Elements.CursorMouseArea {
            anchors.fill: parent
            hoverEnabled: true
            toolTip: qsTr("LOGOUT_TOOLTIP")
            tooltipGlueCenter: true
            onClicked: quitClicked();
        }
    }

    Item {
        id: avatarImage

        anchors { top: parent.top; left: parent.left; topMargin: 5; leftMargin: 5 }
        width: 58
        height: 58

        Rectangle {
            color: "#ffffff"
            opacity: 0.33
            anchors.fill: parent
            smooth: true
        }

        Image {
            width: 56
            height: 56
            anchors { top: parent.top; left: parent.left; topMargin: 1; leftMargin: 1 }
            source: avatarSource
            opacity: 1
            smooth: true
            fillMode: Image.PreserveAspectFit

            Rectangle {
                id: levelBack

                height: 20
                width: levelText.width + 8
                color: "#000000"
                anchors { bottom: parent.bottom; left: parent.left }
                opacity: 0.7
            }

            Text{
                id: levelText

                anchors { verticalCenter: levelBack.verticalCenter; horizontalCenter: levelBack.horizontalCenter }
                text: level
                color: "#ffffff"
                font { family: "Arial"; pixelSize: 14; bold: false }
            }
        }

        Elements.CursorMouseArea {
            anchors.fill: parent;
            hoverEnabled: true
            toolTip: qsTr("LEVEL_AVATAR_TOOLTIP")
            onClicked: mouseButtonClick()
        }
    }

    Row {
        spacing: 8
        anchors { top: parent.top; left: parent.left; topMargin: 10; leftMargin: 68 }

        Image{
            anchors { top: parent.top; topMargin: 1; }
            width: 18
            visible: !isGuest && isNickNameSaved
            height: 14
            source:  installPath + (nickNameViewClass.isPremium ? "Assets/Images/vip.png" : "Assets/Images/vip-no.png")
            smooth : true
            opacity: nickNameViewClass.isPremium ? 1 : 0.2

            Elements.CursorMouseArea {
                anchors.fill: parent;
                hoverEnabled: true
                tooltipGlueCenter: true
                toolTip: nickNameViewClass.isPremium ? qsTr("PREMIUM_TOOLTIP"): qsTr("PREMIUM_NO_TOOLTIP")
                tooltipPosition: "W"
                cursor: CursorArea.ArrowCursor
            }
        }

        Text {
            id: upTextWidget

            smooth: true
            font { family: "Arial"; pixelSize: 17; bold: false }
            color: "#ffffff"
            text: upText
            width: nickNameWidth();
            elide: Text.ElideRight

            Elements.CursorMouseArea {
                anchors.fill: parent;
                hoverEnabled: true
                onClicked: mouseButtonClick()
                toolTip: qsTr("NICKNAME_TOOLTIP")
            }
        }
    }

    Row {
        id: downRowWidget

        anchors { bottom: parent.bottom; left: parent.left; bottomMargin: 11; leftMargin: 68 }
        height: 22

        Rectangle {
            width: balanceText.width + 28
            height: 27
            color: "#006600"
            border { width: 1; color: "#339900" }

            Image {
                width: 13
                height: 14
                anchors { right: parent.right; rightMargin: 5; }
                fillMode: Image.PreserveAspectFit
                anchors { top: parent.top; topMargin: 8 }
                source: installPath + "Assets/Images/coins.png"
                smooth: true
            }

            Text {
                id: balanceText

                text: downText
                anchors { verticalCenter: parent.verticalCenter }
                anchors { left: parent.left; leftMargin: 4; top: parent.top; topMargin: 2 }
                wrapMode: Text.NoWrap
                style: Text.Normal
                smooth: true
                color: "#fbc608"
                font { family: "Arial"; pixelSize: 22 }
            }

            Elements.CursorMouseArea {
                anchors.fill: parent
                hoverEnabled: true
                toolTip: qsTr("MONEY_TOOLTIP")
                onClicked: moneyClicked()
            }
        }

        Rectangle {
            width: 123
            height: 28
            color: "#339900"

            Text {
                color: "#fff"
                text: qsTr("ACCOUNT_DEPOSIT")
                anchors { top: parent.top; topMargin: 7; left: parent.left; leftMargin: 7; }
                wrapMode: Text.NoWrap
                style: Text.Normal
                smooth: true
                font { family: "Arial"; pixelSize: 12; letterSpacing: -0.1 }
            }

            Elements.CursorMouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: moneyClicked()
            }
        }
    }
}
