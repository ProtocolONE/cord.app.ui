import QtQuick 1.1

Image {
    id: root

    property int type: 0
    property alias text: textElement.text

    source: root.type === 0 ? installPath + '/Assets/Images/Application/Widgets/AllGames/orangeStick.png' :
                              installPath + '/Assets/Images/Application/Widgets/AllGames/greenStick.png'

    Text {
        id: textElement

        anchors {
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: -4
        }


        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter

        width: parent.width
        height: parent.height
        wrapMode: Text.WordWrap

        color: '#ffffff'
        font.pixelSize: 10
    }
}

