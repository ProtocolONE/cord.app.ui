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

/**
 * WidgetManagerPrivate
 *
 * Used to solve QML -> JS bugs with dynamic object creation in JS. Also used as local, feature based signal bus
 * object.
 */
Item {
    id: root

    signal widgetsReady()

    function emitReady() {
        widgetsReady()
    }

    function createObject(namespace, object, parentObj) {
        var qml = createHeader(namespace);
        qml += object + '{}';

        return Qt.createQmlObject(qml, parentObj || root, namespace + '.' + object);
    }

    function createHeader(namespace) {
        var qml = 'import QtQuick 1.1;';
        qml += 'import ' + namespace + ' 1.0;';

        return qml;
    }

    function createViewObject(namespace, object, modelReference, parentObj) {
        var qml = createHeader(namespace);
        qml += object + '{'
        qml += '__modelReference: "' + modelReference + '";'
        qml += '}';

        return Qt.createQmlObject(qml, parentObj || root, namespace + '.' + object);
    }
}
