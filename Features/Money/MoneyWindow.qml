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
import QtWebKit 1.0
import Tulip 1.0
import "." as Money
import "../../js/UserInfo.js" as UserInfo

Window {
    id: window

    signal closeRequest();

    x: (Desktop.primaryScreenAvailableGeometry.width  - width) / 2 + 50
    y: (Desktop.primaryScreenAvailableGeometry.height - height) / 2 - 50

    deleteOnClose: true

    width: 1002
    height: 697

    visible: true
    topMost: true

    title: qsTr("MONEY_TULIP")
    flags: Qt.FramelessWindowHint

    onCloseRequest: window.close();

    Component.onCompleted: browserRoot.show();

    Money.Money {
        id: browserRoot

        property int saveX
        property int saveY

        function getMoneyUrl() {
            return UserInfo.getUrlWithCookieAuth("http://www.gamenet.ru/money");
        }

        function urlEncondingHack(url) {
            return "<html><head><script type='text/javascript'>window.location='" + url + "';</script></head><body></body></html>";
        }

        function show() {
            browserRoot.addPage(urlEncondingHack(getMoneyUrl()));
        }

        width: parent.width
        height: parent.height

        onClose: window.closeRequest();

        onPositionPressed: {
            browserRoot.saveX = x;
            browserRoot.saveY = y;
        }

        onPositionChanged: {
            window.x = window.x + (x - browserRoot.saveX);
            window.y = window.y + (y - browserRoot.saveY);
        }
    }
}
