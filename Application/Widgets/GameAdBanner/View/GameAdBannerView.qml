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

import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import "../../../Core/App.js" as App
import "GameAdBannerView.js" as GameAdBannerView

WidgetView {
    id: root

    property int rotationTimeout: 5000
    property variant currentGameItem: App.currentGame()
    property int index
    property bool hasAds: GameAdBannerView.filtered.length > 0

    function update() {
        if (!root.currentGameItem) {
            return;
        }

        GameAdBannerView.filtered = model.getAds(currentGameItem.gameId);

        root.index = 0;

        if (GameAdBannerView.filtered.length > 0) {
            switchAnimation();
        } else {
            switchToEmptyAnim.start();
        }
    }

    function decrementIndex() {
        root.index = (root.index == 0) ? (GameAdBannerView.filtered.length - 1) : (root.index - 1);
    }

    function incrementIndex() {
        root.index = (root.index + 1) % GameAdBannerView.filtered.length;
    }

    function switchAnimation() {
        showNextTimer.stop();
        contentSwitcher.switchToNext();
        if (GameAdBannerView.filtered.length > 1) {
            showNextTimer.restart()
        }
    }

    width: parent.width
    height: parent.height
    clip: true
    onCurrentGameItemChanged: {
        if (currentGameItem) {
            model.refreshAds(currentGameItem.gameId);
        }
    }

    QtObject {
        id: d

        property bool buttonsOver: previousButton.containsMouse || nextButton.containsMouse
    }

    Connections {
        target: model
        onAdsChanged: update();
    }

    Switcher {
        id: contentSwitcher

        property variant currentItem: content1

        function switchToNext() {
            //  INFO: на всякий случай - если не задали поля для баннеров
            var textLabel = GameAdBannerView.filtered[root.index].description || "";
            var imageSource = GameAdBannerView.filtered[root.index].imageQgna
                                    || GameAdBannerView.filtered[root.index].image || "";

            if (currentItem === content1) {
                content2.setContent(imageSource, textLabel);
                switchTo(content2);
                currentItem = content2;
            } else {
                content1.setContent(imageSource, textLabel);
                switchTo(content1);
                currentItem = content1;
            }
        }

        BannerItem {
            id: content1
            width: root.width
            height: root.height
        }

        BannerItem {
            id: content2
            width: root.width
            height: root.height
        }
    }

    MouseArea {
        id: mouseArea

        hoverEnabled: true
        anchors.fill: parent
        onClicked: App.openExternalUrl(GameAdBannerView.filtered[root.index].link);

        //  HACK: работает только когда MouseArea (и соответственно контролы) лежат друг в друге
        ImageButton {
            id: previousButton

            visible: (mouseArea.containsMouse || d.buttonsOver) && GameAdBannerView.filtered.length > 1
            width: 24
            height: 24
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
                normal: installPath + "Assets/Images/Application/Widgets/GameAdBanner/arrow_left.png"
                hover: installPath + "Assets/Images/Application/Widgets/GameAdBanner/arrow_left.png"
                disabled: installPath + "Assets/Images/Application/Widgets/GameAdBanner/arrow_left.png"
            }
            onClicked: {
                showNextTimer.stop();

                decrementIndex();

                if (GameAdBannerView.filtered.length > 0) {
                    switchAnimation();
                } else {
                    switchToEmptyAnim.start();
                }
            }
        }

        ImageButton {
            id: nextButton

            visible: (mouseArea.containsMouse || d.buttonsOver) && GameAdBannerView.filtered.length > 1
            width: 24
            height: 24
            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
                rightMargin: 10
            }
            style: ButtonStyleColors {
                normal: "#1ABC9C"
                hover: "#019074"
                disabled: "#1ABC9C"
            }
            styleImages: ButtonStyleImages {
                normal: installPath + "Assets/Images/Application/Widgets/GameAdBanner/arrow_right.png"
                hover: installPath + "Assets/Images/Application/Widgets/GameAdBanner/arrow_right.png"
                disabled: installPath + "Assets/Images/Application/Widgets/GameAdBanner/arrow_rigth.png"
            }
            onClicked: {
                showNextTimer.stop();

                incrementIndex();

                if (GameAdBannerView.filtered.length > 0) {
                    switchAnimation();
                } else {
                    switchToEmptyAnim.start();
                }
            }
        }
    }

    Timer {
        id: showNextTimer

        repeat: false
        interval: root.rotationTimeout
        onTriggered: {
            incrementIndex();
            switchAnimation();
        }
    }

    SequentialAnimation {
        id: switchToEmptyAnim

        ScriptAction { script: showNextTimer.stop() }
        NumberAnimation { target: contentSwitcher; property: "opacity"; to: 0; duration: 250 }
    }
}
