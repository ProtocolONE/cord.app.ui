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
import GameNet.Controls 1.0

import "../Core/Styles.js" as Styles

Item {
    id: root

    property alias spacing: content.spacing
    property alias style: progressBar.style
    property alias textColor: text.color
    property variant serviceItem

    signal clicked();

    height: 36

    QtObject {
        id: d

        function isError() {
            if (!root.serviceItem) {
                return false;
            }

            return root.serviceItem.status === "Error";
        }

        function getStatusText() {
            if (d.isError()) {
                return qsTr("DOWNLOAD_STATUS_ERROR");
            }

            if (!root.serviceItem) {
                return 'Mocked text about downloading...';
            }

            return serviceItem.statusText;
        }

    }

    Column {
        id: content

        anchors.fill: parent
        spacing: 4

        ProgressBar {
            id: progressBar

            height: 4
            style {
                background: Styles.style.downloadStatusProgressBackground
                line: Styles.style.downloadStatusProgressLine
            }
            animated: true
            anchors { left: parent.left; right: parent.right}
            progress: serviceItem ? serviceItem.progress : 75
            visible: !d.isError()
        }

        Item {
            anchors { left: parent.left; right: parent.right}
            clip: true
            height: text.height

            Text {
                id: text

                property int offset: 0
                property int offsetDuration: 0

                font { family: 'Arial'; pixelSize: 12 }
                color: Styles.style.downloadStatusText
                text: d.getStatusText();
                smooth: true

                onPaintedWidthChanged: {
                    if (text.paintedWidth > root.width) {
                        if (!scrollAnimation.running) {
                            scrollAnimation.start();
                        }
                        return;
                    }

                    if (scrollAnimation.running) {
                        scrollAnimation.stop();
                        text.x = 0;
                    }
                }
            }

            Timer {
                id: scrollAnimation

                property int frame: 0

                interval: 33
                triggeredOnStart: true
                repeat: true

                onTriggered: {
                    if (frame === 0) {
                        text.offset = root.width - text.paintedWidth
                        text.offsetDuration = Math.max(0, 2000 * (text.paintedWidth / root.width))
                    }

                    //INFO Парни, простите. Другого способа нормально написать эту анимацию не нашёл. По русски - секундная
                    //пауза, потом изменение Х в течение рассчитанного времени (text.offsetDuration) - сдвигаем влево,
                    //потом еще секундная пауза и возврат Х назад до 0. Причина такой "красоты" - высокий CPU load при
                    //встроенной анимации QML.
                    var time = ++frame * interval
                    , tick = time / 1000
                    , offsetInTicks = text.offsetDuration / 1000;

                    if (tick <= 1) {
                        return;
                    }

                    if (1 <= tick && tick < (1 + offsetInTicks)) {
                        text.x = text.offset * (tick - 1) / offsetInTicks
                        return;
                    }

                    if ((1 + offsetInTicks) <= tick && tick < (2 + offsetInTicks)) {
                        return;
                    }

                    if ((2 + offsetInTicks) <= tick && tick < (2 + 2 * offsetInTicks)) {
                        text.x = text.offset * (2 + 2 * offsetInTicks - tick) / offsetInTicks
                        return;
                    }

                    if (tick > (2 + 2 * offsetInTicks)) {
                        frame = 0;
                    }
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent

        onClicked: root.clicked();
    }
}
