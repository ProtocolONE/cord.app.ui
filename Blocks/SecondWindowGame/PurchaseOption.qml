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
import "../../js/Core.js" as Core
import "../../Elements" as Elements
import "../../Elements/Tooltip" as Tooltip

Elements.Option {
    id: container

    property int daysCount

    width: 250
    height: 25

    Row {
        spacing: 10
        anchors.verticalCenter: parent.verticalCenter

        Text {
            text: model.label
            width: 80
            anchors.verticalCenter: parent.verticalCenter
            color: "#FFFFFF"
            font { family: "Arial"; pixelSize: 18 }
        }

        Image {
            width: 15
            anchors.verticalCenter: parent.verticalCenter
            source: installPath + "images/arrow.png"
            rotation: 180
            fillMode: Image.PreserveAspectFit
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: "" + model.price
            color: "#FFFFFF"
            font { family: "Arial"; pixelSize: 18 }
        }

        Image {
            anchors.verticalCenter: parent.verticalCenter
            fillMode: Image.PreserveAspectFit
            source: container.checked ? (installPath + "images/gn_43382A.png") : (installPath + "images/gn_FFFFFF.png")
            smooth: true
        }
    }
}
