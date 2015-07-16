import QtQuick 2.4

import GameNet.Controls 1.0
import Application.Controls 1.0
import Application.Core.Styles 1.0

Item {
    id: root

    property int count
    property alias checked: groupButton.checked

    signal clicked();

    width: groupCountText.width + 24
    height: 16

    Row {
        height: parent.height
        spacing: 8

        CheckedButton {
            id: groupButton

            width: 16
            height: 16
            checked: false
            onClicked: root.clicked();
            icon: installPath + Styles.messengerGroupCountIcon
            analytics {
                category: "Messenger GroupHeader"
                action: "toggle"
                label: "OpenGroupEdit"
                value: checked|0
            }
        }

        TextButton {
            id: groupCountText

            function countText() {
                var translate = {
                    textSingle: qsTr('GROUP_CONTACT_HEADER_MEMBER_COUNT_SINGLE'),
                    textDouble: qsTr('GROUP_CONTACT_HEADER_MEMBER_COUNT_DOUBLE'),
                    textMultiple: qsTr('GROUP_CONTACT_HEADER_MEMBER_COUNT_MULTIPLE')
                };

                var longModulo = root.count % 100;
                var shortModulo = longModulo % 10;
                var template = "";

                if ((longModulo < 10 || longModulo > 20) && shortModulo > 1 && shortModulo < 5) {
                    template = translate['textDouble'];
                } else if (shortModulo == 1 && longModulo != 11) {
                    template = translate['textSingle'];
                } else {
                    template = translate['textMultiple'];
                }

                return root.count + " " + template;
            }

            font {
                family: "Arial"
                pixelSize: 12
            }

            style {
                normal: Styles.textBase
                hover: Styles.menuText
                disabled: Styles.textBase
            }

            text: groupCountText.countText()
            onClicked: root.clicked();
        }

    }
}
