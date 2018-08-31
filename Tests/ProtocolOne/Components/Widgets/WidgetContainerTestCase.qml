import QtQuick 2.4
import ProtocolOne.Components.Widgets 1.0

Row {
   WidgetContainer {
       width: 100
       height: 100
       widget: 'SimpleWidget'
   }

   WidgetContainer {
       width: 100
       height: 100

       property variant widgetList: [
           'SimpleWidget', 'DualViewWidget', 'SingletonModelWidget', 'SeparateModelWidget'
       ]

       property int index: -1

       Timer {
           interval: 1000
           running: true
           repeat: true
           onTriggered: {
               parent.index = (parent.index + 1) % parent.widgetList.length;
               parent.widget = parent.widgetList[parent.index]
           }
       }
   }

   WidgetContainer {
       width: 100
       height: 100
       widget: 'DualViewWidget'

       Timer {
           interval: 1000
           running: true
           repeat: true
           onTriggered: {
               parent.view = (parent.view === "ViewOne")
                   ? "ViewTwo"
                   : "ViewOne"
           }
       }
   }

   Column {
        WidgetContainer {
            width: 100
            height: 100

            widget: 'SingletonModelWidget'
            view: "ViewOne"
        }

        WidgetContainer {
            width: 100
            height: 100

            widget: 'SingletonModelWidget'
            view: "ViewTwo"
        }
    }

   Column {
        WidgetContainer {
            width: 100
            height: 100

            widget: 'SeparateModelWidget'
            view: "ViewOne"
        }

        WidgetContainer {
            width: 100
            height: 100

            widget: 'SeparateModelWidget'
            view: "ViewTwo"
        }
    }

    ListView {
       orientation: ListView.Vertical

       width: 100
       height: 200

       model: ListModel {
            ListElement {
                widget: 'SingletonModelWidget'
            }
            ListElement {
                widget: 'SimpleWidget'
            }
        }

        delegate: WidgetContainer {
            width: 100
            height: 100
            widget: model.widget
        }
    }
}

