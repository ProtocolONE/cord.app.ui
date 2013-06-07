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
import "../Models" as Models
import "../Elements" as Elements
import "../Delegates" as Delegates
import "../Blocks" as Blocks

import "../js/Core.js" as Core
import "../js/GoogleAnalytics.js" as GoogleAnalytics

Item {
    id: cHome

//    width: Core.clientWidth
//    height: 400
//    Item {
//        id: mainWindow
//        property string emptyString: ""
//        signal torrentListenPortChanged();
//        signal downloadButtonStartSignal();
//    }

//    property string installPath: "../"


    focus: true

    signal finishAnimation()
    signal mouseItemClicked(variant item)

    function closeAnimationStart() {
        closeHomeAnimation.start();
    }

    NumberAnimation { id: closeHomeAnimation; easing.type: Easing.OutQuad; target: cHome; property: "opacity"; from: 1; to: 0; duration: 150 }

    Connections {
        target: mainWindow
        onDownloadButtonStartSignal: {
            var item = Core.serviceItemByServiceId(serviceId);
            mouseItemClicked(item);
        }
    }

    Item {
        anchors { left: parent.left; right: parent.right; top: parent.top }
        height: 86

        Rectangle {
            color: "#000000"
            height: 86
            width: parent.width
            opacity: 0.4
        }

        Item {
            anchors { fill: parent; leftMargin: 30 }

            Item {
                anchors { top: parent.top; left: gameTitle.left }
                anchors { topMargin: 12; leftMargin: gameTitle.width * 0.7 }
                visible: gameTitle.visible
                height: 21
                width: textDescribtion.width + 11

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
                    text: qsTr("FREE_OF_CHARGE")
                    smooth: true
                }
            }

            Text {
                id: gameTitle

                anchors { top: parent.top; topMargin: 20 }
                font { family: "Segoe UI Light"; bold: false; pixelSize: 46 }
                smooth: true
                color: "#ffffff"
                text: qsTr("ALL_GAMES")
            }

            Text{
                id: blockGameNet

                color: "#ffffff"
                text: "GameNet"
                anchors { top: parent.top; topMargin: 14 }
                font { family: "Arial"; bold: false; pixelSize: 14; }

                Elements.CursorMouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: mainAuthModule.openWebPage("http://www.gamenet.ru/");
                }
            }
        }
    }

    Elements.FlowView {
        anchors { fill: parent; leftMargin: 46; topMargin: 109 }
        width: 700
        height: 550
        delegate: Delegates.GameIconDelegate {
            model: model
            onMouseClicked: {
                GoogleAnalytics.trackEvent('/Home', 'Navigation', 'Switch To Game ' + item.gaName, 'Flow Image');
                mouseItemClicked(item)
            }
        }

        model: Core.gamesListModel
    }
}
