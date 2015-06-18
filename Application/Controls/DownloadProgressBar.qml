import QtQuick 1.1
import GameNet.Controls 1.0

import "../Core/Styles.js" as Styles

ProgressBar {
    style {
        background: Styles.style.downloadProgressBackground
        line: Styles.style.downloadProgressLine
    }
}
