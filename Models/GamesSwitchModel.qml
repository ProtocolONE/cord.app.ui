
import QtQuick 1.0
import "../Blocks" as Blocks

Blocks.GamesSwitch {
    signal testAndCloseSignal();

    onHomeButtonClicked: {
        testAndCloseSignal();
        qGNA_main.state = "HomePage";
    }

    onGameSelection: testAndCloseSignal();
}
