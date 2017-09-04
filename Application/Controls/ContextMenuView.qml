import QtQuick 2.4
import GameNet.Controls 1.0
import Tulip 1.0
import Application.Core 1.0
import Application.Core.Styles 1.0

Rectangle {
    id: root

    signal contextClicked(string action);

    function fill(options) {
        options.forEach(function(o) {
            actionModel.append({
                                   name: o.name || "",
                                   action: o.action || "",
                                   iconLink: o.iconLink || ""
                               });
        });
    }

    width: actionListView.width + 14
    height: actionModel.count * 28 + 14 + (actionModel.count == 0 ? 2 : 0)
    color: Styles.popupBlockBackground

    ListModel {
        id: actionModel
    }

    ContentThinBorder {}

    Item {
        anchors {
            fill: parent
            margins: 7
        }

        ListView {
            id: actionListView

            model: actionModel
            interactive: false
            height: model.count * 28 + 2 + 10
            width: 10

            delegate: Item {
                id: item

                Component.onCompleted: {
                    var w = menuText.width + 40
                    if (w > actionListView.width) {
                        actionListView.width = w;
                    }
                }

                width: actionListView.width
                height: 28

                Rectangle {
                    anchors.fill: parent
                    color: Styles.applicationBackground
                    visible: actionMouser.containsMouse
                }

                Text {
                    id: menuText

                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: 17
                    }

                    opacity: actionMouser.containsMouse ? 1 : 0.5
                    color: actionMouser.containsMouse
                           ? Styles.chatButtonText
                           : Styles.textBase

                    font {
                        pixelSize: 12
                        family: "Arial"
                    }


                    text: qsTr(model.name)
                }

                Image {
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: menuText.right
                        leftMargin: 4
                    }

                    visible : model.iconLink !== ""
                    source: installPath + model.iconLink
                }

                CursorMouseArea {
                    id: actionMouser

                    anchors.fill: parent
                    onClicked: root.contextClicked(model.action);
                }
            }
        }
    }
}
