import QtQuick 1.1
import GameNet.Controls 1.0 as Controls

Controls.Button {
    id: button

    signal buttonClick(int button)

    property int buttonId

    width: 200
    height: 46

    onClicked: buttonClick(buttonId);

    style: Controls.ButtonStyleColors {
        normal: "#1abc9c"
    }
}

