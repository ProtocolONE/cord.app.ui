import QtQuick 1.1
import GameNet.Controls 1.0
import "../../../Application/Core/App.js" as App

Rectangle {
    width: 245
    height: 180

    property variant serviceItem
    property int pauseAnimation
    property alias source: image.source
    property alias imageWidth: image.width

    function show() {
        showAnimation.restart();
    }

    width: image.width
    height: image.height
    visible: false

    SequentialAnimation {
        id: showAnimation

        PauseAnimation { duration: root.pauseAnimation }
        PropertyAnimation { target: root; property: "visible"; to: true }

        NumberAnimation {
            target: root;
            property: "scale";
            easing {
                type: Easing.OutBack
            }
            from: 0; to: 1;
            duration: 400
        }
    }

    Connections {
        target: App.signalBus()

        onProgressChanged: {
            if (serviceItem.serviceId != gameItem.serviceId) {
                return;
            }

            if (gameItem.status == 'Downloading') {
                stateGroup.state = gameItem.status;
                return;
            }

            stateGroup.state = 'Normal';
        }
    }

    Rectangle {
        id: backgroundRect

        anchors { fill: parent; margins: -5 }
        color: '#ff6555'
        visible: mouseArea.containsMouse || startButton.containsMouse
    }

    Item {
        width: root.imageWidth
        height: root.height

        Rectangle {
            anchors.fill: parent
            color: '#ff6555'
        }

        Image {
            id: image

            width: root.imageWidth
            height: 180

            opacity: 0
            asynchronous: true

            SequentialAnimation {
                id: imageShow

                NumberAnimation { target: image; property: "opacity"; from: 0; to: 1; duration: 150 }
            }

            onStatusChanged: {
                if (status == Image.Ready);
                    imageShow.start();
            }
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true

        onClicked: App.activateGame(serviceItem.serviceId);
    }

    Item {
        anchors.fill: parent

        Rectangle {
            anchors {
                left: parent.left
                bottom: parent.bottom
            }

            width: stateGroup.state == 'Downloading' ? 245 : backgroundRect.visible ? parent.width : hightlightItem.width
            height: stateGroup.state == 'Downloading' ? 90 : backgroundRect.visible ? parent.height : hightlightItem.height

            color: '#092135'
            opacity: 0.8
        }

        Item {
            id: hightlightItem

            width: 245
            height: stateGroup.state == 'Downloading' ? 90 : 50

            anchors {
                left: parent.left
                bottom: parent.bottom
            }

            Item {
                anchors { fill: parent; margins: 8 }

                Column {
                    anchors.fill: parent
                    spacing: 2

                    Text {
                        font { family: 'Arial'; pixelSize: 18 }
                        color: '#eff0f0'
                        text: serviceItem.name
                    }

                    Text {
                        font { family: 'Arial'; pixelSize: 12 }
                        color: '#eff0f0'
                        text: serviceItem.shortDescription
                    }
                }

                Item {
                    id: downloadStatus

                    anchors {
                        left: parent.left
                        right: parent.right
                        bottom: parent.bottom
                        bottomMargin: 0
                    }

                    height: 36

                    ProgressBar {
                        id: progressBar

                        anchors {
                            bottom: parent.bottom
                            bottomMargin: 31 - 8
                            left: parent.left
                            right: parent.right
                        }

                        height: 4
                        progress: serviceItem.progress

                        style: ProgressBarStyleColors {
                            background: "#0d5043"
                            line: "#35cfb1"
                        }
                    }


                    Text {
                        id: statusText

                        anchors {
                            bottom: parent.bottom
                        }

                        font { family: 'Arial'; pixelSize: 12 }
                        color: '#eff0f0'
                        text: serviceItem.statusText
                    }
                }
            }
        }
    }

    Button {
        id: startButton

        anchors.centerIn: parent

        width: 160
        height: 36

        text: qsTr("START_GAME_BUTTON")

        opacity: (backgroundRect.visible && stateGroup.state != 'Downloading') ? 1 : 0

        onClicked: App.downloadButtonStart(serviceItem.serviceId);
    }
}
