import QtQuick 2.4
import ProtocolOne.Controls 1.0
import Application.Controls 1.0

import Application.Core 1.0

import "./Controls"
import "./Controls/Inputs"

Form {
    id: root

    property alias message: root.subTitle
    property bool supportButton: false

    implicitHeight: 473
    implicitWidth: 500

    title: qsTr("MESSAGE_TITLE")

    footer {
        visible: false
    }

    signal clicked();

    AuxiliaryButton {
        visible: root.supportButton
        anchors.right: parent.right
        anchors.rightMargin: 180
        width: 150
        text: qsTr("SUPPORT_BUTTON_LABEL");
        onClicked: App.openExternalUrl("https://support.protocol.one");
    }

    PrimaryButton {
        anchors.right: parent.right
        width: 150
        text: qsTr("OK_BUTTON_LABEL");
        onClicked: root.clicked();
        analytics {
            category: 'Auth Message'
            label: 'Close'
        }
    }
}
