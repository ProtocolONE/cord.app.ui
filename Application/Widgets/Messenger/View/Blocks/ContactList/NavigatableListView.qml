import QtQuick 1.1

ListView {
    id: listView

    function scrollToStart() {
        listView.currentIndex = 0;
    }

    function scrollToEnd() {
        listView.currentIndex = listView.count - 1;
    }

    function decrementIndex() {
        if (listView.currentIndex <= 0) {
            return;
        }

        listView.currentIndex--;
    }

    function incrementIndex() {
        if (listView.currentIndex >= listView.count - 1) {
            return;
        }

        listView.currentIndex++;
    }

    function incrementIndexPgDown() {
        if (listView.currentIndex >= listView.count - 1) {
            return;
        }

        var newIndex = listView.currentIndex + 6;
        if (newIndex > listView.count - 1) {
            newIndex = listView.count - 1;
        }

        listView.currentIndex = newIndex;
    }

    function decrementIndexPgUp() {
        if (listView.currentIndex <= 0) {
            return;
        }

        var newIndex = listView.currentIndex - 6;
        if (newIndex < 0) {
            newIndex = 0;
        }

        listView.currentIndex = newIndex;
    }
}
