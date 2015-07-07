import QtQuick 1.1

import "../../../../Core/Styles.js" as Styles

Image {
    id: root

    property string type: ''

    function getSource(value) {
        if (value === 'hit') {
            return installPath + '/Assets/Images/Application/Widgets/AllGames/orangeStick.png';
        }

        if (value === 'new') {
            return installPath + '/Assets/Images/Application/Widgets/AllGames/greenStick.png'
        }

        return ''
    }

    source: getSource(root.type)

    Text {
        id: textElement

        function getText(value) {
            if (value === 'hit') {
                return qsTr("GAME_TOP_STICK");
            }

            if (value === 'new') {
                return qsTr("GAME_NEW_STICK")
            }

            return ''
        }

        text: getText(root.type)

        anchors {
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: -4
        }

        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter

        width: parent.width
        height: parent.height
        wrapMode: Text.WordWrap

        color: "#FFFFFF"
        font {
            bold: true
            pixelSize: 10
            family: "Open Sans Regular"
        }
    }
}

