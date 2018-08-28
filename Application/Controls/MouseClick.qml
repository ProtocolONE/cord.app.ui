import QtQuick 2.4
import "MouseClick.js" as Js
import Application.Core 1.0

Item {
    Connections {
        target: SignalBus

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

