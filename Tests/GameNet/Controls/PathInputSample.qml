import QtQuick 1.1
import GameNet.Controls 1.0

Rectangle {
    width: 600
    height: 400


    PathInput {
        id: pathInput

        width: 300
        height: 48
        x: 150
        y: 100
        path: "C:\\Games\\Aika"

        onBrowseClicked: {
            console.log("Browse path!!");
        }
    }
}
