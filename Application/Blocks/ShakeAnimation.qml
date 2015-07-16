import QtQuick 2.4

SequentialAnimation {
    id: shakeAnimation

    property variant target
    property string property

    property int shakeValue: 2
    property int shakeTime: 120

    property real from: 0

    loops: 2

    PropertyAnimation {
        target: shakeAnimation.target
        property: shakeAnimation.property
        to: shakeAnimation.from - shakeAnimation.shakeValue
        duration: shakeAnimation.shakeTime / 4
    }

    PropertyAnimation {
        target: shakeAnimation.target
        property: shakeAnimation.property
        easing.type: Easing.InOutBack
        to: shakeAnimation.from + shakeAnimation.shakeValue
        duration: shakeAnimation.shakeTime / 2
    }

    PropertyAnimation {
        target: shakeAnimation.target
        property: shakeAnimation.property
        to: shakeAnimation.from
        duration: shakeAnimation.shakeTime / 4
    }
}
