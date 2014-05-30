/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 1.1
import Tulip 1.0

Item {
    id: root

    property bool enabled: true
    property alias readOnly: inputBehavior.readOnly
    property alias text: inputBehavior.text
    property alias placeholder: placeholderText.text
    property alias maximumLength: inputBehavior.maximumLength
    property alias echoMode: inputBehavior.echoMode
    property bool showCapslock: true
    property bool showLanguage: true
    property variant typeahead: TypeaheadBehaviour {}

    property alias language: inputBehavior.language
    property alias capsLock: inputBehavior.capsLock

    property int fontSize: 16
    property variant style: InputStyleColors {}

    property alias error: inputBehavior.error

    property alias icon: iconImage.source
    property alias iconBackground: controlIcon.color
    property bool iconHovered: false
    property alias iconCursor: iconMouseCursor.cursor

    property alias inputMask: inputBehavior.inputMask
    property alias validator: inputBehavior.validator

    signal iconClicked()

    onFocusChanged: {
        if (focus) {
            inputBehavior.focus = true
        }
    }

    Rectangle {
        id: controlBorder

        anchors { fill: parent; margins: 1 }
        color: "#FFFFFF"
        border { width: 2; color: style.normal }

        Behavior on border.color {
            ColorAnimation { duration: 300 }
        }
    }

    Item {
        id: control

        anchors { fill: parent; margins: 2 }

        Rectangle {
            id: controlIcon

            property bool internaMouseOver: false
            property bool isMouseOver: internaMouseOver && mouseArea.containsMouse

            onIsMouseOverChanged: iconHovered = isMouseOver;

            function isOver(x, y) {
                var internalPos = mapToItem(controlIcon, x, y);
                if (0 < internalPos.x && internalPos.x < controlIcon.width
                        && 0 < internalPos.y && internalPos.y < controlIcon.height) {
                    internaMouseOver = true;
                    return;
                }

                internaMouseOver =  false;
            }

            visible: root.icon != ""
            width: root.icon != "" ? parent.height : 0
            height: parent.height
            color: "#FFFFFF"

            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }

            Image {
                id: iconImage

                anchors.centerIn: parent
                source: root.icon
            }

            MouseArea {
                anchors.fill: parent
                onClicked: root.iconClicked();
            }

            CursorArea {
                id: iconMouseCursor

                cursor: CursorArea.ArrowCursor
                anchors.fill: parent
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

            Item {
                anchors.fill: parent
                clip: true

                Text {
                    id: autoCompleteText

                    function getFirstPosition() {
                        // INFO нужен биндинг на inputBehavior.cursorPosition, но значение его не важно для расчетов.
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
                    color: "#FFFFFF"
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

                fontSize: root.fontSize
                anchors {
                    left: parent.left
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }

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
                        return;
                    }

                    if (event.key == Qt.Key_Escape) {
                        if (suggestionsContainer.controlVisible) {
                            suggestionsContainer.controlVisible = false;
                            return;
                        }

                        inputBehavior.focus = false;
                        return;
                    }

                    if (event.key >= Qt.Key_Space && event.key <= Qt.Key_AsciiTilde) {
                        if (text.length >= root.maximumLength) {
                            QMultimedia.playSound(installPath + "Assets/Sounds/GameNet/Controls/error.wav");
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

                        color: "#FF6555"
                        font { family: "Arial"; pixelSize: 20; capitalization: Font.AllUppercase }
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
                                source: installPath + "Assets/Images/GameNet/Controls/Input/keyboard_ru.png"
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
                                source: installPath + "Assets/Images/GameNet/Controls/Input/keyboard_en.png"
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

                Rectangle {
                    id: capslockIcon

                    width: visible ? height : 0
                    height: parent.height
                    visible: inputBehavior.activeFocus && root.showCapslock && inputBehavior.capsLock
                    anchors.verticalCenter: parent.verticalCenter

                    Image {
                        anchors.centerIn: parent
                        source: installPath + "Assets/Images/GameNet/Controls/Input/capslock.png"
                    }
                }
            }
        }
    }

    MouseArea {
        id: mouseArea

        hoverEnabled: true
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        onClicked: inputBehavior.focus = true;
        onPositionChanged: controlIcon.isOver(mouse.x, mouse.y);
    }

    Item {
        anchors {
            left: parent.left
            right: parent.right
            top: parent.bottom
            topMargin: -2
        }

        height: suggestionsView.height + 4
        visible: suggestionsContainer.controlVisible && suggestionsView.model.count > 0

        Rectangle {
            anchors { fill: parent; margins: 1 }
            color: "#FFFFFF"
            border {
                color: root.style.active
                width: 2
            }
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

                width: control.width
                height: suggestionsView.model.count > 0 ? (control.height * suggestionsView.model.count) : 2
                interactive: false
                clip: true

                model: typeahead.proxyModel

                delegate: Rectangle {
                    color: suggestionsView.currentIndex == index || delegateArea.containsMouse ? "#FFCC00" : "#FFFFFF"
                    width: control.width
                    height: control.height

                    Text {
                        anchors {
                            right: parent.right
                            rightMargin: 10
                            left: parent.left
                            leftMargin: control.height + 10
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
        states: [
            State {
                name: ""
                PropertyChanges { target: controlBorder; border.color: style.normal }
                PropertyChanges { target: inputBehavior; color: style.normal }
            },
            State {
                name: "Active"
                when: inputBehavior.activeFocus
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
