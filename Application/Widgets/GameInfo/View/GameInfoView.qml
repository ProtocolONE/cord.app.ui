/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1
import Tulip 1.0
import GameNet.Controls 1.0
import GameNet.Components.Widgets 1.0

import "../../../Core/App.js" as App

WidgetView {
    id: root

    property int rotationTimeout: 5000
    property variant gameItem: App.currentGame()
    onGameItemChanged: {
        if (gameItem) {
            model.refreshGallery(gameItem.gameId);
        }
    }

    function update() {
        if (!root.gameItem) {
            return;
        }

        previewListModel.clear();
        d.index = 0;

        var items = model.getGallery(gameItem.gameId);

        for (var i = 0; i < items.length; i++){
            var newData = items[i];
            newData.index = i;

            previewListModel.append(newData);
        }

        if (previewListModel.count > 0) {
            d.switchAnimation();
        }
    }

    implicitWidth: 590
    implicitHeight: contentColumn.height

    clip: true

    Connections {
        target: model

        onInfoChanged: update();
    }

    QtObject {
        id: d

        property int index: 0

        onIndexChanged: listView.currentIndex = index;

        function changeIndex(newIndex) {
            if (d.index == newIndex) {
                return;
            }

            d.index = newIndex;
            switchAnimation();
        }

        function incrementIndex() {
            if (previewListModel.count == 0) {
                return;
            }

            if (d.index + 1 >= previewListModel.count) {
                d.index = 0;
            } else {
                d.index++;
            }

            switchAnimation();
        }

        function decrementIndex() {
            if (previewListModel.count == 0) {
                return;
            }

            if (d.index - 1 < 0) {
                d.index = previewListModel.count - 1;
            } else {
                d.index--;
            }

            switchAnimation();
        }

        function switchAnimation() {
            showNextTimer.stop();
            listView.currentItem.moveToItem();
            contentSwitcher.opacity = 1;
            contentSwitcher.switchToNext();
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#f0f5f8"
    }

    Column {
        id: contentColumn

        width: parent.width

        Column {
            width: parent.width
            height: previewListModel.count > 0 ? 390 : 0
            visible: previewListModel.count > 0
            spacing: 10

            Item {
                width: parent.width
                height: parent.height - 70

                Switcher {
                    id: contentSwitcher

                    property variant currentItem: content1

                    function switchToNext() {
                        var nextItem = previewListModel.get(d.index);
                        if (!nextItem) {
                            return;
                        }

                        if (currentItem === content1) {
                            content2.source = nextItem.source;
                            switchTo(content2);
                            currentItem = content2;
                            noInetTimeout.restart();
                        } else {
                            content1.source = nextItem.source;
                            switchTo(content1);
                            currentItem = content1;
                            noInetTimeout.restart();
                        }
                    }

                    anchors.fill: parent

                    Timer {
                        id: noInetTimeout

                        running: false
                        interval: 5000
                        repeat: false
                        onTriggered: {
                            if (contentSwitcher.currentItem.progress == 0) {
                                showNextTimer.restart();
                            }
                        }
                    }

                    WebImage {
                        id: content1

                        width: parent.width
                        height: parent.height
                        onStatusChanged: {
                            if (content1.status == Image.Ready) {
                                showNextTimer.restart();
                            }
                        }
                    }

                    WebImage {
                        id: content2

                        width: parent.width
                        height: parent.height
                        onStatusChanged: {
                            if (content2.status == Image.Ready) {
                                showNextTimer.restart();
                            }
                        }
                    }
                }

                ImageButton {
                    id: previousButton

                    width: 48
                    height: 48
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: 10
                    }
                    style: ButtonStyleColors {
                        normal: "#1ABC9C"
                        hover: "#019074"
                        disabled: "#1ABC9C"
                    }
                    styleImages: ButtonStyleImages {
                        normal: installPath + 'Assets/images/Application/Widgets/GameInfo/leftArrow.png'
                        hover: normal
                        disabled: normal
                    }
                    onClicked: {
                        showNextTimer.stop();
                        d.decrementIndex();
                    }
                }

                ImageButton {
                    id: nextButton

                    width: 48
                    height: 48
                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                        rightMargin: 14
                    }
                    style: ButtonStyleColors {
                        normal: "#1ABC9C"
                        hover: "#019074"
                        disabled: "#1ABC9C"
                    }
                    styleImages: ButtonStyleImages {
                        normal: installPath + 'Assets/images/Application/Widgets/GameInfo/rightArrow.png'
                        hover: normal
                        disabled: normal
                    }
                    onClicked: {
                        showNextTimer.stop();
                        d.incrementIndex();
                    }
                }


                WidgetContainer {
                    anchors {
                        bottom: parent.bottom
                    }

                    width: parent.width
                    height: 50

                    widget: 'Facts'
                }
            }

            Item {
                height: 70
                anchors {
                    left: parent.left
                    leftMargin: 10
                    right: parent.right
                    rightMargin: 10
                }

                WheelArea {
                    anchors.fill: parent
                    onVerticalWheel: {
                        var newValue = flickable.contentX - delta;

                        if (newValue < 0) {
                            newValue = 0;
                        }

                        if (newValue > flickable.contentWidth - width ) {
                            newValue = flickable.contentWidth - width;
                        }

                        flickable.contentX = newValue;
                    }
                }

                Flickable {
                    id: flickable

                    anchors.fill: parent
                    contentWidth: listView.width
                    boundsBehavior: Flickable.StopAtBounds

                    Behavior on contentX {
                        NumberAnimation {
                            id: contentAnimation
                            duration: 75
                        }
                    }
                    // TODO add acceleration

                    ListView {
                        id: listView

                        height: 60
                        width: (listView.count) * (80 + listView.spacing) - listView.spacing
                        cacheBuffer: width

                        interactive: false
                        orientation: ListView.Horizontal

                        model: ListModel {
                            id: previewListModel
                        }

                        spacing: 18

                        delegate: GameInfoDelegate {
                            function moveToItem() {
                                if (x + width > flickable.contentX + flickable.width) {
                                    flickable.contentX += (x + width) - (flickable.contentX + flickable.width);
                                }

                                if (x < flickable.contentX) {
                                    flickable.contentX = x;
                                }
                            }

                            hovered: index == listView.currentIndex ? 1 : 0
                            width: 80
                            height: 60

                            onClicked: d.changeIndex(index);
                        }
                    }
                }
            }
        }

        Item {
            width: parent.width
            height: aboutText.height + 30

            Text {
                id: aboutText

                wrapMode: Text.WordWrap
                y: 15

                anchors {
                    left: parent.left
                    leftMargin: 10
                    right: parent.right
                    rightMargin: 10
                }
                smooth: true
                clip: true
                font { family: "Verdana"; pixelSize: 14 }
                lineHeightMode: Text.FixedHeight
                lineHeight: 20
                maximumLineCount: 4
                textFormat: Text.PlainText
                text: root.gameItem ? root.gameItem.aboutGameText : ""
            }
        }

    }

    Timer {
        id: showNextTimer

        repeat: true
        interval: root.rotationTimeout
        triggeredOnStart: false
        onTriggered: d.incrementIndex();
    }
}
