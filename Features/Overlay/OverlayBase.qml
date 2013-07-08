import QtQuick 1.1
import Tulip 1.0

Overlay {
    id: over

    flags: Qt.Window | Qt.Tool | Qt.FramelessWindowHint
    width: 1024
    height: 1024
    x: 10
    y: 10
    visible: true

    inputCapture: Overlay.MouseAndKeyboard
    inputBlock: Overlay.None

    drawFps: false
    opacity: 1

    onGameInit: {
        console.log('Overlay game init', width, height);
        over.width = width;
        over.height = height;
    }

    // Попробуем таймер для проверки работает ли вообще репейнт на ноуте.
    // Хак работает - решить оставить ли его
    Timer {
        id: timerRepaint

        interval: 1000
        running: true
        repeat: true
        onTriggered: over.repaint();
    }
}
