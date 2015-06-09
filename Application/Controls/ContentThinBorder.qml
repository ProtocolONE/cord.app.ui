import QtQuick 1.1
import "../Core/Styles.js" as Styles

Rectangle {
    anchors {
        fill: parent
        bottomMargin: 1
        rightMargin: 1
    }

    color: "#00000000"
    opacity: Styles.style.blockInnerOpacity

    border {
        width: 1
        color: Styles.style.light
    }
}
