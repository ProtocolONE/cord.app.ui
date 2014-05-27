/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1
import GameNet.Components.Widgets 1.0

WidgetModel {
    id: root

    property ListModel premiumModel: ListModel {
        ListElement{
            textLabel: QT_TR_NOOP("ONE_DAY_PREMIUM_TRADIO_TEXT")
            coin: 30
        }

        ListElement {
            textLabel: QT_TR_NOOP("WEEK_PREMIUM_TRADIO_TEXT")
            coin: 180
        }

        ListElement {
            textLabel: QT_TR_NOOP("MONTH_PREMIUM_TRADIO_TEXT")
            coin: 540
        }

        ListElement {
            textLabel: QT_TR_NOOP("3_MONTH_PREMIUM_TRADIO_TEXT")
            coin: 1080
        }
    }

    Component.onCompleted: {
        var fields = ['textLabel']
            , elem
            , i;

        for (i = 0; i < premiumModel.count; i++) {
            elem = premiumModel.get(i);
            fields.forEach(function(e) {
                if (elem[e]) {
                    premiumModel.setProperty(i, e, qsTr(elem[e]));

                }
            });
        }
    }
}
