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
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            topMargin: 10
            bottomMargin: 11
            leftMargin: 20
            rightMargin: 20
        }

        ListView {
            height: parent.height
            anchors.centerIn: parent
            spacing: 7

            orientation: ListView.Horizontal
            interactive: false
            cacheBuffer: 10
            width: 200 // INFO надо бы разобратся и считать ширину в зависимости от делегатов

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
            }

            delegate: TextButton {
                function isEnabled(number, name) {
                    var user = MessengerJs.selectedUser();
                    if (!user.isValid()) {
                        return false;
                    }

                    if (!user.historyDay) {
                        return true;
                    }

                    var actualDay =
                            +Moment.moment().startOf('day').subtract(number, name);

                    return actualDay < user.historyDay;
                }

                color: Styles.style.messengerChatDialogMessageNicknameText
                font {
                    family: "Arial"
                    pixelSize: 12
                }
                text: qsTr(textValue)
                onClicked: root.queryMore(model.number, model.name);
                enabled: isEnabled(model.number, model.name)
                style {
                    normal: Styles.style.infoText
                    hover: Styles.style.textBase
                    disabled: Styles.style.infoText
                }
            }
        }
    }
}
