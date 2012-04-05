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

Rectangle {
    // HACK
    //property string installPath: "../"

    id: bigButtonRectangle

    property int progressPercent: -1
    property bool allreadyDownloaded: false
    property bool startDownloading: false
    property bool isPause: false
    property bool isError: false
    property bool isStarted: false
    property bool isMouseAreaAccepted: true
    property color textColor: isError ? "#ff2828" : isPause ? "#ffb900" : "#33cc00"
    property int textSize: 28

    property string buttonText
    property string buttonPauseText
    property string buttonErrorText
    property string buttonDownloadText
    property string buttonDownloadedText

    property Gradient buttonActiveGradient: Gradient {
        GradientStop { position: 1; color: "#177e00" }
        GradientStop { position: 0; color: "#32b003" }
    }

    property Gradient buttonNormalGradient: Gradient {
        GradientStop { position: 1; color: "#227700" }
        GradientStop { position: 0; color: "#227700" }
    }

    property Gradient buttonStartedGradient: Gradient {
        GradientStop { position: 1; color: "#a4a4a4" }
        GradientStop { position: 0; color: "#545454" }
    }

    property Gradient buttonNormalReverseGradient: Gradient {
        GradientStop { position: 0; color: "#4db523" }
        GradientStop { position: 1; color: "#237c00" }
    }

    property Gradient nullGradient: Gradient {
        GradientStop { position: 0; color: "#00000000" }
    }

    signal buttonClicked();

    color: "#00000000"
    width: 155
    height: 55
    border { color: "#ffffff"; width: 1 }

    Component {
        id: progressItem

        Item {
            Image {
                id: lightImage

                anchors.left: parent.left
                source: installPath + "images/lighting3.png"
            }

            SequentialAnimation {
                running: lightImage.visible
                loops: Animation.Infinite

                ParallelAnimation {
                    PropertyAnimation { target: lightImage; property: "opacity"; from: 0; to: 1 ; duration: 100 }
                    PropertyAnimation { target: lightImage; property: "width"; from: 0; to: bigButtonRectangle.width; duration: 1500 }
                }

                PropertyAnimation {target: lightImage;  property: "opacity"; from: 1; to: 0 ; duration: 200 }
            }
        }
    }

    Loader {
        sourceComponent: progressItem;
        z: 1
        anchors { top: parent.top; topMargin: -2; }
        visible: startDownloading && !isPause && !isError && !allreadyDownloaded;
    }

    Loader {
        sourceComponent: progressItem;
        z: 1
        anchors { bottom: parent.bottom; bottomMargin: 2;}
        visible: startDownloading && !isPause && !isError && !allreadyDownloaded;
    }

    Rectangle {
        id: gradientRectangle

        anchors { fill: parent; topMargin: 1; leftMargin: 1 }
        gradient: isStarted ? buttonStartedGradient :
                              (!startDownloading && bigButtonMouseArea.containsMouse)
                              ? buttonNormalGradient : buttonNormalReverseGradient;
        opacity: isStarted ? 0.8 : 1
        visible: progressPercent <= 0 || progressPercent >= 100 //!startDownloading || progressPercent >= 0 || progressPercent <= 100
    }


    Rectangle {
        visible: progressPercent >= 0 && progressPercent < 100
        color: isError ? "#cc0000" : isPause ? "#cba80d" : "#339900"
        anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
        anchors { topMargin: 1; leftMargin: 1 }
        width: ((parent.width - 1) / 100) * progressPercent
    }

    Text {
        id: buttonTextId

        opacity: isStarted ? 0.8 : 1
        text: isPause ? buttonPauseText
                      : allreadyDownloaded ? buttonDownloadedText
                                           : isError ? buttonErrorText
                                                     : startDownloading ? buttonDownloadText
                                                                        : buttonText
        color: "#ffffff"
        font { family: "Segoe UI Light"; weight: Font.Light; pixelSize: textSize }
        anchors.centerIn: parent
    }

    Elements.CursorMouseArea {
        id: bigButtonMouseArea

        visible: isMouseAreaAccepted && !isStarted
        anchors.fill: parent
        hoverEnabled: true
        onClicked: buttonClicked();
    }
}
