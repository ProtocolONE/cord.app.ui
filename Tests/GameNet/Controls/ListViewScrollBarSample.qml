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

import GameNet.Controls 1.0

Rectangle {
    width: 1000
    height: 620

    Row {
        spacing: 10

        Column {
            spacing: 5

            Input {
                width: 200
                height: 30
                placeholder: "Total items"
                onTextChanged: view.update(text|0);
            }

            Input {
                width: 200
                height: 30
                placeholder: "Cursor Wheel Step"
                onTextChanged: scroll.cursorWheelStep = text|0;
            }

            Input {
                width: 200
                height: 30
                placeholder: "Cursor Radius"
                onTextChanged: scroll.cursorRadius = text|0;
            }

            Input {
                width: 200
                height: 30
                placeholder: "Cursor Color"
                onTextChanged: scroll.color = text;
            }

            Input {
                width: 200
                height: 30
                placeholder: "Cursor Max Height"
                onTextChanged: scroll.cursorMaxHeight = text|0;
            }

            Input {
                width: 200
                height: 30
                placeholder: "Cursor Min Height"
                onTextChanged: scroll.cursorMinHeight = text|0;
            }

            Input {
                width: 200
                height: 30
                placeholder: "ListView Count Limit"
                onTextChanged: scroll.listViewCountLimit = text|0;
            }
        }

        ListView {
            id: view

            function update(count) {
                view.model.clear();
                for (var i = 0; i < count; i++) {
                    view.model.append({
                         h: (50 + 100 * Math.random()) | 0
                    })
                }
            }

            Component.onCompleted: update(100)

            cacheBuffer: 500
            clip: true
            width: 100
            height: 500
            spacing: 1

            delegate: Rectangle {
                width: 100
                height: h
                color: "blue"

                Text {
                    anchors.centerIn: parent
                    text: index
                    color: "white"
                }
            }

            model: ListModel {}
        }

        ListViewScrollBar {
            id: scroll

            width: 16
            height: 500

            listView: view
        }
    }
}
