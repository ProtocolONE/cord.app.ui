import QtQuick 2.4

Rectangle {
    id: control

    property ErrorMessageStyle style: ErrorMessageStyle {}
    property alias text: errorText.text

    color: style.background
    height: visible ? (errorText.height + 10) : 0

    Text {
        id: errorText

        wrapMode: Text.Wrap

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            topMargin: 5
        }

        font { pixelSize: 12; family: "Arial" }

        color: control.style.text
        smooth: false
    }
}
