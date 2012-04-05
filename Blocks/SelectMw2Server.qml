/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.0
import "../Delegates" as Delegates
import "../Elements" as Elements
import "." as Blocks

Blocks.MoveUpPage {
    id: page
    signal clicked(int index);

    property bool isBlockOpen: false

    width: 800
    height: 400
    openHeight: 308

    Rectangle {
        id: chooseServerBox

        function startGame() {
            var index = (selectMw2ServerModelListView.currentIndex != -1)
                ? selectMw2ServerModelListView.currentIndex : 0;

            selectMw2ServerModel.listModel.itemSelected(index);
            page.closeMoveUpPage();
        }

        anchors.fill: parent
        color: "#09467f"

        Connections {
            target: selectMw2ServerModel
            onOpenBlock: page.openMoveUpPage();
        }

        Text {
            font { family: "Arial"; pixelSize: 18 }
            text: qsTr("TITLE_CHOOSE_MW2_SERVER")
            anchors { left: parent.left; top: parent.top; leftMargin: 40; topMargin: 25 }
            wrapMode: Text.WordWrap
            color: "#ffffff"
            smooth: true
        }

        Rectangle {
            anchors { left: parent.left; top: parent.top; leftMargin: 275; topMargin: 30 }
            color: "#09467f"
            border { color: "#4774a0"; width: 1 }
            width: 380
            height: ((selectMw2ServerModelListView.count + 1) * 24) + 3

            Component {
                id: headerView

                Rectangle {
                    height: 27
                    width: 380
                    border { color: "#4774a0"; width: 1 }
                    color: "#00000000"

                   Row {
                        anchors { top: parent.top; topMargin: 5 }
                        spacing: 15

                        Rectangle {
                            height: parent.height
                            width: 25;
                            Text {
                                anchors { left: parent.left; leftMargin: 6 }
                                font.pixelSize: 14;
                                color: "#99ccff";
                                text: "№"
                            }
                        }

                        Rectangle {
                            height: parent.height
                            width: 80;
                            Text { font.pixelSize: 14; color: "#99ccff"; text: qsTr("LABEL_SERVER_NAME") }
                        }

                        Rectangle {
                            height: parent.height
                            width: 90;
                            Text { font.pixelSize: 14; color: "#99ccff"; text: qsTr("LABEL_SERVER_STATUS") }
                        }

                        Rectangle {
                            height: parent.height
                            width: 85;
                            Text { font.pixelSize: 14; color: "#99ccff";text: qsTr("LABEL_CHARS_ON_SERVER") }
                        }
                    }
                }
            }

            ListView {
                id: selectMw2ServerModelListView

                anchors.fill: parent
                header: headerView
                interactive: false
                highlightFollowsCurrentItem: true
                currentIndex: -1
                orientation: ListView.Vertical

                delegate: Delegates.SelectMw2ServerDelegate {
                    function selectIndex(index) {
                        if (selectMw2ServerModelListView.currentIndex !== -1) {
                           selectMw2ServerModelListView.currentItem.isSelected = false;
                        }

                        selectMw2ServerModelListView.currentIndex = index;
                        selectMw2ServerModelListView.currentItem.isSelected = true;
                    }

                    onItemSelected: selectIndex(index)
                    onStartGame: {
                        selectIndex(index)
                        chooseServerBox.startGame();
                    }
                }

                model: selectMw2ServerModel.listModel
                /*
                ListModel {
                    ListElement {
                        position: "112";
                        name: "SomeServer";
                        charCount: 5;
                        status: 1;
                        isPinned: 1
                    }
                    ListElement {
                        position: "1";
                        name: "SomeServer2";
                        charCount: 45;
                        status: 2;
                        isPinned: 0
                    }
                    ListElement {
                        position: "3";
                        name: "SomeServer3";
                        charCount: 5;
                        status: 3;
                        isPinned: 0
                    }
                    ListElement {
                        position: "2";
                        name: "SomeServer4";
                        charCount: 7;
                        status: 0;
                        isPinned: 0
                    }
                }
                */
            }
        }

        Elements.Button5 {
            anchors { top: parent.top; left: parent.left; topMargin: 250; leftMargin: 276 }
            buttonText: qsTr("BUTTON_PLAY")
            onButtonClicked: chooseServerBox.startGame();
        }
    }
}
