import QtQuick 2.4
import Tulip 1.0

import ProtocolOne.Controls 1.0

MouseArea {
    id: mouser

    property alias cursor: mouser.cursorShape
    property string toolTip
    property string tooltipPosition
    property bool tooltipGlueCenter: false

    cursorShape: Qt.PointingHandCursor
    hoverEnabled: true
    onEntered: Tooltip.entered(mouser)
    onExited: Tooltip.exited(mouser)
    onPressed: Tooltip.exited(mouser)
    onReleased: Tooltip.entered(mouser)

    acceptedButtons: Qt.LeftButton | Qt.RightButton
}
