import QtQuick 2.4
import "WidgetManager.js" as WidgetManager

FocusScope {
    id: root

    signal close();

    property string __modelReference
    property variant model

    Component.onDestruction: {
        var shouldDeleteModel = root.model
                && __modelReference !== ''
                && (root.__modelReference.indexOf('id_persist') === -1);

        if (shouldDeleteModel) {
            root.model.destroy();
        }
    }

}
