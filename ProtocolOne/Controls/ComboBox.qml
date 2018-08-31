import QtQuick 2.4
import Tulip 1.0

Item {
    id: root

    property bool enabled: true
    property int currentIndex: 0
    property int dropDownSize: -1
    property ListModel model: ListModel {}

    property int fontSize: 15
    property ComboBoxStyle style: ComboBoxStyle {}
    property string icon

    property alias listBlock: listBlock
    property alias listContainer: listContainer

    property bool preventDefault: false

    implicitHeight: 40

    function append(value, text, icon) {
        root.model.append({"value": value, "text": text, "icon": icon})
    }

    function findValue(value) {
        var i, item;

        for (i = 0; i < model.count; i++) {
            item = model.get(i);
            if (item.value != undefined && item.value == value) {
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
            if (item.text != undefined && item.text === text) {
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

    function isMouseInside(x, y) {
        var translatedCoords;

        translatedCoords = controlBorder.mapFromItem(root, x, y);
        if (translatedCoords.x > 0 && translatedCoords.x < controlBorder.width &&
                translatedCoords.y > 0 && translatedCoords.y < controlBorder.height) {
            return true;
        }

        if (!root.listContainer.controlVisible) {
            return false;
        }

        translatedCoords = listBlock.mapFromItem(root, x, y);
        if (translatedCoords.x > 0 && translatedCoords.x < listBlock.width &&
                translatedCoords.y > 0 && translatedCoords.y < listBlock.height) {
            return true;
        }

        return false;
    }

    Rectangle {
        id: controlBorder

        anchors.fill: parent
        color: root.style.background
        border { width: 2; color: root.style.normal }

        Behavior on border.color {
            ColorAnimation { duration: 300 }
        }
    }

    MouseArea {
        // INFO Пока изменяется анимация высоты с помошью behavior on height, MouseArea в делегатах ListView не работают
        // эта подложка нужна что-бы недопустить клики насквозь, пока анимация не завершится
        anchors {
            left: parent.left
            top: parent.bottom
            right: parent.right
        }
        height: listView.height
        visible: listContainer.controlVisible
    }

    Item {
        id: control

        anchors { fill: parent; margins: 2 }

        Item {
            width: control.width
            height: control.height

            Item {
                id: iconContainer

                width: root.icon != "" ? parent.height : 0
                height: root.icon != "" ? parent.height : 0

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
                        color: root.style.text
                        elide: Text.ElideRight
                        font { family: "Arial"; pixelSize: root.fontSize }
                        text: (root.model.count > 0 && root.currentIndex >= 0) ?
                                  (root.model.get(root.currentIndex).text || "") : ""
                    }
                }
            }

            Item {
                id: showListButton

                width: parent.height
                height: parent.height
                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }

                Image {
                    id: showListButtonImage

                    anchors.centerIn: parent
                    source: installPath + "Assets/Images/ProtocolOne/Controls/ComboBox/down_n.png"
                    rotation: listContainer.controlVisible ? 180 : 0
                }
            }
        }

        CursorMouseArea {
            id: mouseArea

            enabled: root.enabled
            cursor: Qt.PointingHandCursor
            hoverEnabled: true
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton
            onClicked: {
                if (!root.preventDefault) {
                    listContainer.controlVisible = !listContainer.controlVisible;
                }
            }
        }
    }

    Rectangle {
        id: listBlock

        anchors {
            left: root.left
            top: root.bottom
            topMargin: -2
        }
        width: root.width
        height: listContainer.controlVisible ? listView.height + 4 : 0

        color: root.style.background
        border {
            color: root.style.active
            width: 2
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
            visible: opacity > 0
            width: control.width
            height: listView.height
            anchors { fill: parent; margins: 2 }

            ListView {
                id: listView

                property int listSize: (root.dropDownSize > 0) && (listView.model.count > root.dropDownSize) ?
                                           root.dropDownSize : listView.model.count

                width: control.width
                height: listView.model.count > 0 ? (control.height * listSize) : 2
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                model: root.model

                delegate: Rectangle {
                    color: delegateArea.containsMouse
                           ? root.style.selectHover
                           : root.style.background
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
                        color: root.style.text
                        font { family: 'Arial'; pixelSize: root.fontSize }
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

            ListViewScrollBar {
                id: scroll

                anchors {
                    right: listView.right
                    rightMargin: 1
                }
                height: listView.height
                width: 6
                listView: listView
                cursorMaxHeight: listView.height
                cursorMinHeight: 50
                visible: (root.dropDownSize > 0) && (listView.model.count > root.dropDownSize)
                color: style.scrollBarCursor
                cursorColor: style.scrollBarCursorHover
                cursorRadius: 4
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
                PropertyChanges { target: controlBorder; border.color: root.style.normal }
                PropertyChanges { target: placeholderText; color: root.style.text }
                PropertyChanges { target: showListButtonImage; source: installPath + "Assets/Images/ProtocolOne/Controls/ComboBox/down_n.png" }
            },
            State {
                name: "Active"
                when: mouseArea.containsMouse || listContainer.controlVisible
                PropertyChanges { target: controlBorder; border.color: root.style.active }
                PropertyChanges { target: placeholderText; color: root.style.active }
                PropertyChanges { target: showListButtonImage; source: installPath + "Assets/Images/ProtocolOne/Controls/ComboBox/down_a.png" }
            },
            State {
                name: "Disabled"
                when: !root.enabled
                PropertyChanges { target: controlBorder; border.color: root.style.disabled }
                PropertyChanges { target: placeholderText; color: root.style.disabled }
                PropertyChanges { target: iconImage; opacity: 0.2 }
                PropertyChanges { target: listContainer; controlVisible: false }
            }
        ]
    }
}
