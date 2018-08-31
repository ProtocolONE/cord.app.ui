import QtQuick 2.4
import ProtocolOne.Core 1.0
import ProtocolOne.Controls 1.0
import ProtocolOne.Components.Widgets 1.0
import Application.Blocks.Popup 1.0
import Application.Core.Popup 1.0
import Application.Controls 1.0
import Application.Core 1.0
import Application.Core.MessageBox 1.0
import Application.Core.Settings 1.0

PopupBase {
    id: root

    property variant gameItem: model ? model.currentGame : null
    property bool isPause: false

    signal pause();

    onPause: {
        if (root.isPause) {
            App.downloadButtonStart(root.gameItem.serviceId);
            Ga.trackEvent('GameLoad', 'play', root.gameItem.gaName);
        } else {
            App.downloadButtonPause(root.gameItem.serviceId);
            Ga.trackEvent('GameLoad', 'pause', root.gameItem.gaName);
        }

        root.isPause = !root.isPause;
    }

    implicitWidth: Math.max(innerWidget.width + defaultMargins * 2, 630)
    title: qsTr("GAME_LOAD_VIEW_HEADER_TEXT").arg(App.currentGame().name)

    Connections {
        target: App.mainWindowInstance()

        ignoreUnknownSignals: true
        onDownloaderFinished: {
            if (service == App.currentGame().serviceId) {
                root.close();
            }
        }

        onSelectService: root.close();
    }

    onVisibleChanged: stateGroup.state = 'Normal';

    Component.onCompleted: {
        root.isPause = (root.gameItem.status === 'Paused');
    }

    Column {
        id: centerBlock

        spacing: 20

        anchors {
            left: parent.left
            right: parent.right
        }

        Column {
            width: parent.width
            spacing: 10

            Item {
                id: downloadInfoBlock

                width: parent.width
                height: 100

                Row {
                    spacing: 10

                    Image {
                        source: installPath +'Assets/Images/Application/Widgets/AlertAdapter/info.png'
                    }

                    Column {
                        spacing: 20

                        Text {
                            font {family: "Arial"; pixelSize: 14}
                            smooth: true
                            color: defaultTextColor
                            text: qsTr("DOWNLOAD_INFO_TEXT")
                        }

                        TextButton {
                            id: netSettingsChange

                            text: qsTr("DOWNLOAD_INFO_CHANGE")
                            fontSize: 14
                            onClicked: {
                                Popup.show('ApplicationSettings', '', 0, 'DownloadsPage');
                                Popup.refresh();
                            }

                            analytics {
                                category: 'GameLoad'
                                action: 'NetworkSettingsOn'
                            }
                        }
                    }
                }
            }

            Text {
                font {family: "Arial"; pixelSize: 14}
                smooth: true
                color: defaultTextColor
                text: model ? model.headerText : ""
            }

            Row {
                width: parent.width
                spacing: 6

                Item {
                    id: progressBarContainer

                    height: 22
                    width: parent.width - pauseButton.width - (cancelButton.visible ? cancelButton.width : 0)- 12

                    ContentThinBorder{}

                    DownloadProgressBar {
                        anchors {
                            fill: parent
                            margins: 6
                        }

                        progress: model ? model.progress : 0
                    }
                }

                TextButton {
                    id: pauseButton

                    text: !root.isPause ? qsTr("GAME_LOAD_PAUSE") : qsTr("GAME_LOAD_CONTINUE")
                    fontSize: 14
                    onClicked: root.pause();
                }

                TextButton {
                    id: cancelButton

                    visible: root.isPause
                    text: qsTr("Отменить")
                    fontSize: 14
                    onClicked: {
                        MessageBox.show(
                            qsTr("Отмена загрузки игры %1").arg(root.gameItem.name),
                            qsTr("Вы уверены, что хотите отменить загрузку игры?"),
                            MessageBox.button.yes | MessageBox.button.no,
                            function(result) {
                                if (result != MessageBox.button.yes) {
                                    return;
                                }
                                root.gameItem.status = "Normal";
                                root.gameItem.statusText = '';
                                SignalBus.cancelDownload(root.gameItem);
                                Ga.trackEvent('GameLoad', 'cancel', root.gameItem.gaName);
                                root.close();
                            });
                    }
                }
            }
        }

        TextButton {
            id: showStatButton

            text: qsTr("SHOW_STATISTICS")
            fontSize: 14
            analytics {
                category: 'GameLoad'
                action: 'details'
                label: root.gameItem ? root.gameItem.gaName : ""
            }

            onClicked: {

                if (stateGroup.state === "Detailed") {
                    stateGroup.state = "Normal";
                } else {
                    stateGroup.state = "Detailed";
                }
                
            }
        }

        ProgressWidget {
            id: progressWidget

            totalWantedDone: model ? model.totalWantedDone : 0
            totalWanted: model ? model.totalWanted : 0
            directTotalDownload: model ? model.directTotalDownload : 0
            peerTotalDownload: model ? model.peerTotalDownload : 0
            payloadTotalDownload: model ? model.payloadTotalDownload : 0
            peerPayloadDownloadRate: model ? model.peerPayloadDownloadRate : 0
            payloadDownloadRate: model ? model.payloadDownloadRate : 0
            directPayloadDownloadRate: model ? model.directPayloadDownloadRate : 0
            payloadUploadRate: model ? model.payloadUploadRate : 0
            totalPayloadUpload: model ? model.totalPayloadUpload : 0
        }

        PopupHorizontalSplit {
            visible: showStatButton.visible
        }

        WidgetContainer {
            id: innerWidget

            widget: root.gameItem ? root.gameItem.widgets.gameDownloading : ""
            visible: widget
        }
    }

    StateGroup {
        id: stateGroup

        state: 'Normal'
        states: [
            State {
                name: "Normal"
                when: stateGroup.state == "Normal" || root.visible == false
                PropertyChanges { target: downloadInfoBlock; visible: true }
                PropertyChanges { target: progressWidget; visible: false }
                PropertyChanges { target: showStatButton; text: qsTr("SHOW_STATISTICS") }
            },
            State {
                name: "Detailed"
                when: stateGroup.state == "Detailed"
                PropertyChanges { target: downloadInfoBlock; visible: false }
                PropertyChanges { target: progressWidget; visible: true }
                PropertyChanges { target: showStatButton; text: qsTr("HIDE_STATISTICS") }
            }
        ]
    }
}
