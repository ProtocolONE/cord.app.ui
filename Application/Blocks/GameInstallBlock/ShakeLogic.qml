import QtQuick 1.1
import Application.Blocks 1.0

import "../../Core/App.js" as App

Item {
    property alias target: shakeAnimation.target
    property bool enabled: false

    Connections {
        target: App.signalBus()
        onNavigate: {
            var needShake = (link == 'mygame' && from == 'GameItem')
                && !enabled
                && !App.isAppSettingsEnabled("qml/installBlock/", "shakeAnimationShown", false);

            if (needShake) {
                App.setAppSettingsValue("qml/installBlock/", "shakeAnimationShown", true);
                shakeAnimationTimer.start();
            }
        }
    }

    Timer {
        id: shakeAnimationTimer

        interval: 1500
        onTriggered: shakeAnimation.start();
    }

    ShakeAnimation {
        id: shakeAnimation

        target: target
        property: "x"
        from: 0
        shakeValue: 2
        shakeTime: 120
    }
}
