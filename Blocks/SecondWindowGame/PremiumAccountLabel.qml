import QtQuick 1.1
import "../../Elements" as Elements

Elements.CursorMouseArea {
    id: root

    property string text: qsTr("ADWANCED_ACCOUNT_HINT")

    width: premiumIcon.width
    height: 90

    Column {
        anchors.fill: parent
        spacing: 5

        Image {
            id: premiumIcon

            source: installPath + 'Assets/Images/blocks/SecondWindowGame/premium.png'
        }

        Text {
            x: -width / 6
            text: root.text
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            width: 110
            height: 15
            color: "#ff9801"
            font { family: "Arial"; pixelSize: 12 }
            horizontalAlignment: Text.AlignHCenter
        }
    }

}
