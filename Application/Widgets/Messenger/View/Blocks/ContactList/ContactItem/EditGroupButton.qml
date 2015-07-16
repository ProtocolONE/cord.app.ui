import QtQuick 2.4
import Application.Controls 1.0
import Application.Core.Styles 1.0

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
    icon: installPath + Styles.messengerHeaderGroupIcon
}
