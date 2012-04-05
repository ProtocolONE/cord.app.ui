import qGNA.Library 1.0
import QtQuick 1.1
import Qt 4.7

Rectangle {
    id: trayBlock
    width: 204
    height: 127
    focus: true

    Connections {
        target: trayMenu

        onMenuTypeChanged: {
            switch(trayMenu.menuType) {
                case TrayWindow.FullMenu:
                  trayMenu.resizeWindow(204, 127);
                  break;
                case TrayWindow.OnlyQuitMenu:
                  trayMenu.resizeWindow(204, 127 - 22 * 3 - 15);
                  break;
                }
        }

        onHideMenu: {
            if (listViewId.currentIndex >= 0) {
                listViewId.currentItem.isHover = false;
                listViewId.currentIndex = -1;
            }
        }

        onKeyPressed: {
            switch(key) {
            case Qt.Key_Up: {
                if (listViewId.currentIndex >= 0) {
                    listViewId.currentItem.isHover = false;

                    if (0 === listViewId.currentIndex) {
                        listViewId.currentIndex = listViewId.count - 1;
                    } else {
                        listViewId.currentIndex = listViewId.currentIndex - 1;
                    }

                    listViewId.currentItem.isHover = true;
                } else {
                    listViewId.currentIndex = listViewId.count - 1;
                    listViewId.currentItem.isHover = true;
                }
                break;
            }
            case Qt.Key_Down: {
                if (listViewId.currentIndex >= 0) {
                    listViewId.currentItem.isHover = false;

                    if (listViewId.count - 1 === listViewId.currentIndex) {
                        listViewId.currentIndex = 0;
                    } else {
                        listViewId.currentIndex = listViewId.currentIndex + 1;
                    }

                    listViewId.currentItem.isHover = true;
                } else {
                    listViewId.currentIndex = 0;
                    listViewId.currentItem.isHover = true;
                }
                break;
            }
            case Qt.Key_Return:
            case Qt.Key_Enter:
                if (listViewId.currentIndex >= 0) {
                    trayBlock.menuClick( listViewId.currentItem.value );
                } else
                    trayMenu.hide();

                break;
            }
        }
    }

    signal menuClick(int id);

    property ListModel fullMenu: ListModel {
                        ListElement {
                            icon:  "images/trayProfileIcon.png"
                            label: QT_TR_NOOP("MENU_ITEM_PROFILE")
                            value: 0
                        }
                        ListElement {
                            icon:  "images/trayMoneyIcon.png"
                            label: QT_TR_NOOP("MENU_ITEM_MONEY")
                            value: 1
                        }
                        ListElement {
                            icon:  "images/traySettingsIcon.png"
                            label: QT_TR_NOOP("MENU_ITEM_SETTINGS")
                            value: 2
                        }
                        ListElement {
                            label: QT_TR_NOOP("MENU_ITEM_QUIT")
                            value: 3
                        }
                    }

    property ListModel quitMenu: ListModel {
        ListElement {
            label: QT_TR_NOOP("MENU_ITEM_QUIT")
            icon: ""
            value: 3
        }
    }

    Image {
        source: installPath + "images/trayBackIcon.png"
        anchors.fill: parent
    }
    Rectangle {
        anchors.fill: parent
        anchors.topMargin: 29
        color: "#000000"
        opacity: 0.30
        Image {
            source: installPath + "images/trayBackShadow.png"
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.right: parent.right
        }
    }
    Text {
        color: "#ececec"
        text: "qGNA"
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 12
        font.pixelSize: 15
        font.family: "Tahoma"
        smooth: true
    }
    ListView {
        id: listViewId
        anchors.fill: parent
        anchors.topMargin: 29 + 5
        currentIndex: -1

        delegate:
            Rectangle {
                color: "#00000000"
                height: 22
                width: listViewId.width
                property bool isHover: false

                Rectangle {
                    id: hoverRectangle
                    color: "#ffffff"
                    anchors.fill: parent
                    opacity: 0.15
                    visible: isHover

                }
                MouseArea {
                    id: delegateMouseAreaId
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        trayBlock.menuClick(value);
                    }
                    onEntered: {
                        if (listViewId.currentItem)
                            listViewId.currentItem.isHover = false;

                        listViewId.currentIndex = index;
                        isHover = true;
                    }

                    onExited: {
                        isHover = false;
                    }
                }
                Image {
                    source: icon ? installPath + icon : ""
                    visible: icon ? true : false
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.top: parent.top
                    anchors.topMargin: 4
                }
                Text {
                    color: "#ececec"
                    anchors.left: parent.left
                    anchors.leftMargin: 39
                    anchors.top: parent.top
                    anchors.topMargin: 2
                    text: qsTr(label)
                    font.pixelSize: 14
                    font.family: "Tahoma"
                    smooth: true
                }
        }

        model: trayMenu.menuType === TrayWindow.FullMenu ? fullMenu : quitMenu
    }
}
