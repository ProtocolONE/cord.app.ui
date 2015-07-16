import QtQuick 2.4
import GameNet.Controls 1.0

Rectangle {
    width: 800
    height: 600
    color: "cyan"

    Column {
        anchors.fill: parent
        spacing: 10

        Rectangle {
            width: 100
            height: childrenRect.height

            ScrollText {
                width: parent.width
                text: "The quick brown fox jumps over the lazy dog ."
                color: "red"
                font.pixelSize: 24
            }
        }

        Rectangle {
            width: 300
            height: childrenRect.height

            ScrollText {
                width: parent.width
                text: "The quick brown fox jumps over the lazy dog ."
                color: "green"
            }
        }

        Rectangle {
            width: 100
            height: childrenRect.height

            ScrollText {
                width: parent.width
                text: "The quick brown fox jumps over the lazy dog ."
                color: "red"
                font.pixelSize: 24
            }
        }

        Row {
            width: parent.width
            height: childrenRect.height
            spacing: 10

            Button {
                width: 80
                height: 20
                text: scrollingText1.running ? "Stop" : "Start"
                onClicked: scrollingText1.running = !scrollingText1.running;
            }

            Rectangle {
                width: 96
                height: childrenRect.height

                ScrollText {
                    id: scrollingText1

                    width: parent.width
                    text: "The quick brown fox jumps over the lazy dog ."
                    color: "red"
                    font.pixelSize: 24
                    running: false
                    textMoveDuration: 1000

                }
            }
        }
    }
}
