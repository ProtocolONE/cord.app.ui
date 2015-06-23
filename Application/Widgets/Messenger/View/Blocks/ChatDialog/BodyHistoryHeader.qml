import QtQuick 1.1

import GameNet.Controls 1.0
import Application.Controls 1.0

import "../../../../../Core/Styles.js" as Styles
import "../../../Models/Messenger.js" as MessengerJs
import "../../../../../Core/moment.js" as Moment

Item {
    id: root

    signal queryMore(int number, string name);

    height: 34

    Item {
        anchors {
            fill: parent
            topMargin: 10
            bottomMargin: 11
            leftMargin: 20
            rightMargin: 20
        }

        Row {
            height: parent.height
            anchors.centerIn: parent
            spacing: 10

            Text {
                text: qsTr("BODY_HISTORY_HEADER_TITLE")
                color: Styles.style.infoText
                font {
                    family: "Arial"
                    pixelSize: 12
                }
            }

            ListView {
                height: parent.height
                spacing: 7

                orientation: ListView.Horizontal
                interactive: false
                cacheBuffer: 10
                width: 250 // INFO надо бы разобратся и считать ширину в зависимости от делегатов

                model: ListModel {
                    ListElement {
                        number: 1
                        name: 'day'
                        textValue: QT_TR_NOOP("YESTERDAY_HISTORY_TEXT")
                    }
                    ListElement {
                        number: 1
                        name: 'week'
                        textValue: QT_TR_NOOP("WEEK_HISTORY_TEXT")
                    }
                    ListElement {
                        number: 2
                        name: 'week'
                        textValue: QT_TR_NOOP("TWO_WEEKS_HISTORY_TEXT")
                    }
                    ListElement {
                        number: 1
                        name: 'month'
                        textValue: QT_TR_NOOP("MONTH_HISTORY_MONTH")
                    }
                    ListElement {
                        number: 100
                        name: 'month'
                        textValue: QT_TR_NOOP("MONTH_HISTORY_BEGINNING")
                    }
                }

                delegate: TextButton {
                    font {
                        family: "Arial"
                        pixelSize: 12
                    }
                    text: qsTr(textValue)
                    onClicked: root.queryMore(model.number, model.name);
                    style {
                        normal: Styles.style.infoText
                        hover: Styles.style.textBase
                        disabled: Styles.style.infoText
                    }
                }
            }
        }
    }
}
