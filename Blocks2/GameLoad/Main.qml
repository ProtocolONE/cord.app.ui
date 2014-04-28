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
import "../../Controls" as Controls

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

    width: 630
    height: state == "Normal" ? 360 : 502

    color: '#f0f5f8'
    state: "Normal"

    Column {
        x: 20
        width: parent.width - x
        height: parent.height

        Item {
            id: headBlock

            width: parent.width
            height: 55

            Image {
                source: installPath + '/images/close.png'
                anchors {
                    right: parent.right
                    top: parent.top
                    margins: 10
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.close();
                }
            }

            Controls.HorizontalSplit {
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }

                style: HorizontalSplitterStyleColors {}
            }

            Text {
                id: headText

                anchors {
                    verticalCenter: parent.verticalCenter
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
                    topMargin: 20
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

                Rectangle {
                    anchors {
                        fill: parent
                        margins: 6
                    }

                    color: '#0d5144'

                    Rectangle {
                        height: parent.height
                        width: root.progress > 0 ? (root.progress / 100)  * parent.width : 0
                        visible: root.progress > 0

                        color: '#32cfb2'
                    }
                }

                Controls.TextButton {
                    anchors {
                        left: parent.right
                        leftMargin: 7
                        verticalCenter: parent.verticalCenter
                    }

                    text: qsTr("PAUSE")
                    fontSize: 14
                    style: TextButtonStyle {}
                    onClicked: root.pause();
                }
            }

            Controls.TextButton {
                anchors {
                    left: parent.left
                    top: parent.top
                    topMargin: 81
                }

                text: qsTr("SHOW_STATISTICS")
                fontSize: 14
                style: TextButtonStyle {}
                visible: root.state == "Normal"
                onClicked: root.state = "Detailed"
            }

            ProgressWidget {
                id: progressWidget

                anchors {
                    left: parent.left
                    top: parent.top
                    topMargin: 83
                }

                visible: root.state == 'Detailed'
            }


            Controls.HorizontalSplit {
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }

                style: HorizontalSplitterStyleColors {}
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
    }



    StateGroup {
        states: [
            State {
                name: "Normal"
                when: root.state == "Normal" || root.visible == false
                PropertyChanges { target: centerBlock; height: 115 }
            },
            State {
                name: "Detailed"
                when: root.state == "Detailed"
                PropertyChanges { target: centerBlock; height: 255 }
            }
        ]
    }
}
