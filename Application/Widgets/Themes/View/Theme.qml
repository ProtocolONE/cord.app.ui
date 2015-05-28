import Tulip 1.0
import QtQuick 1.1

import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import "../../../Core/Styles.js" as Styles
import "../../../Core/moment.js" as Moment

Item {
    id: root

    property bool downloaded: pack.status == ThemePack.Ready
    property bool isLoading: pack.status == ThemePack.Loading

    property string imagePath : installPath + 'Assets/Images/Application/Widgets/Themes/'

    signal clicked();

    width: 380
    height: 210

    function install() {
        pack.install()
    }

    function download() {
        pack.download();
    }

    WebImage {
        width: 370
        height: 200

        source: model.preview

        Rectangle {
            anchors.fill: parent
            anchors.margins: 1
            border {
                width: 2
                color: Styles.style.primaryBorder
            }
            color: "#00000000"
            visible: mouser.containsMouse
        }

        MouseArea {
            id: mouser

            visible: !isLoading
            anchors.fill: parent
            hoverEnabled: true

            Button {
                visible: mouser.containsMouse
                anchors.centerIn: parent
                width: 220
                height: 30
                text: downloaded
                      ? qsTr("THEME_INSTALL")
                      : qsTr("THEME_LOAD_AND_INSTALL")
                onClicked: root.clicked();
            }
        }

        Rectangle {
            x: 15
            y: 15
            width: 30
            height: 30
            color: downloaded ? Styles.style.checkedButtonActive : Styles.style.primaryButtonNormal

            Image {
                source: imagePath + (downloaded ? 'ready.png' :'download.png')
                anchors.centerIn: parent
            }
        }

        ProgressBar {
            y: 170
            anchors { left: parent.left; right: parent.right; leftMargin: 15; rightMargin: 15;}
            height: 4
            style {
                background: Styles.style.downloadStatusProgressBackground
                line: Styles.style.downloadStatusProgressLine
            }
            animated: true
            width: parent.width
            progress: pack.progress * 100
            visible: isLoading
        }

        Text {
            x: 15
            y: 175
            visible: isLoading
            font { family: 'Arial'; pixelSize: 13 }
            color: Styles.style.downloadStatusText
            text: getText();
            smooth: true

            function getText() {
                var total = (pack.size / 1048576).toPrecision(2),
                    current = ((pack.progress * pack.size) / 1048576).toPrecision(2);

                return qsTr("THEME_PROGRESS")
                    .arg(current)
                    .arg(total);
            }
        }

        Text {
            x: 15
            y: 175
            visible: !isLoading && mouser.containsMouse

            font { family: 'Arial'; pixelSize: 13 }
            color: Styles.style.downloadStatusText
            text: qsTr("THEME_ABOUT")
                .arg(model.name)
                .arg(Moment.moment(model.updateDate, "DD.MM.YYYY HH:mm:ss").fromNow())

            smooth: true
        }
    }

    ThemePack {
        id: pack

        themeFolder: "GameNet Themes"
        source: model.theme
    }
}
