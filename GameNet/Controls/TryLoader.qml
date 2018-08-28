import QtQuick 2.4

Loader {
    signal failed();
    signal successed();

    property bool _isFailSended : false
    property bool _isSuccessSended : false

    function reemit() {
        if (status == Loader.Ready && !_isSuccessSended) {
            _isSuccessSended = true;
            successed();
        }

        if (status == Loader.Error  && !_isFailSended) {
            _isFailSended = true;
            failTimer.start()
        }
    }

    Component.onCompleted: reemit();
    onStatusChanged: reemit();

    Timer {
        id: failTimer
        running: false
        interval: 1
        onTriggered: failed();
    }
}
