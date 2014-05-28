import QtQuick 1.1
import Tulip 1.0
import GameNet.Controls 1.0

import "../../../../Proxy/App.js" as AppJs

Item {
    id: root

    property alias isDoggyVisible: vkDoggy.isDoggyVisible

    property bool goodSignActive: false;

    QtObject {
        id: d

        property bool isRain: false
        property bool isLightning: false

        function mousePosition() {
            var mouse = MouseCursor.mousePos();

            var window = AppJs.windowPosition();
            if (!window) {
                window = MouseCursor.debugOnlyWindowPos();
                window.y = window.y + 20;
            }

            return {
                x: mouse.x - window.x,
                y: mouse.y - window.y
            };
        }

        function isNearPoint(mouse, x, y, width, height) {
            if (Math.abs(mouse.x - x) >= width ||
                Math.abs(mouse.y - y) >= height) {

                return false;
            }

            return true;
        }

        function rainCheck(mouse) {
            d.isRain = d.isNearPoint(mouse, root.width, 0, 100, 100);
        }

        function lightningCheck(mouse) {
            var value = d.isNearPoint(mouse, root.width, 0, 50, 50);
            if (!d.isLightning && value) {
                lightningBackground.start();
                sun.startLightning();
            }

            d.isLightning = value;
        }

        function logicTick() {
            var mouse = d.mousePosition();

            d.rainCheck(mouse);
            d.lightningCheck(mouse);
        }
    }

    LightningBackground {
        id: lightningBackground

        anchors.fill: parent
    }

    ParallaxView {
        id: parallax

        anchors.fill: parent

        Timer {
            interval: 33
            running: true
            repeat: true
            onTriggered: {
                var mouse = MouseCursor.mousePos();

                var window = AppJs.windowPosition();
                if (!window) {
                    window = MouseCursor.debugOnlyWindowPos();
                }

                parallax.mouseX = mouse.x - window.x;
                parallax.mouseY = mouse.y - window.y;
            }
        }

        ParallaxBottomImage {
            depthX: 0.15
            depthY: 0.01
            source: installPath + "images/Auth/back_frame_01.png"
        }

        ParallaxBottomImage {
            depthX: 0.3
            depthY: 0.03
            source: installPath + "images/Auth/back_frame_02.png"
        }

        /*
        ParallaxLayer {
            depthX: 0.05
            depthY: 0.01

            Sun {
                id: sun

                isRain: d.isRain
                anchors {
                    top: parent.top
                    topMargin: 50
                    right: parent.right
                    rightMargin: 50
                }
            }
        }
        */

        ParallaxBottomImage {
            depthX: 0.4
            depthY: 0.06
            source: installPath + "images/Auth/back_frame_03.png"
        }

        ParallaxLayer {
            depthX: 0.02
            depthY: 0.01

            VkDoggy {
                id: vkDoggy

                anchors {
                    bottom:  parent.bottom
                    bottomMargin: vkDoggy.isDoggyVisible ? -100 : -250
                    left: parent.left
                    leftMargin: 20
                }
            }
        }
    }

    Image {
        source: installPath + "images/Auth/like_01.png"

        rotation: root.goodSignActive ? 90 : 0
        transformOrigin: Item.Bottom
        anchors.right: parent.left

        Behavior on rotation {
            NumberAnimation {
                duration: 1000
                easing.type: Easing.OutElastic
            }
        }
    }


    Timer {
        id: drawTimer

        interval: 33
        running: true
        repeat: true
        onTriggered: d.logicTick();
    }
}
