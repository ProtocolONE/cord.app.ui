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

import "Guide.js" as Guide
import "../../js/Core.js" as Core
import "../../js/GoogleAnalytics.js" as GoogleAnalytics

Item {
    id: root

    function show() {
        if (!inner.isAllowToShowHelp) {
            return;
        }

        inner.maxIndex = Guide.storyLine.length;
        inner.currentIndex = -1;
        if (inner.isWellcomeMustBeShown) {
            inner.isWellcomeMustBeShown = false;
            root.state = 'firstEnter';
        } else {
            root.state = 'guideShow';
        }

        GoogleAnalytics.trackEvent('/', 'Guide', root.state);
    }

    implicitWidth: Core.clientWidth
    implicitHeight: Core.clientHeight
    state: 'closed'

    Component.onCompleted: {
        inner.init();
        Guide._qml = root;
    }

    QtObject {
        id: inner

        property bool isSoundEnabled: true
        property bool isVisible: false
        property bool isFirstTime: false
        property bool isAllowToShowHelp: false
        property bool isWellcomeMustBeShown: false
        property bool isForward: true
        property int currentIndex: -1
        property int maxIndex: 0

        function showNext() {
            nextEntryTimer.stop();

            if (inner.isVisible) {
                hideGuide.start();
            } else {
                showGuide.start();
            }
            inner.isVisible = !inner.isVisible;
        }

        function showPrev() {
            inner.isForward = false;
            showNext();
        }

        function markAsMoreOneAsk() {
            Settings.setValue("qml/features/guide/", "showCount", 1);
        }

        function markAsRefuseHelp() {
            Settings.setValue("qml/features/guide/", "showCount", 2);
        }

        function markWellcomeAsShown() {
            Settings.setValue("qml/features/guide/", "showCount", 3);
        }

        function markAsShown() {
            Settings.setValue("qml/features/guide/", "showCount", 4);
        }

        function init() {
            var showCount = Settings.value("qml/features/guide/", "showCount", 0) |0;
            inner.isAllowToShowHelp = (showCount !== 2) && (showCount !== 3)
            inner.isWellcomeMustBeShown = (showCount < 2);
            inner.isFirstTime = (showCount === 0);
        }
    }

    MouseArea {
        id: backMouser

        anchors.fill: parent
        hoverEnabled: true
    }

    Timer {
        id: nextEntryTimer

        onTriggered: inner.showNext();
    }

    SequentialAnimation {
        id: hideGuide

        alwaysRunToEnd: true

        ParallelAnimation {
            PropertyAnimation { target: attention; from: 0; to: 0.7; property: "opacity"; duration: 400 }
            PropertyAnimation { target: attentionBorder; from: 1; to: 0; property: 'opacity'; duration: 400}
            PropertyAnimation { targets: guidePage; from: 1; to: 0; property: 'opacity'; duration: 400 }
        }

        ScriptAction {
            script: showGuide.start();
        }
    }

    SequentialAnimation {
        id: showGuide

        alwaysRunToEnd: false

        ScriptAction {
            script: {
                var newIndex = inner.currentIndex + (inner.isForward ? 1 : -1),
                    options = (newIndex > -1 && newIndex < inner.maxIndex) ? Guide.storyLine[newIndex] : undefined;

                inner.isForward = true;
                if (!options) {
                    inner.markAsShown();
                    showGuide.stop();
                    root.state = 'closed';
                    return;
                }

                inner.currentIndex = newIndex;

                attention.x = options.focusRect.x;
                attention.y = options.focusRect.y;
                attention.width = options.focusRect.width;
                attention.height = options.focusRect.height;

                textBackground.x = options.textRect.x;
                textBackground.y = options.textRect.y;
                textBackground.width = options.textRect.width;
                textBackground.height = options.textRect.height;

                sound.source = installPath + '/Sounds/Features/Guide/' + options.sound;

                infoText.text = options.text;
                nextEntryTimer.interval = options.duration;
                Guide._drawLines(v1, v2, attention, textBackground, options.dock)
            }
        }

        ParallelAnimation {
            PropertyAnimation { target: attention; from: 0.7; to: 0; property: "opacity"; duration: 400 }
            PropertyAnimation { target: attentionBorder; from: 0; to: 1; property: 'opacity'; duration: 400}
            PropertyAnimation { targets: guidePage; from: 0; to: 1; property: 'opacity'; duration: 400 }
        }

        ScriptAction {
            script: nextEntryTimer.restart()
        }
    }

    Item {
        id: background

        anchors.fill: parent

        Rectangle {
            id: up

            color: "#000000"
            opacity: 0.7
            anchors { top: parent.top; left: parent.left; right: parent.right; bottom: attention.top }
        }

        Rectangle {
            id: down

            color: "#000000"
            opacity: 0.7
            anchors { top: attention.bottom; left: parent.left; right: parent.right; bottom: parent.bottom }
        }

        Rectangle {
            id: left

            color: "#000000"
            opacity: 0.7
            anchors { top: attention.top; left: parent.left; right: attention.left; bottom: attention.bottom }
        }

        Rectangle {
            id: right

            color: "#000000"
            opacity: 0.7
            anchors { top: attention.top; left: attention.right; right: parent.right; bottom: attention.bottom }
        }

        Rectangle {
            id: attention

            color: "#000000"
            opacity: 0.7
        }

        Rectangle {
            id: attentionBorder

            anchors.fill: attention
            color: "#00000000"
            border.color: "#f0f0dc"
        }
    }

    Proxy.Player {
        id: sound

        volume: inner.isSoundEnabled ? 1 : 0

        Behavior on volume {
            NumberAnimation { duration: 300 }
        }
    }

    Item {
        id: guidePage

        opacity: 0
        anchors.fill: parent

        Rectangle {
            id: v1
            color: "#f0f0dc"
        }

        Rectangle {
            id: v2
            color: "#f0f0dc"
        }

        Rectangle {
            id: textBackground

            color: "#f0f0dc"

            Text {
                id: infoText

                anchors { fill: parent; margins: 10 }
                horizontalAlignment: Text.AlignJustify
                color: "#333333"
                font.pixelSize: 18
                wrapMode: Text.WordWrap
            }
        }
    }

    Row {
        id: controlls

        opacity: 0
        spacing: 30
        anchors { left: parent.left; bottom: parent.bottom; leftMargin: 130; bottomMargin: 95 }

        Row {
            spacing: 5

            Private.ImageButton {
                rotation: 180
                source: installPath + 'images/Features/Guide/arrow.png'
                toolTip: qsTr('BUTTON_PREV')
                enabled: inner.currentIndex > 0
                onClicked: {
                    inner.showPrev();
                    GoogleAnalytics.trackEvent('/', 'Guide', 'showPrev', inner.currentIndex.toString());
                }
            }

            Private.ImageButton {
                source: installPath + 'images/Features/Guide/arrow.png'
                toolTip: qsTr('BUTTON_NEXT')
                onClicked: {
                    inner.showNext();
                    GoogleAnalytics.trackEvent('/', 'Guide', 'showNext', inner.currentIndex.toString());
                }
            }
        }

        Text {
            text: qsTr("TEXT_CURRENT_FROM_MAX").arg(inner.currentIndex + 1).arg(inner.maxIndex)
            color: "#FFFFFF"
            anchors.verticalCenter: parent.verticalCenter
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
    }

    Item {
        id: wellcomePage

        property int closeInterval: 15000

        opacity: 0
        anchors.fill: parent

        Rectangle {
            anchors.fill: parent
            color: "#000000"
            opacity: 0.7
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
                        progressAnim.stop();
                        inner.markWellcomeAsShown();
                        root.show();
                        GoogleAnalytics.trackEvent('/', 'Guide', 'acceptGuide');
                    }
                }

                Elemetns.Button3 {
                    buttonText: inner.isFirstTime ? qsTr('GUIDE_BUTTON_LATER') : qsTr('GUIDE_BUTTON_REFUSE')
                    buttonHighlightColor: "#413c37"
                    onButtonClicked: {
                        root.state = "closed";
                        if (inner.isFirstTime) {
                            inner.markAsMoreOneAsk()
                            GoogleAnalytics.trackEvent('/', 'Guide', 'showLater');
                        } else {
                            inner.markAsRefuseHelp();
                            GoogleAnalytics.trackEvent('/', 'Guide', 'showRefuse');
                        }
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

            ScriptAction {
                script: sound.source = installPath + '/Sounds/Features/Guide/1.wma'
            }

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
            anchors {bottom: parent.bottom; bottomMargin: 107}
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
            PropertyChanges { target: background; opacity: 0.7 }
            PropertyChanges { target: guidePage; opacity: 0 }
            PropertyChanges { target: controlls; opacity: 0 }
            PropertyChanges { target: wellcomePage; opacity: 1 }
            PropertyChanges { target: attention; x: 0; y: 0; width: 0; height: 0}
            PropertyChanges { target: backMouser; visible: true }
        },
        State {
            name: "guideShow"
            PropertyChanges { target: background; opacity: 0.7 }
            PropertyChanges { target: guidePage; opacity: 0 }
            PropertyChanges { target: controlls; opacity: 1 }
            PropertyChanges { target: wellcomePage; opacity: 0 }
            PropertyChanges { target: attention; x: 0; y: 0; width: 0; height: 0}
            PropertyChanges { target: backMouser; visible: true }
        },
        State {
            name: "closed"
            PropertyChanges { target: background; opacity: 0 }
            PropertyChanges { target: controlls; opacity: 0 }
            PropertyChanges { target: guidePage; opacity: 0 }
            PropertyChanges { target: wellcomePage; opacity: 0 }
            PropertyChanges { target: attention; x: 0; y: 0; width: 0; height: 0}
            PropertyChanges { target: backMouser; visible: false }
        }
    ]

    transitions: [
        Transition {
            from: "*"
            to: "closed"
            SequentialAnimation {
                ScriptAction {
                    script: sound.stop();
                }
                PropertyAnimation {targets: [wellcomePage, guidePage, controlls]; property: "opacity"; duration: 250}
                PropertyAnimation {targets: [background]; property: "opacity"; duration: 250}
            }
        },

        Transition {
            from: "closed"
            to: "firstEnter"
            SequentialAnimation {
                PropertyAnimation {targets: [background, wellcomePage]; property: "opacity"; duration: 250}
                ScriptAction {
                    script: progressAnim.start();
                }
            }
        },

        Transition {
            from: "closed"
            to: "guideShow"
            SequentialAnimation {
                PropertyAnimation {targets: [background, guidePage, controlls]; property: "opacity"; duration: 250}
                ScriptAction {
                    script: inner.showNext()
                }
            }
        },

        Transition {
            from: "firstEnter"
            to: "guideShow"
            SequentialAnimation {
                PropertyAnimation {targets: [wellcomePage, background, controlls]; property: "opacity"; duration: 250}
                ScriptAction {
                    script: inner.showNext()
                }
            }
        }
    ]
}
