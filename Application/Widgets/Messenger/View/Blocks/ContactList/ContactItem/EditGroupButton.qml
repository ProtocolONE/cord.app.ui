import QtQuick 1.1
import Application.Controls 1.0
import "../../../../../../Core/Styles.js" as Styles
CheckedButton {
    analytics {
        category: "Messenger GroupHeader"
        action: "toggle"
        label: "OpenGroupEdit"
        value: checked|0
    }
    implicitWidth: 48
    implicitHeight: 48
    boldBorder: true
    checked: false
    icon: installPath + Styles.style.messengerHeaderGroupIcon
}
