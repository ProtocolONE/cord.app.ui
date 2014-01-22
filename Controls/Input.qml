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

Rectangle {
    id: control

    property bool enabled: true
    property alias text: inputBehavior.text
    property int maxLength: 32767
    property alias echoMode: inputBehavior.echoMode
    property bool showCapslock: true
    property bool showLanguage: true
    property variant typeahead: TypeaheadBehaviour {}

    property int fontSize: 16
    property variant style: InputStyleColors {}

    property alias errorMessage: errorMessage.text

    property alias icon: iconImage.source
    property alias iconBackground: controlIcon.color
    property bool iconHovered: false

    signal iconClicked()

    color: "#FFFFFF"
    border {
        width: 2
        color: style.normal
    }

    Behavior on border.color {
        ColorAnimation { duration: 300 }
    }

    Rectangle {
        id: controlIcon

        property bool internaMouseOver: false
        property bool isMouseOver: internaMouseOver && mouseArea.containsMouse

        onIsMouseOverChanged: {
            if (isMouseOver) {
                iconHovered = true;
            } else {
                iconHovered = false;
            }
        }

        function isOver(x, y) {
            var internalPos = mapToItem(controlIcon, x, y);
            if (0 < internalPos.x && internalPos.x < controlIcon.width && 0 < internalPos.y && internalPos.y < controlIcon.height) {
                internaMouseOver = true;
                return;
            }
            internaMouseOver =  false;
        }

        visible: control.icon != ""
        width: control.icon != "" ? parent.height - 2 : 0
        height: parent.height - 2
        color: "#FFFFFF"

        anchors {
            left: parent.left
            leftMargin: 1
            verticalCenter: parent.verticalCenter
        }

        Image {
            id: iconImage

            anchors.centerIn: parent
            source: control.icon
        }
    }

    Item {
        anchors {
            left: controlIcon.right
            leftMargin: 5
            right: capslockIcon.left
            rightMargin: 5
            verticalCenter: parent.verticalCenter
        }

        Text {
            id: autoCompleteText

            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            color: "#d6d6d6"
            elide: Text.ElideRight
            font { family: "Arial"; pixelSize: control.fontSize }
        }

        InputBehaviour {
            id: inputBehavior

            fontSize: control.fontSize
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
                    suggestionsContainer.controlVisible = false;
                    return;
                }

                if (event.key >= Qt.Key_Space && event.key <= Qt.Key_AsciiTilde) {
                    if (text.length>= control.maxLength) {
                        inputBehavior.error = true;
                        QMultimedia.playSound(installPath + "Sounds/Controls/error.wav");
                        return;
                    }
                }

                if (text.length <= control.maxLength) {
                    inputBehavior.error = false;
                }
            }

            onFocusLost: {
                suggestionsContainer.controlVisible = false;
            }
            onTextChanged: {
                autoCompleteText.text = "";
                typeahead.filter = text;
                suggestionsContainer.controlVisible = true;
            }
        }
    }

    Rectangle {
        id: capslockIcon

        width: visible ? 32 : 0
        height: 24
        visible: inputBehavior.activeFocus && control.showCapslock && inputBehavior.capsLock
        anchors {
            right: languageIcon.left
            rightMargin: 5
            verticalCenter: parent.verticalCenter
        }

        Image {
            anchors.centerIn: parent
            source: installPath + "Images/Controls/Input/capslock.png"
        }
    }

    Item {
        id: languageIcon

        width: control.showLanguage ? 24 : 0
        height: 24
        visible: control.showLanguage && inputBehavior.focus
        anchors {
            right: parent.right
            rightMargin: 5
            verticalCenter: parent.verticalCenter
        }

        Image {
            id: languageImage

            anchors.centerIn: parent
        }

        Text {
            id: languageText

            color: "#FF6555"
            font { family: "Arial"; pixelSize: 20; capitalization: Font.AllUppercase }
            visible: false
            anchors.verticalCenter: parent.verticalCenter
            anchors.fill: parent
        }

        states: [
            State {
                name: "RuLayout"
                when: inputBehavior.language == "ru"
                PropertyChanges {
                    target: languageImage
                    source: installPath + "Images/Controls/Input/keyboard_ru.png"
                }
                PropertyChanges {
                    target: languageText
                    visible: false
                }
            },
            State {
                name: "EnLayout"
                when: inputBehavior.language == "en"
                PropertyChanges {
                    target: languageImage
                    source: installPath + "Images/Controls/Input/keyboard_en.png"
                }
                PropertyChanges {
                    target: languageText
                    visible: false
                }
            },
            State {
                name: "OtherLayout"
                when:  inputBehavior.language != "ru" && inputBehavior.language != "en"
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


    ErrorMessage {
        id: errorMessage

        visible: text.length > 0 && inputBehavior.error
        width: parent.width + 2
        height: 30
        anchors {
            left: parent.left
            leftMargin: -1
            top: parent.bottom
            topMargin: 2
        }
    }

    MouseArea {
        id: mouseArea

        hoverEnabled: true
        anchors.fill: parent

        onClicked: {
            if (controlIcon.isMouseOver) {
                control.iconClicked();
            }

            inputBehavior.focus = true;
        }
        onPositionChanged: controlIcon.isOver(mouse.x, mouse.y);
    }

    Rectangle {
        id: suggestionsContainer

        property bool controlVisible: false

        function decrementCurrentIndex() {
            var newIndex = -1;

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

            control.text = value;
            autoCompleteText.text = "";
            suggestionsContainer.controlVisible = false;
        }

        width: parent.width
        height: suggestionsView.height + 2
        color: "#FFFFFF"
        visible: controlVisible && suggestionsView.model.count > 0
        border {
            color: control.style.active
            width: 2
        }
        anchors {
            left: parent.left
            top: parent.bottom
        }

        ListView {
            id: suggestionsView

            onCurrentIndexChanged: {
                if (currentIndex >= 0)
                    autoCompleteText.text = suggestionsView.model.get(currentIndex).value;
            }

            width: control.width - 2
            height: suggestionsView.model.count > 0 ? (control.height * suggestionsView.model.count) : 2
            anchors {
                centerIn: parent
            }
            interactive: false
            clip: true

            model: typeahead.proxyModel

            delegate: Rectangle {
                color: suggestionsView.currentIndex == index || delegateArea.containsMouse ? "#FFCC00" : "#FFFFFF"
                width: control.width
                height: 40

                Rectangle {
                    id: spacer

                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                    }
                    width: 48
                    height: 40
                    color: "#00FFFFFF"
                }

                Text {
                    anchors {
                        left: spacer.right
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }
                    text: value
                    color: '#66758F'
                    font { family: 'Arial'; pixelSize: 16 }
                }

                MouseArea {
                    id: delegateArea

                    anchors.fill: parent
                    hoverEnabled: true

                    onClicked: {
                        control.text = value;
                        suggestionsContainer.controlVisible = false;
                    }
                }
            }
        }
    }

    StateGroup {
        states: [
            State {
                name: ""
                PropertyChanges { target: control; border.color: style.normal }
                PropertyChanges { target: inputBehavior; color: style.normal }
            },
            State {
                name: "Active"
                when: inputBehavior.activeFocus
                PropertyChanges { target: control; border.color: style.active }
                PropertyChanges { target: inputBehavior; color: style.active }
            },
            State {
                name: "Hover"
                when: mouseArea.containsMouse
                PropertyChanges { target: control; border.color: style.active }

            },
            State {
                name: "Disabled"
                when: !enabled
                PropertyChanges { target: control; border.color: style.disabled }
                PropertyChanges { target: iconImage; opacity: 0.2 }
                PropertyChanges { target: inputBehavior; opacity: 0.2 }
            },
            State {
                name: "ErrorNormal"
                when: inputBehavior.error
                PropertyChanges { target: control; border.color: style.error }
                PropertyChanges { target: inputBehavior; color: style.error }
            },
            State {
                name: "ErrorActive"
                when: inputBehavior.activeFocus && inputBehavior.error
                PropertyChanges { target: control; border.color: style.hover }
                PropertyChanges { target: inputBehavior; color: style.hover }
            },
            State {
                name: "ErrorHover"
                when: mouseArea.containsMouse && inputBehavior.error
                PropertyChanges { target: control; border.color: style.hover }
                PropertyChanges { target: inputBehavior; color: style.error }
            }
        ]
    }
}
