import QtQuick 2.4

import Tulip 1.0
import GameNet.Controls 1.0

import Application.Core.Styles 1.0

Item {
    id: root

    property alias avatar: avatarImage.source
    property alias nickname: nicknameText.text
    property alias status: statusText.text

    property bool canDelete: true
    property bool owner: true
    property bool canSelect: true

    signal clicked();
    signal deleteClicked();
    signal rightButtonClicked(variant mouse);

    signal selectUser();

    implicitHeight: 40
    implicitWidth: 209

    MouseArea {
        id: mouser

        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: {
            if (mouse.button === Qt.RightButton) {
                root.rightButtonClicked(mouse);
            }

            if (mouse.button === Qt.LeftButton) {
                root.clicked();
            }
        }

        Rectangle {
            anchors.fill: parent
            color: Styles.light
            opacity: 0.1
            visible: parent.containsMouse
        }

        Item {
            id: contentContainer

            anchors {
                fill: parent
                margins: 4
            }

            Row {
                anchors.fill: parent

                Image {
                    id: avatarImage

                    width: 32
                    height: 32

                    source: root.avatar

                    CursorMouseArea {
                        visible: root.canSelect
                        anchors.fill: parent
                        onClicked: root.selectUser();
                    }
                }

                Item  {
                    width: 14
                    height: parent.height

                    Image {
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            top: parent.top
                            topMargin: 2
                        }

                        visible: root.owner
                        source: installPath + "/Assets/Images/Application/Widgets/Messenger/ownerIcon.png"
                    }
                }

                Item {
                    width: contentContainer.width - (32 + 14 + (deleteContainer.visible ? deleteContainer.width : 0))
                    height: parent.height

                    Text {
                        id: nicknameText

                        width: parent.width
                        elide: Text.ElideRight
                        color: Styles.menuText

                        font {
                            pixelSize: 14
                            family: "Arial"
                        }

                        anchors {
                            baseline: parent.top
                            baselineOffset: 12
                        }
                    }

                    Text {
                        id: statusText

                        color: Styles.textBase
                        width: parent.width
                        elide: Text.ElideRight
                        opacity: 0.5

                        font {
                            pixelSize: 14
                            family: "Arial"
                        }

                        anchors {
                            baseline: parent.bottom
                            baselineOffset: -3
                        }
                    }
                }

                Item {
                    id: deleteContainer

                    visible: mouser.containsMouse && root.canDelete

                    width: 19
                    height: parent.height

                    ImageButton {
                        style {
                            normal: "#00000000"
                            hover: "#00000000"
                            disabled: "#00000000"
                        }
                        anchors.fill: parent

                        styleImages {
                            normal: installPath + Styles.messengerChatClose
                        }

                        opacity: containsMouse ? 1 : 0.5
                        onClicked: root.deleteClicked()

                        Behavior on opacity {
                            NumberAnimation {
                                duration: 250
                            }
                        }
                    }
                }
            }
        }
    }
}
