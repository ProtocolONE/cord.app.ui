/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1
import Tulip 1.0

//  INFO: закоментированно, потому что при таком подключении файл ToolTip.js выполняется 2 раза,
//  несмотря на то, что объявлен как .pragma library
//  Судя по всему есть некоторый баг в Qt, который в таком случаем воспринимает импорты как разные.
//  Поэтому импорт сделан не через qmldir (см ниже)
//import GameNet.Controls 1.0

import "../../../Gamenet/Controls"
import "../../../Gamenet/Controls/Tooltip.js" as Tooltip

Item {
    width: 1000
    height: 599

    Item {
        id: baseLayer

        anchors.fill: parent

        Image {
            anchors.centerIn: parent
            source: installPath + '/Assets/Images/test/main_07.png'
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
