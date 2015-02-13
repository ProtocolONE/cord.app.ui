import QtQuick 1.1

import "../../../../../Core/Styles.js" as Styles
import "../../../../../Core/moment.js" as Moment

Item {
    id: root

    property string sectionProperty

    height: 34

    Item {
        anchors {
            fill: parent
            topMargin: 10
            bottomMargin: 11
            leftMargin: 20
            rightMargin: 20
        }

        Text {
            id: infoMessage

            function dateText(timestamp) {
                var now = Moment.moment().startOf('day'),
                        actual = Moment.moment(+timestamp);

                if (now.isSame(actual)) {
                    return qsTr("CHAT_HISTORY_BODY_TODAY_TEXT");
                }

                if (now.subtract('days', 1).isSame(actual)) {
                    return qsTr("CHAT_HISTORY_BODY_YESTERDAY_TEXT");
                }

                return qsTr("CHAT_BODY_DATE_FORMAT").arg(actual.format('DD MMMM YYYY'));
            }

            anchors.centerIn: parent

            color: Styles.style.messengerChatDialogMessageNicknameText
            font {
                family: "Tahoma"
                pixelSize: 11
                bold: true
            }
            text: infoMessage.dateText(+root.sectionProperty)
        }
    }

    Rectangle {
        height: 1
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            leftMargin: 20
            rightMargin: 20
        }
        color: Qt.darker(Styles.style.messengerChatDialogBodyBackground, Styles.style.darkerFactor)
    }
}
