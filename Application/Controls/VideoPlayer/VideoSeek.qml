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

Item {
    id: progressControl

    property alias containsMouse: progressMouser.containsMouse
    property real progress: 0;
    property int duration: 0;

    signal seek(int position)

    height: 20
    opacity: containsMouse ? 1 : 0.8

    QtObject {
        id: d

        function positionTime(seekTime) {
            var minutes = Math.floor(seekTime / 60000),
                seconds =  Math.floor((seekTime % 60000) / 1000);

            return minutes + ':' + ((seconds < 10) ? '0' : '') + seconds;
        }
    }

    Rectangle {
        id: progressBar

        anchors {left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter}
        height: progressMouser.containsMouse ? 6 : 3
        color: "#FFFFFF"
        opacity: 0.7

        Behavior on height {
            PropertyAnimation {
                duration: 100
            }
        }
    }

    Rectangle {
        anchors {left: progressBar.left; top: progressBar.top; bottom: progressBar.bottom}
        width: Math.ceil(parent.width * progressControl.progress)

        Behavior on width {
            id: progressBehaviour

            PropertyAnimation {
                duration: 1000
            }
        }
        color: "#D92620"
    }

    VideoSeekText {
        id: seekText

        visible: progressMouser.containsMouse
        anchors {left: progressControl.left; bottom: progressControl.top}
    }

    MouseArea {
        id: progressMouser

        function seekPosition(event) {
            var pos = mapFromItem(progressMouser, event.x, 0);
            return progressControl.duration * pos.x / width;
        }

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        propagateComposedEvents: true
        onClicked: {
            progressBehaviour.enabled = false;
            progressControl.seek(seekPosition(mouse));
            recoverDuration.restart()
        }

        onPositionChanged: {
            var mappedPosition = mapFromItem(progressMouser, mouse.x, 0),
                seekTime = progressControl.duration * mappedPosition.x / width;

            seekText.anchors.leftMargin = mappedPosition.x - 10;
            seekText.text = d.positionTime(seekTime);
        }

        Timer {
            id: recoverDuration

            interval: 1000
            onTriggered:progressBehaviour.enabled = true;
        }
    }
}
