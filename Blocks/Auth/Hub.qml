/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1

Item {
    id: root

    signal guestLogin();
    signal genericAuth();
    signal vkAuth();
    signal register();

    implicitHeight: 414
    implicitWidth: 930

    QtObject {
        id: d

        property int widgetCount: 3
    }

    Row {
        width: parent.width
        height: parent.height

        SingleWidget {
            width: parent.width / d.widgetCount
            source: installPath + 'images/Auth/account.png'
            headText: qsTr("ACCOUNT_WIDGET_HEAD_LABEL")
            descText: qsTr("ACCOUNT_WIDGET_HEAD_DESC")
            buttonText: qsTr("AUTH_LOGIN_BUTTON")
            onClicked: root.genericAuth();
        }

        Rectangle {
            width: 1
            height: parent.height
            color: '#579f33'
        }

        SingleWidget {
            width: parent.width / d.widgetCount
            source: installPath + 'images/Auth/vk.png'
            headText: qsTr("AUTH_WIDGET_HEAD_LABEL")
            descText: qsTr("AUTH_WIDGET_HEAD_DESC")
            buttonText: qsTr("AUTH_LOGIN_BUTTON")
            onClicked: root.vkAuth();
        }

        Rectangle {
            width: 1
            height: parent.height
            color: '#579f33'
        }

        SingleWidget {
            width: parent.width / d.widgetCount
            source: installPath + 'images/Auth/new.png'
            headText: qsTr("NEW_WIDGET_HEAD_LABEL")
            descText: qsTr("NEW_WIDGET_HEAD_DESC")
            buttonText: qsTr("REGISTRATION_BUTTON")
            onClicked: root.register();
        }
    }
}
