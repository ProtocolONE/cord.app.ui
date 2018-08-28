import QtQuick 2.4

/**
 * WidgetManagerPrivate
 *
 * Used as local, feature based signal bus object.
 */
Item {
    id: root

    signal widgetsReady()

    function emitReady() {
        widgetsReady()
    }
}
