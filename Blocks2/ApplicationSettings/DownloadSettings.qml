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
import "../../Controls" as Controls
import "../../js/Translate.js" as TranslateJs

Rectangle {
    id: settingsPageRoot

    //  HACK: раскомментировать для тестирования
    Item {
        id: settingsViewModel

        property int downloadSpeed: 0
        property int uploadSpeed: 1000
        property int incomingPort: 3456
        property int numConnections: 10
        property bool seedEnabled: true
    }

    Column {
        x: 30
        y: 0
        spacing: 20

        Row {
            spacing: 20
            z: 100

            Item {
                width: 300
                height: 60

                Text {
                    width: parent.width
                    height: 20
                    text: qsTr("DOWNLOAD_LIMIT")
                    font {
                        family: 'Arial'
                        pixelSize: 16
                    }
                    color: '#5c6d7d'
                }

                Controls.ComboBox {
                    id: downloadBandwidthLimit
                    y: 20

                    width: parent.width
                    height: 40
                    Component.onCompleted: {
                        append(0, qsTr("SPEED_UNLIMITED"));
                        append(50, qsTr("SPEED_50"));
                        append(200, qsTr("SPEED_200"));
                        append(500, qsTr("SPEED_500"));
                        append(1000, qsTr("SPEED_1000"));
                        append(2000, qsTr("SPEED_2000"));
                        append(5000, qsTr("SPEED_5000"));

                        var index = downloadBandwidthLimit.findValue(settingsViewModel.downloadSpeed);
                        if (index >= 0) {
                            downloadBandwidthLimit.currentIndex = index;
                        }
                    }
                }
            }

            Item {
                width: 300
                height: 60

                Text {
                    width: parent.width
                    height: 20
                    text: qsTr("UPLOAD_LIMIT")
                    font {
                        family: 'Arial'
                        pixelSize: 16
                    }
                    color: '#5c6d7d'
                }

                Controls.ComboBox {
                    id: uploadBandwidthLimit

                    y: 20
                    width: parent.width
                    height: 40

                    Component.onCompleted: {
                        append(0, qsTr("SPEED_UNLIMITED"));
                        append(50, qsTr("SPEED_50"));
                        append(200, qsTr("SPEED_200"));
                        append(500, qsTr("SPEED_500"));
                        append(1000, qsTr("SPEED_1000"));
                        append(2000, qsTr("SPEED_2000"));
                        append(5000, qsTr("SPEED_5000"));

                        var index = uploadBandwidthLimit.findValue(settingsViewModel.uploadSpeed);
                        if (index >= 0) {
                            uploadBandwidthLimit.currentIndex = index;
                        }

                    }
                }
            }
        }


        Row {
            spacing: 20

            Item {
                width: 300
                height: 60

                Text {
                    width: parent.width
                    height: 20
                    text: qsTr("INCOMING_PORT")
                    font {
                        family: 'Arial'
                        pixelSize: 16
                    }
                    color: '#5c6d7d'
                }

                Row {
                    y: 20
                    spacing: 20

                    Controls.Input {
                        id: incomingPort

                        width: 140
                        height: 40
                        text: "" + settingsViewModel.incomingPort
                        showCapslock: false
                        showLanguage: false
                        validator: IntValidator { bottom: 0; top: 65535 }
                    }

                    Controls.Button {
                        width: 140
                        height: 40
                        text: qsTr("PORT_AUTO")
                        style: Controls.ButtonStyleColors {
                            normal: "#3498BD"
                            hover: "#3670DC"
                        }
                        onClicked: {
                            incomingPort.text = Math.floor(Math.random() * 60000) + 1000;
                        }
                    }
                }
            }

            Item {
                width: 300
                height: 60

                Text {
                    width: parent.width
                    height: 20
                    text: qsTr("CONNECTION_COUNT")
                    font {
                        family: 'Arial'
                        pixelSize: 16
                    }
                    color: '#5c6d7d'
                }

                Controls.Input {
                    y: 20
                    width: parent.width
                    height: 40
                    text: "" + settingsViewModel.numConnections
                    showCapslock: false
                    showLanguage: false
                    validator: IntValidator { bottom: 1; top: 65535 }
                }
            }
        }

        Controls.CheckBox {
            text: qsTr("PARTICIPATE_SEEDING")
            checked: settingsViewModel.seedEnabled
            style: Controls.ButtonStyleColors {
                normal: "#1ABC9C"
                hover: "#019074"
            }
        }
    }
}
