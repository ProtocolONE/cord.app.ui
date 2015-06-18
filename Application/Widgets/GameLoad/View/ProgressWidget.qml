/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 1.1

Column {

    property string totalWantedDone
    property string totalWanted
    property string directTotalDownload
    property string peerTotalDownload
    property string payloadTotalDownload
    property string peerPayloadDownloadRate
    property string payloadDownloadRate
    property string directPayloadDownloadRate
    property string payloadUploadRate
    property string totalPayloadUpload

    spacing: 12
    width: parent.width

    function downloadStatusText() {
        return qsTr("DOWNLOAD_STATUS_TEXT").arg(d.calcDimension(totalWantedDone)).
                                            arg(d.calcDimension(totalWanted));
    }

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

    Row {
        width: parent.width
        height: 50
        spacing: 0

        property int itemWidth: parent.width / 3

        StatInfoElementBig {
            width: parent.itemWidth
            height: parent.height

            infoText: qsTr("DOWNLOAD_COMPLETE_FROM_TO")
            detailedText: qsTr("DOWNLOAD_COMPLETE_FROM_TO_PERCENT").arg(d.calcDimension(totalWantedDone)).
                                                                    arg(d.calcDimension(totalWanted)).
                                                                    arg(totalWanted == 0 || totalWantedDone == 0 ? 0 :
                                                                    Math.round(100 / totalWanted * totalWantedDone));
        }

        StatInfoElementBig {
            width: parent.itemWidth
            height: parent.height

            infoText: qsTr("DOWNLOAD_COMPLETE_TOTAL")
            detailedText: d.calcDimension(payloadTotalDownload)
        }

        StatInfoElementBig {
            width: parent.itemWidth
            height: parent.height

            infoText: qsTr("DOWNLOAD_SPEED_TOTAL")
            detailedText: qsTr('%1/seconds').arg(d.calcDimension(payloadDownloadRate));
        }

    }

    Grid {
        width: parent.width
        height: 91
        columns: 2

        property int itemWidth: parent.width / 2

        StatInfoElementSmall {
            width: parent.itemWidth
            height: 30

            infoText: qsTr("DOWNLOAD_PEER_DOWNLOAD_TOTAL")
            detailedText: d.calcDimension(peerTotalDownload)
        }
        StatInfoElementSmall {
            width: parent.itemWidth
            height: 30

            infoText: qsTr("DOWNLOAD_PEER_DOWNLOAD_SPEED")
            detailedText: qsTr('%1/seconds').arg(d.calcDimension(peerPayloadDownloadRate));
        }
        StatInfoElementSmall {
            width: parent.itemWidth
            height: 30

            infoText: qsTr("DOWNLOAD_PEER_DIRECT_TOTAL")
            detailedText: d.calcDimension(directTotalDownload)
        }

        StatInfoElementSmall {
            width: parent.itemWidth
            height: 30

            infoText: qsTr("DOWNLOAD_PEER_DIRECT_SPEED")
            detailedText: qsTr('%1/seconds').arg(d.calcDimension(directPayloadDownloadRate));
        }
        StatInfoElementSmall {
            width: parent.itemWidth
            height: 30

            infoText: qsTr("DOWNLOAD_PEER_UPLOAD_TOTAL")
            detailedText: d.calcDimension(totalPayloadUpload)
        }
        StatInfoElementSmall {
            width: parent.itemWidth
            height: 30

            infoText: qsTr("DOWNLOAD_PEER_UPLOAD_SPEED")
            detailedText: qsTr('%1/seconds').arg(d.calcDimension(payloadUploadRate));
        }
    }
}
