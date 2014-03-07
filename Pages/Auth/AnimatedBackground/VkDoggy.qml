import QtQuick 1.1

Image {
    id: doggyImage

    property int amplitude: 3
    property bool isDoggyVisible: false

    source: installPath + "./images/Auth/doggy2.png"
    transformOrigin: Item.Bottom

    Behavior on anchors.bottomMargin {

        NumberAnimation {
            duration: 1000
            easing.type: Easing.OutElastic
            alwaysRunToEnd: true
        }
    }

    SequentialAnimation {
        loops: Animation.Infinite

        running: true

        PropertyAnimation {
            target: doggyImage

            to: -doggyImage.amplitude
            from: doggyImage.amplitude
            duration: 1000
            easing.type: Easing.InQuart
            properties: "rotation"
        }

        PropertyAnimation {
            target: doggyImage

            to: doggyImage.amplitude
            from: -doggyImage.amplitude
            duration: 1000
            easing.type: Easing.InQuart
            properties: "rotation"
        }

    }
}
