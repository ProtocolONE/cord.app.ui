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
    property int currentIndex: 0
    property int dropDownSize: -1
    property ListModel model: ListModel {}

    property int fontSize: 16
    property variant style: InputStyleColors {}
    property string icon

    function append(value, text, icon) {
        root.model.append({"value": value, "text": text, "icon": icon})
    }

    function findValue(value) {
        var i, item;

        for (i = 0; i < model.count; i++) {
            item = model.get(i);
            if (item.value && item.value === value) {
                return i;
            }
        }

        return -1;
    }

    function getValue(index) {
        if(root.model.count == 0 || index < 0 || index >= root.model.count) {
            return;
        }
        return root.model.get(index).value;
    }

    function setValue(index, value) {
        if(root.model.count == 0 || index < 0 || index >= root.model.count) {
            return;
        }

        root.model.setProperty(index, "value", value);
    }

    function findText(text) {
        var i, item;

        for (i = 0; i < model.count; i++) {
            item = model.get(i);
            if (item.text && item.text === text) {
                return i;
            }
        }

        return -1;
    }

    function getText(index) {
        if(root.model.count == 0 || index < 0 || index >= root.model.count) {
            return "";
        }
        return root.model.get(index).text;
    }

    function setText(index, text) {
        if(root.model.count == 0 || index < 0 || index >= root.model.count) {
            return;
        }

        root.model.setProperty(index, "text", text);
    }

    Connections {
        target: mainWindow
        onLeftMouseClick: {
            var posInItem;

            posInItem = listBlock.mapFromItem(mainWindow, x, y);

            if (posInItem.x < 0 || posInItem.x > listBlock.width ||
                    posInItem.y < 0 || posInItem.x > listBlock.height) {
                listContainer.controlVisible = false;
            }
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

        Item {
            width: control.width
            height: control.height

            Rectangle {
                id: iconContainer

                width: root.icon != "" ? parent.height : 0
                height: root.icon != "" ? parent.height : 0
                color: "#FFFFFF"
                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }

                Image {
                    id: iconImage

                    source: root.icon
                    anchors.centerIn: parent
                }
            }

            Item {
                anchors {
                    left: iconContainer.right
                    leftMargin: 10
                    right: showListButton.left
                    rightMargin: 10
                    verticalCenter: parent.verticalCenter
                }
                height: parent.height

                Item {
                    anchors.fill: parent
                    clip: true

                    Text {
                        id: placeholderText

                        anchors {
                            left: parent.left
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                        }
                        color: root.style.normal
                        elide: Text.ElideRight
                        font { family: "Arial"; pixelSize: root.fontSize }
                        text: (root.model.count > 0 && root.currentIndex >= 0) ?
                                  (root.model.get(root.currentIndex).text || "") : ""
                    }
                }
            }

            Rectangle {
                id: showListButton

                width: parent.height
                height: parent.height
                color: "#FFFFFF"
                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }

                Image {
                    id: showListButtonImage

                    anchors.centerIn: parent
                    source: installPath + "images/Controls/ComboBox/down_n.png"
                }
            }
        }

        MouseArea {
            id: mouseArea

            hoverEnabled: true
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton
            onClicked: listContainer.controlVisible = !listContainer.controlVisible;
        }
        CursorArea {
            id: iconMouseCursor

            cursor: CursorArea.PointingHandCursor
            anchors.fill: parent
            visible: mouseArea.containsMouse
        }
    }

    Item {
        id: listBlock

        anchors {
            left: root.left
            top: root.bottom
            topMargin: -2
        }
        width: root.width
        height: listContainer.controlVisible ? listView.height + 4 : 0

        Rectangle {
            anchors { fill: parent; margins: 1}
            color: "#FFFFFF"
            border {
                color: root.style.active
                width: 2
            }
        }

        Behavior on height {
            NumberAnimation {
                duration: 150
            }
        }

        Item {
            id: listContainer

            property bool controlVisible: false

            opacity: 0
            width: control.width
            height: listView.height
            anchors { fill: parent; margins: 2 }

            ListView {
                id: listView

                property int listSize: (root.dropDownSize > 0) ? root.dropDownSize : listView.model.count

                width: control.width
                height: listView.model.count > 0 ? (control.height * listSize) : 2
                interactive: false
                clip: true

                model: root.model

                delegate: Rectangle {
                    color: delegateArea.containsMouse ? "#FFCC00" : "#FFFFFF"
                    width: control.width
                    height: control.height

                    Text {
                        anchors {
                            right: parent.right
                            rightMargin: 10
                            left: parent.left
                            leftMargin: root.icon != "" ? control.height + 10 : 10
                            verticalCenter: parent.verticalCenter
                        }
                        elide: Text.ElideRight
                        text: qsTr(model.text)
                        color: '#66758F'
                        font { family: 'Arial'; pixelSize: 16 }
                    }

                    MouseArea {
                        id: delegateArea

                        anchors.fill: parent
                        hoverEnabled: true

                        onClicked: {
                            root.currentIndex = index;
                            listContainer.controlVisible = false;
                        }
                    }
                }
            }
        }

        StateGroup {
            state: ""
            states: [
                State {
                    name: ""
                    PropertyChanges { target: listContainer; opacity: 0 }
                },
                State {
                    name: "ListOpened"
                    when: listContainer.controlVisible
                    PropertyChanges { target: listContainer; opacity: 1 }
                }
            ]

            transitions: [
                Transition {
                    from: ""
                    to: "ListOpened"

                    SequentialAnimation {
                        PauseAnimation { duration: 150 }

                        PropertyAnimation {
                            properties: "opacity"
                            duration: 150
                        }
                    }
                }
            ]
        }
    }

    StateGroup {
        states: [
            State {
                name: ""
                PropertyChanges { target: controlBorder; border.color: style.normal }
                PropertyChanges { target: placeholderText; color: root.style.normal }
                PropertyChanges { target: showListButtonImage; source: installPath + "images/Controls/ComboBox/down_n.png" }
            },
            State {
                name: "Active"
                when: inputBehavior.activeFocus || listContainer.controlVisible
                PropertyChanges { target: controlBorder; border.color: style.active }
                PropertyChanges { target: placeholderText; color: root.style.active }
                PropertyChanges { target: showListButtonImage; source: installPath + "images/Controls/ComboBox/down_a.png" }
            },
            State {
                name: "Hover"
                when: mouseArea.containsMouse || listContainer.controlVisible
                PropertyChanges { target: controlBorder; border.color: style.active }
                PropertyChanges { target: placeholderText; color: root.style.active }
                PropertyChanges { target: showListButtonImage; source: installPath + "images/Controls/ComboBox/down_a.png" }

            },
            State {
                name: "Disabled"
                when: !root.enabled
                PropertyChanges { target: controlBorder; border.color: style.disabled }
                PropertyChanges { target: placeholderText; color: style.disabled }
                PropertyChanges { target: iconImage; opacity: 0.2 }
            },
            State {
                name: "ErrorNormal"
                when: inputBehavior.error
                PropertyChanges { target: controlBorder; border.color: style.error }
                PropertyChanges { target: placeholderText; color: style.error }
            },
            State {
                name: "ErrorActive"
                when: inputBehavior.activeFocus && inputBehavior.error
                PropertyChanges { target: controlBorder; border.color: style.hover }
                PropertyChanges { target: placeholderText; color: style.hover }
            },
            State {
                name: "ErrorHover"
                when: mouseArea.containsMouse && inputBehavior.error
                PropertyChanges { target: controlBorder; border.color: style.hover }
                PropertyChanges { target: placeholderText; color: style.hover }
            }
        ]
    }
}
