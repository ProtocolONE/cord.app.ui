import QtQuick 1.1
import Tulip 1.0

import "../Elements" as Elements
import "." as Blocks
import "../js/GameListModelHelper.js" as GameListModelHelper

Blocks.MoveUpPage {
    id: page

    property bool withPath
    property string pathInput
    property string serviceId
    property alias createShortcut: createShortcutCheckBox.isChecked

    signal accept();

    openHeight: page.withPath ? d.gameOpenHeight : d.homeOpenHeight

    QtObject {
        id: d

        property Gradient hoverGradient: Gradient {
            GradientStop { position: 1; color: "#227700" }
            GradientStop { position: 0; color: "#227700" }
        }

        property Gradient normalGradient: Gradient {
            GradientStop { position: 1; color: "#177e00" }
            GradientStop { position: 0; color: "#32b003" }
        }

        property int gameOpenHeight: 132
        property int homeOpenHeight: 87
    }

    Rectangle {
        anchors { left: parent.left; right: parent.right; }
        height: page.withPath ? d.gameOpenHeight : d.homeOpenHeight
        color: "#353945"

        Rectangle {
            height: 1
            anchors { left: parent.left; right: parent.right }
            color: "#4B4D59"
        }

        Column {
            visible: !page.withPath
            anchors { left: parent.left; top: parent.top; leftMargin: 42; topMargin: 16 }

            Text {
                color : "#CCCCCC"
                font { pixelSize: 11; family: "Arial" }
                textFormat: Text.RichText
                text: qsTr("FIRSTLICENSE_LICENSE_CAPTION")
            }

            Text {
                color : gamenetLicenseHover.containsMouse ? "#FFFFFF" : "#CCCCCC"
                font { pixelSize: 11; family: "Arial"; underline: true }
                textFormat: Text.RichText
                text: qsTr("FIRSTLICENSE_GAMENET_LICENSE_CAPTION")

                Elements.CursorMouseArea {
                    id: gamenetLicenseHover

                    anchors.fill: parent
                    onClicked: Qt.openUrlExternally("http://www.gamenet.ru/license");
                }
            }
        }

        Column {
            anchors { left: parent.left; top: parent.top; leftMargin: 42; topMargin: 16 }
            visible: page.withPath
            spacing: 7

            Text {
                color: "#FFFFFF"
                font { family: "Arial"; pixelSize: 16 }
                text: qsTr("FIRSTLICENSE_GAMEPATH_LABEL")
            }

            Row {
                height: childrenRect.height
                spacing: 7

                Elements.FileInput {
                    id: pathInput

                    width: 273
                    height: 28
                    textElement { text: page.pathInput; readOnly: true }
                    onEditTextChanged: page.pathInput = text;
                }

                Elements.Button3 {
                    buttonText: qsTr("BUTTON_BROWSE")
                    height: 27
                    onButtonClicked: {
                        var result = QFileDialog.getExistingDirectory(qsTr('FIRSTLICENSE_BROWSE_WINDOW_CAPTION'), page.pathInput);
                        if (result) {
                            page.pathInput = result;
                        }
                    }
                }
            }

            Elements.CheckBox {
                id: createShortcutCheckBox

                buttonText: qsTr("FIRSTLICENSE_CREATE_SHORTCUTS")
                state: "Active"
            }
        }

        Row {
            visible: page.withPath
            anchors { left: parent.left; leftMargin: 42 ;bottom: parent.bottom; bottomMargin: 12 }
            spacing: 5

            Text {
                color : "#CCCCCC"
                font { pixelSize: 11; family: "Arial" }
                textFormat: Text.RichText
                text: qsTr("FIRSTLICENSE_LICENSE_CAPTION")
            }

            Text {
                color : gamenetLicenseHover2.containsMouse ? "#FFFFFF" : "#CCCCCC"
                font { pixelSize: 11; family: "Arial"; underline: true }
                textFormat: Text.RichText
                text: qsTr("FIRSTLICENSE_GAMENET_LICENSE_CAPTION")

                Elements.CursorMouseArea {
                    id: gamenetLicenseHover2

                    anchors.fill: parent
                    onClicked: Qt.openUrlExternally("http://www.gamenet.ru/license");
                }
            }

            Text {
                color : gamenetLicenseHover3.containsMouse ? "#FFFFFF" : "#CCCCCC"
                font { pixelSize: 11; family: "Arial"; underline: true }
                textFormat: Text.RichText
                text: qsTr("FIRSTLICENSE_GAME_LICENSE_CAPTION")

                Elements.CursorMouseArea {
                    id: gamenetLicenseHover3

                    anchors.fill: parent
                    onClicked: {
                        var item = GameListModelHelper.serviceItemByServiceId(page.serviceId);
                        if (!item) {
                            return;
                        }

                        var url = item.licenseUrl;
                        if (url) {
                            Qt.openUrlExternally(url);
                        }
                    }
                }
            }
        }

        Rectangle {
            border { width: 1; color: "#FFFFFF" }
            gradient: buttonMouser.containsMouse ? d.hoverGradient : d.normalGradient
            anchors { right: parent.right; top: parent.top; rightMargin: 33; topMargin: 16 }
            width: 322
            height: 54

            Text {
                anchors.centerIn: parent
                color : "#FFFFFF"
                font { pixelSize: 28; family: "Segoe UI" }
                textFormat: Text.RichText
                text: qsTr("FIRSTLICENSE_ACCEPT_BUTTON_CAPTION")
            }

            Elements.CursorMouseArea {
                id: buttonMouser

                anchors.fill: parent
                onClicked: page.accept();
            }
        }
    }
}

