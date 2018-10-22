import QtQuick 1.1
import GameNet.Controls 1.0

import "../../Core/Styles.js" as Styles

import "./Controls"
import "./Controls/Inputs"

Form {
    id: root

    property alias message: root.subTitle

    implicitHeight: 473
    implicitWidth: 500

    title: qsTr("MESSAGE_TITLE")

    footer {
        visible: false
    }

    signal clicked();

    Button {
        width: 200
        height: 48
        text: qsTr("OK_BUTTON_LABEL");
        onClicked: root.clicked();
    }
}
