import QtQuick 1.1

Item {
    id: item

    property ListModel model
    property Component delegate
    property int count: 0
    property int spacing: 15

    Row {
        spacing: item.spacing

        Column {
            id: bigItem
        }

        Column {
            spacing: item.spacing

            Row {
                id: topRow
                spacing: item.spacing
            }

            Row {
                id: bottomRow
                spacing: item.spacing
            }
        }
    }

    function getAnimationPause(index) {
        var delay  = {
            0 : 0,
            1 : 50,
            2 : 150,
            3 : 100,
            4 : 175,
            5 : 200,
        }

        return delay[index] ? delay[index] : 0;
    }

    // В функции по текущей модели создаются элементы и заполняется контейнер.
    // Удаления элементов пока не предусмотренно, так как по факту коллекция в runtime
    // не меняется. При необходимости можно будет дописать.
    function fill() {
        if (!model || !delegate) {
            console.log("FlowView error: model or delegate is empty")
            return;
        }

        if (model.count < 1) {
            return;
        }

        var listItem, index;
        listItem = delegate.createObject(bigItem, {model: model.get(0)})
        listItem.animationPause = 0;

        for (index = 1; index < 3; ++index) {
            listItem = delegate.createObject(topRow, {model: model.get(index)});
            listItem.animationPause = getAnimationPause(index);
        }

        for (index = 3; index < model.count; ++index) {
            listItem = delegate.createObject(bottomRow, {model: model.get(index)});
            listItem.animationPause = getAnimationPause(index);
        }

        count = model.count;
    }

    Component.onCompleted: {
        fill();
    }
}
