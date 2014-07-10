import QtQuick 1.1
import "./PageSwitcher.js" as PageSwitcherJs

Item {
    id: root

    property string source: ""
    property Component sourceComponent

    signal switchFinished()

    onSourceChanged: {
        d.switchToPage(source);
    }

    onSourceComponentChanged: {
        d.switchToComponent(sourceComponent)
    }

    QtObject {
        id: d

        property int currentLayer: -1
        property bool page: false
        property bool reset: false
        property bool isInProgress: false

        function switchToPage(page) {
            if (d.reset) {
                return;
            }

            if (d.isInProgress) {
                PageSwitcherJs.pushPage(page);
                return;
            }

            d.isInProgress = true;
            d.page = true;
            if (d.currentLayer == 2) {
                d.currentLayer = 1;
                first.source = page;
                switcher.switchTo(first);
            } else {
                d.currentLayer = 2;
                second.source = page;
                switcher.switchTo(second);
            }
        }

        function switchToComponent(component) {
            if (d.reset) {
                return;
            }

            if (d.isInProgress) {
                PageSwitcherJs.pushComponent(component);
                return;
            }

            d.isInProgress = true;
            d.page = false;
            if (d.currentLayer == 2) {
                d.currentLayer = 1;
                first.sourceComponent = component;
                switcher.switchTo(first);
            } else {
                d.currentLayer = 2;
                second.sourceComponent = component;
                switcher.switchTo(second);
            }
        }

        function switchFinished() {
            root.switchFinished();
            if (d.currentLayer == 2) {
                first.source = "";
                first.sourceComponent = null;
            } else {
                second.source = "";
                second.sourceComponent = null;
            }

            d.reset = true;
            if (d.page) {
                root.source = "";
            } else {
                root.sourceComponent = null;
            }
            d.reset = false;

            d.isInProgress = false;

            var next = PageSwitcherJs.get();
            if (!next) {
                return;
            }

            if (next.isPage()) {
                d.switchToPage(next.value);
            } else {
                d.switchToComponent(next.value);
            }
        }
    }

    Switcher {
        id: switcher

        anchors.fill: parent
        onSwitchFinished: d.switchFinished();

        Loader {
            id: first

            anchors.fill: parent
        }

        Loader {
            id: second

            anchors.fill: parent
        }
    }

}
