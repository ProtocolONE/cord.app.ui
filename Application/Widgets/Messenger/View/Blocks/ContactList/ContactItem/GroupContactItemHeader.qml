/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2015, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 1.1
import Tulip 1.0

import "../../../../../../Core/Styles.js" as Styles

Item {
    id: root

    property alias occupantModel: occupantView.model

    property string title: ""

    signal nicknameClicked()
    signal clicked()
    signal rightButtonClicked(variant mouse);

    signal groupButtonClicked();

    implicitWidth: 78
    implicitHeight: 72

    Row {
        anchors {
            fill: parent
            leftMargin: 12
            topMargin: 12
            bottomMargin: 12
        }

        spacing: 7

        Item {
            width: 200 - 20
            height: parent.height

            Text {
                width: parent.width
                anchors {
                    baseline: parent.top
                    baselineOffset: 14
                }

                font {
                    family: "Arial"
                    pixelSize: 14
                }

                color: Styles.style.menuText
                // INFO Этот хак чинит проблему с уползанием текста, когда текст пустой
                text: root.title ? root.title : "  "
                elide: Text.ElideRight
                textFormat: Text.PlainText
            }

            GroupCountButton {
                anchors {
                    bottom: parent.bottom
                    bottomMargin: 6
                }

                count: occupantModel.count
                checked: false
                onClicked: root.groupButtonClicked()
            }
        }

        OccupantListView {
            id: occupantView

            height: parent.height
            width: Math.floor((root.width - 247) / 54)*54 - 6
        }
    }

    EditGroupButton {
        anchors {
            top: parent.top
            topMargin: 12
            right: parent.right
        }

        onClicked: root.groupButtonClicked()
    }

}
