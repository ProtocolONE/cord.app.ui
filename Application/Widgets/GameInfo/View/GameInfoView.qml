import QtQuick 2.4
import Tulip 1.0
import GameNet.Core 1.0
import GameNet.Controls 1.0
import GameNet.Components.Widgets 1.0

import Application.Controls 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0
import Application.Core.Settings 1.0

WidgetView {
    id: root

    property variant gameItem: App.currentGame()

    onGameItemChanged: {
        if (gameItem) {
            updateGallery.restart()
        }
    }

    function update() {
        if (!root.gameItem) {
            return;
        }

        var autoPlay = AppSettings.isAppSettingsEnabled('gameInfo', 'autoPlay', true),
            items = model.getGallery(gameItem.gameId),
            index = 0,
            i;

        previewListModel.clear();
        for (i = 0; i < items.length; i++){
            items[i].index = i;
            previewListModel.append(items[i]);
        }

        if (items[0].type === 1 && autoPlay == false) {
            for (i = 1; i < items.length; i++){
                if (items[i].type === 0) {
                    index = i;
                    break;
                }
            }
        }


        d.index = index;
        listView.forceLayout();

        if (previewListModel.count > 0) {
            d.switchAnimation();
        }
    }

    implicitWidth: 590
    implicitHeight: contentColumn.height

    clip: true

    Timer {
        id: updateGallery

        interval: 0
        onTriggered: model.refreshGallery(gameItem.gameId);
    }

    Connections {
        target: model
        onInfoChanged: update();
    }

    QtObject {
        id: d

        property int index

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
            if (listView.currentItem) {
                listView.currentItem.moveToItem();
            }
            contentSwitcher.switchToNext();
        }
    }

    ContentBackground {}

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

                Item {
                    id: contentSwitcher

                    width: parent.width
                    height: parent.height

                    WebImage {
                        id: content

                        anchors.fill: parent
                        cache: false
                        asynchronous: true
                    }

                    VideoPlayer {
                        id: video

                        Connections {
                            target: SignalBus
                            onServiceStarted: video.pause();
                            onHideMainWindow: video.pause();
                        }

                        anchors.fill: parent
                        onAutoPlayChanged: AppSettings.setAppSettingsValue('gameInfo', 'autoPlay', video.autoPlay|0)
                        onVolumeChanged: AppSettings.setAppSettingsValue('gameInfo', 'volume', video.volume)
                        Component.onCompleted: {
                            var volume = AppSettings.appSettingsValue('gameInfo', 'volume', -1);
                            video.volume = (volume === -1) ? 0 : volume;
                            video.autoPlay = AppSettings.isAppSettingsEnabled('gameInfo', 'autoPlay', 1);
                        }
                    }

                    Image {
                        id: image

                        anchors.fill: parent
                        opacity: 0
                        visible: opacity > 0
                    }

                    NumberAnimation {
                        id: transition

                        target: image
                        property: 'opacity'
                        from: 1
                        to: 0
                        duration: 250
                    }

                    function switchToNext() {
                        var nextItem = previewListModel.get(d.index);
                        if (!nextItem) {
                            return;
                        }

                        contentSwitcher.grabToImage(function(result) {
                            image.source = result.url;

                            if (nextItem.type === 0) {
                                content.source = nextItem.source;
                                content.visible = true;
                                video.source = '';
                                video.visible = false;
                            } else {
                                video.source = nextItem.source;
                                video.visible = true;
                                content.source = '';
                                content.visible = false;
                            }
                            transition.start()
                        },
                        Qt.size(image.width, image.height))
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
                    height: parent.height - 120
                    imageAnchors.horizontalCenterOffset: -4
                    anchors {verticalCenter: parent.verticalCenter; left: parent.left}
                    style {normal: "#00000000"; hover: "#00000000"; disabled: "#00000000"}
                    styleImages {
                        normal: previousButton.containsMouse || hoverArea.containsMouse ?
                                    installPath + 'Assets/images/Application/Widgets/GameInfo/leftArrowHover.png' :
                                    installPath + 'Assets/images/Application/Widgets/GameInfo/leftArrow.png'
                        /*
                          INFO теперь есть ховер на весь виджет, и по новому дизайну, ховер на весь виджет, должен
                          подсвечивать и кнопки, поэтому пришлось написать так.
                          */
                        hover: previousButton.styleImages.normal
                        disabled: previousButton.styleImages.normal
                    }
                    analytics {
                        category: 'GameInfo'
                        action: 'LeftArrow'
                    }

                    onClicked: d.decrementIndex();
                }

                ImageButton {
                    id: nextButton

                    width: edgeRightImage.width
                    height: parent.height - 120
                    anchors {verticalCenter: parent.verticalCenter; right: parent.right}
                    imageAnchors.horizontalCenterOffset: 4
                    style {normal: "#00000000"; hover: "#00000000"; disabled: "#00000000"}
                    styleImages {
                        normal: nextButton.containsMouse || hoverArea.containsMouse ?
                                    installPath + 'Assets/images/Application/Widgets/GameInfo/rightArrowHover.png' :
                                    installPath + 'Assets/images/Application/Widgets/GameInfo/rightArrow.png'
                        /*
                          INFO теперь есть ховер на весь виджет, и по новому дизайну, ховер на весь виджет, должен
                          подсвечивать и кнопки, поэтому пришлось написать так.
                          */
                        hover: nextButton.styleImages.normal
                        disabled: nextButton.styleImages.normal
                    }

                    analytics {
                        category: 'GameInfo'
                        action: 'RightArrow'
                    }

                    onClicked: d.incrementIndex();
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

                    model: ListModel {
                        id: previewListModel
                    }

                    interactive: false
                    orientation: ListView.Horizontal

                    onCurrentIndexChanged: {
                        previousButton.analytics.label = currentItem.preview || '';
                        nextButton.analytics.label = currentItem.preview || '';
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
                            Ga.trackEvent('GameInfo', 'preview click', preview);
                            d.changeIndex(index);
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
                y: 17

                anchors {
                    left: parent.left
                    leftMargin: 10
                    right: parent.right
                    rightMargin: 10
                }

                color: Styles.infoText
                smooth: true
                clip: true
                font {
                    family: "Open Sans Regular"
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

    ContentStroke {
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            leftMargin: 10
            rightMargin: 10
        }
    }
}
