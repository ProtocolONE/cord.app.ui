import QtQuick 2.4
import Application.Controls 1.0

AuxiliaryButton {
    id: button

    signal buttonClick(int button)

    property int buttonId

    width: 200
    height: 46

    onClicked: buttonClick(buttonId);
}

