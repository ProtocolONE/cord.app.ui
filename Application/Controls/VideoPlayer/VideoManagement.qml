/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2016, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 2.4
import QtMultimedia 5.5
import GameNet.Controls 1.0

Item {
    id: root

    property int playbackState;
    property bool containsMouse: playPauseControl.containsMouse
                                 || autoPlayItem.containsMouse
                                 || volumeControl.containsMouse

    property alias autoPlay: autoPlayItem.checked
    property alias volume: volumeControl.volume;
    property string currentTime;
    property string totalTime;

    signal togglePlay();

    height: 24

    Image {
        id: playback

        width: 24
        height: 24
        anchors {left: parent.left; leftMargin: 10; verticalCenter: parent.verticalCenter}
        source: (playbackState == MediaPlayer.PlayingState)
            ? installPath + 'Assets/Images/Application/Controls/VideoPlayer/pause.png'
            : installPath + 'Assets/Images/Application/Controls/VideoPlayer/play.png'

        MouseArea {
            id: playPauseControl

            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: togglePlay()
            hoverEnabled: true
            propagateComposedEvents: true
            preventStealing: true
        }
    }

    Row {
        anchors {left: parent.left; leftMargin: 60; verticalCenter: parent.verticalCenter}
        spacing: 10

        VideoVolume {
            id: volumeControl
        }

        CheckBox {
            id: autoPlayItem

            style {normal: "#cccccc"; active: "#cccccc"; activeHover: "#cccccc"; hover: "#cccccc"}
            text: qsTr("Автоматическое воспроизведение")
        }
    }

    Item {
        anchors {right: parent.right; verticalCenter: parent.verticalCenter }
        height: 10
        width: 50

        Text {
            anchors {right: parent.right; bottom: parent.bottom; }
            color: "#FFFFFF"
            text: currentTime + ' / ' + totalTime
        }
    }
}
