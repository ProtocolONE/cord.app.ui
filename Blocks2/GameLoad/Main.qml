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
import GameNet.Controls 1.0

Rectangle {
    id: root

    property alias headerText: headText.text
    property alias bannerImageUrl: bannerImage.source
    property int progress: 15

    property alias totalWantedDone: progressWidget.totalWantedDone
    property alias totalWanted: progressWidget.totalWanted
    property alias directTotalDownload: progressWidget.directTotalDownload
    property alias peerTotalDownload: progressWidget.peerTotalDownload
    property alias payloadTotalDownload: progressWidget.payloadTotalDownload
    property alias peerPayloadDownloadRate: progressWidget.peerPayloadDownloadRate
    property alias payloadDownloadRate: progressWidget.payloadDownloadRate
    property alias directPayloadDownloadRate: progressWidget.directPayloadDownloadRate
    property alias payloadUploadRate: progressWidget.payloadUploadRate
    property alias totalPayloadUpload: progressWidget.totalPayloadUpload

    signal close();
    signal pause();

    implicitWidth: 630

    color: '#f0f5f8'

    onVisibleChanged: stateGroup.state = 'Normal';

    Column {
        anchors {
            fill: parent
            margins: 20
        }

        Item {
            id: headBlock

            width: parent.width
            height: 35

            Image {
                source: installPath + '/images/close.png'
                anchors {
                    right: parent.right
                    top: parent.top
                    margins: -5
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.close();
                }
            }

            HorizontalSplit {
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }

                style: SplitterStyleColorsPrivate {}
            }

            Text {
                id: headText

                anchors {
                    top: parent.top
                    left: parent.left
                }

                font {
                    family: 'Arial'
                    pixelSize: 18
                }

                color: '#343537'
                smooth: true
            }
        }

        Item {
            id: centerBlock

            width: parent.width

            Text {
                font {
                    family: "Arial"
                    pixelSize: 14
                }
                anchors {
                    left: parent.left
                    top: parent.top
                    topMargin: 15
                }

                smooth: true
                color: '#5d6f7b'
                text: progressWidget.downloadStatusText();
                // TODO здесь нужно как то забиндить текст наружу, в зависимости от статуса установки
            }

            Rectangle {
                width: 500
                height: 22
                color: '#00000000'
                border { color: '#e1e5e8' }

                anchors {
                    left: parent.left
                    top: parent.top
                    topMargin: 40
                }

                ProgressBar {
                    anchors {
                        fill: parent
                        margins: 6
                    }
                    style: ProgressBarStyleColors {
                        background: "#0d5144"
                        line: '#32cfb2'
                    }

                    progress: root.progress
                }

                TextButton {
                    anchors {
                        left: parent.right
                        leftMargin: 7
                        top: parent.top
                        topMargin: 3
                    }

                    text: qsTr("PAUSE")
                    fontSize: 14
                    style: TextButtonStyle {}
                    onClicked: root.pause();
                }
            }

            TextButton {
                id: showStatButton

                anchors {
                    left: parent.left
                    top: parent.top
                    topMargin: 81
                }

                text: qsTr("SHOW_STATISTICS")
                fontSize: 14
                style: TextButtonStyle {}
                onClicked: stateGroup.state = "Detailed"
            }

            ProgressWidget {
                id: progressWidget

                anchors {
                    left: parent.left
                    top: parent.top
                    topMargin: 83
                }
            }


            HorizontalSplit {
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }

                style: SplitterStyleColorsPrivate {}
            }

            Item {
                anchors {
                    top: parent.bottom
                    topMargin: 20
                }
                width: 590
                height: 150

                Image {
                    id: bannerImage

                    anchors.fill: parent
                }
            }
        }

        StateGroup {
            id: stateGroup

            state: 'Normal'

            states: [
                State {
                    name: "Normal"
                    when: stateGroup.state == "Normal" || root.visible == false
                    PropertyChanges { target: centerBlock; height: 115 }
                    PropertyChanges { target: root; implicitHeight: 360 }
                    PropertyChanges { target: progressWidget; visible: false }
                    PropertyChanges { target: showStatButton; visible: true }
                },
                State {
                    name: "Detailed"
                    when: stateGroup.state == "Detailed"
                    PropertyChanges { target: centerBlock; height: 255 }
                    PropertyChanges { target: root; implicitHeight: 502 }
                    PropertyChanges { target: progressWidget; visible: true }
                    PropertyChanges { target: showStatButton; visible: false }
                }
            ]
        }
    }
}
