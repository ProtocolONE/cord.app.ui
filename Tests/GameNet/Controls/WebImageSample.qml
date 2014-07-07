import QtQuick 1.1
import GameNet.Controls 1.0

Rectangle {
    width: 500
    height: 400

    WebImage {
        width: 100
        height: 100
        background: "red"
        anchors.centerIn: parent
        source: "http://yandex.ru/images/today?size=1920x1080"
    }
}
