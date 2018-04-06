import QtQuick 2.4
import Tulip 1.0
import GameNet.Controls 1.0
import Application.Controls 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0

Item {
    id: root

    property bool activated: false

    implicitHeight: 61
    implicitWidth: 100

    signal clicked();

    function closePanel() {
        root.activated = false;
    }

    Item {
        id: d

        function outerMenuClicked(root, button, view, x, y) {

            var posInItem = button.mapFromItem(root, x, y);
            var contains =  posInItem.x >= 0
                    && posInItem.y >=0
                    && posInItem.x <= button.width
                    && posInItem.y <= button.height;

            if (contains)
                return contains;

            posInItem = view.mapFromItem(root, x, y);
            contains =  posInItem.x >= 0
                    && posInItem.y >=0
                    && posInItem.x <= view.width
                    && posInItem.y <= view.height;

            return contains;
        }
    }

    AccountItemBottom {
        visible: root.activated
        color: Styles.contentBackground
    }

    GameMenuItem {
        id: menuButton

        y: 1
        anchors {left: parent.left; right: parent.right; leftMargin: 1; rightMargin: 1}
        text: qsTr("GAME_MENU_SPECIAL_BUTTON_ACCOUNTS")
        icon: installPath + Styles.gameMenuExtendedAccIcon
        activeOpacity: activated ? 0 : 0.3
        onClicked: {

            if (ContextMenu.isShown()) {
                ContextMenu.hide();
                return;
            }

            ContextMenu.show({x:0, y:0}, root, accountItemTopComponent, {});
        }
    }

    ContentStroke {
        visible: !root.activated
        width: parent.width
    }

    Component {
        id: accountItemTopComponent

        Rectangle {

            signal outerClicked(variant root, int x, int y);
            property bool canHide: true
            color: Styles.popupBlockBackground

            onOuterClicked:{
                canHide = !d.outerMenuClicked(root, menuButton, view, x, y);
            }

            AccountItemTop {
                id: view
                visible: true
            }
        }
    }
}
