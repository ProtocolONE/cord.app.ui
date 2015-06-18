import QtQuick 1.1
import Application.Controls 1.0

Item {
    id: root

    width: 40 + button.width
    height: 46

    property alias text: button.text
    property int buttonId
    signal buttonClick(int button)

    MinorButton {
        id: button

        height: parent.height
        onClicked: root.buttonClick(buttonId);
        fontSize: 14
    }
}
