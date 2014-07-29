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
import "WidgetManager.js" as WidgetManager

FocusScope {
    id: root

    signal close();

    property string __modelReference
    property variant model: WidgetManager._internal.getModelByReference(__modelReference)

    function clear() {
        var shouldDeleteModel = root.model
                && __modelReference !== ''
                && (root.__modelReference.indexOf('id_persist') === -1);

        if (shouldDeleteModel) {
            root.model.destroy();
        }
    }
}
