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

import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import "../../../Core/App.js" as App

WidgetView {
    id: root

    width: 590
    height: 600

    Rectangle {
        anchors {
            fill: parent
        }

        Column {
            anchors {
                fill: parent
                margins: 10
            }
            spacing: 5

            Text {
                font {
                    family: 'Arial'
                    pixelSize: 14
                }

                text: 'Новости новости новости новости новости новости'
            }

            Text {
                font {
                    family: 'Arial'
                    pixelSize: 14
                }

                text: 'Новости новости новости новости новости новости'
            }

            Text {
                font {
                    family: 'Arial'
                    pixelSize: 14
                }

                text: 'Новости новости новости новости новости новости'
            }

            Text {
                font {
                    family: 'Arial'
                    pixelSize: 14
                }

                text: 'Новости новости новости новости новости новости'
            }

            Text {
                font {
                    family: 'Arial'
                    pixelSize: 14
                }

                text: 'Новости новости новости новости новости новости'
            }
        }
    }
}
