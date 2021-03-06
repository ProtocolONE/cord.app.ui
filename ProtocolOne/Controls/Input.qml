import QtQuick 2.4
import QtMultimedia 5.4
import Tulip 1.0

Item {
    id: root

    property bool enabled: true
    property alias readOnly: inputBehavior.readOnly
    property alias text: inputBehavior.text
    property alias placeholder: placeholderText.text
    property alias maximumLength: inputBehavior.maximumLength
    property alias horizontalAlignment: inputBehavior.horizontalAlignment
    property alias echoMode: inputBehavior.echoMode
    property bool showCapslock: true
    property bool showLanguage: true
    property TypeaheadBehaviour typeahead: TypeaheadBehaviour {}
    property alias suggestionsVisible: suggestionsContainer.controlVisible

    property alias language: inputBehavior.language
    property alias capsLock: inputBehavior.capsLock

    property int fontSize: 16
    property InputStyleColors style: InputStyleColors {}

    property alias error: inputBehavior.error

    property alias icon: iconImage.fakeSource
    property alias iconBackground: controlIcon.color
    property bool iconHovered: iconMouseArea.containsMouse
    property alias iconCursor: iconMouseArea.cursor

    property alias inputMask: inputBehavior.inputMask
    property alias validator: inputBehavior.validator

    property bool clearOnEsc: false
    property bool passwordType: false

    readonly property bool inputFocus: inputBehavior.focus

    property alias toolTip: inputBehavior.toolTip
    property alias tooltipPosition: inputBehavior.tooltipPosition
    property alias tooltipGlueCenter: inputBehavior.tooltipGlueCenter

    signal iconClicked()
    signal enterPressed()
    signal tabPressed()
    signal backTabPressed()

    function isSuggestionsContainerVisible() {
        return suggestionsContainer.controlVisible && suggestionsView.model.count > 0;
    }

    onFocusChanged: {
        if (focus) {
            inputBehavior.focus = true;
        }
    }

    function isMouseInside(x, y) {
        var translatedCoords;

        translatedCoords = controlBorder.mapFromItem(root, x, y);
        if (translatedCoords.x > 0 && translatedCoords.x < controlBorder.width &&
                translatedCoords.y > 0 && translatedCoords.y < controlBorder.height) {
            return true;
        }

        if (!root.isSuggestionsContainerVisible()) {
            return false;
        }

        translatedCoords = suggestionsBorder.mapFromItem(root, x, y);
        if (translatedCoords.x > 0 && translatedCoords.x < suggestionsBorder.width &&
                translatedCoords.y > 0 && translatedCoords.y < suggestionsBorder.height) {
            return true;
        }

        return false;
    }

    Rectangle {
        id: controlBorder

        anchors.fill: parent
        color: style.background
        border { width: 2; color: style.normal }

        Behavior on border.color {
            ColorAnimation { duration: 250 }
        }
    }

    SoundEffect {
        id: errorSound

        source: installPath + "Assets/Sounds/Controls/error.wav"
    }

    MouseArea {
        id: mouseArea

        anchors { fill: parent; margins: 2 }
        hoverEnabled: true
        onClicked: inputBehavior.forceActiveFocus();
        cursorShape: Qt.IBeamCursor

        Rectangle {
            id: controlIcon

            visible: root.icon != ""
            width: root.icon != "" ? parent.height : 0
            height: parent.height
            color: style.background
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }

            Behavior on color {
                ColorAnimation { duration: 250 }
            }

            Image {
                id: iconImage

                property string fakeSource: root.icon

                anchors.centerIn: parent
                source: internalState.state === 'ErrorNormal'
                        ? (installPath + 'Assets/Images/ProtocolOne/Controls/Input/error.png')
                        : iconImage.fakeSource
            }

            CursorMouseArea {
                id: iconMouseArea

                anchors.fill: parent
                onClicked: root.iconClicked();
                cursor: Qt.ArrowCursor
                visible: mouseArea.containsMouse
            }
        }

        Item {
            anchors {
                left: controlIcon.right
                leftMargin: 10
                right: iconContainer.left
                rightMargin: 10
                verticalCenter: parent.verticalCenter
            }
            height: parent.height

            clip: true

            Item {
                anchors.fill: parent
                clip: true

                Text {
                    id: autoCompleteText

                    function getFirstPosition() {
                        // HACK: нужен биндинг на inputBehavior.cursorPosition, но значение его не важно для расчетов.
                        if (inputBehavior.cursorPosition > 0) {
                        }

                        return inputBehavior.positionToRectangle(0).x;
                    }

                    anchors {
                        left: parent.left
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }

                    color: "#d6d6d6"
                    font { family: "Arial"; pixelSize: root.fontSize }

                    visible: suggestionsContainer.visible && autoCompleteText.getFirstPosition() === 0
                }

                Rectangle {
                    function getWidth() {
                        if (inputBehavior.cursorPosition > 0) {
                        }

                        return inputBehavior.positionToRectangle(inputBehavior.text.length).x
                    }

                    width: getWidth();
                    height: parent.height
                    color: style.background
                }
            }

            Text {
                id: placeholderText

                anchors {
                    left: parent.left
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
                color: root.style.placeholder
                elide: Text.ElideRight
                font { family: "Arial"; pixelSize: root.fontSize }

                visible: inputBehavior.text.length == 0
            }

            InputBehaviour {
                id: inputBehavior

                color: style.text
                fontSize: root.fontSize
                anchors {
                    left: parent.left
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
                echoMode: (root.passwordType && !eyeMouser.containsMouse)
                          ? TextInput.Password
                          : TextInput.Normal

                Keys.onTabPressed: root.tabPressed();
                Keys.onBacktabPressed: root.backTabPressed();

                Keys.onPressed: {
                    if (event.key == Qt.Key_Up) {
                        suggestionsContainer.decrementCurrentIndex();
                        return;
                    }

                    if (event.key == Qt.Key_Down) {
                        suggestionsContainer.incrementCurrentIndex();
                        return;
                    }

                    if (event.key == Qt.Key_Right) {
                        if (inputBehavior.cursorPosition == inputBehavior.text.length) {
                            suggestionsContainer.selectCurrent();
                        }
                        return;
                    }

                    if (event.key == Qt.Key_Enter || event.key == Qt.Key_Return) {
                        suggestionsContainer.selectCurrent();
                        root.enterPressed();
                        return;
                    }

                    if (event.key == Qt.Key_Escape) {
                        event.accepted = true;
                        if (root.isSuggestionsContainerVisible()) {
                            suggestionsContainer.controlVisible = false;
                            return;
                        }

                        if (root.clearOnEsc) {
                            root.text = "";
                        }

                        inputBehavior.focus = false;
                        return;
                    }

                    if (event.key >= Qt.Key_Space && event.key <= Qt.Key_AsciiTilde) {
                        if (text.length >= root.maximumLength) {
                            if (!errorSound.playing) {
                                errorSound.play();
                            }
                            return;
                        }
                    }
                }

                onFocusLost: suggestionsContainer.controlVisible = false;

                onTextChanged: {
                    inputBehavior.error = false;
                    autoCompleteText.text = "";
                    typeahead.filter = text;
                    suggestionsContainer.controlVisible = true;
                }
            }

        }

        Item {
            id: iconContainer

            anchors.right: parent.right
            width: (capslockIcon.visible ? capslockIcon.width : 0)
                   + (languageIcon.visible ? languageIcon.width : 0)
                   + (eyeIcon.visible ? eyeIcon.width : 0)

            height: parent.height

            Row {
                height: parent.height
                anchors.right: parent.right
                layoutDirection: Qt.RightToLeft

                Item {
                    id: languageIcon

                    width: visible ? height : 0
                    height: parent.height
                    visible: root.showLanguage && inputBehavior.focus

                    Text {
                        id: languageText

                        color: root.style.placeholder
                        font { family: "Arial"; pixelSize: 14; capitalization: Font.AllUppercase }
                        visible: false
                        anchors.centerIn: parent
                    }

                    Image {
                        id: languageImage

                        source: ""
                        anchors.centerIn: parent
                    }

                    states: [
                        State {
                            name: "RuLayout"
                            when: inputBehavior.language == "RU"
                            PropertyChanges {
                                target: languageImage
                                source: installPath + "Assets/Images/ProtocolOne/Controls/Input/keyboard_ru.png"
                                visible: true
                            }
                            PropertyChanges {
                                target: languageText
                                visible: false
                            }
                        },
                        State {
                            name: "EnLayout"
                            when: inputBehavior.language == "EN"
                            PropertyChanges {
                                target: languageImage
                                source: installPath + "Assets/Images/ProtocolOne/Controls/Input/keyboard_en.png"
                                visible: true
                            }
                            PropertyChanges {
                                target: languageText
                                visible: false
                            }
                        },
                        State {
                            name: "OtherLayout"
                            when:  inputBehavior.language != "RU" && inputBehavior.language != "EN"
                            PropertyChanges {
                                target: languageImage
                                visible: false
                            }
                            PropertyChanges {
                                target: languageText
                                visible: true
                                text: inputBehavior.language
                            }
                        }
                    ]
                }

                Item {
                    id: capslockIcon

                    width: visible ? height : 0
                    height: parent.height
                    visible: inputBehavior.activeFocus && root.showCapslock && inputBehavior.capsLock
                    anchors.verticalCenter: parent.verticalCenter

                    Image {
                        anchors.centerIn: parent
                        source: installPath + "Assets/Images/ProtocolOne/Controls/Input/capslock.png"
                    }
                }

                Item {
                    id: eyeIcon

                    width: visible ? height : 0
                    height: parent.height
                    visible: root.passwordType === true && root.text.length

                    Image {
                        anchors.centerIn: parent
                        source: eyeMouser.containsMouse
                            ? installPath + "Assets/Images/ProtocolOne/Controls/Input/eye_hover.png"
                            : installPath + "Assets/Images/ProtocolOne/Controls/Input/eye.png"
                    }

                    CursorMouseArea {
                        id: eyeMouser

                        anchors.fill: parent
                    }
                }
            }
        }
    }

    Rectangle {
        id: suggestionsBorder

        anchors {
            left: parent.left
            right: parent.right
            top: parent.bottom
            topMargin: -2
        }

        height: suggestionsView.height + 4
        visible: root.isSuggestionsContainerVisible()

        color: style.background
        border {
            color: root.style.active
            width: 2
        }

        Item {
            id: suggestionsContainer

            property bool controlVisible: false

            anchors { fill: parent; margins: 2 }

            function decrementCurrentIndex() {
                var newIndex;

                if (suggestionsView.count == 0) {
                    return;
                }

                newIndex = suggestionsView.currentIndex - 1;
                if (newIndex < 0) {
                    newIndex = suggestionsView.count - 1;
                }

                suggestionsView.currentIndex = newIndex;
            }

            function incrementCurrentIndex() {
                var newIndex = -1;

                if (suggestionsView.count == 0) {
                    return;
                }

                newIndex = suggestionsView.currentIndex + 1;

                if (newIndex >= suggestionsView.count) {
                    newIndex = 0;
                }

                suggestionsView.currentIndex = newIndex;
            }

            function selectCurrent() {
                var value = "";

                if (suggestionsView.count == 0) {
                    return;
                }

                if (suggestionsView.currentIndex >= 0) {
                    value = suggestionsView.model.get(suggestionsView.currentIndex).value;
                } else {
                    value = suggestionsView.model.get(0).value;
                }

                root.text = value;
                autoCompleteText.text = "";
                suggestionsContainer.controlVisible = false;
            }

            ListView {
                id: suggestionsView

                onCurrentIndexChanged: {
                    if (currentIndex >= 0)
                        autoCompleteText.text = suggestionsView.model.get(currentIndex).value;
                }

                width: mouseArea.width
                height: suggestionsView.model.count > 0 ? (mouseArea.height * suggestionsView.model.count) : 2
                interactive: false
                clip: true

                model: typeahead.proxyModel

                delegate: Rectangle {
                    color: suggestionsView.currentIndex == index || delegateArea.containsMouse ? "#FFCC00" : "#FFFFFF"
                    width: mouseArea.width
                    height: mouseArea.height

                    Text {
                        anchors {
                            right: parent.right
                            rightMargin: 10
                            left: parent.left
                            leftMargin: mouseArea.height + 10
                            verticalCenter: parent.verticalCenter
                        }
                        elide: Text.ElideRight
                        text: model.value
                        color: '#66758F'
                        font { family: 'Arial'; pixelSize: 16 }
                    }

                    MouseArea {
                        id: delegateArea

                        anchors.fill: parent
                        hoverEnabled: true

                        onClicked: {
                            root.text = value;
                            suggestionsContainer.controlVisible = false;
                        }
                    }
                }
            }
        }
    }

    StateGroup {
        id: internalState

        states: [
            State {
                name: ""
                PropertyChanges { target: controlBorder; border.color: style.normal }
                PropertyChanges { target: inputBehavior; color: style.text }
            },
            State {
                name: "Active"
                when: inputBehavior.activeFocus && Qt.application.active
                PropertyChanges { target: controlBorder; border.color: style.active }
                PropertyChanges { target: inputBehavior; color: style.active }
            },
            State {
                name: "Hover"
                when: mouseArea.containsMouse
                PropertyChanges { target: controlBorder; border.color: style.active }
                PropertyChanges { target: inputBehavior; color: style.active }
            },
            State {
                name: "Disabled"
                when: !root.enabled
                PropertyChanges { target: controlBorder; border.color: style.disabled }
                PropertyChanges { target: iconImage; opacity: 0.2 }
                PropertyChanges { target: inputBehavior; opacity: 0.2 }
            },
            State {
                name: "ErrorNormal"
                when: inputBehavior.error

                PropertyChanges { target: controlIcon; color: style.error }
                PropertyChanges { target: controlBorder; border.color: style.error }
                PropertyChanges { target: inputBehavior; color: style.error }
            },
            State {
                name: "ErrorActive"
                when: inputBehavior.activeFocus && inputBehavior.error
                PropertyChanges { target: controlBorder; border.color: style.hover }
                PropertyChanges { target: inputBehavior; color: style.hover }
            },
            State {
                name: "ErrorHover"
                when: mouseArea.containsMouse && inputBehavior.error
                PropertyChanges { target: controlBorder; border.color: style.hover }
                PropertyChanges { target: inputBehavior; color: style.error }
            }
        ]
    }
}
