/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 2.4
import Tulip 1.0

import GameNet.Controls 1.0

Item {
    width: 1000
    height: 599

    Item {
        id: baseLayer

        anchors.fill: parent

        Image {
            anchors.centerIn: parent
            source: installPath + '/Tests/Assets/main_07.png'
        }

        Row {
            spacing: 10

            Button {
                width: 200
                height: 30

                toolTip: "I'm tooltip!"
                text: "Click me!"

                onClicked: {console.log("Button clicked!");}
            }

            Button {
                width: 200
                height: 30

                toolTip: "I'm tooltip!"
                text: "Click me!"

                onClicked: {console.log("Button clicked!");}
            }

            Button {
                width: 200
                height: 30

                toolTip: "I'm tooltip!"
                text: "Click me!"

                onClicked: {console.log("Button clicked!");}
            }
        }

    }

    Item {
        id: tooltipLayer

        anchors.fill: parent
        z: 2
    }

    Component.onCompleted: {
        console.log("Sample::onCompleted!");

        Tooltip.init(tooltipLayer);
    }
}
