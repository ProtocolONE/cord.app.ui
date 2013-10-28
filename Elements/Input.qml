/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1
import "." as Elements

Rectangle {
    id: input

    property string fontFamily: "Century Gothic"
    property int fontSize: 16
    property color textColor: "#000"
    property alias searchText: textInputLogin.text

    property bool failState: false
    property color inputColor: "#eaf5e5"
    property color inputColorHover: "#fff"

    property string inputMask
    property int maximumLength: 32767

    property string text: textInputLogin.text
    /** @depricated Use text instead of editText */
    property string editText: textInputLogin.text


    property bool showKeyboardLayout: false
    property string editDefaultText: qsTr("Login")

    property int textEchoMode: TextInput.Normal
    property alias textEditComponent: textInputLogin
    property bool editFocus: false
    property bool readOnly: false
    property bool acceptableInput: textInputLogin.acceptableInput
    property variant validator

    signal searchEntered(string text)
    signal enterPressed()
    signal tabPressed()

    function setAutoCompleteSource(source) {
        typeaheadModel.clear();

        Object.keys(source).forEach(function(e) {
            if (!e) {
                return;
            }

            typeaheadModel.append({login: e, value: source[e]});
        });
    }

    function clear() {
        textInputLogin.text = "";
    }

    function filterFunc(a, b) {
        return true;
    }

    function sortFunc(a, b) {
        if (a.value < b.value) {
            return 1;
        }

        return -1;
    }

    onTabPressed: {
        if (!textInputLogin.text || typeahead.numFilerItems <= 0) {
            return;
        }

        textInputLogin.text = typeahead.completeText();
    }

    Keys.onDownPressed: {
        if (!textInputLogin.text || typeahead.numFilerItems <= 0) {
            return;
        }

        typeahead.incrementCurrentIndex();
    }

    Keys.onUpPressed: {
        if (!textInputLogin.text || typeahead.numFilerItems <= 0) {
            return;
        }

        typeahead.decrementCurrentIndex();
    }

    Keys.onRightPressed: {
        if (!textInputLogin.text) {
            return;
        }

        if (typeahead.numFilerItems > 0) {
            textInputLogin.text = typeahead.completeText();
            typeahead.numFilerItems = 0;
        } else {
            enterPressed();
        }
    }
    onValidatorChanged: textInputLogin.validator = validator;

    width: 250
    height: 32

    Rectangle {
        id: inputEditor

        width: parent.width; height: parent.height
        color: inputColor
        border { width: failState ? 1 : 0; color: "#E5392D" }
    }

    Text {
        id: placeholderText

        anchors {fill: parent; leftMargin: 8}
        verticalAlignment: Text.AlignVCenter
        text: editDefaultText
        color: textColor
        opacity: 0.5
        font { family: fontFamily; pixelSize: 14 }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: input.editFocus = true
    }

    Text {
        id: autoCompleteText

        property int typeTextCoord: textInputLogin.positionToRectangle(textInputLogin.text.length).x

        anchors { left: parent.left; leftMargin: 8; verticalCenter: parent.verticalCenter }
        width: textInputLogin.width
        font { family: fontFamily; pixelSize: fontSize }
        elide: Text.ElideRight
        color: '#9a9a9a'
        text: typeahead.completeText();
        visible: (typeahead.numFilerItems > 0) &&
                 (typeTextCoord < (width - (textInputLogin.anchors.leftMargin + textInputLogin.anchors.rightMargin)))
    }

    TextInput {
        id: textInputLogin

        anchors {
            left: parent.left;
            leftMargin: 8; right: layoutHint.visible ? layoutHint.left : parent.right;
            rightMargin: 8;
            verticalCenter: parent.verticalCenter
        }
        selectByMouse: true
        maximumLength: input.maximumLength
        inputMask: input.inputMask
        readOnly: input.readOnly
        color: failState ? "#E5392D" : textColor
        font { family: fontFamily; pixelSize: fontSize }
        focus: editFocus
        onAccepted: { input.opacity = 0; input.searchEntered(text); }
        echoMode: textEchoMode

        onTextChanged: typeahead.filter = text;

        onFocusChanged: {
            if (focus) {
                inputEditor.color = inputColorHover
            } else {
                inputEditor.color = inputColor
                typeahead.numFilerItems = 0;
            }
        }

        Keys.onPressed: {
            failState = false;

            if (event.key == Qt.Key_Return  || event.key == Qt.Key_Enter) {              
                if (typeahead.numFilerItems > 0) {
                    text = typeahead.completeText();
                    typeahead.numFilerItems = 0;
                } else {
                    enterPressed();
                }

                event.accepted = true;
                return;
            }

            if (event.key == Qt.Key_Tab || event.key == Qt.Key_Backtab) {
                tabPressed();
                event.accepted = true;
                return;
            }

            if (event.key == Qt.Key_Escape) {
                typeahead.hide();
            }
        }
    }

    Rectangle {
        id: layoutHint

        width: 24
        height: 24
        visible: showKeyboardLayout && textInputLogin.focus
        anchors { right: parent.right; top: parent.top; topMargin: 2; rightMargin: 2 }

        color: keybLayoutMouseArea.containsMouse ? '#2d8700' : '#6cab4c'

        CursorMouseArea {
            id: keybLayoutMouseArea

            anchors.fill: parent
            onClicked: keyboardHook.changeLayout();
        }

        Text {
            anchors.centerIn: parent
            text: keyboardHook.keyboardLayout
            color: '#ffffff'
            font { family: 'Arial'; pixelSize: 12; bold: true }
        }
    }


    Item {
        anchors { left: parent.right; top: parent.top; bottom: parent.bottom; leftMargin: 6 }
        width: capsLockTips.width + 20
        visible: keyboardHook.capsLockEnabled && showKeyboardLayout && textInputLogin.focus

        Rectangle {
            anchors.fill: parent
            color: '#266f01'
        }

        Text {
            id: capsLockTips

            anchors.centerIn: parent

            text: qsTr("ENABLED_CAPSLOCK_TIPS")
            color: '#ffffff'
        }
    }

    Rectangle {
        anchors { left: parent.left; top: parent.bottom }
        width: parent.width
        height: 2
        color: '#cccccc'
        visible: parent.textEditComponent.focus && typeahead.model.count > 0 && typeahead.numFilerItems > 0

        Rectangle {
            anchors { fill: parent; topMargin: 1 }
            color: '#ffffff'
        }

        onVisibleChanged: {
            if (!visible) {
                typeahead.currentIndex = -1;
            }

            typeahead.refreshFilters();
        }

        ListView {
            id: typeahead

            function hide() {
                //numFilerItems = 0;
                filter = '';
                typeahead.currentIndex = -1;
                firstLoginId = -1;
            }

            function completeText() {
                if (typeahead.currentIndex != -1) {
                    return typeahead.model.get(typeahead.currentIndex).login;
                }

                return typeahead.firstLogin;
            }

            function sortListModel(sortFunction)
            {
                var sortdata = [];

                for (var i = 0; i < model.count; ++i)
                    sortdata[i] = model.get(i);

                sortdata.sort(sortFunction);

                for (var i = 0; i < sortdata.length; ++i)
                    for (var j = 0; j < model.count; ++j)
                        if (model.get(j) === sortdata[i]) {
                            model.move(j, model.count - 1, 1);
                            break;
                        }
            }

            function refreshFilters() {
                var i, item,
                    itemsCount = 0,
                    lowerFilter,
                    lowerLogin;

                firstLoginId = -1;

                sortListModel(sortFunc);

                for (i = 0; i < typeahead.model.count; ++i) {
                    item = typeahead.model.get(i);

                    if (filterFunc(item.login, typeahead.filter)) {
                        ++itemsCount;

                        if (firstLoginId == -1) {
                            firstLoginId = i;
                        }
                    }
                }

                numFilerItems = itemsCount;
            }

            function incrementCurrentIndex() {
                var item;

                if (numFilerItems <= 0) {
                    return;
                }

                for (var i = currentIndex + 1; ; ++i) {

                    if (i == typeahead.model.count) {
                        i = 0;
                    }

                    item = typeahead.model.get(i);

                    if (!item) {
                        continue;
                    }

                    if (filterFunc(item.login, typeahead.filter) &&
                        internalFilterFunc(i)) {
                        currentIndex = i;
                        return;
                    }
                }
            }

            function decrementCurrentIndex() {
                var item;

                if (numFilerItems <= 0) {
                    return;
                }

                for (var i = currentIndex - 1; ; --i) {

                    if (i < 0) {
                        i = typeahead.model.count - 1;
                    }

                    item = typeahead.model.get(i);

                    if (!item) {
                        continue;
                    }

                    if (filterFunc(item.login, typeahead.filter) &&
                        internalFilterFunc(i)) {
                        currentIndex = i;
                        return;
                    }
                }
            }

            function internalFilterFunc(index){
                var item, comp = 0;

                for (var i = 0; i < typeahead.model.count && comp < 5; ++i) {
                    item = typeahead.model.get(i);

                    if (filterFunc(item.login, typeahead.filter)) {
                        ++comp;
                    }

                    if (index == i) {
                        return true;
                    }
                }

                return false;
            }

            property string firstLogin: firstLoginId < 0 ? '' : model.get(firstLoginId).login
            property int firstLoginId: -1
            property int numFilerItems: 0
            property string filter: ''

            onModelChanged: refreshFilters();
            onCountChanged: refreshFilters();
            onFilterChanged: refreshFilters();

            y: 2
            width: parent.width
            height: 24 * 5
            interactive: false
            currentIndex: -1

            model: ListModel {
                id: typeaheadModel
            }

            delegate: Rectangle {
                property bool _active: typeahead.currentIndex == index
                property bool filterAccepted: filterFunc(login, typeahead.filter) &&
                                              typeahead.internalFilterFunc(index)

                width: parent.width
                height: filterAccepted ? 24 : 0
                visible: filterAccepted
                color: _active ? "#fdedaf" : ma.containsMouse ? '#fff5ce' : '#ffffff'

                Text {
                    x: 5
                    y: 2
                    width: parent.width - x
                    text: login
                    color: '#111111'
                    elide: Text.ElideRight
                    font { family: 'Arial'; pixelSize: 14 }
                }

                MouseArea {
                    id: ma

                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        input.textEditComponent.text = login;
                        typeahead.numFilerItems = 0;
                    }
                }
            }
        }
    }

    states: State {
        name: "hasText"; when: textInputLogin.text != ''
        PropertyChanges { target: placeholderText; opacity: 0 }
    }

    transitions: [
        Transition {
            from: ""; to: "hasText"
            NumberAnimation { exclude: placeholderText; properties: "opacity" }
        },
        Transition {
            from: "hasText"; to: ""
            NumberAnimation { properties: "opacity" }
        }
    ]
}
