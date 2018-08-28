import QtQuick 2.4
import QtMultimedia 5.5
import GameNet.Controls 1.0

import "./VideoPlayer"

Item {
    id: root

    property alias source: video.source
    property alias autoPlay: playPauseControl.autoPlay
    property alias volume: playPauseControl.volume

    function pause() {
        video.pause();
    }

    implicitWidth: 590
    implicitHeight: 330
    clip: true

    Rectangle {
        anchors.fill: parent
        color: "#000000"
    }

    QtObject {
        id: d

        function positionTime(seekTime) {
            var minutes = Math.floor(seekTime / 60000),
                seconds =  Math.floor((seekTime % 60000) / 1000);

            return minutes + ':' + ((seconds < 10) ? '0' : '') + seconds;
        }
    }

    function togglePlay() {
        if (video.playbackState !== MediaPlayer.PlayingState) {
            video.play();
        } else {
            video.pause();
        }
    }

    MouseArea {
           id: videoMouser
           anchors.fill: parent

           hoverEnabled: true
           onClicked: {
               var pos = mapFromItem(videoMouser, mouse.x, mouse.y)
               if (pos.y > parent.height - navigationControl.height) {
                   return;
               }
               togglePlay()
           }
    }

    Video {
        id: video

        property real progress: video.position / video.duration

        fillMode: VideoOutput.PreserveAspectCrop
        anchors.fill: parent

        Rectangle {
            //INFO Green codec start issue workaround.
            anchors.fill: parent
            opacity: video.position < 350 ? 1 : 0
            visible: opacity > 0
            color: "#000000"
        }

        Image {
            source: installPath + 'Assets/Images/Application/Controls/VideoPlayer/playBig.png'
            anchors.centerIn: parent
            visible: video.status == MediaPlayer.EndOfMedia
                     || (video.position === 0 && video.status == MediaPlayer.Loaded)

            Behavior on visible {
                enabled: video.autoPlay
                NumberAnimation {
                    duration: 250
                }
            }
        }

        Wait {
            anchors.centerIn: parent
            visible: video.status === MediaPlayer.Loading
                     || video.status === MediaPlayer.Buffering
                     || video.status === MediaPlayer.Stalled
        }
    }

    Item {
        id: navigationControl

        anchors {left: parent.left; right: parent.right; bottom: parent.bottom;}
        height: 60

        function hasPlayableState() {
            var states = [
                MediaPlayer.Loaded,
                MediaPlayer.Buffering,
                MediaPlayer.Stalled,
                MediaPlayer.Buffered,
                MediaPlayer.EndOfMedia
            ];

            return states.indexOf(video.status) !== -1;
        }

        opacity: (videoMouser.containsMouse || playPauseControl.containsMouse || progressMouser.containsMouse) ? 1 : 0
        visible: opacity > 0 && hasPlayableState()

        Behavior on opacity {
            PropertyAnimation {
                duration: 150
            }
        }

        Image {
            anchors.fill: parent
            source: installPath + 'Assets/Images/Application/Controls/VideoPlayer/gradient.png'
        }

        Item {
            anchors {fill: parent; margins: 10; bottomMargin: 5}

            VideoSeek {
                id: progressMouser

                anchors {left: parent.left; right: parent.right; top: parent.top}
                progress: video.progress
                duration: video.duration
                onSeek: {
                    video.seek(position);
                    if (video.playbackState !== MediaPlayer.PlayingState) {
                        video.play();
                    }
                }
            }

            VideoManagement {
                id: playPauseControl

                anchors {left: parent.left; right: parent.right; bottom: parent.bottom }
                currentTime: d.positionTime(video.position)
                totalTime: d.positionTime(video.duration)
                playbackState: video.playbackState
                onTogglePlay: root.togglePlay()
                onAutoPlayChanged: video.autoPlay = playPauseControl.autoPlay
                onVolumeChanged: video.volume = playPauseControl.volume
            }
        }
    }
}
