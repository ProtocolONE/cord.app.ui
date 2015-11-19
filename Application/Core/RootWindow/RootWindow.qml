pragma Singleton

import QtQuick 2.4
import Application.Core 1.0

Item {
    id: root

    property variant rootWindow: App.mainWindowInstance()
}
