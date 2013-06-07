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

    property int widgetCount: guestWidget.visible ? 4 : 3
    property bool guestEnable
    property int autoGuestLoginTimout

    property alias guestDescText: guestWidget.descText

    signal guestLogin
    signal genericAuth
    signal vkAuth
    signal register

    Row {
        width: parent.width
        height: parent.height

        SingleWidget {
            id: guestWidget

            width: parent.width / widgetCount
            source: autoGuestLoginTimout > 0 && autoGuestLoginTimout < 10 ?
                                               installPath + 'images/Auth/stopwatch-a.png' :
                                               installPath + 'images/Auth/stopwatch.png'

            headText: qsTr("GUEST_WIDGET_HEAD_LABEL")
            buttonText: qsTr("PLAY_NOW_BUTTON")
            countDown: autoGuestLoginTimout
            visible: guestEnable
            onClicked: root.guestLogin();
        }

        Rectangle {
            width: 1
            height: parent.height
            color: '#579f33'
            visible: guestWidget.visible
        }

        SingleWidget {
            id: accountWidget

            width: parent.width / widgetCount
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
            id: vkWidget

            width: parent.width / widgetCount
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
            id: newWidget

            width: parent.width / widgetCount
            source: installPath + 'images/Auth/new.png'
            headText: qsTr("NEW_WIDGET_HEAD_LABEL")
            descText: qsTr("NEW_WIDGET_HEAD_DESC")
            buttonText: qsTr("REGISTRATION_BUTTON")
            onClicked: root.register();
        }
    }
}
