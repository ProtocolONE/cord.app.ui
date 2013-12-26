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
import Tulip 1.0

import "Private" as Private
import "../../Proxy" as Proxy
import "../../Elements" as Elemetns

import "../../js/Core.js" as Core
import "../../js/GoogleAnalytics.js" as GoogleAnalytics

Item {
    id: root

    signal backgroundMousePressed(int mouseX, int mouseY);
    signal backgroundMousePositionChanged(int mouseX, int mouseY);

    function show() {
        if (!inner.isAllowToShowHelp) {
            return;
        }

        if (inner.isWellcomeMustBeShown) {
            inner.isWellcomeMustBeShown = false;
            root.state = 'firstEnter';
            inner.currentIndex = -1;
        } else {
            root.state = 'guideShow';
        }

        inner.showNext();

        GoogleAnalytics.trackEvent('/', 'Guide', root.state);
    }

    implicitWidth: Core.clientWidth
    implicitHeight: Core.clientHeight
    state: 'closed'

    onStateChanged: {
        if (state == 'closed')  {
            sound.stop();
            nextEntryTimer.stop();
        }
    }

    Component.onCompleted: inner.init();

    QtObject {
        id: inner

        property bool isSoundEnabled: true
        property bool isVisible: false
        property bool isAllowToShowHelp: false
        property bool isWellcomeMustBeShown: true
        property int currentIndex: -1
        property int maxIndex: 8
        property variant durations: {
            1: 11000,
            2: 8000,
            3: 7000,
            4: 7000,
            5: 8000,
            6: 11000,
            7: 5000,
            8: 4000
        };

        function showNext() {
            if (inner.currentIndex < inner.maxIndex) {
                ++inner.currentIndex;
                nextEntryTimer.next();
            }
        }

        function showPrev() {
            if (inner.currentIndex > 1) {
                --inner.currentIndex;
                nextEntryTimer.next();
            }
        }

        function markAsRefuseHelp() {
            Settings.setValue("qml/features/guide/", "showCount", 1);
        }

        function markAsShown() {
            Settings.setValue("qml/features/guide/", "showCount", 2);
        }

        function init() {
            var showCount = Settings.value("qml/features/guide/", "showCount", 0) |0;
            inner.isAllowToShowHelp = (showCount == 0);
        }
    }

    MouseArea {
        id: backMouser

        anchors.fill: parent
        hoverEnabled: true

        onPressed: backgroundMousePressed(mouseX, mouseY);
        onPositionChanged: {
            if (pressedButtons & Qt.LeftButton === Qt.LeftButton) {
                backgroundMousePositionChanged(mouseX, mouseY);
            }
        }
    }

    Timer {
        id: nextEntryTimer

        function next() {
            if (!!inner.durations[inner.currentIndex]) {
                nextEntryTimer.interval = inner.durations[inner.currentIndex];
                nextEntryTimer.restart();
            }
        }

        onTriggered: delayTimer.start();
    }

    Timer {
        id: delayTimer

        interval: 250
        onTriggered: {
            if (inner.currentIndex == inner.maxIndex) {
                inner.markAsShown();
                root.state = 'closed';
                return;
            }

            inner.showNext();
        }
    }

    Item {
        id: background

        anchors.fill: parent

        Image {
            function imagePath(index) {
                if (index < 0) {
                    return '';
                }

                return installPath + 'images/Features/Guide/static/' + index + '.png';
            }

            anchors.fill: parent
            source: imagePath(inner.currentIndex);
        }
    }

    Proxy.Player {
        id: sound

        function soundPath(index) {
            if (index < 0) {
                return '';
            }

            return installPath + '/Sounds/Features/Guide/' + index + '.wma';
        }

        volume: inner.isSoundEnabled ? 1 : 0
        source: soundPath(inner.currentIndex)

        Behavior on volume {
            NumberAnimation { duration: 300 }
        }
    }


    Row {
        id: controlls

        opacity: 0
        spacing: 5
        anchors { right: parent.right; top: parent.top; rightMargin: 255; topMargin: 192 }

            Private.ImageButton {
                rotation: 180
                source: installPath + 'images/Features/Guide/arrow.png'
                toolTip: qsTr('BUTTON_PREV')
                enabled: inner.currentIndex > 1
                onClicked: {
                    inner.showPrev();
                    GoogleAnalytics.trackEvent('/', 'Guide', 'showPrev', inner.currentIndex.toString());
                }
            }

            Private.ImageButton {
                source: installPath + 'images/Features/Guide/arrow.png'
                toolTip: qsTr('BUTTON_NEXT')
                enabled: inner.currentIndex < inner.maxIndex
                onClicked: {
                    inner.showNext();
                    GoogleAnalytics.trackEvent('/', 'Guide', 'showNext', inner.currentIndex.toString());
                }
            }

        Private.ImageButton {
            source: inner.isSoundEnabled
                ? installPath + 'images/Features/Guide/soundOff.png'
                : installPath + 'images/Features/Guide/soundOn.png'

            toolTip: inner.isSoundEnabled
                ? qsTr('BUTTON_DISABLE_SOUND')
                : qsTr('BUTTON_ENABLE_SOUND')

            onClicked: {
                inner.isSoundEnabled = !inner.isSoundEnabled;
                GoogleAnalytics.trackEvent('/', 'Guide', 'sound', inner.isSoundEnabled.toString());
            }
        }

        Private.ImageButton {
            source: installPath + 'images/Features/Guide/close.png'

            toolTip: qsTr('BUTTON_CLOSE_GUIDE')

            onClicked: {
                root.state = 'closed';
                GoogleAnalytics.trackEvent('/', 'Guide', 'closet');
            }
        }
    }

    Rectangle {
        id: wellcomePage

        property int closeInterval: 15000

        color: '#00000000'
        anchors.fill: parent

        Image {
            anchors.fill: parent
            source: installPath + 'images/Features/Guide/static/0.png';
        }

        Column {
            spacing: 28
            anchors { horizontalCenter: parent.horizontalCenter; top: parent.top; topMargin: 110 }

            Image {
                source: installPath + 'images/Features/Guide/logo.png'
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                horizontalAlignment: Text.AlignHCenter
                text: qsTr('GUIDE_WELLCOME')
                color: "#f0f0dc"
                font.pixelSize: 18
                wrapMode: Text.WordWrap
                width: 377
            }

            Row {
                spacing: 10
                anchors.horizontalCenter: parent.horizontalCenter

                Elemetns.Button3 {
                    buttonText: qsTr('GUIDE_BUTTON_OK')
                    buttonHighlightColor: "#413c37"
                    onButtonClicked: {
                        inner.markAsShown();
                        root.show();
                        GoogleAnalytics.trackEvent('/', 'Guide', 'acceptGuide');
                    }
                }

                Elemetns.Button3 {
                    buttonText: qsTr('GUIDE_BUTTON_REFUSE')
                    buttonHighlightColor: "#413c37"
                    onButtonClicked: {
                        root.state = "closed";
                        inner.markAsRefuseHelp();
                        GoogleAnalytics.trackEvent('/', 'Guide', 'refuseGuide');
                    }
                }
            }
        }

        Timer {
            id: closeTimer

            running: root.state == 'firstEnter'
            interval: wellcomePage.closeInterval
            onTriggered: {
                root.state = "closed"
                GoogleAnalytics.trackEvent('/', 'Guide', 'closeOnTimeOut');
            }
        }

        ParallelAnimation {
            id: progressAnim

            running: root.state === 'firstEnter'

            PropertyAnimation {
                target: progress;
                property: "width"
                from: root.width;
                to: 0;
                duration: wellcomePage.closeInterval
            }
        }


        Rectangle {
            color: "#c0bdb3"
            anchors { bottom: parent.bottom; bottomMargin: 107 }
            height: 1
            width: root.width
            opacity: 0.2
        }

        Rectangle {
            id: progress

            color: "#FFFFFF"
            anchors { bottom: parent.bottom; bottomMargin: 107 }
            height: 1
            width: root.width
        }
    }

    states: [
        State {
            name: "firstEnter"
            PropertyChanges { target: controlls; opacity: 0 }
            PropertyChanges { target: wellcomePage; opacity: 1 }
            PropertyChanges { target: backMouser; visible: true }
        },
        State {
            name: "guideShow"
            PropertyChanges { target: controlls; opacity: 1 }
            PropertyChanges { target: wellcomePage; opacity: 0 }
            PropertyChanges { target: backMouser; visible: true }
        },
        State {
            name: "closed"
            PropertyChanges { target: background; opacity: 0 }
            PropertyChanges { target: controlls; opacity: 0 }
            PropertyChanges { target: wellcomePage; opacity: 0 }
            PropertyChanges { target: backMouser; visible: false }
        }
    ]
}
