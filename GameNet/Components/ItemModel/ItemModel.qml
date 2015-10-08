import QtQuick 2.4

import GameNet.Components.JobWorker 1.0

import "./ItemModel.js" as Js

Item {
    id: root

    property int count: 0
    property Component prototype
    property string indexProperty

    property variant syncdate
    property variant notifableProperty: [] // string or array of strings

    signal sourceChanged();
    signal propertyChanged(string id, string key, variant oldValue, variant newValue);

    Component.onDestruction: {
        d.clearModel()
    }

    onSyncdateChanged: root.sourceChanged();
    onNotifablePropertyChanged: d.updateNotifableProperty();
    Component.onCompleted: d.updateNotifableProperty();

    function append(value) {
        var item, id;
        if (!value.hasOwnProperty(root.indexProperty)) {
            throw new Error('Value has not index property');
        }

        id = value[root.indexProperty];
        if (!root.contains(id)) {
            item = root.prototype.createObject(null, value);
            Js.model[id] = item;
            Js.count++;
            d.invalidate();
            return;
        }

        item = root.get(id);
        for(var key in value) {
            if (!value.hasOwnProperty(key) || !item.hasOwnProperty(key)) {
                continue;
            }

            item[key] = value[key];
        }
    }

    function clear() {
        worker.clear();
        Js.model = {};
        Js.count = 0;
        Js.invalidated = false;
        d.invalidate();
    }

    function get(id) {
        if (!root.contains(id)) {
            return null;
        }

        return Js.model[id];
    }

    function getById(id) { // UNDONE оставился для совместимости
        return get(id);
    }

    function contains(value) {
        var refresh = root.syncdate;
        return Js.model.hasOwnProperty(value);
    }

    function remove(id) {
        if (!Js.model.hasOwnProperty(id)) {
            return;
        }

        var item = Js.model[id];
        delete Js.model[id];
        item.destroy();
        Js.count--;
        d.invalidate();
    }

    // Info не биндейбл значение числа элементов.
    function rawCount() {
        return Js.count;
    }

    function setProperty(id, key, value) {
        if (!Js.model.hasOwnProperty(id)) {
            return;
        }

        worker.push(new Js.SetPropertyJob(id, key, value, root));;
    }

    function setPropertyById(id, key, value) { // UNDONE оставился для совместимости
        root.setProperty(id, key, value);
    }

    function forEachId(callback) {
       Object.keys(Js.model).forEach(callback);
    }

    function forEach(callback) {
        var index = 0;
        for (var key in Js.model) {
            callback(Js.model[key], key);
            index++;
        }
    }

    function keys() {
        return Object.keys(Js.model);
    }

    function beginBatch() {
        d.canSendSourceChanged  = false;
    }

    function endBatch() {
        d.canSendSourceChanged  = true;
        d.invalidate();
    }

    QtObject {
        id: d

        property bool canSendSourceChanged: true

        function clearModel() {
            for (var key in Js.model) {
                if (!Js.model.hasOwnProperty(key)) {
                    return;
                }

                Js.model[key].destroy();
            }

            Js.model = {};
            Js.count = 0;
            root.count = 0;
        }

        function invalidate() {
            if (Js.invalidated || !d.canSendSourceChanged) {
                return;
            }

            Js.invalidated = true;
            worker.push(new Js.Invalidate(root));
        }

        function updateNotifableProperty() {
            console.log(typeof root.notifableProperty)
            Js.notifableProperty = {};
            if (!root.notifableProperty) {
                return;
            }

            if (typeof root.notifableProperty == "string") {
                Js.notifableProperty[root.notifableProperty] = 1;
                return;
            }

            for (var index in root.notifableProperty) {
                Js.notifableProperty[root.notifableProperty[index]] = 1;
            }
        }
    }

    JobWorker {
        id: worker

        interval: 10
        managed: true
    }
}
