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

import "../Controls" as Controls

Rectangle {
    id: root

    color: "#FFFFFF"
    width: 600
    height: 400

    Column {
        x: 200
        y: 30
        spacing: 10

        Controls.ProgressBar {
            id: progressBar

            style: Controls.ProgressBarStyleColors {
                background: "#8089328F"
                line: "#73448347"
            }
            width: 350
            height: 5
            animated: true
            progress: 100
            onClicked: {
                console.log("ProgressBar clicked!");
            }
        }

        Row {
            spacing: 20

            Rectangle {
                width: 100
                height: 30
                color: "#BBBBBB"

                Text {
                    text: "Random!"
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        var newProgress = Math.floor(Math.random() * 100);
                        progressBar.progress = newProgress;
                    }
                }
            }

            Rectangle {
                width: 100
                height: 30

                border {
                    width: 2
                    color: "#DDDDDD"
                }

                Text {
                    id: progressValue
                    anchors.centerIn: parent
                    text: "" + progressBar.progress
                }
            }
        }
        Row {
            spacing: 20

            Rectangle {
                width: 100
                height: 30
                color: "#BBBBBB"

                Text {
                    text: "Toggle animated"
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        progressBar.animated = !progressBar.animated;
                    }
                }
            }
        }
    }
}
