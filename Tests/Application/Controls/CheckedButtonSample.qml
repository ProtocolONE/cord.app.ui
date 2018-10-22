import QtQuick 1.1
import GameNet.Components.Widgets 1.0
import GameNet.Components.JobWorker 1.0
import GameNet.Controls 1.0

import Application.Controls 1.0

import "../../../Application/Core/Styles.js" as Styles

Rectangle {
    id: root

    width: 1000
    height: 600
    color: Styles.style.applicationBackground

    Grid {
        spacing: 10
        anchors.fill: parent
        anchors.margins: 10


        CheckedButton {
            width: 100
            height: 50

            onClicked: checked = !checked
        }

        CheckedButton {
            width: 100
            height: 50
            boldBorder: true

            onClicked: checked = !checked
        }


        CheckedButton {
            text: "Сохранить группу"

            onClicked: checked = !checked
        }

        CheckedButton {
            boldBorder: true

            checked: false
            text: "Сохранить группу"
            onClicked: checked = !checked
        }


        CheckedButton {
            icon: installPath + "Assets/Images/Application/Widgets/Messenger/ContactItem/editGroupChatIcon.png"

            onClicked: checked = !checked
        }

        CheckedButton {
            icon: installPath + "Assets/Images/Application/Widgets/Messenger/ContactItem/editGroupChatIcon.png"

            checked: false
            onClicked: checked = !checked
        }

        CheckedButton {
            text: "Прогресс"
            icon: installPath + "Assets/Images/Application/Widgets/Messenger/ContactItem/editGroupChatIcon.png"

            onClicked: {
                checked = !checked
                progressButton1.inProgress = !progressButton1.inProgress;
                progressButton2.inProgress = !progressButton2.inProgress;
            }
        }

        CheckedButton {
            id: progressButton1

            text: "Сохранить группу"

            inProgress: true
            onClicked: inProgress = !inProgress
        }

        CheckedButton {
            id: progressButton2

            icon: installPath + "Assets/Images/Application/Widgets/Messenger/ContactItem/editGroupChatIcon.png"

            inProgress: true
            onClicked: inProgress = !inProgress
        }

        CheckedButton {
            enabled: false
            width: 100
            height: 50
        }

        CheckedButton {
            enabled: false
            icon: installPath + "Assets/Images/Application/Widgets/Messenger/ContactItem/editGroupChatIcon.png"
            text: "Сохранить группу"
        }

        CheckedButton {
            enabled: false
            boldBorder: true
            text: "Сохранить группу"
        }
    }

}
