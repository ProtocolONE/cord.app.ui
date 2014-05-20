import QtQuick 1.1
import Tulip 1.0
import QXmpp 1.0

import "Elements/Tooltip" as Tooltip
import "Pages/Auth" as Auth

import "Controls" as Controls
//import "Blocks2" as Blocks2

import "Elements" as Elements
//import "Models" as Models

import "js/Core.js" as Core
import "js/UserInfo.js" as UserInfo
import "Proxy/App.js" as AppProxy

import "Application/Models/Messenger.js" as MessengerJs

//import "Blocks2/Messenger" as Messenger

import Application.Blocks.Messenger 1.0
import Gamenet.Controls 1.0

Rectangle {
    width: 1000
    height: 600

    color: "#092135"

    Component.onCompleted: {

        //        var user = "nikita.gorbunov";
        //        var server = "j.gamenet.dev"
        //        var password = "123"

        var user = "400001000001634860";
        var server = "j.gamenet.dev"
        var password = "4c2f65777d38eb07d32d111061005dcd5a119150"

        var bareJid = user + "@" + server;

        MessengerJs.connect(user, password);
    }

    QtObject {
        id: d
    }

    Row {
        anchors.fill: parent
        layoutDirection: Qt.RightToLeft

        Contacts {
            height: parent.height
        }

        VerticalSplit {
            height: parent.height
            style: SplitterStyleColors {
                main: "#FFFFFF"
                shadow: "#E5E5E5"
            }
        }

        Chat {
            visible: !!MessengerJs.currentUser()
            width: 590
            height: parent.height
        }
    }

}
