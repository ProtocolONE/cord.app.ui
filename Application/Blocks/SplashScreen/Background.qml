import QtQuick 2.4
import Tulip 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import Application.Core 1.0

Item {
    id: root

    width: 1000
    height: 600

    property bool showBack: false
    property string infoText: ""

    signal animationFinished();

    function start() {
        startAnimation.start();
    }

    property string defaultPath: installPath + "/Assets/Images/Application/Blocks/SplashScreen/"

    Rectangle {
        anchors.fill: parent
        color: '#021F2D'
    }

    SequentialAnimation {
        id: startAnimation

        alwaysRunToEnd: true
        onStopped: animationFinished();

        PropertyAnimation {
            target: parallax;
            property: "opacity";
            from: 0;
            to: 1;
            duration: App.isQmlViewer() ? 10 : 1000
        }

        PropertyAnimation {
            target: logo
            property: "opacity"
            easing.type: Easing.InCubic
            from: 0;
            to: 1;
            duration: App.isQmlViewer() ? 10 : 2000
        }

        PauseAnimation { duration: App.isQmlViewer() ? 10 : 2000 }
    }

    ParallaxView {
        id: parallax

        property int frame: 0

        visible: root.showBack
        anchors.fill: parent
        onBeforeUpdate: {
            var mouse = MouseCursor.mousePos();
            var window =  MouseCursor.debugOnlyWindowPos();

            parallax.mouseX = mouse.x - window.x;
            parallax.mouseY = mouse.y - window.y;

            parallax.updateAnimation();
        }

        function updateAnimation() {
            var freq = ++frame / refreshTimeout
                , pi2 = 2 * Math.PI;

            backOverlay.opacity = Math.sin(Math.PI * ((freq / 5) % 1));

            backOverlay.anchors.horizontalCenterOffset = 75 * Math.sin(pi2 * ((freq / 15) % 1));
            backOverlay.anchors.verticalCenterOffset  = 75 * Math.cos(pi2 * ((freq / 15) % 1));

            back.anchors.horizontalCenterOffset = backOverlay.anchors.horizontalCenterOffset;
            back.anchors.verticalCenterOffset = backOverlay.anchors.verticalCenterOffset;

            layer1.anchors.horizontalCenterOffset = - 50 * Math.sin(pi2 * ((freq / 15) % 1));
            layer1.anchors.verticalCenterOffset = - 50 * Math.cos(pi2 * ((freq / 15) % 1));

            layer2.anchors.horizontalCenterOffset = 50 * Math.sin(pi2 * ((freq / 25) % 1));
            layer2.anchors.verticalCenterOffset = - 50 * Math.cos(pi2 * ((freq / 25) % 1));

            layer3.anchors.horizontalCenterOffset = - 50 * Math.sin(pi2 * ((freq / 30) % 1));
            layer3.anchors.verticalCenterOffset = 50 * Math.cos(pi2 * ((freq / 30) % 1));
        }

        ParallaxLayer {
            depthX: 0.03
            depthY: 0.03

            Image {
                id: back

                cache: false
                anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter }
                source: defaultPath + "01_base.jpg"
            }

            Image {
                id: backOverlay

                opacity: 0
                cache: false
                asynchronous: true
                anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter }
                source: defaultPath + "02_base.jpg"
            }
        }

        ParallaxLayer {
            depthX: 0.10
            depthY: 0.10

            Image {
               id: layer1

               asynchronous: true
               cache: false
               anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter }
               source: defaultPath + "01_particles.png"
            }
        }

        ParallaxLayer {
            depthX: 0.10
            depthY: 0.10

            Image {
               asynchronous: true
               cache: false
               anchors { left: parent.left; top: parent.top; leftMargin: 170; topMargin: 120 }
               source: defaultPath + "line2_1.png"
            }
        }

        ParallaxLayer {
            depthX: 0.11
            depthY: 0.11

            Image {
               asynchronous: true
               cache: false
               anchors { left: parent.left; top: parent.top; leftMargin: 570; topMargin: 180 }
               source: defaultPath + "line2_2.png"
            }
        }

        ParallaxLayer {
            depthX: 0.12
            depthY: 0.12

            Image {
               asynchronous: true
               cache: false
               anchors { left: parent.left; top: parent.top; leftMargin: 500; topMargin: 420 }
               source: defaultPath + "line2_3.png"
            }
        }

        ParallaxLayer {
            depthX: 0.14
            depthY: 0.14

            Image {
               asynchronous: true
               cache: false
               anchors { left: parent.left; top: parent.top; leftMargin: 100; topMargin: 320 }
               source: defaultPath + "line2_4.png"
            }
        }

        ParallaxLayer {
            depthX: 0.17
            depthY: 0.17

            Image {
                id: layer2

                asynchronous: true
                cache: false
                anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter }
                source: defaultPath + "02_particles.png"
            }
        }

        ParallaxLayer {
            depthX: 0.18
            depthY: 0.18

            Image {
               asynchronous: true
               cache: false
               anchors { left: parent.left; top: parent.top; leftMargin: 50; topMargin: 120 }
               source: defaultPath + "line3_1.png"
            }
        }

        ParallaxLayer {
            depthX: 0.21
            depthY: 0.21

            Image {
               asynchronous: true
               cache: false
               anchors { left: parent.left; top: parent.top; leftMargin: 400; topMargin: 25 }
               source: defaultPath + "line3_2.png"
            }
        }

        ParallaxLayer {
            depthX: 0.22
            depthY: 0.22

            Image {
               asynchronous: true
               cache: false
               anchors { left: parent.left; top: parent.top; leftMargin: 900; topMargin: 500 }
               source: defaultPath + "line3_3.png"
            }
        }

        ParallaxLayer {
            depthX: 0.22
            depthY: 0.22

            Image {
               asynchronous: true
               cache: false
               anchors { left: parent.left; top: parent.top; leftMargin: 325; topMargin: 500 }
               source: defaultPath + "line3_4.png"
            }
        }

        ParallaxLayer {
            depthX: 0.24
            depthY: 0.24

            Image {
               asynchronous: true
               cache: false
               anchors { left: parent.left; top: parent.top; leftMargin: 850; topMargin: 100 }
               source: defaultPath + "line3_5.png"
            }
        }

        ParallaxLayer {
            depthX: 0.25
            depthY: 0.25

            Image {
               asynchronous: true
               cache: false
               anchors { left: parent.left; top: parent.top; leftMargin: 25; topMargin: 375 }
               source: defaultPath + "line3_6.png"
            }
        }

        ParallaxLayer {
            depthX: 0.23
            depthY: 0.23

            Image {
                id: layer3

                asynchronous: true
                cache: false
                anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter }
                source: defaultPath + "03_particles.png"
            }
        }

        ParallaxLayer {
            depthX: 0.30
            depthY: 0.30

            Image {
                asynchronous: true
                cache: false
                anchors.centerIn: parent
                source: defaultPath + "04_particles.png"
            }
        }

        ParallaxLayer {
            depthX: 0.32
            depthY: 0.32

            Image {
               asynchronous: true
               cache: false
               anchors { left: parent.left; top: parent.top; leftMargin: 75; topMargin: 450 }
               source: defaultPath + "line4_1.png"
            }
        }

        ParallaxLayer {
            depthX: 0.34;
            depthY: 0.34

            Image {
               asynchronous: true
               cache: false
               anchors { left: parent.left; top: parent.top; leftMargin: 775; topMargin: 150 }
               source: defaultPath + "line4_2.png"
            }
        }

        ParallaxLayer {
            depthX: 0.36
            depthY: 0.36

            Image {
               asynchronous: true
               cache: false
               anchors { left: parent.left; top: parent.top; leftMargin: 175; topMargin: 10 }
               source: defaultPath + "line4_3.png"
            }
        }

        ParallaxLayer {
            depthX: 0.40
            depthY: 0.40

            Image {
                asynchronous: true
                cache: false
                anchors.centerIn: parent
                source: defaultPath + "05_particles.png"
            }
        }
    }

    Column {
        anchors.centerIn: parent

        Image {
            id: logo

            opacity: 0
            asynchronous: true
            cache: false
            source: defaultPath + "01_logo.png"
        }

        Text {
            visible: text !== ""
            text: root.infoText
            color: "#FFFFFF"
            anchors.horizontalCenter: parent.horizontalCenter
            textFormat: Text.StyledText
            linkColor: "#177FDC"
            onLinkActivated: App.openExternalUrl(url);
            font { family: "Segoe UI Light"; pixelSize: 18; }
        }
    }
}
