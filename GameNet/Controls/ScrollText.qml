import QtQuick 1.0

Item {
    id: root

    property alias text: text.text
    property alias color: text.color
    property alias font: text.font

    property bool running: true
    property int textMoveDuration: 2000

    clip: true
    height: text.height

    Component.onCompleted: d.updateAnimationRunning()
    onRunningChanged: d.updateAnimationRunning()

    QtObject {
        id: d

        property int frame: 0
        property int offset: 0
        property int offsetDuration: 0

        function stopAnimation() {
            scrollAnimation.stop();
            text.x = 0;
            d.frame = 0;
        }

        function updateAnimationRunning() {
            if (!root.running) {
                d.stopAnimation();
                return;
            }

            if (text.paintedWidth > root.width) {
                if (!scrollAnimation.running) {
                    scrollAnimation.start();
                }
                return;
            }

            if (scrollAnimation.running) {
                d.stopAnimation();
            }
        }

        function updateFrame() {
            if (frame === 0) {
                d.offset = root.width - text.paintedWidth
                d.offsetDuration = Math.max(0, root.textMoveDuration * ((-d.offset) / root.width))
            }

            //INFO Парни, простите. Другого способа нормально написать эту анимацию не нашёл. По русски - секундная
            //пауза, потом изменение Х в течение рассчитанного времени (d.offsetDuration) - сдвигаем влево,
            //потом еще секундная пауза и возврат Х назад до 0. Причина такой "красоты" - высокий CPU load при
            //встроенной анимации QML.
            var time = ++frame * scrollAnimation.interval
                , tick = time / 1000
                , offsetInTicks = d.offsetDuration / 1000;

            if (tick <= 1) {
                return;
            }

            if (1 <= tick && tick < (1 + offsetInTicks)) {
                text.x = d.offset * (tick - 1) / offsetInTicks
                return;
            }

            if ((1 + offsetInTicks) <= tick && tick < (2 + offsetInTicks)) {
                return;
            }

            if ((2 + offsetInTicks) <= tick && tick < (2 + 2 * offsetInTicks)) {
                text.x = d.offset * (2 + 2 * offsetInTicks - tick) / offsetInTicks
                return;
            }

            if (tick > (2 + 2 * offsetInTicks)) {
                frame = 0;
                text.x = 0
            }
        }
    }

    Text {
        id: text

        font { family: 'Arial'; pixelSize: 12 }
        smooth: true
        onPaintedWidthChanged: d.updateAnimationRunning()
        textFormat: Text.PlainText
    }

    Timer {
        id: scrollAnimation

        interval: 33
        triggeredOnStart: true
        repeat: true

        onTriggered: d.updateFrame()
    }
}
