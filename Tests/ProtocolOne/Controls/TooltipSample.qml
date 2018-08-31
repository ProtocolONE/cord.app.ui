import QtQuick 2.4
import Tulip 1.0

import ProtocolOne.Controls 1.0

Item {
    width: 1000
    height: 599

    Item {
        id: baseLayer

        anchors.fill: parent

        Image {
            anchors.centerIn: parent
            source: installPath + '/Tests/Assets/main_07.png'
        }

        Row {
            spacing: 10

            Button {
                width: 200
                height: 30

                toolTip: "I'm tooltip!"
                text: "Click me!"

                onClicked: {console.log("Button clicked!");}
            }

            Button {
                width: 200
                height: 30

                toolTip: "I'm tooltip!"
                text: "Click me!"

                onClicked: {console.log("Button clicked!");}
            }

            Button {
                width: 200
                height: 30

                toolTip: "I'm tooltip!"
                text: "Click me!"

                onClicked: {console.log("Button clicked!");}
            }
        }

    }

    Item {
        id: tooltipLayer

        anchors.fill: parent
        z: 2
    }

    Component.onCompleted: {
        console.log("Sample::onCompleted!");

        Tooltip.init(tooltipLayer);
    }
}
