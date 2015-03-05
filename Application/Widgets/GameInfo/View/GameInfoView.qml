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
import "../../../Core/Styles.js" as Styles
import "../../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics

WidgetView {
    id: root

    property int rotationTimeout: 5000
    property variant gameItem: App.currentGame()

    onGameItemChanged: {
        if (gameItem) {
            model.refreshGallery(gameItem.gameId);
        }
    }

    Component.onCompleted: {
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
        color: Styles.style.gameInfoImageBackground
    }

    Column {
        id: contentColumn

        width: parent.width

        Column {
            width: parent.width
            height: previewListModel.count > 0 ? 390 : 0
            visible: previewListModel.count > 0
            spacing: 2

            Item {
                width: parent.width
                height: parent.height - 60

                MouseArea {
                    id: hoverArea

                    anchors.fill: parent
                    hoverEnabled: true
                }

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
                        cache: false
                        asynchronous: true

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
                        cache: false
                        asynchronous: true

                        onStatusChanged: {
                            if (content2.status == Image.Ready) {
                                showNextTimer.restart();
                            }
                        }
                    }
                }

                Image {
                    id: edgeLeftImage

                    anchors.left: parent.left
                    source: installPath + 'Assets/images/Application/Widgets/GameInfo/leftEdgeHover.png'
                    visible: previousButton.containsMouse || nextButton.containsMouse || hoverArea.containsMouse
                }

                Image {
                    id: edgeRightImage

                    anchors.right: parent.right
                    source: installPath + 'Assets/images/Application/Widgets/GameInfo/rightEdgeHover.png'
                    visible: previousButton.containsMouse || nextButton.containsMouse || hoverArea.containsMouse
                }

                ImageButton {
                    id: previousButton

                    width: edgeLeftImage.width
                    height: parent.height
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                    }
                    imageAnchors.horizontalCenterOffset: -4

                    style: ButtonStyleColors {
                        normal: "#00000000"
                        hover: "#00000000"
                        disabled: "#00000000"
                    }
                    styleImages: ButtonStyleImages {
                        normal: previousButton.containsMouse || hoverArea.containsMouse ?
                                    installPath + 'Assets/images/Application/Widgets/GameInfo/leftArrowHover.png' :
                                    installPath + 'Assets/images/Application/Widgets/GameInfo/leftArrow.png'
                        /*
                          INFO теперь есть ховер на весь виджет, и по новому дизайну, ховер на весь виджет, должен
                          подсвечивать и кнопки, поэтому пришлось написать так.
                          */
                        hover: normal
                        disabled: normal
                    }
                    analytics: GoogleAnalyticsEvent {
                        page: '/GameInfo/' + (root.gameItem ? root.gameItem.gaName : '')
                        category: 'PreviousButton'
                        action: 'Click'
                        label: previewListModel.count > 0 ? previewListModel.get(d.index).preview : ''
                    }

                    onClicked: {
                        showNextTimer.stop();
                        d.decrementIndex();
                    }
                }

                ImageButton {
                    id: nextButton

                    width: edgeRightImage.width
                    height: parent.height
                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                    }
                    imageAnchors.horizontalCenterOffset: 4
                    style: ButtonStyleColors {
                        normal: "#00000000"
                        hover: "#00000000"
                        disabled: "#00000000"
                    }
                    styleImages: ButtonStyleImages {
                        normal: nextButton.containsMouse || hoverArea.containsMouse ?
                                    installPath + 'Assets/images/Application/Widgets/GameInfo/rightArrowHover.png' :
                                    installPath + 'Assets/images/Application/Widgets/GameInfo/rightArrow.png'
                        /*
                          INFO теперь есть ховер на весь виджет, и по новому дизайну, ховер на весь виджет, должен
                          подсвечивать и кнопки, поэтому пришлось написать так.
                          */
                        hover: normal
                        disabled: normal
                    }
                    analytics: GoogleAnalyticsEvent {
                        page: '/GameInfo/' + (root.gameItem ? root.gameItem.gaName : '')
                        category: 'NextButton'
                        action: 'Click'
                        label: previewListModel.count > 0 ? previewListModel.get(d.index).preview : ''
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
                height: 60
                anchors {
                    left: parent.left
                    leftMargin: 1
                    right: parent.right
                    rightMargin: 1
                }

                WheelArea {
                    anchors.fill: parent
                    onVerticalWheel: {
                        var newValue = listView.contentX - delta;

                        if (newValue < 0) {
                            newValue = 0;
                        }

                        if (newValue > listView.contentWidth - listView.width ) {
                            newValue = listView.contentWidth - listView.width;
                        }

                        listView.contentX = newValue;
                    }
                }

                ListView {
                    id: listView

                    height: 60
                    width: parent.width
                    cacheBuffer: width
                    boundsBehavior: Flickable.StopAtBounds

                    Behavior on contentX {
                        NumberAnimation {
                            id: contentAnimation
                            duration: 75
                        }
                    }

                    interactive: false
                    orientation: ListView.Horizontal

                    model: ListModel {
                        id: previewListModel
                    }

                    spacing: 2

                    delegate: GameInfoDelegate {
                        function moveToItem() {
                            if (index == listView.count - 1) {
                                listView.contentX = x - listView.width + width;
                                return;
                            }

                            if (index == 0) {
                                listView.contentX = x;
                                return;
                            }

                            if (x + width * 1.5 > listView.contentX + listView.width) {
                                listView.contentX += (x + width * 1.5) - (listView.contentX + listView.width);
                            }

                            if (x < listView.contentX) {
                                listView.contentX = x - width / 2;
                            }
                        }

                        hovered: index == listView.currentIndex ? 1 : 0
                        width: 106
                        height: 60

                        onClicked: {
                            GoogleAnalytics.trackEvent('/GameInfo/' + root.gameItem.gaName,
                                                       "MiniImage",
                                                       "Click",
                                                       preview);
                            d.changeIndex(index);
                        }
                    }
                }
            }
        }

        Item {
            width: parent.width
            height: aboutText.height + 30

            Rectangle {
                anchors {
                    fill: parent
                    topMargin: 3
                }

                color: Styles.style.gameInfoBackground
            }

            Text {
                id: aboutText

                wrapMode: Text.WordWrap
                y: 17

                anchors {
                    left: parent.left
                    leftMargin: 10
                    right: parent.right
                    rightMargin: 10
                }
                color: Styles.style.gameInfoAboutText
                smooth: true
                clip: true
                font {
                    family: "Myriad"
                    pixelSize: 15
                }
                lineHeightMode: Text.FixedHeight
                lineHeight: 20
                maximumLineCount: 4
                textFormat: Text.PlainText
                text: root.gameItem ? root.gameItem.aboutGame : ""
            }
        }
    }

    Rectangle {
        height: 1
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
        color: Qt.darker(Styles.style.gameInfoBackground, Styles.style.darkerFactor)
    }

    Timer {
        id: showNextTimer

        repeat: true
        interval: root.rotationTimeout
        triggeredOnStart: false
        onTriggered: d.incrementIndex();
    }
}
