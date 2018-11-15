import QtQuick 2.4
import ProtocolOne.Controls 1.0
import Application.Controls 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0

Item {
    id: root

    property variant socialButtons: []

    property alias title: primaryTextButton.title
    property alias text: primaryTextButton.text

    signal openOAuth(string network, string url);
    signal clicked();

    implicitHeight: 100
    implicitWidth: 500

    function clearSocialRow() {
        var i;
        for (i = socialRow.children.length - 1; i >=0; --i) {
            socialRow.children[i].destroy();
        }
    }

    onSocialButtonsChanged: {
        clearSocialRow();
        var i = 0;
        for (; i < socialButtons.length; ++i) {
            socialButton.createObject(socialRow, {
                                          network: socialButtons[i].name,
                                          url: socialButtons[i].url,
                                      })
        }
    }

    ContentStroke {
        width: parent.width
        opacity: 0.25
    }

    Text {
        y: 6
        text: qsTr("Войти с помощью")
        color: Styles.lightText
        font { pixelSize: 14 }
    }

    Component {
        id: socialButton

        Button {
            property string network
            property string url

            width: height
            height: 40
            anchors.verticalCenter: parent.verticalCenter

            style {
                normal: "#00000000"
                hover: "#00000000"
            }

            onClicked: root.openOAuth(network, url);
            toolTip: (qsTr('Login with %1')).arg(network)

            Image {
                anchors.centerIn: parent
                source: installPath +'Assets/Images/Application/Blocks/Auth/oauth/' + network + '.png'
            }
        }
    }

    Row {
        id: socialRow

        spacing: 10
        anchors { left: parent.left; top: parent.top; topMargin: 22+10 }
    }

    Item {
        anchors {
            top: parent.top;
            right: parent.right;
            topMargin: 22
        }
        height: 48

        Column {
            anchors {
                verticalCenter: parent.verticalCenter;
                right: parent.right
            }
            height: childrenRect.height

            FooterButton {
                id: primaryTextButton

                anchors.right: parent.right
                onClicked: root.clicked();
            }
        }
    }
}
