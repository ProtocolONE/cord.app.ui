import QtQuick 2.4
import QtQuick.Window 2.2

import Tulip 1.0

import GameNet.Core 1.0
import GameNet.Controls 1.0
import GameNet.Components.Widgets 1.0

import Application.Core 1.0
import Application.Core.Settings 1.0
import Application.Controls 1.0

WidgetModel {
    id: root

    property string lastStoppedServiceId

    function canShow(serviceId) {
        if (serviceId != "370000000000") {
            return false;
        }

        var showStatus = AppSettings.value("qml/GameSurvey/", "Survey1726", -1);
        if (showStatus == 1) {
           return false;
        }

        return true;
    }

    function show() {
        Ga.trackEvent('GameSurvey', 'show', 'Survey1726');
        AppSettings.setValue("qml/GameSurvey/", "Survey1726", 1);

        var surveyUrl = "https://docs.google.com/forms/d/e/1FAIpQLSeonAEy4SXAZG8lu5v0X-h4-B7FBcnWxNL9WIv3FyR_ukz5KA/viewform";
        var popup = surverPopupComponent.createObject(null, {
                                                                surveyUrl: surveyUrl
                                                            });
        popup.popupClosed.connect(function() {
            popup.destroy();
        })

        popup.visible = true;
    }

    Connections {
        target: App.mainWindowInstance()
        ignoreUnknownSignals: true

        onServiceFinished: {
            if (root.canShow(service)) {
                delayTimer.start();
            }
        }
    }

    Timer {
        id: delayTimer

        running: false
        repeat: false
        interval: 1000
        onTriggered: root.show();
    }

    Component {
        id: surverPopupComponent

        Window {
            id: popupWindow

            signal popupClosed();

            property string surveyUrl: ""

            property Gradient hoverGradientStyle1: Gradient {
                GradientStop { position: 0; color: "#257f02" }
                GradientStop { position: 1; color: "#257f02" }
            }

            property Gradient normalGradientStyle1: Gradient {
                GradientStop { position: 0; color: "#4ab120" }
                GradientStop { position: 1; color: "#257f02" }
            }

            width: 900
            height: 500
            x: Desktop.primaryScreenAvailableGeometry.x + (Desktop.primaryScreenAvailableGeometry.width - width) / 2
            y: Desktop.primaryScreenAvailableGeometry.y + (Desktop.primaryScreenAvailableGeometry.height - height) / 2

            flags: Qt.FramelessWindowHint
            modality: Qt.WindowModal

            onClosing: popupWindow.popupClosed();

            DragWindowArea {
                anchors.fill: parent
                rootWindow: popupWindow
            }

            Connections {
                target: SignalBus

                onApplicationActivated: popupWindow.requestActivate();
            }

            Image {
                source: installPath + "Assets/Images/Application/Widgets/GameSurvey/background.png"
            }

            CursorMouseArea {
                id: closeButtonImageMouser

                width: 40
                height: 40
                hoverEnabled: true
                anchors { right: parent.right; top: parent.top; }
                onClicked: {
                    Ga.trackEvent('GameSurvey', 'close', 'Survey1726');
                    popupWindow.close()
                }
            }

            Image {
                id: closeButtonImage

                anchors { right: parent.right; top: parent.top; rightMargin: 2; topMargin: 2 }
                source: installPath + "Assets/Images/CloseGrayBackground.png"
                opacity: closeButtonImageMouser.containsMouse ? 0.9 : 0.5

                Behavior on opacity {
                    NumberAnimation { duration: 225 }
                }
            }

            Image {
                anchors {
                    top: parent.top
                    topMargin: 2
                    left: parent.left
                    leftMargin: 2
                }

                source: installPath + "Assets/Images/GameNetLogoGrayBackground.png"

                CursorMouseArea {
                    anchors.fill: parent
                    onClicked: {
                        App.openExternalUrl(Config.GnUrl.site())
                        Ga.trackEvent('GameSurvey', 'openGameNet', 'Survey1726');
                    }
                }
            }

            Item {
                width: parent.width
                height: 107
                anchors.bottom: parent.bottom

                Rectangle {
                    anchors.fill: parent
                    color: "#000000"
                    opacity: 0.5
                }

                Rectangle {
                    anchors.centerIn: parent
                    width: Math.max(40 + windowAnnounceButtonText.width, 300)
                    height: 64
                    color: "#FFFFFF"

                    Rectangle {
                        id: windowAnnounceButton

                        property Gradient hover: popupWindow.hoverGradientStyle1
                        property Gradient normal: popupWindow.normalGradientStyle1

                        anchors { fill: parent; margins: 2 }
                        gradient: windowAnnounceButtonMouser.containsMouse
                                  ? windowAnnounceButton.hover
                                  : windowAnnounceButton.normal

                        Text {
                            id: windowAnnounceButtonText

                            text: qsTr("Помочь продюсеру")
                            anchors.centerIn: parent
                            color: "#ffffff"
                            font { family: "Arial"; pixelSize: 28}
                        }

                        CursorMouseArea {
                            id: windowAnnounceButtonMouser

                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                App.openExternalUrl(popupWindow.surveyUrl)
                                Ga.trackEvent('GameSurvey', 'openSurvey', 'Survey1726');
                                popupWindow.close();
                            }
                        }
                    }
                }
            }

            Rectangle {
                anchors {
                    fill: parent
                }

                color: "#00000000"
                border {
                    width: 1
                    color: "#1e1b1b"
                }
            }
        }
    }
}
