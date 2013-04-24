import QtQuick 1.0

import "../js/Core.js" as Core
import "../Elements" as Elements

Rectangle{

    property variant currentItem: Core.currentGame()
    property bool textVisible: true

    signal homeButtonClicked();

    function leftMarginDescription() {
        return labelTextImage.width * 0.8;
    }

    onTextVisibleChanged: {
        labelTextImage.visible = textVisible
    }

    onCurrentItemChanged: {
        labelTextImage.visible = false
        headerAnimation.start();
    }

    Rectangle{
        color: "#000000"
        height: 86
        width: parent.width
        opacity: 0.4
    }

    SequentialAnimation {
        id: headerAnimation

        running: true

        PauseAnimation { duration: 250 }

        PropertyAnimation {
            target: labelTextImage;
            easing.type: Easing.OutQuad;
            property: "visible";
            to: textVisible;
        }

        NumberAnimation {
            target: labelTextImage;
            easing.type: Easing.OutQuad;
            property: "anchors.leftMargin";
            from: -300;
            to: 30;
            duration: 200
        }
    }

    Rectangle {
        anchors { top: parent.top; left: labelTextImage.left }
        anchors { topMargin: 12; leftMargin: leftMarginDescription() }
        visible: labelTextImage.visible
        height: 21
        width: textDescribtion.width + 11
        color: "#00ffffff"

        Rectangle{
            anchors.fill: parent
            color :"#ffffff"
            opacity: 0.7
        }

        Text {
            id: textDescribtion

            color: "#000000"
            font { family: "Arial"; bold: false; pixelSize: 12; letterSpacing: 0.4 }
            anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: 6 }
            text: currentItem ? Core.gamesListModel.shortDescribtion(currentItem.gameId) : qsTr("FREE_OF_CHARGE")
            smooth: true
        }
    }

    Text {
        id: labelTextImage

        anchors { top: parent.top; left: parent.left; topMargin: 20; }
        visible: textVisible
        font { family: "Segoe UI Light"; bold: false; pixelSize: 46 }
        smooth: true
        color: "#ffffff"
        text: currentItem ? currentItem.name : qsTr("ALL_GAMES")
    }

    Timer{
        id: timerGameNet

        property bool isGameNet: true

        interval: 5000
        running: currentItem != null
        repeat: true
        onTriggered: {
            if(currentItem != null)
                isGameNet =! isGameNet;
        }
    }

    Text{
        id: blockGameNet

        color: "#ffffff"
        text: "GameNet"
        visible: labelTextImage.visible && timerGameNet.isGameNet
        anchors { top: parent.top; left: labelTextImage.left; topMargin: 14 }
        font { family: "Arial"; bold: false; pixelSize: 14; }

        Elements.CursorMouseArea {

            anchors.fill: parent
            hoverEnabled: true
            onEntered: timerGameNet.stop();
            onClicked: mainAuthModule.openWebPage("http://www.gamenet.ru/");
            onExited: timerGameNet.start();
        }
    }
    Rectangle{
        id: blockAllGames

        visible: labelTextImage.visible && !timerGameNet.isGameNet
        anchors { top: parent.top; left: labelTextImage.left }
        anchors { topMargin: 14; leftMargin: -imageAllGames.width - 2 }
        width: imageAllGames.width + textAllGames.width
        height: Math.max(imageAllGames.height, textAllGames.height)
        color: "#00ffffff"

        Text{
            id: textAllGames

            anchors { left: parent.left; leftMargin: imageAllGames.width + 2 }
            color: "#ffffff"
            text: qsTr("ALL_GAMES")
            font { family: "Arial"; bold: false; pixelSize: 14; }
        }

        Image{
            id: imageAllGames

            source: installPath + "images/arrow.png"
            anchors { verticalCenter: textAllGames.verticalCenter }
        }

        Elements.CursorMouseArea {

            anchors.fill: parent
            hoverEnabled: true
            onEntered: timerGameNet.stop();
            onClicked: {
                homeButtonClicked();
                timerGameNet.isGameNet =! timerGameNet.isGameNet;
            }
            onExited: timerGameNet.start();
        }
    }
}
