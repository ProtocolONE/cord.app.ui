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
import GameNet.Controls 1.0
import GameNet.Components.Widgets 1.0

import "../../../Core/App.js" as App
import "../../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics

WidgetView {
    id: root

    property variant gameItem: App.currentGame()

    width: 630
    height: 245

    Component.onDestruction: {
        root.gameItem.statusText = '';
        root.gameItem.status = "Normal";
        App.updateProgress(root.gameItem);
    }

    Timer {
        interval: 5000
        running: root.visible
        onTriggered: {
            App.executeService(root.gameItem.serviceId);
            root.close();
        }
    }

    Rectangle {
        anchors.fill: parent
        color: '#f0f5f8'
    }

    Column {
        anchors {
            fill: parent
            margins: 20
        }
        spacing: 20

        Item {
            id: headBlock

            width: parent.width
            height: 35


            HorizontalSplit {
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }

                style: SplitterStyleColorsPrivate {}
            }

            Text {
                id: headText

                anchors {
                    top: parent.top
                    left: parent.left
                }

                font {
                    family: 'Arial'
                    pixelSize: 18
                }

                color: '#343537'
                smooth: true
                text: qsTr("GAME_EXECUTING_HEADER").arg(root.gameItem.name)
            }
        }

        Item {
            width: 590
            height: 150

            WidgetContainer {
                anchors.fill: parent
                widget: gameItem.widgets.gameStarting
                visible: widget
            }
        }
    }
}
