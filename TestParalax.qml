import QtQuick 1.1
import Tulip 1.0
import "D:../../../../GameNet/Controls" as Controls
import "D:../../../../Application/Blocks/Header" as Header
import "D:../../../../Application/Blocks/GameMenu" as GameMenu
import "D:../../../../Application/Blocks" as Blocks
import "D:../../../../GameNet/Components/Widgets"

import "Elements/Tooltip" as Tooltip
import "Pages/Auth" as Auth

import "Elements" as Elements
import "Application/Models" as Models

import "js/Core.js" as Core
import "js/UserInfo.js" as UserInfo
import "Proxy/App.js" as AppProxy

import "Tests/Application/Core" as Tests

Rectangle {
    id: root

    signal onWindowPressed(int x, int y);
    signal onWindowReleased(int x, int y);
    signal onWindowClose();
    signal onWindowOpen();
    signal onWindowPositionChanged(int x, int y);
    signal onWindowMinimize();

    signal windowDestroy();

    property bool progressTmp: false

    width: 1000
    height: 600
    //color: "#FAFAFA"
    //color: "red"

    color: "#092135"

    Connections {
        target: Core.gamesListModel

        onCurrentGameItemChanged: {
            var item = Core.currentGame();
            if (item.menu.count > 0) {
                gameMenu.currentIndex = item.currentMenuIndex;
                gameMenu.flickable.positionViewAtIndex(item.currentMenuIndex, ListView.Beginning)
                return;
            }
        }
    }

    Rectangle {
        width: 100
        height: 100
        color: "blue"
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        Elements.Button {
            anchors.fill: parent
            onClicked: {
                root.fillModel();
            }
        }
    }

    Component.onCompleted: {
        Core.setProgressParent(root);
        Core.activateGameByServiceId("300003010000000000");

        var item = Core.currentGame();
        console.log('  Current game  ', item.serviceId)

    }

    //    Auth.Index {
    //        anchors.fill: parent
    //    }

    TestMenuModel {
        id: menu
    }


    Header.Header {
        width: parent.width
        height: 42
    }

    Item {
        anchors.fill: parent
        anchors.topMargin: 42

        Row {
            anchors.fill: parent

            Rectangle { // left
                width: 178
                height: parent.height
                color: "#092135"

                Column {
                    anchors.fill: parent

                    Rectangle {
                        width: parent.width
                        height: 136
                        color : "green"
                    }

                    Controls.HorizontalSplit {
                        width: parent.width
                    }

                    Item {
                        width: parent.width
                        height: 376
                        clip: true

                        GameMenu.GameMenu {
                            id: gameMenu

                            anchors.fill: parent
                            model: Core.currentGame().menu

                            onUrlClicked: {
                                console.log('Open Url', url)
                                //AppProxy.openExternalUrl(url)
                            }

                            onPageClicked: {
                                Core.currentGame().currentMenuIndex = gameMenu.currentIndex;
                                console.log('Open Page ', page)
                            }

                        }

                        Elements.ScrollBar {
                            id: menuScroll

                            flickable: gameMenu.flickable

                            visible: gameMenu.flickable.contentHeight > menuScroll.height
                            height: parent.height
                            anchors.right: parent.right
                            //scrollbarWidth: 2
                        }

                    }
                }

                Rectangle {
                    width: parent.width
                    height: 44
                    color: "red"
                    anchors.bottom: parent.bottom
                }
            }

            Controls.VerticalSplit {
                height: parent.height
            }

            Rectangle { // center
                width: 590
                height: parent.height
                color: "pink"
            }


            Controls.VerticalSplit {
                height: parent.height
            }

            Rectangle { // right
                width: 228
                height: parent.height
                color: "blue"

                ListView {
                    boundsBehavior: Flickable.StopAtBounds
                    anchors.fill: parent
                    width: parent.width
                    height: model.count * 37

                    interactive: true

                    maximumFlickVelocity: 1450

                    model: Core.gamesListModel
                    delegate: Rectangle {
                        width: parent.width
                        height: 37
                        color: "green"

                        Text {
                            anchors.centerIn: parent
                            text: model.name
                        }

                        Controls.ButtonBehavior {
                            anchors.fill: parent
                            onClicked:  {
                                console.log('--- ', model.serviceId)
                                Core.activateGameByServiceId(model.serviceId);
                            }
                        }
                    }
               }
            }

        }
    }


    Item {
        anchors.fill: parent
        focus: true
        Keys.onReleased: {
            normalImg.visible = !normalImg.visible
        }

        Image {
            id: normalImg

            visible: false
            opacity: 0.2
            source: installPath + "./1/6_05.jpg"
        }
    }


    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: {

            //normalImg.visible = !normalImg.visible



        }
    }

    Text {
        id: test

        Component.onCompleted: {
            console.log('test.smooth:',test.smooth);
        }
    }

    Tooltip.Tooltip {}

    Connections {
        target: UserInfo.instance()

        onAuthDone: {
            console.log('-------------- AuthDone', UserInfo.userId());
        }

        onLogoutDone: {
            console.log('-------------- LogoutDone', UserInfo.userId());
        }
    }

}
