import QtQuick 1.1

Item {
    property ListView internalView

    function scrollToStart() {
        internalView.scrollToStart()
    }

    function scrollToEnd() {
        internalView.scrollToEnd()
    }

    function decrementIndex() {
        internalView.decrementIndex()
    }

    function incrementIndex() {
        internalView.incrementIndex()
    }

    function incrementIndexPgDown() {
        internalView.incrementIndexPgDown()
    }

    function decrementIndexPgUp() {
        internalView.decrementIndexPgUp()
    }

    function selectCurrentUser() {
        if (internalView.currentItem) {
            internalView.currentItem.select();
        }
    }

    function isAnyItemHighlighted() {
        return internalView.currentIndex != -1;
    }

    function selectFirstUser() {
        if (internalView.count < 1 || internalView.currentIndex < 0) {
            return;
        }

        internalView.currentIndex = 0;
        internalView.currentItem.select();
    }
}
