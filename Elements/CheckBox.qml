/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.0
import "." as Elements

Item {
    id: mainCheckBoxId

    property bool enabled: true
    property string buttonText
    property bool isChecked: state == "Active";

    signal checked();
    signal unchecked();

    function setValue(val) {
        if (val == value()) {
            return;
        }

        if (val) {
            mainCheckBoxId.state = "Active";
            checked();
        } else {
            mainCheckBoxId.state = "Normal";
            unchecked();
        }
    }

    function value() {
        return (mainCheckBoxId.state == "Active");
    }

    width: 30 + checkBoxTextId.width
    height: 20
    state: "Active"

    Rectangle {
        id: checkBoxId

        width: 20
        height: 20
        anchors.verticalCenter: parent.verticalCenter
        color: "#FFFFFF"
        opacity: mouser.containsMouse ? 0.95 : 0.85

        Image {
            id: checkedImageId

            anchors.centerIn: parent
            source: installPath + "images/checkImage.png"
        }
    }

    Text {
        id: checkBoxTextId

        text: buttonText
        style: Text.Normal
        anchors { left: parent.left; leftMargin: 30; verticalCenter: parent.verticalCenter }
        font { family: "Segoe UI Semibold"; bold: false; pixelSize: 14; weight: "Normal" }
        opacity: mouser.containsMouse ? 0.95 : 0.85
        smooth: true
        color: mainCheckBoxId.enabled ? "#FFFFFF" : "#666666"
    }

    Elements.CursorMouseArea {
        id: mouser

        visible: mainCheckBoxId.enabled
        anchors.fill: parent
        hoverEnabled: true
        onClicked: setValue(!value());
    }

    states: [
        State {
            name: "Normal"
            PropertyChanges { target: checkedImageId; visible: false }
            PropertyChanges { target: mainCheckBoxId; isChecked: false }
        },
        State {
            name: "Active"
            PropertyChanges { target: checkedImageId; visible: true }
            PropertyChanges { target: mainCheckBoxId; isChecked: true }
        }
    ]
}
