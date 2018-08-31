import QtQuick 2.4
import Tulip 1.0
import ProtocolOne.Controls 1.0

Button {
    id: root

    property string source

    implicitWidth: 16
    implicitHeight: 14

    style {
        normal: "#00000000"
        hover: "#00000000"
        disabled: "#00000000"
    }

    Image {
        id: icon

        anchors.centerIn: parent

        source: root.containsMouse
                ? root.source.replace('.png', 'Hover.png') :
                  root.source
    }
}
