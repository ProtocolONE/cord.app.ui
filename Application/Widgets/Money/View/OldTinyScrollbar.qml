import QtQuick 2.4
import Tulip 1.0

Item {
    id: scrollBarElement

    property variant flickable

    property real cHeight: flickable.contentHeight
    property real cContentY: 0
    property bool acceptToScroll: false

    property int wheelTo

    clip: true

    NumberAnimation {
        id: downWheelScrollAnimation
        target: flickable; property: "contentY";
        duration: (cHeight - cContentY) / 15;
        from: cContentY;
        to: wheelTo;
        easing.type: Easing.OutCubic
        onStarted: cContentY = wheelTo;
    }

    NumberAnimation {
        id: upWheelScrollAnimation
        target: flickable;
        property: "contentY";
        duration: cContentY / 15;
        from: cContentY;
        to: wheelTo;
        easing.type: Easing.OutCubic
        onStarted: cContentY = wheelTo;
    }

    WheelArea {
        anchors.fill: parent
        onVerticalWheel: {
            var newValue = flickable.contentY - delta;
            if (newValue < 0)
                newValue = 0;
            if (newValue > flickable.contentHeight - scrollBarElement.height)
                newValue = flickable.contentHeight - scrollBarElement.height;

            wheelTo = newValue;
            if (downWheelScrollAnimation.running) {
                downWheelScrollAnimation.stop();
            }

            downWheelScrollAnimation.start();
        }

        onHorizontalWheel: {
            var newValue = flickable.contentY - delta;
            if (newValue < 0)
                newValue = 0;
            if (newValue > flickable.contentHeight)
                newValue = flickable.contentHeight;

            wheelTo = newValue;
            if (upWheelScrollAnimation.running) {
                upWheelScrollAnimation.stop();
            }

            upWheelScrollAnimation.start();
        }
    }

}
