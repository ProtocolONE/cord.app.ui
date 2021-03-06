import QtQuick 2.4
import ProtocolOne.Core 1.0
import ProtocolOne.Controls 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0
import Application.Core.Config 1.0

Item {
    id: delegate

    property bool shouldShowDelimited: index != 0

    clip: true
    implicitWidth: 590
    implicitHeight: index == 0 ? 130 : 139

//    function openNews(gameShortName, eventId) {
//        App.openExternalUrlWithAuth(Config.site("/games/") + gameShortName + "/post/" + eventId + "/");

//        Ga.trackEvent('GameNews', 'outer link', eventId);
//    }

//    CursorMouseArea {
//        id: mouser

//        property bool containsMouseEx: mouser.containsMouse || mouserHeader.containsMouse

//        anchors { fill: parent; leftMargin: 10; rightMargin: 10; topMargin: shouldShowDelimited ? 9 : 0}
//        onClicked: openNews(gameShortName, eventId);
//    }

    Column {
        anchors { fill: parent; leftMargin: 10; rightMargin: 10 }
        spacing: 8

        Rectangle {
            height: 1
            width: parent.width
            color: Styles.light
            visible: shouldShowDelimited
            opacity: 0.15
        }

        Row {
            height: parent.height
            width: parent.width

            spacing: 10

            WebImage {
                id: newsImage

                visible: previewImage !== ''
                height: 130
                width: 160
                source: model.previewImage
                cache: false
                asynchronous: false

            }

            Column {
                anchors.top: parent.top
                anchors.topMargin: 2

                height: 128
                width: newsImage.visible ? 430 : 600
                spacing: 6

                Column {
                    width: parent.width
                    spacing: 5

                    Row {
                        height: 12
                        width: parent.width
                        spacing: 10

                        Text {
                            height: 12
                            text: gameName
                            color: Styles.textTime //Qt.darker(Styles.textTime, mouser.containsMouseEx ? 1.5: 0)
                            font { family: 'Arial'; pixelSize: 12 }
                            visible: !root.isSingleMode

                            Behavior on color {
                                ColorAnimation { duration: 200 }
                            }
                        }

                        Text {
                            id: timeText

                            Timer {
                                interval: 60000
                                triggeredOnStart: true
                                running: true
                                onTriggered: timeText.text = Moment.moment(time).fromNow();
                            }

                            height: 12
                            color: Styles.chatInactiveText // Qt.darker(Styles.chatInactiveText, mouser.containsMouseEx ? 1.5: 0)

                            font { family: 'Arial'; pixelSize: 12 }

                            Behavior on color {
                                ColorAnimation { duration: 200 }
                            }
                        }
                    }

                    Item {
                        id: rootNewsHeader

                        width: parent.width
                        height: newsHeader.height

                        Text {
                            id: newsHeader
                            anchors.verticalCenter: parent.verticalCenter

                            height: 23
                            width: 355
                            text: title
                            color: Styles.titleText// Qt.darker(Styles.titleText, mouser.containsMouseEx ? 1.5: 0)
                            elide: Text.ElideRight
                            font { family: 'Open Sans Light'; pixelSize: 20; bold: false }

                            Behavior on color {
                                ColorAnimation { duration: 200 }
                            }
                        }

//                        Image {
//                            id: iconLink
//                            anchors.verticalCenter: parent.verticalCenter

//                            x: newsHeader.paintedWidth + 5
//                            y: 2

//                            source: installPath + Styles.linkIconNews
//                        }

//                        CursorMouseArea {
//                            id: mouserHeader

//                            anchors.fill: parent
//                            toolTip: newsHeader.text
//                            hoverEnabled: newsHeader.truncated
//                            acceptedButtons: Qt.NoButton
//                        }
                    }
                }

                Text {
                    text: announcement
                    height: 86
                    width: parent.width - 35
                    wrapMode: Text.WordWrap
                    elide: Text.ElideRight
                    maximumLineCount: 4
                    clip: true
                    color: Styles.infoText //Qt.darker(Styles.infoText, mouser.containsMouseEx ? 1.5: 0)
                    font { family: 'Arial'; pixelSize: 13 }
                    lineHeight: 20
                    lineHeightMode: Text.FixedHeight
                    onLinkActivated: App.openExternalUrlWithAuth(link);

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }
            }
        }
    }
}
