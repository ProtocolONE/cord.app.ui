import QtQuick 2.4
import ProtocolOne.Core 1.0
import ProtocolOne.Components.Widgets 1.0
import ProtocolOne.Controls 1.0

import Application.Core 1.0
import "GameAdBannerView.js" as GameAdBannerView

WidgetView {
    id: root

    property int rotationTimeout: 5000
    property variant currentGameItem: App.currentGame()
    property int index
    property bool hasAds: false
    property bool initialized: false

    onCurrentGameItemChanged: {
        if (currentGameItem && initialized) {
            model.refreshAds(currentGameItem.serviceId);
        }
    }

    Component.onCompleted: {
        if (currentGameItem) {
            model.refreshAds(currentGameItem.serviceId);
        }
        initialized = true;
    }

    function update() {
        showNextTimer.stop();
        if (!root.currentGameItem) {
            return;
        }

        GameAdBannerView.filtered = model.getAds(currentGameItem.serviceId);
        d.banners = GameAdBannerView.filtered;

        root.index = 0;
        root.hasAds = GameAdBannerView.filtered.length > 0;

        if (root.hasAds) {
            switchAnimation();
        }
    }

    function decrementIndex() {
        if (GameAdBannerView.filtered.length == 0) {
            return;
        }

        root.index = (root.index == 0) ? (GameAdBannerView.filtered.length - 1) : (root.index - 1);
    }

    function incrementIndex() {
        if (GameAdBannerView.filtered.length == 0) {
            return;
        }

        root.index = (root.index + 1) % GameAdBannerView.filtered.length;
    }

    function switchToIndex(toIndex) {
        if (toIndex < 0 || toIndex > GameAdBannerView.filtered.length - 1) {
            return;
        }

        root.index = toIndex;
        switchAnimation();
    }

    function switchAnimation() {
        showNextTimer.stop();
        contentSwitcher.opacity = 1;
        contentSwitcher.switchToNext();
        if (GameAdBannerView.filtered.length > 1) {
            showNextTimer.restart()
        }
    }

    width: 590
    height: root.hasAds ? 150 : 0
    visible: root.hasAds
    clip: true

    QtObject {
        id: d

        property bool buttonsOver: previousButton.containsMouse || nextButton.containsMouse
        property variant banners
    }

    Connections {
        target: root.model || null
        onAdsChanged: update();
    }

    Switcher {
        id: contentSwitcher

        property variant currentItem: content1

        function switchToNext() {
            //  INFO: на всякий случай - если не задали поля для баннеров
            var textLabel = GameAdBannerView.filtered[root.index].description || "";
            var imageSource = GameAdBannerView.filtered[root.index].image;
            var bannerId = GameAdBannerView.filtered[root.index].id;

            if (currentItem === content1) {
                content2.source = imageSource;
                content2.text = textLabel;
                content2.bannerId = bannerId;
                switchTo(content2);
                currentItem = content2;
            } else {
                content1.source = imageSource;
                content1.text = textLabel;
                content1.bannerId = bannerId;
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
        onClicked: {
            if (GameAdBannerView.filtered.length == 0) {
                return;
            }

            App.openExternalUrlWithAuth(GameAdBannerView.filtered[root.index].link);
            Ga.trackEvent("GameAdBanner", "click", contentSwitcher.currentItem.bannerId);
        }

        //  HACK: работает только когда MouseArea (и соответственно контролы) лежат друг в друге
        ImageButton {
            id: previousButton

            visible: d.banners ? d.banners.length > 1 : false
            width: 24
            height: 24
            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
                leftMargin: 3
            }

            analytics {
                category: "GameAdBanner"
                action: "LeftArrow"
                label: contentSwitcher.currentItem.bannerId
            }

            style {
                normal: "#00000000"
                hover: "#00000000"
                disabled: "#00000000"
            }

            styleImages {
                normal: installPath + "Assets/Images/Application/Widgets/GameAdBanner/arrow_left.png"
                hover: installPath + "Assets/Images/Application/Widgets/GameAdBanner/arrow_left_hover.png"
                disabled: installPath + "Assets/Images/Application/Widgets/GameAdBanner/arrow_left.png"
            }

            onClicked: {
                showNextTimer.stop();

                decrementIndex();

                if (GameAdBannerView.filtered.length > 0) {
                    switchAnimation();
                }
            }
        }

        ImageButton {
            id: nextButton

            visible: d.banners ? d.banners.length > 1 : false
            width: 24
            height: 24
            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
                rightMargin: 3
            }

            analytics {
                category: "GameAdBanner"
                action: "RightArrow"
                label: contentSwitcher.currentItem.bannerId
            }

            style {
                normal: "#00000000"
                hover: "#00000000"
                disabled: "#00000000"
            }

            styleImages {
                normal: installPath + "Assets/Images/Application/Widgets/GameAdBanner/arrow_right.png"
                hover: installPath + "Assets/Images/Application/Widgets/GameAdBanner/arrow_right_hover.png"
                disabled: installPath + "Assets/Images/Application/Widgets/GameAdBanner/arrow_rigth.png"
            }

            onClicked: {
                showNextTimer.stop();

                incrementIndex();

                if (GameAdBannerView.filtered.length > 0) {
                    switchAnimation();
                }
            }
        }
    }

    Item {
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: 7
            rightMargin: 3
        }
        height: 8

        ListView {
            anchors.right: parent.right
            height: parent.height
            width: count * (12 + spacing)

            orientation: ListView.Horizontal
            spacing: 2
            interactive: false

            delegate: Item {
                width: 12
                height: 12

                Image {
                    source: root.index === index ?
                                installPath + "Assets/Images/Application/Widgets/GameAdBanner/crumb_active.png" :
                                crumbMouseArea.containsMouse ?
                                    installPath + "Assets/Images/Application/Widgets/GameAdBanner/crumb_hover.png" :
                                    installPath + "Assets/Images/Application/Widgets/GameAdBanner/crumb_inactive.png"
                }

                CursorMouseArea {
                    id: crumbMouseArea

                    anchors.fill: parent
                    onClicked: {
                        root.switchToIndex(index);
                        Ga.trackEvent("GameAdBanner", "pill " + index, currentGameItem.gaName)
                    }
                }
            }

            model: d.banners
        }
    }

    Timer {
        id: showNextTimer

        /*
          INFO У таймар появился баг, если в его onTriggered попытаться остановить / перезапустить таймер с repeat
          false то таймер не перезапустится.
        */
        repeat: true
        interval: root.rotationTimeout
        onTriggered: {
            incrementIndex();
            switchAnimation();
        }
    }
}
