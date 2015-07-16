/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 2.4
import Tulip 1.0

import GameNet.Controls 1.0

import Application.Controls 1.0 as AppControls

import Application.Core 1.0
import Application.Core.Styles 1.0

AppControls.TrayPopupBase {
    id: popUp

    signal closeButtonClicked();
    signal playClicked();

    property alias message: messageText.text
    property alias buttonCaption: actionButton.text
    property alias messageFontSize : messageText.font.pixelSize
    property variant gameItem

    width: 240
    height: 332

    Rectangle {
        anchors.fill: parent
        color: Styles.trayPopupBackground

        Column {
            spacing: 1
            anchors {
                fill: parent
                margins: 1
            }

            Rectangle {
                width: parent.width
                height: 25

                color: Styles.trayPopupHeaderBackground

                Image {
                    anchors {
                        left: parent.left
                        leftMargin: 6
                        verticalCenter: parent.verticalCenter
                    }

                    source: installPath + "Assets/Images/Application/Widgets/Announcements/logo.png"
                }

                ImageButton {
                    id: closeButtonImage

                    anchors {
                        right: parent.right
                        rightMargin: 6
                        verticalCenter: parent.verticalCenter
                    }
                    width: 12
                    height: 12

                    style {
                        normal: "#00000000"
                        hover: "#00000000"
                        disabled: "#00000000"
                    }
                    styleImages {
                        normal: installPath + "Assets/Images/Application/Widgets/Announcements/closeButton.png"
                    }

                    opacity: containsMouse ? 1 : 0.5
                    onClicked: {
                        root.closeButtonClicked();
                        root.shadowDestroy();
                    }

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 250
                        }
                    }
                }
            }

            //  INFO: В соответсвие с дизайном QGNA 3.4 размер фоновой картинки для
            //  артовой всплывашки должен быть 238х288
            Item {
                width: parent.width
                height: 306

                Image {
                    width: 238
                    height: 308
                    asynchronous: true
                    fillMode: Image.Stretch
                    smooth: true
                    source: gameItem.imagePopupArt
                }

                Text {
                    id: messageText

                    anchors {
                        bottom: actionButton.top
                        bottomMargin: 20

                        left: actionButton.left
                        leftMargin: 5
                        right: actionButton.right
                        rightMargin: 5
                    }
                    wrapMode: TextEdit.WordWrap
                    font {
                        family: "Arial"
                        pixelSize: 15
                    }
                    color: Styles.trayPopupText
                    horizontalAlignment: Text.AlignHCenter
                }

                Button {
                    id: actionButton

                    anchors {
                        left: parent.left
                        leftMargin: 8
                        right: parent.right
                        rightMargin: 8
                        bottom: parent.bottom
                        bottomMargin: 8
                    }

                    style {
                        normal: Styles.trayPopupButtonNormal
                        hover:  Styles.trayPopupButtonHover
                    }

                    height: 44
                    fontSize: 18

                    onClicked: {
                        root.playClicked();
                        root.shadowDestroy();
                    }
                }
            }
        }
    }
}
