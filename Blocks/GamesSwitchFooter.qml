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
import "../js/GameListModelHelper.js" as GameListModelHelper
import "../js/GoogleAnalytics.js" as GoogleAnalytics
import "../Models" as Models

Item {
    id: footer

    property variant currentGameItem

    signal itemClicked(variant item);
    signal goHomeRequest();
    signal openUrlRequest(string url);

    implicitHeight: 52
    implicitWidth: 800

    QtObject {
        id: d

        signal startShake();
    }

    Text {
        anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: 17 }
        text: qsTr("OTHER_GAMES")
        color: otherGameMouser.containsMouse ? "#cbcbcb" : "#9b9b9b"
        font { family: "Arial"; pixelSize: 18; bold: true }

        Elements.CursorMouseArea {
            id: otherGameMouser

            anchors.fill: parent
            hoverEnabled: true
            onEntered: d.startShake();
            onClicked: footer.goHomeRequest();
        }
    }

    Item {
        width: miniListView.count * 30 + 22
        anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom; top: parent.top }

        ListView {
            id: miniListView

            anchors { fill: parent; verticalCenter: parent.verticalCenter }
            interactive: false
            model: gamesListModel
            orientation: ListView.Horizontal
            highlightFollowsCurrentItem: true
            spacing: 10
            contentHeight: 46

            delegate: Item {
                id: delegate

                property bool isSelectedItem : footer.currentGameItem != undefined &&
                                               footer.currentGameItem.serviceId == serviceId

                property int shakeAngel: 20


                function someSize() {
                    if (isSelectedItem && serviceId != "300003010000000000" && serviceId != "300002010000000000")
                        return 20

                    if (serviceId == "300003010000000000") {
                        return isSelectedItem ? 42 : 30
                    }

                    if (serviceId == "300002010000000000") {
                        if (footer.currentGameItem != undefined && footer.currentGameItem.serviceId == "300003010000000000") {
                            return 30
                        } else {
                            return isSelectedItem ? 42 : 20
                        }
                    }

                    return 20;
                }

                function showImage() {
                    return true;
                    if (serviceId == "300003010000000000") {
                        return true;
                    }

                    if (serviceId == "300002010000000000") {
                        if (isSelectedItem || footer.currentGameItem != undefined && footer.currentGameItem.serviceId == "300003010000000000") {
                            return true;
                        }
                    }

                    return false
                }

                function startShake() {
                    shake.start();
                }

                width: someSize()
                height: someSize()

                anchors.verticalCenter: parent.verticalCenter

                Component.onCompleted: d.startShake.connect(delegate.startShake);

                Behavior on width {
                    NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
                }

                Behavior on height {
                    NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
                }

                SequentialAnimation {
                    id: shake

                    NumberAnimation { target: delegate; property: "rotation"; from: 0; to: shakeAngel; duration: 50; easing.type: Easing.InOutQuad }
                    NumberAnimation { target: delegate; property: "rotation"; from: shakeAngel; to: -shakeAngel; duration: 50; easing.type: Easing.InOutQuad }
                    NumberAnimation { target: delegate; property: "rotation"; from: -shakeAngel; to: 0; duration: 50; easing.type: Easing.InOutQuad }
                }

                Image {
                    anchors.fill: parent
                    visible: showImage()
                    source: installPath + imageMini
                }

                Rectangle {
                    anchors { fill: parent; rightMargin: 1; bottomMargin: 1 }
                    border {
                        width: 1;

                        color: shake.running || (delegateMouser.containsMouse && !isSelectedItem)
                               ? "#FFFFFF"
                               //:(isSelectedItem && (serviceId == "300003010000000000" || serviceId == "300002010000000000")? "#FF7F27" : "#797979")
                                 :(isSelectedItem ? "#FF7F27" : "#797979")

                        Behavior on color {
                            ColorAnimation { duration: 300 }
                        }
                    }

                    color: "#00000000"
//                    color: delegate.isSelectedItem
//                           ? ((serviceId == "300003010000000000" || serviceId == "300002010000000000") ? "#00000000" : "#666666" )
//                           : "#00000000"
                }

                Elements.CursorMouseArea {
                    id: delegateMouser

                    anchors.fill: parent

                    toolTip: gamesListModel.miniToolTip(gameId)
                    onClicked: footer.itemClicked(GameListModelHelper.serviceItemByIndex(index));
                }
            }

        }
    }

    Row {
        anchors { top: parent.top; bottom: parent.bottom; right: parent.right; rightMargin: 20 }
        layoutDirection: Qt.RightToLeft
        spacing: 10

        Elements.ImageButton {
            width: 34
            height: 32
            opacityHover: true
            anchors { verticalCenter: parent.verticalCenter; }
            source: installPath + "images/Blocks/GameSwitchFooter/gamenet.png"

            toolTip: qsTr("GAMENET_ICON_TOOLTIP")
            onClicked: {
                if (qGNA_main.currentGameItem) {
                    GoogleAnalytics.trackEvent('/game/' + qGNA_main.currentGameItem.gaName,
                                           'Open External Link', 'Gamenet', 'Footter');
                }

                footer.openUrlRequest("http://www.gamenet.ru");
            }
        }

        Item {
            width: 1
            height: 1
        }

        Text {
            anchors { verticalCenter: parent.verticalCenter; }
            text: qsTr("GAMENET_MONEY_LINK")
            color: "#cbcbcb"
            font { underline: true; family: "Arial"; pixelSize: 18; bold: true }

            Elements.CursorMouseArea {
                anchors.fill: parent
                onClicked: {
                    if (qGNA_main.currentGameItem) {
                        GoogleAnalytics.trackEvent('/game/' + qGNA_main.currentGameItem.gaName,
                                                   'Open External Link', 'Money', 'Footter');
                    }

                    footer.openUrlRequest("http://www.gamenet.ru/money");
                }
            }
        }
    }
}
