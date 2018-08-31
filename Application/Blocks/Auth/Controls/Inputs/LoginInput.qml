import QtQuick 2.4
import ProtocolOne.Controls 1.0
import Application.Controls 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0

Item {
    id: root

    default property alias data: root.data

    property alias placeholder: input.placeholder
    property alias text: input.text
    property alias error: input.error
    property alias errorMessage: errorContainer.errorMessage
    property alias typeahead: input.typeahead
    property alias maximumLength: input.maximumLength
    property alias suggestionsVisible: input.suggestionsVisible

    signal tabPressed()
    signal backTabPressed()

    height: 64
    implicitWidth: parent.width

    onFocusChanged: {
        if (focus) {
            input.focus = true
        }
    }

    Column {
        anchors.fill: parent

        Input {
            id: input

            icon: installPath + Styles.inputEmailIcon
            width: parent.width
            height: 48
            language: App.keyboardLayout()
            showCapslock: false

            onTabPressed: root.tabPressed();
            onBackTabPressed: root.backTabPressed();

            typeahead: TypeaheadBehaviour {
                dictionary: []
            }
        }

        ErrorContainer {
            id: errorContainer

            error: root.error
            width: parent.width
            height: 16
        }
    }
}
