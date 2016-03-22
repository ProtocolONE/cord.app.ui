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
    id: root

    height: 24
    width: 24 + 10 + 70

    property real volume: 1.0
    property real _volume: 0.5
    property bool containsMouse: volumeMouser.containsMouse || mouser.containsMouse

    Row {
        spacing: 10

        Image {
            width: 24
            height: 24
            source: root.volume > 0
                ? installPath + 'Assets/Images/Application/Controls/VideoPlayer/volume.png'
                : installPath + 'Assets/Images/Application/Controls/VideoPlayer/mute.png'

            MouseArea {
                id: mouser

                cursorShape: Qt.PointingHandCursor
                anchors.fill: parent
                onClicked: {
                    if (volume > 0) {
                        _volume = volume;
                        root.volume = 0;
                    } else {
                        root.volume = _volume > 0 ? _volume : 0.5;
                    }
                }
            }
        }

        Item {
            anchors { verticalCenter: parent.verticalCenter}
            width: 70
            height: 10

            Rectangle {
                anchors { verticalCenter: parent.verticalCenter}
                width: parent.width
                height: 4
                color: "#FFFFFF"
                opacity: 0.7
            }

            Rectangle {
                anchors { verticalCenter: parent.verticalCenter}
                width: Math.ceil(parent.width * volume)
                height: 4
                color: "#D92620"
            }

            MouseArea {
                id: volumeMouser

                function updateVolume(x) {
                    var pos = mapToItem(volumeMouser, x, 0);
                    root.volume = Math.max(0, Math.min(1, x / volumeMouser.width));
                }

                cursorShape: Qt.PointingHandCursor
                anchors.fill: parent
                onClicked: updateVolume(mouse.x)
                onPositionChanged: {
                    if ((mouse.buttons & Qt.LeftButton) === Qt.LeftButton) {
                        updateVolume(mouse.x)
                    }
                }
            }
        }
    }
}
