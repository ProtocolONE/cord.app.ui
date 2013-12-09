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

Item {
    id: optionContainer

    default property alias content: placeholder.data
    property variant group
    property bool checked: false
    property variant style: OptionStyle {}

    signal optionClicked(variant itemData)

    implicitWidth: 200
    implicitHeight: 30

    Component.onCompleted: {
        if (group && group.register)
            group.register(optionContainer);
    }

    function check() {
        optionContainer.checked = true;
    }
    function uncheck() {
        optionContainer.checked = false;
    }

    Rectangle {
        id: optionBackground

        anchors.fill: parent
        color: optionContainer.checked ? optionContainer.style.selectedColor : (mouseArea.containsMouse ? optionContainer.style.hoverColor : optionContainer.style.normalColor)
    }

    Image {
        id: icon

        anchors {left: parent.left; leftMargin: 5; verticalCenter: parent.verticalCenter}
        source: optionContainer.checked ? optionContainer.style.checkedIcon : optionContainer.style.uncheckedIcon

        fillMode: Image.PreserveAspectFit
    }

    Item {
        id: placeholder

        anchors {left: icon.right; leftMargin: 10; verticalCenter: parent.verticalCenter}
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            optionContainer.check();
            optionContainer.optionClicked(optionContainer);
        }
    }
}
