/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (В©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
**
** @author: Nikolay Bondarenko <nikolay.bondarenko@syncopate.ru>
** @since: 1.1
****************************************************************************/

import QtQuick 1.1

import "."
import "../../js/Core.js" as Core

Item {
    property variant currentItem;

    signal launchGame(string serviceId);

    function setupButton(button, serviceId) {
        var item = Core.serviceItemByServiceId(serviceId);
        button.source = installPath + item.imageHorizontalSmall;
        button.name = item.name;
        button.serviceId = item.serviceId ;
    }

    onCurrentItemChanged: {
        setupButton(button1, currentItem.maintenanceProposal1);
        setupButton(button2, currentItem.maintenanceProposal2);
    }

    height: 240

    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: 0.80
    }

    Rectangle {
        anchors { left: parent.left; top: parent.top; leftMargin: 260; topMargin: 20 }
        width: 1
        height: 200
        color: "#353535"
    }

    Column {
        anchors { left: parent.left; top: parent.top; leftMargin: 40; topMargin: 20 }
        spacing: 10

        Text {
            color: "#e4cd32"
            text: qsTr("MAINTENANCE_FIRST_TITLE")
            font { family: "Segoe UI Light"; bold: false; pixelSize: 23; weight: "Light" }
            smooth: true
        }

        Column {
            spacing: 5
            Text {
                color: "#e4cd32"
                text: qsTr("MAINTENANCE_TIME_TITLE")
                font.pixelSize: 14
                smooth: true
            }

            Text {
                text: !currentItem
                      ? ""
                      : ((currentItem.maintenanceInterval > 3600)
                         ? qsTr("STATUS_TEXT_MAINTENANCE_GREATE_HOUR")
                              .arg(Math.floor(currentItem.maintenanceInterval / 3600))
                              .arg(Math.floor(currentItem.maintenanceInterval % 3600 / 60))
                              .arg(currentItem.maintenanceInterval % 60)
                         : qsTr("STATUS_TEXT_MAINTENANCE_LESS_HOUR")
                              .arg(Math.floor(currentItem.maintenanceInterval / 60))
                              .arg(currentItem.maintenanceInterval % 60));

                color: "#e4cd32"
                smooth: true
                font.pixelSize: 20
            }
        }
    }

    Column {
        anchors { left: parent.left; top: parent.top; leftMargin: 280; topMargin: 20 }
        spacing: 10

        Text {
            color: "#ffffff"
            text: qsTr("MAINTENANCE_SECOND_TITLE")
            font { family: "Segoe UI Light"; bold: false; pixelSize: 23; weight: "Light" }
            smooth: true
        }

        Text {
            color: "#e4cd32"
            width: 487
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            text: currentItem ? qsTr("MAINTENANCE_ADV_TITLE").arg(currentItem.name) : ""
            font.pixelSize: 14
            lineHeight: 1.1
            smooth: true
        }

        Row {
            spacing: 10

            ImageButton {
                id: button1
                onClicked: launchGame(serviceId);
            }

            ImageButton {
                id: button2
                onClicked: launchGame(serviceId);
            }
        }
    }
}
