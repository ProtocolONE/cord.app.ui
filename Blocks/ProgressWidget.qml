import QtQuick 1.1
import "../Elements"

Item {

    property string totalWantedDone
    property string totalWanted
    property string directTotalDownload
    property string peerTotalDownload
    property string payloadTotalDownload
    property string peerPayloadDownloadRate
    property string payloadDownloadRate
    property string directPayloadDownloadRate
    property string playloadUploadRate
    property string totalPayloadUpload

    width: 596
    height: 166

    QtObject {
        id: d

        function calcDimension(value) {
            if (value < 999900) {
                return qsTr('%1 KB').arg((value / 1000).toFixed(1));
            }

            if (value < 999990000) {
                return qsTr('%1 MB').arg((value / 1000000).toFixed(1));
            }

            return qsTr('%1 GB').arg((value / 1000000000).toFixed(2));
        }
    }

    Column {

        anchors { fill: parent }

        Rectangle {
            width: parent.width
            height: 33

            color: '#cccccc'

            Text {
                anchors { left: parent.left; top: parent.top; margins: 9 }
                font { family: "Tahoma"; pixelSize: 14 }
                smooth: true
                color: '#333333'
                text: qsTr("DOWNLOAD_INFO_CAPTION")
            }
        }

        Rectangle {
            width: parent.width
            height: 133
            color: '#dddddd'

            Column {
                anchors { fill: parent; leftMargin: parent.width / 2; margins: 9 }

                Item {
                    width: 1
                    height: 56
                }

                Text {
                    id: textPeerDownloadSpeed

                    font { family: "Tahoma"; pixelSize: 14 }
                    smooth: true
                    color: '#333333'
                    text: qsTr("DOWNLOAD_PEER_DOWNLOAD_SPEED").arg(qsTr('%1/seconds').
                                                                  arg(d.calcDimension(peerPayloadDownloadRate)));
                }

                Text {
                    id: textPayloadDownloadSpeed

                    font { family: "Tahoma"; pixelSize: 14 }
                    smooth: true
                    color: '#333333'

                    text: qsTr("DOWNLOAD_PEER_DIRECT_SPEED").arg(qsTr('%1/seconds').
                                                                arg(d.calcDimension(directPayloadDownloadRate)));
                }


                Text {
                    id: textPeerUploadSpeed

                    font { family: "Tahoma"; pixelSize: 14 }
                    smooth: true
                    color: '#333333'
                    text: qsTr("DOWNLOAD_PEER_UPLOAD_SPEED").arg(qsTr('%1/seconds').
                                                                arg(d.calcDimension(playloadUploadRate)));
                }
            }

            Column {
                anchors { fill: parent; rightMargin: parent.width / 2; margins: 9 }

                Text {
                    id: textDownloadComplete

                    font { family: "Tahoma"; pixelSize: 14 }
                    smooth: true
                    color: '#333333'

                    text: qsTr('DOWNLOAD_COMPLETE_FROM_TO').
                            arg(d.calcDimension(totalWantedDone)).
                            arg(d.calcDimension(totalWanted)).
                            arg(totalWanted == 0 || totalWantedDone == 0 ? 0 :
                                Math.round(100 / totalWanted * totalWantedDone));
                }

                Text {
                    id: textDownloadCompleteTotal

                    font { family: "Tahoma"; pixelSize: 14 }
                    smooth: true
                    color: '#333333'

                    text: qsTr('DOWNLOAD_COMPLETE_TOTAL').arg(d.calcDimension(payloadTotalDownload));
                }

                Text {
                    id: textDownloadSpeed

                    font { family: "Tahoma"; pixelSize: 14 }
                    smooth: true
                    color: '#333333'
                    text: qsTr('DOWNLOAD_SPEED_TOTAL').arg(qsTr('%1/seconds').
                                                          arg(d.calcDimension(payloadDownloadRate)));
                }

                Item {
                    width: 1
                    height: 5
                }

                Text {
                    id: textDownloadPeerTotal

                    font { family: "Tahoma"; pixelSize: 14 }
                    smooth: true
                    color: '#333333'
                    text: qsTr("DOWNLOAD_PEER_DOWNLOAD_TOTAL").arg(d.calcDimension(peerTotalDownload));
                }

                Text {
                    id: textPayloadPeerTotal

                    font { family: "Tahoma"; pixelSize: 14 }
                    smooth: true
                    color: '#333333'
                    text: qsTr("DOWNLOAD_PEER_DIRECT_TOTAL").arg(d.calcDimension(directTotalDownload));
                }

                Text {
                    id: textUploadPeerTotal

                    font { family: "Tahoma"; pixelSize: 14 }
                    smooth: true
                    color: '#333333'
                    text: qsTr("DOWNLOAD_PEER_UPLOAD_TOTAL").arg(d.calcDimension(totalPayloadUpload));
                }
            }
        }
    }
	
	Rectangle {
        anchors { left: parent.left; bottom: parent.bottom }
        anchors { leftMargin: 10; bottomMargin: -2 }
        rotation: 45
        color: '#dddddd'
        width: 8
        height: 8
	}
}
