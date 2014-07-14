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
import Tulip 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0
import Application.Blocks 1.0

import "../../../Application/Core/Popup.js" as PopupJs

Rectangle {
    width: 1000
    height: 599
    color: '#EEEEEE'

    WidgetManager {
        id: manager

        Component.onCompleted: {
            manager.registerWidget('Application.Widgets.GameDownloadError');
            manager.init();

            PopupJs.init(popupLayer);
        }
    }

    QtObject {
        id: errorServiceItem

        property string status: "Error"
        property int progress: 15
        property string statusText: "Ошибка"
    }

    QtObject {
        id: downloadingServiceItem

        property string status: "Downloading"
        property int progress: 15
        property string statusText: "Качаю"
    }


    Column {
        anchors.fill: parent
        anchors.margins: 5
        spacing: 10

        Button {
            width: 300
            height: 40
            text: "Show Error"
            onClicked: PopupJs.show("GameDownloadError")
        }

        Rectangle {
            width: 200
            height: 30
            border {
                color: "green"
                width: 2
            }

            DownloadStatus {
                anchors.fill: parent
                anchors.margins: 3
                textColor: "blue"
                serviceItem: errorServiceItem
            }
        }

        Rectangle {
            width: 200
            height: 30
            border {
                color: "green"
                width: 2
            }

            DownloadStatus {
                anchors.fill: parent
                anchors.margins: 3
                textColor: "blue"
                serviceItem: downloadingServiceItem
            }
        }
    }

    Item {
        id: popupLayer

        anchors.fill: parent
        z: 2
    }
}