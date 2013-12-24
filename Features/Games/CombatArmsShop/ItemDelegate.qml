import QtQuick 1.1
import "../../../Elements" as Elements

Item {
    id: container

    property variant view: ListView.view
    property bool isCurrent: ListView.isCurrentItem

    signal buyClicked(variant modelItem)
    
    anchors.verticalCenter: parent.verticalCenter

    Column {
        anchors.fill: parent
        spacing: 3

        Rectangle {
            color: "#4D4235"
            border.color: "#5F564A"
            width: 148
            height: 98
            anchors.horizontalCenter: parent.horizontalCenter

            Image {
                width: 148
                height: 98
                fillMode: Image.PreserveAspectFit
                smooth: true
                source: installPath + model.preview
                anchors.fill: parent
            }

            Rectangle {
                id: hoverBlock

                color: "#37000000"
                visible: itemArea.containsMouse
                anchors.fill: parent

                Text {
                    id: shortDesc

                    text: model.shortDescription
                    wrapMode: Text.WordWrap
                    width: parent.width - 6
                    color: "#FFFFFF"
                    font { family: "Arial"; pixelSize: 14; bold: true }

                    anchors {
                        top: parent.top
                        topMargin: 5
                        left: parent.left
                        leftMargin: 3
                    }
                }

                Rectangle {
                    id: priceBackground

                    width: parent.width/2
                    height: 27
                    color: "#FDC809"
                    anchors { left: parent.left; bottom: parent.bottom }

                    Text {
                        id: priceText

                        text: options.get(0).price
                        anchors {
                            verticalCenter: parent.verticalCenter
                            left: parent.left
                            leftMargin: 4
                        }

                        wrapMode: Text.NoWrap
                        style: Text.Normal
                        smooth: true
                        color: "#43382A"
                        font { family: "Arial"; pixelSize: 20 }
                    }

                    Image {
                        anchors {
                            verticalCenter: parent.verticalCenter
                            left: priceText.right
                            leftMargin: 5
                        }

                        fillMode: Image.PreserveAspectFit
                        source: installPath + "images/gn_43382A.png"
                        smooth: true
                    }
                }

                Rectangle {
                    id: buyButton

                    width: parent.width/2
                    height: 27
                    color: "#006600"

                    anchors { right: parent.right; bottom: parent.bottom }

                    Text {
                        text: qsTr("CA_SHOP_ITEMS_BUY")
                        anchors.centerIn: parent
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.NoWrap
                        style: Text.Normal
                        smooth: true
                        color: "#FFFFFF"
                        font { family: "Arial"; pixelSize: 14 }
                    }
                }
            }

            Elements.CursorMouseArea {
                 id: itemArea

                 anchors.fill: parent
                 hoverEnabled: true
                 onClicked: {
                     view.currentIndex = index;
                     buyClicked(model);
                 }
             }
        }

        Text {
            text: title
            wrapMode: Text.WordWrap
            width: parent.width - 6
            height: 20
            color: "#FFFFFF"
            horizontalAlignment: Text.AlignHCenter
            font { family: "Arial"; pixelSize: 12 }

            anchors.horizontalCenter: parent.horizontalCenter
        }

    }
}

