import QtQuick 1.1

import "../../../../../Core/Styles.js" as Styles
import "../../../../../Core/moment.js" as Moment

Item {
    id: root

    property string sectionProperty

    height: 34

    Rectangle {
        height: 1
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            leftMargin: 10
            rightMargin: 20
            topMargin: 16
        }
        color: Styles.style.messengerChatDialogBodySection
    }

    Rectangle {
        anchors {
            centerIn: parent
        }

        color: Styles.style.messengerChatDialogBodyBackground
        width: infoMessage.width + 20
        height: parent.height

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

            color: Styles.style.messengerChatDialogMessageDateSectionText
            font {
                family: "Tahoma"
                pixelSize: 11
                bold: true
            }
            text: infoMessage.dateText(+root.sectionProperty)
        }
    }
}
