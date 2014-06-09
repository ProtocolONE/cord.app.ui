import QtQuick 1.1
import "Money.js" as MoneyJs

Item {
    id: rootTabRect

    property int tabIndex
    property string title
    property real progress
    property variant currentItem
    property int rootWidth
    property int pageCount

    signal removeTab(int index);
    signal indexChanged(int index);

    Item {
        width: parent.width + 10
        height: parent.height

        Image {
            id: leftImage

            anchors { left: parent.left; top: parent.top }
            source: (rootTabRect.currentItem == tabIndex) ?
                        installPath + 'Assets/Images/Application/Widgets/Money/activetab_left.png' :
                        (textMa.containsMouse || tabMa.containsMouse) ?
                            installPath + 'Assets/Images/Application/Widgets/Money/nonactivetab_hover_left.png' :
                            installPath + 'Assets/Images/Application/Widgets/Money/nonactivetab_left.png'
        }

        Rectangle {
            anchors {
                left: leftImage.right
                right: rightImage.left
                top: parent.top
                bottom: parent.bottom
            }

            color: (rootTabRect.currentItem == tabIndex) ? '#fafafa' :
                                                        (textMa.containsMouse || tabMa.containsMouse) ? '#f2f4f4' : '#e5e9ea'


            Rectangle {
                anchors { left: parent.left; top: parent.top; right: parent.right }
                height: 1
                color: '#ffffff'
            }
        }

        Image {
            id: rightImage

            anchors { right: parent.right; top: parent.top }
            source: (rootTabRect.currentItem == tabIndex) ?
                        installPath + 'Assets/Images/Application/Widgets/Money/activetab_right.png' :
                        (textMa.containsMouse || tabMa.containsMouse) ?
                            installPath + 'Assets/Images/Application/Widgets/Money/nonactivetab_hover_right.png' :
                            installPath + 'Assets/Images/Application/Widgets/Money/nonactivetab_right.png'
        }
    }

    AnimatedImage {
        anchors {
            left: parent.left
            top: parent.top
            leftMargin: 15
            topMargin: 6
        }

        visible: rootTabRect.width > 60 && (rootTabRect.progress) > 0.0 && (rootTabRect.progress < 1.0)

        source: (rootTabRect.currentItem == tabIndex) ? installPath + 'Assets/Images/Application/Widgets/Money/preloader_active_tab.GIF' :
                                                     installPath + 'Assets/Images/Application/Widgets/Money/preloader_back_tab.GIF'
    }

    Text {
        id: text

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            leftMargin: 40
            rightMargin: 20
            topMargin: 10
        }

        text: parent.title
        color: '#000000'
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        elide: Text.ElideRight
        font { family: "Arial"; pixelSize: 14; bold: true }
    }

    MouseArea {
        id: textMa

        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
        onClicked: {
            if (mouse.button == Qt.MiddleButton) {
                tabMa.removeTabItem(tabIndex);
                return;
            }

            if (mouse.button == Qt.LeftButton) {
                rootTabRect.indexChanged(tabIndex);
            }
        }
    }

    Item {
        width: 10
        height: 10
        anchors { right: parent.right; top: parent.top; topMargin: 11; rightMargin: 9 }

        Image {
            id: closeImage

            source: tabMa.containsMouse ? installPath + 'Assets/Images/Application/Widgets/Money/closetab_hover.png' :
                                          installPath + 'Assets/Images/Application/Widgets/Money/closetab.png'
            visible: rootTabRect.width > 60 || (rootTabRect.currentItem == tabIndex && rootTabRect.width > 30)
        }

        MouseArea {
            id: tabMa

            function removeTabItem(index) {
                if (rootTabRect.pageCount == 0) {
                    return;
                }

                rootTabRect.removeTab(index);

                if (index == rootRect.currentItem) {
                    for (var i = index; i >= 0; --i) {
                        if (MoneyJs.pages[i]) {
                            rootTabRect.indexChanged(i);
                            return;
                        }
                    }
                }

                MoneyJs.updatePagesWidth(rootTabRect.rootWidth);
            }

            anchors.fill: parent
            hoverEnabled: true
            visible: closeImage.visible
            onClicked: removeTabItem(tabIndex);
        }
    }
}
