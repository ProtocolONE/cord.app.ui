import QtQuick 1.1
import Tulip 1.0

import GameNet.Controls 1.0
import Application.Controls 1.0

import "../../../../../../Core/Styles.js" as Styles

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

            // INFO When psd would be ready we can switch Item to Image.
            Item {
                width: 16
                height: 16
                clip: true
                x: 6

                Rectangle {
                    x: -15
                    color: "#00000000"
                    width: 15
                    height: 15
                    border {
                        color: "#FFFFFF"
                        width: 2
                    }

                    rotation: 45
                }
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

            anchors {
                baseline: parent.bottom
                baselineOffset: -4
            }

            font {
                family: "Arial"
                pixelSize: 12
            }

            style {
                normal: Styles.style.textBase
                hover: Styles.style.menuText
                disabled: Styles.style.textBase
            }

            color: Styles.style.textBase
            text: groupCountText.countText()
            elide: Text.ElideRight
            onClicked: root.clicked();
        }

    }
}
