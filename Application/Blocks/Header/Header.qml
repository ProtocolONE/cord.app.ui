import QtQuick 2.4

import Tulip 1.0

import ProtocolOne.Controls 1.0
import ProtocolOne.Components.Widgets 1.0
import Application.Controls 1.0

import Application.Core 1.0
import Application.Core.Config 1.0
import Application.Core.Styles 1.0
import Application.Core.Popup 1.0
import Application.Core.MessageBox 1.0

Item {
    id: root

    signal switchTo(string page);

    implicitWidth: 1000
    implicitHeight: 30

    ContentBackground {
        anchors.fill: parent
        color: Styles.contentBackgroundDark
    }

    ContentStroke {
        width: parent.width
    }

    ContentStroke {
        height: parent.height - 1
        y: 1
    }

    ContentStroke {
        height: parent.height - 1
        y: 1
        anchors.right: parent.right
    }

    Row {
        anchors.fill: parent

        Item {
            height: parent.height
            width: 162 - 10

            Image {
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 8-1
                }

                source: installPath + Styles.headerProtocolOneLogo
            }

            Button {
                width: 26
                height: 12
                visible: !App.isPublicVersion()
                anchors {
                    top: parent.top
                    topMargin: 4
                    right: parent.right
                    rightMargin: 4
                }

                analytics {
                    category: 'header'
                    label: 'Open public test window'
                }

                style {
                    normal: Styles.primaryButtonNormal
                    hover: Styles.primaryButtonHover
                }

                text: App.isPublicTestVersion() ? "Beta" : "Test"
                fontSize: 10
                toolTip: qsTr("PUBLIC_TEST_TOOLTIP")


                onClicked: Popup.show('PublicTest');
            }
        }

        HeaderButton {
            visible: !App.isSingleGameMode()
            height: parent.height
            icon: installPath + Styles.headerAllGames
            text: qsTr("HEADER_BUTTON_ALL_GAMES")
            analytics {
                category: 'header'
                label: 'All Games'
            }
            onClicked: root.switchTo("allgame");
        }

        HeaderButton {

            function available() {
                if (GoogleAnalyticsHelper.winVersion() <= 0x0080) { //INFO Win7+
                    return false;
                }

                var themes = WidgetManager.getWidgetByName('Themes');
                if (!themes || !themes.model) {
                    return false;
                }

                return themes.model.available;
            }

            visible: available()
            height: parent.height
            icon: installPath + Styles.headerThemes
            text: qsTr("HEADER_BUTTON_THEMES")
            analytics {
                category: 'header'
                label: 'Themes'
            }
            onClicked: root.switchTo("themes");
        }

        HeaderButton {
            property string url: Config.value('support\\url', '')

            visible: !!url
            height: parent.height
            icon: installPath + Styles.headerSupport
            iconLink: installPath + Styles.linkIconHeader
            text: qsTr("HEADER_BUTTON_SUPPORT")
            analytics {
                category: 'header'
                action: 'outer link'
                label: 'Support'
            }

            onClicked: {
                App.openExternalUrl(url);
            }
        }
    }

    Item {
        width: 120
        height: parent.height
        anchors { right: parent.right; rightMargin: 8 }

        Row {
            anchors.fill: parent
            layoutDirection: Qt.RightToLeft

            HeaderControlButton {
                width: 26
                height: parent.height
                source: installPath + Styles.headerClose
                anchors.verticalCenter: parent.verticalCenter
                toolTip: qsTr("HEADER_BUTTON_CLOSE")
                tooltipGlueCenter: true
                analytics {
                    category: 'header'
                    label: 'Close'
                }
                onClicked: SignalBus.hideMainWindow();
            }

            HeaderControlButton {
                width: 26
                height: parent.height
                source: installPath + Styles.headerCollapse
                anchors.verticalCenter: parent.verticalCenter
                anchors.bottom: parent.bootom
                toolTip: qsTr("HEADER_BUTTON_COLLAPSE")
                tooltipGlueCenter: true
                analytics {
                    category: 'header'
                    label: 'Collapse'
                }
                onClicked: SignalBus.collapseMainWindow();
            }

            HeaderControlButton {
                width: 26
                height: parent.height
                source: installPath + Styles.headerSettings
                anchors.verticalCenter: parent.verticalCenter
                toolTip: qsTr("HEADER_BUTTON_SETTINGS")
                tooltipGlueCenter: true
                analytics {
                    category: 'header'
                    label: 'ApplicationSettings'
                }
                onClicked: Popup.show('ApplicationSettings');
            }

            HeaderControlButton {
                width: 26
                height: parent.height
                source: installPath + Styles.headerLogout
                anchors.verticalCenter: parent.verticalCenter
                toolTip: qsTr("HEADER_BUTTON_LOGOUT")
                tooltipGlueCenter: true
                analytics {
                    category: 'header'
                    label: 'Logout'
                }
                onClicked: {
                    if (!App.currentRunningMainService() && !App.currentRunningSecondService()) {
                        SignalBus.logoutRequest();
                        return;
                    }

                    MessageBox.show(qsTr("LOGOUT_ALERT_HEADER"),
                                    qsTr("LOGOUT_ALERT_BODY"),
                                    MessageBox.button.ok | MessageBox.button.cancel, function(result) {
                                        if (result != MessageBox.button.ok) {
                                            return;
                                        }

                                        SignalBus.logoutRequest();
                                    });

                }
            }
        }
    }

//    WidgetContainer {
//        width: 30
//        height: 30
//        widget: 'Messenger'
//        view: 'ProtocolOneNotification'

//        anchors {
//            verticalCenter: parent.verticalCenter
//            right: parent.right
//            rightMargin: 116
//        }
//    }

    AnimatedImage {
        id: runningCat


        visible: false
        playing: false
        asynchronous: true
        cache: false
        anchors { bottom: parent.bottom; bottomMargin: -2; left:parent.left; leftMargin: 650 }
        source: installPath + "Assets/Images/Application/Blocks/Header/catrun.gif"
        onCurrentFrameChanged: {
            if (currentFrame + 1 === frameCount) {
                runningCat.playing = false;
                runningCat.visible = false;
            }
        }
    }

    DragWindowArea {
        property int hiddenClics: 0

        anchors { left: parent.left; leftMargin: 820; verticalCenter: parent.verticalCenter }
        width: 30
        height: 30
        onClicked: {
            if (0 === ++hiddenClics % 4) {
                runningCat.currentFrame = 0;
                runningCat.visible = true;
                runningCat.playing = true;
            }
        }
    }
}
