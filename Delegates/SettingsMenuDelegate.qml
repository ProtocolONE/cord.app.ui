import QtQuick 1.1
import "../Elements" as Elements

Elements.TextClick {    
    id: generalMenuText

    implicitWidth: 181
    implicitHeight: 32
    state: itemState

    SequentialAnimation {
        running: false;
        PauseAnimation { duration: 100 }
        ParallelAnimation {
            NumberAnimation {
                target: generalMenuText;
                easing.type: Easing.OutQuad;
                property: "x";
                from: -60;
                to: 0;
                duration: 250
            }

            NumberAnimation {
                target: generalMenuText;
                easing.type: Easing.OutQuad;
                property: "opacity";
                from: 0;
                to: 1;
                duration: 250
            }
        }
    }

    Elements.CursorShapeArea { anchors.fill: parent }
}
