import QtQuick 2.4

import ProtocolOne.Core 1.0
import Application.Core 1.0

MouseArea {
    width: 20
    height: 20

    onDoubleClicked: {
        Ga.trackEvent('HiddenAppClose', 'click', 'Quit');
        SignalBus.exitApplication();
    }
}
