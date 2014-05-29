import QtQuick 1.1
import GameNet.Components.Widgets 1.0

Item {
    WidgetContainer {
        anchors {
            right: parent.right
            rightMargin: 230
            bottom: parent.bottom
        }

        height: 558
        width: 590
        widget: 'Messenger'
        view: 'Chat'
    }

//    WidgetContainer {
//        anchors {
//            right: parent.right
//            bottom: parent.bottom
//        }

//        height: 467
//        width: 230
//        widget: 'Messenger'
//        view: 'Contacts'
//    }
}
