import QtQuick 2.4
import ProtocolOne.Components.Widgets 1.0
import ProtocolOne.Controls 1.0

import Dev 1.0

import Application.Core 1.0

Rectangle {
    width: 800
    height: 800

    color: '#002336'

//    WidgetManager {
//        id: manager


//    }

    Component.onCompleted: {
        WidgetManager.registerWidget('Application.Widgets.Facts');
        WidgetManager.init();
    }

    RequestServices {
        onReady: {
            App.activateGame(App.serviceItemByGameId("760"));
        }
    }

    WidgetContainer {
        widget: 'Facts'
    }

    Row {
        x: 10
        y: 200
        spacing: 20

        Button {
            width: 200
            height: 30

            text: "TestBug"
            onClicked: {
                var a = '{
                            "4294967294": { "id": "4294967294" },
                            "4294967295": { "id": "4294967295" },
                            "4294967296": { "id": "4294967296" },
                            "4300000000": { "id": "4300000000" },
                            "4563402752": { "id": "4563402752" },
                            "68987912192": { "id": "68987912192" },
                            "20000000000": { "id": "20000000000" },
                            "30000000000": { "id": "30000000000" },
                            "240000000000": { "id": "240000000000" },
                            "370000000000": { "id": "370000000000" }
                         }';
                var s = JSON.parse(a);
                for (var k in s) {
                    console.log(typeof(k), typeof(s[k].id), k, s[k].id, k === s[k].id)
                    if (k != s[k].id) {
                        console.log("Bug ", k, s[k].id)
                    }
                }

                var g = {};
                var h = "240000000000";
                g[h] = h + "BUG";
                console.log(JSON.stringify(g, null, 2), h, g["3776798720"], g[h], g["240000000000"]
                            , "240000000000" == "3776798720"
                            , "240000000000" === "3776798720")


                console.log("240000000000" == "3776798720", "240000000000" === "3776798720", "240000000000" === "3776798721")
                console.log(JSON.stringify(s, null ,2));
            }
        }

        Button {
            width: 200
            height: 30

            text: "Activate 92 (CA)"
            onClicked: {
                App.activateGame(App.serviceItemByGameId("92"));
            }
        }

        Button {
            width: 200
            height: 30

            text: "Activate 71 (BS)"
            onClicked: {
                App.activateGame(App.serviceItemByGameId("71"));
            }
        }

        Button {
            width: 200
            height: 30

            text: "Activate 760 (REBORN)"
            onClicked: {
                App.activateGame(App.serviceItemByGameId("760"));
            }
        }
    }
}
