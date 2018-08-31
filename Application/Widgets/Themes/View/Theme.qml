import Tulip 1.0
import QtQuick 2.4

import ProtocolOne.Core 1.0
import ProtocolOne.Components.Widgets 1.0
import ProtocolOne.Controls 1.0

import Application.Controls 1.0
import Application.Core 1.0
import Application.Core.Styles 1.0

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

            border {
                width: 2
                color: Styles.primaryBorder
            }
            color: "#00000000"
            visible: mouser.containsMouse
        }

        MouseArea {
            id: mouser

            visible: !isLoading
            anchors.fill: parent
            hoverEnabled: true

            PrimaryButton {
                visible: mouser.containsMouse
                anchors.centerIn: parent
                width: 220
                height: 30
                analytics {
                    category: 'Themes'
                    label: downloaded ? 'Install' : 'Load and install'
                }
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
            color: downloaded ? Styles.checkedButtonActive : Styles.primaryButtonNormal

            Image {
                source: imagePath + (downloaded ? 'ready.png' :'download.png')
                anchors.centerIn: parent
            }
        }

        DownloadProgressBar {
            y: 170
            anchors { left: parent.left; right: parent.right; leftMargin: 15; rightMargin: 15;}
            height: 4
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
            color: Styles.bannerInfoText
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
            color: Styles.bannerInfoText
            text: qsTr("THEME_ABOUT")
                .arg(model.name)
                .arg(Moment.moment(model.updateDate, "DD.MM.YYYY HH:mm:ss").fromNow())

            smooth: true
        }
    }

    ThemePack {
        id: pack

        themeFolder: "ProtocolOne Themes"
        source: model.theme
    }
}
