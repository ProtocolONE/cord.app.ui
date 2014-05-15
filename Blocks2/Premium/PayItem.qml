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
import GameNet.Controls 1.0

Rectangle {
    id: root

    property int checkedIndex
    property alias checked: radioButton.checked
    property alias text: radioButton.text
    property string coinValue: ''

    signal clicked

    height: 30
    color: radioButton.containsMouse ? '#ffffff' : '#00000000'

    RadioButton {
        id: radioButton

        anchors.fill: parent

        text: qsTr("ONE_DAY_PREMIUM_TRADIO_TEXT")
        checked: root.checkedIndex == index
        style: ButtonStyleColors {
            normal: "#000000"
            hover: "#019074"
            disabled: "#1ADC9C"
        }
        onClicked: root.clicked(index);
        spacing: 100 - controlText.width

        Image {
            anchors {
                top: parent.top
                left: parent.left
                leftMargin: 140
                topMargin: 14
            }
            source: installPath + 'images/Blocks2/rightArrow.png'

        }

        Text {
            text: coinValue + ' GN'
            color: '#ff6d66'
            font {
                family: "Arial"
                pixelSize: 16
            }
            anchors {
                right: parent.right
                top: parent.top
                rightMargin: 9
                topMargin: 7
            }
        }
    }
}
