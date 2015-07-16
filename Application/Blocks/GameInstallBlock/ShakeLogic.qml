import QtQuick 2.4
import Application.Blocks 1.0

import Application.Core.Settings 1.0
import Application.Core 1.0

Item {
    property alias target: shakeAnimation.target
    property bool enabled: false

    Connections {
        target: SignalBus
        onNavigate: {
            var needShake = (link == 'mygame' && from == 'GameItem')
                && !enabled
                && !AppSettings.isAppSettingsEnabled("qml/installBlock/", "shakeAnimationShown", false);

            if (needShake) {
                AppSettings.setAppSettingsValue("qml/installBlock/", "shakeAnimationShown", true);
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
