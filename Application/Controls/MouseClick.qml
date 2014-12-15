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
import "MouseClick.js" as Js
import "../Core/App.js" as App

Item {
    Connections {
        target: App.signalBus()

        onLeftMousePress: {
            var obj = Js.widgets();

            Object.keys(obj).forEach(function(e){
                var item = obj[e].item,
                    callback = obj[e].callback,
                    posInWidget;

                if (!item || !item.visible) {
                    return;
                }

                posInWidget = item.mapToItem(mainWindowRectanglw, mainWindowRectanglw.x, mainWindowRectanglw.y);

                if (!(globalX >= posInWidget.x && globalX <= (posInWidget.x + item.width) &&
                      globalY >= posInWidget.y && globalY <= (posInWidget.y + item.height))) {
                    callback();
                }
            });
        }
    }
}

