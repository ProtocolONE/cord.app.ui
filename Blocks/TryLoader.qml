/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
**
** @author: Ilya Tkachenko <ilya.tkachenko@syncopate.ru>
** @since: 2.0
****************************************************************************/

import QtQuick 1.1

Loader {
    signal failed();
    signal successed();

    property bool _isFailSended : false
    property bool _isSuccessSended : false

    function reemit() {
        if (status == Loader.Ready && !_isSuccessSended) {
            _isSuccessSended = true;
            successed();
        }

        if (status == Loader.Error  && !_isFailSended) {
            _isFailSended = true;
            failTimer.start()
        }
    }

    Component.onCompleted: reemit();
    onStatusChanged: reemit();

    Timer {
        id: failTimer
        running: false
        interval: 1
        onTriggered: failed();
    }
}
