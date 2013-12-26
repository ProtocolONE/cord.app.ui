import QtQuick 1.1
import Tulip 1.0
import "../Elements" as Elements

Item {
    id: root

    property string nickName

    property bool isAuthed: false
    property bool isRunning: false
    property bool playEnabled: false
    property bool enabled: true

    property int buttonWidth: 32
    property int spacing: 5

    signal authClick();
    signal logoutClick();
    signal playClick();

    Rectangle {
        id: secondNickNameBlock

        anchors { left: parent.left; right: parent.right; rightMargin: -root.buttonWidth - root.spacing; bottom: parent.top; bottomMargin: 2; }
        border.color: '#ffffff'
        height: 30
        visible: false

        color: root.isRunning ? "#4B4545" : "#329900"

        Elements.CursorMouseArea { // auth button
            id: loginBlock

            anchors.fill: parent
            visible: false
            enabled: !root.isRunning && root.enabled

            onClicked: root.authClick();

            Text {
                text: qsTr("ADD_ACCOUNT_BUTTON_LABEL")
                color: "#ffffff"
                font { family: "Segoe UI Light"; weight: Font.Light; pixelSize: 15 }
                anchors.centerIn: parent

                elide: Text.ElideRight
            }
        }

        Item { // play button
            id: authedBlock

            anchors.fill: parent
            visible: false

            Item {
                height: parent.height
                width: parent.width - 32

                Text {
                    text: nickName
                    color: "#ffffff"
                    font { family: "Segoe UI Light"; weight: Font.Light; pixelSize: 15 }
                    elide: Text.ElideRight
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: 15
                        right: parent.right
                        rightMargin: 15
                    }
                }

                Elements.CursorMouseArea {
                    id: playButton

                    anchors.fill: parent
                    onClicked: root.playClick();
                    enabled: !root.isRunning && root.enabled && root.playEnabled
                    toolTip: qsTr("SECOND_GAME_PLAY_TOOLTIP")
                }

                Elements.CursorMouseArea {
                    anchors.fill: parent
                    visible: !playButton.enabled && root.enabled
                    hoverEnabled: true
                    toolTip: qsTr("SECOND_GAME_UNABLE_PLAY_TOOLTIP")
                    cursor: CursorArea.ArrowCursor
                }

            }

            Elements.CursorMouseArea {
                height: parent.height
                width: 32
                anchors.right: parent.right
                enabled: !root.isRunning && root.enabled
                onClicked: root.logoutClick();
                toolTip: qsTr("SECOND_GAME_LOGOUT_TOOLTIP")

                Image {
                    source: installPath + 'images/exit.png'
                    anchors.centerIn: parent
                }
            }
        }
    }

    Rectangle {
        anchors { right: parent.right; top: parent.top; rightMargin: -root.buttonWidth - root.spacing }
        border.color: '#ffffff'
        height: parent.height
        width: root.buttonWidth
        color: root.isRunning ? "#4B4545" : "#329900"

        Elements.CursorMouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onClicked: secondNickNameBlock.visible = !secondNickNameBlock.visible;
        }

        Image {
            source: installPath + 'images/blocks/SecondWindowGame/arrow.png'
            anchors.centerIn: parent
        }
    }

    states: [
        State {
            name: "Not Authed"
            when: !root.isAuthed

            PropertyChanges { target: loginBlock; visible: true }
        },
        State {
            name: "Authed"
            when: root.isAuthed

            PropertyChanges { target: authedBlock; visible: true }
        }

    ]
}
