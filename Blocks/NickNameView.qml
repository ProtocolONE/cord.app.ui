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
//import qGNA.Library 1.0
import "../Delegates" as Delegates
import "../Elements" as Elements

Rectangle {
    id: nickNameViewClass
    width: getWidgetWidth();
    height: 71
    color: "#00000000"
    border { color: "#ff9900"; width: 0 }

    property string avatarSource
    property string upText
    property string downText
    property bool isMenuOpen: false
    property bool isMenuAnimation: false

    property bool isGuest: false
    property bool isNickNameSaved: false

    property int openingHeight: 71 + menuListView.model.count * 52

    signal quitClicked();
    signal settingsClicked();
    signal moneyClicked();
    signal confirmGuest();
    signal requestNickname();

    function getHeaderWidth() {
        if ( upTextWidget.width > downTextWidget.width ) {
            if ( upTextWidget.width > 65 )
                return 105 + upTextWidget.width;
            else
                return 185;
        } else if ( downTextWidget.width > 65)
            return 105 + downTextWidget.width;
        else
            return 185;
    }

    function getWidgetWidth() {
        var headerWidth = getHeaderWidth();
        // Числа подобраны с заказчиком.
        return isGuest ? 313 : (isNickNameSaved ? (headerWidth < 190 ? 190 : headerWidth): 283);
    }

    function switchMenu() {
        if (isMenuAnimation)
            return;

        if (isMenuOpen) {
            opacityBlockUp.start();
        } else {
            opacityBlockDown.start();
        }
    }

    function buttonMenuPressed(action) {
        opacityBlockUp.start();

        if (action == "openMoney") {
            moneyClicked();
        } else if (action == "openSettings") {
            settingsClicked();
        } else if (action == "quit") {
            quitClicked();
        } else if (action == "confirmGuest") {
            confirmGuest();
        } else if (action == "confirmNickName") {
            requestNickname();
        } else {
            console.log('nickNameViewClass: Unknown action ', action);
        }
    }

    SequentialAnimation {
        id: opacityBlockUp;

        ParallelAnimation {
            NumberAnimation { target: opacityBlock; easing.type: Easing.OutQuad; property: "opacity"; from: 0.95; to: 0.35; duration: 150 }
            NumberAnimation { target: menuListView; easing.type: Easing.OutQuad; property: "opacity"; from: 1; to: 0; duration: 150 }
            NumberAnimation { target: nickNameViewClass; easing.type: Easing.OutQuad; property: "height"; from: openingHeight; to: 71; duration: 150 }
            PropertyAnimation { target: nickNameViewClass; easing.type: Easing.OutQuad; property: "border.width"; to: 0; duration: 100 }
        }

        onStarted: isMenuAnimation = true;
        onCompleted: {
            isMenuOpen = false;
            isMenuAnimation = false;
        }
    }

    SequentialAnimation {
        id: opacityBlockDown;

        ParallelAnimation {
            NumberAnimation { target: opacityBlock; easing.type: Easing.OutQuad; property: "opacity"; from: opacityBlock.opacity === 0.95 ? 0.95 : 0.35; to: 0.95; duration: 150 }
            NumberAnimation { target: menuListView; easing.type: Easing.OutQuad; property: "opacity"; from: 0; to: 1; duration: 150 }
            NumberAnimation { target: nickNameViewClass; easing.type: Easing.OutQuad; property: "height"; from: 71; to: openingHeight; duration: 150 }
            PropertyAnimation { target: nickNameViewClass; easing.type: Easing.OutQuad; property: "border.width"; to: 1; duration: 100 }
        }

        onStarted: isMenuAnimation = true;
        onCompleted: {
            isMenuOpen = true;
            isMenuAnimation = false;
        }
    }

    SequentialAnimation {
        id: opacityBlockUpHover;

        ParallelAnimation {
            NumberAnimation { target: opacityBlock; easing.type: Easing.OutQuad; property: "opacity"; from: 0.95; to: 0.35; duration: 50 }
            NumberAnimation { target: menuListView; easing.type: Easing.OutQuad; property: "opacity"; from: 1; to: 0; duration: 50 }
            PropertyAnimation { target: nickNameViewClass; easing.type: Easing.OutQuad; property: "border.width"; to: 0; duration: 25 }
        }
    }
    SequentialAnimation {
        id: opacityBlockDownHover;

        ParallelAnimation {
            NumberAnimation { target: opacityBlock; easing.type: Easing.OutQuad; property: "opacity"; from: 0.35; to: 0.95; duration: 50 }
            NumberAnimation { target: menuListView; easing.type: Easing.OutQuad; property: "opacity"; from: 0; to: 1; duration: 50 }
            PropertyAnimation { target: nickNameViewClass; easing.type: Easing.OutQuad; property: "border.width"; to: 1; duration: 25 }
        }
    }

    Elements.CursorMouseArea {
        id: mouser

        anchors.fill: parent;
        hoverEnabled: true
        onClicked: switchMenu();        
        onEntered: {
            if (!isMenuOpen && !opacityBlockDown.running && !opacityBlockUp.running) {
                opacityBlockDownHover.start();
            }
        }

        onExited: {
            if (!isMenuOpen && !opacityBlockDown.running && !opacityBlockUp.running) {
                opacityBlockUpHover.start();
            }
        }
    }

    //HACK Using mainWindow, mainWindowRectanglw in Block. But there is no any other ways to make QGNA-60
    Connections {
        target: mainWindow
        onLeftMouseClick: {
            if (!isMenuOpen)
                return;

            var posInWidget = nickNameViewClass.mapToItem(mainWindowRectanglw, mainWindowRectanglw.x, mainWindowRectanglw.y);
            if (globalX >= posInWidget.x
                && globalX <= posInWidget.x + nickNameViewClass.width
                && globalY >= posInWidget.y
                && globalY <= posInWidget.y + nickNameViewClass.height + menuListView.height)
                return;

            nickNameViewClass.switchMenu();
        }
    }

    Rectangle {
        id: opacityBlock

        anchors { fill: parent; leftMargin: 1; topMargin: 1 }
        opacity: 0.35
        color: "#000000"
    }

    Item {
        anchors { top: parent.top; left: parent.left; topMargin: 7; leftMargin: 7 }
        width: 58
        height: 58

        Rectangle {
            color: "#ffffff"
            opacity: 0.33
            anchors.fill: parent
            smooth: true
        }

        Image {
            x: 1
            y: 1
            width: 56
            height: 56
            source: avatarSource
            opacity: 1
            smooth: true
            fillMode: Image.PreserveAspectFit
            onSourceChanged: {
                console.log("source " + source);
            }
        }
    }

    Text {
        id: upTextWidget

        anchors { top: parent.top; left: parent.left; topMargin: 10; leftMargin: 73 }
        smooth: true
        font { family: "Arial"; pixelSize: 20; bold: false }
        color: "#ffffff"
        text: upText
    }

    Row {
        id: downTextWidget

        anchors { top: parent.top; left: parent.left; topMargin: 38; leftMargin: 73 }
        height: firstTextId.height
        spacing: 6

        Image {
            id: coinIcon

            source: installPath + "images/coinIcon.png"
            smooth: true
        }

        Text {
            id: firstTextId

            smooth: true
            font { family: "Arial"; pixelSize: 22; bold: false }
            color: "#ffffff"
            text: downText
        }
    }

    ListModel {
        id: menuModelNormal

        ListElement {
            imageSource: "images/moneyIcon.png"
            value: QT_TR_NOOP("MENU_ITEM_MONEY")
            action: "openMoney"
        }

        ListElement {
            imageSource: "images/settingsIcon.png"
            value: QT_TR_NOOP("MENU_ITEM_SETTINGS")
            action: "openSettings"
        }

        ListElement {
            imageSource: "images/quitIcon.png"
            value: QT_TR_NOOP("MENU_ITEM_QUIT")
            action: "quit"
        }
    }

    ListModel {
        id: menuModelGuest

        ListElement {
            imageSource: "images/confirmGuestRegistrationIcon.png"
            value: QT_TR_NOOP("MENU_ITEM_GUEST_CONFIRM")
            action: "confirmGuest"
        }

        ListElement {
            imageSource: "images/moneyIcon.png"
            value: QT_TR_NOOP("MENU_ITEM_MONEY")
            action: "openMoney"
        }

        ListElement {
            imageSource: "images/settingsIcon.png"
            value: QT_TR_NOOP("MENU_ITEM_SETTINGS")
            action: "openSettings"
        }

        ListElement {
            imageSource: "images/quitIcon.png"
            value: QT_TR_NOOP("MENU_ITEM_QUIT")
            action: "quit"
        }
    }

    ListModel {
        id: menuModelNickNameConfirm

        ListElement {
            imageSource: "images/choiceNicknameIcon.png"
            value: QT_TR_NOOP("MENU_ITEM_NICK_NAME_CONFIRM")
            action: "confirmNickName"
        }

        ListElement {
            imageSource: "images/moneyIcon.png"
            value: QT_TR_NOOP("MENU_ITEM_MONEY")
            action: "openMoney"
        }

        ListElement {
            imageSource: "images/settingsIcon.png"
            value: QT_TR_NOOP("MENU_ITEM_SETTINGS")
            action: "openSettings"
        }

        ListElement {
            imageSource: "images/quitIcon.png"
            value: QT_TR_NOOP("MENU_ITEM_QUIT")
            action: "quit"
        }
    }

    ListView {
        id: menuListView

        anchors { fill: parent; topMargin: 71; leftMargin: 1 }
        interactive: false
        visible: isMenuOpen

        delegate: Rectangle {
            id: mainImageButtonRectangle

            color: "#00000000"
            width: menuListView.width
            height: 52

            Rectangle {
                height: 1
                color: "#ffffff"
                opacity: 0.5
                anchors { left: parent.left; right: parent.right; top: parent.top }
            }

            Image {
                id: imageIcon

                anchors { left: parent.left; top: parent.top; leftMargin: 6; topMargin: 6 }
                source: installPath + imageSource
                opacity: 0.4
            }

            Text {
                id: imageButtonTextId

                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 31 + imageIcon.width
                    horizontalCenterOffset: 10
                }

                text: qsTr(value)
                font { family: "Arial"; pixelSize: 20; bold: false }
                smooth: true
                color: "#cccccc"
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: buttonMenuPressed(action);
                onEntered: {
                    mainImageButtonRectangle.color = "#ff9800"
                    imageButtonTextId.color = "#ffffff"
                    imageIcon.opacity = 1
                }

                onExited: {
                    mainImageButtonRectangle.color = "#00000000"
                    imageIcon.opacity = 0.4
                    imageButtonTextId.color = "#cccccc"
                }
            }
        }

        model: isGuest ? menuModelGuest : (isNickNameSaved ? menuModelNormal : menuModelNickNameConfirm )
    }
}
