import QtQuick 1.1
import Tulip 1.0
import Qt.labs.particles 1.0

Item {
    id: sun

    property bool isRain: false

    function startLightning() {
        lightningAnimation.start();
    }

    width: 112
    height: 112

    Item {
        width: 112
        height: 112

        NumberAnimation on rotation {
            to: 360
            duration: 9000
            loops: Animation.Infinite
        }

        Image {
            source: installPath + "Assets/Images/Auth/sun_02_yellow.png"
            anchors.centerIn: parent
        }

        Image {
            source: installPath + "Assets/Images/Auth/sun_02_white.png"
            anchors.centerIn: parent
            opacity: sun.isRain ? 1 : 0

            Behavior on opacity {
                NumberAnimation { duration: 400 }
            }
        }
    }

    Item {
        width: 112
        height: 112

        Image {
            source: installPath + "Assets/Images/Auth/rays_01.png"
            anchors.centerIn: parent
            opacity: sun.isRain ? 0 : 1

            Behavior on opacity {
                NumberAnimation { duration: 400 }
            }
        }

        NumberAnimation on rotation {
            to: -360
            duration: 9000
            loops: Animation.Infinite
        }
    }

    Image {
        id: lightningImage

        source: installPath + "Assets/Images/Auth/lightning_01.png"
        anchors {
            top: parent.top
            topMargin: 70
            right: parent.right
            rightMargin: 10
        }

        opacity: 0

        SequentialAnimation {
            id: lightningAnimation

            alwaysRunToEnd: true
            PropertyAnimation {
                alwaysRunToEnd: true
                target: lightningImage
                to: 1
                properties: "opacity"; easing.type: Easing.InBounce; duration: 10
            }

            PropertyAnimation {
                alwaysRunToEnd: true
                target: lightningImage
                to: installPath + "Assets/Images/Auth/lightning_03.png"
                properties: "source"; easing.type: Easing.InBounce; duration: 200
            }

            PropertyAnimation {
                alwaysRunToEnd: true
                target: lightningImage
                to: installPath + "Assets/Images/Auth/lightning_02.png"
                properties: "source"; easing.type: Easing.InBounce; duration: 100
            }
            PropertyAnimation {
                alwaysRunToEnd: true
                target: lightningImage
                to: installPath + "Assets/Images/Auth/lightning_01.png"
                properties: "source"; easing.type: Easing.InBounce; duration: 100
            }

            PropertyAnimation {
                alwaysRunToEnd: true
                target: lightningImage
                to: 0
                properties: "opacity"; easing.type: Easing.InBounce; duration: 10
            }
        }
    }

    Image {
        id: cloud1

        source: installPath + "Assets/Images/Auth/cloud_01.png"
        anchors {
            top: parent.top
            topMargin: 25
            right: parent.right
            rightMargin: 220
        }

        opacity: 0
    }

    Image {
        id: cloud2

        source: installPath + "Assets/Images/Auth/cloud_02.png"
        anchors {
            top: parent.top
            topMargin: 55
            right: parent.right
            rightMargin: -200
        }

        opacity: 0
    }

    Image {
        id: cloud3

        source: installPath + "Assets/Images/Auth/cloud_03.png"
        anchors {
            top: parent.top
            topMargin: 10
            right: parent.right
            rightMargin: -15
        }

        opacity: 0
    }


    Particles {
        id: rain

        opacity: 0
        anchors {
            top: parent.top
            topMargin: 105
            right: parent.right
            rightMargin: -20
        }

        width: 180
        height: 1
        source: installPath + "Assets/Images/Auth/rain_01.png"
        lifeSpan: 1000
        count: -1
        angle: 90
        emissionRate: opacity > 0 ? 25 : 0
        emissionVariance: 5

        velocity: 250
        fadeInDuration: 200
        fadeOutDuration: 300
    }

    state: ""
    states: [
        State {
            name: ""

            PropertyChanges {
                target: cloud1
                opacity: 0
                anchors.rightMargin: 220
            }

            PropertyChanges {
                target: cloud2
                opacity: 0
                anchors.rightMargin: -200
            }

            PropertyChanges {
                target: cloud3
                opacity: 0
            }

            PropertyChanges {
                target: rain
                opacity: 0
            }

        },
        State {
            name: "rain"
            when: sun.isRain

            PropertyChanges {
                target: cloud1
                opacity: 1
                anchors.rightMargin: 20
            }

            PropertyChanges {
                target: cloud2
                opacity: 1
                anchors.rightMargin: -30
            }

            PropertyChanges {
                target: cloud3
                opacity: 1
            }

            PropertyChanges {
                target: rain
                opacity: 1
            }
        }
    ]

    transitions: [
        Transition {
            from: ""
            to: "rain"

            ParallelAnimation {
                PropertyAnimation {
                    properties: "opacity"; easing.type: Easing.InQuad; duration: 300
                }

                PropertyAnimation {
                    target: cloud1
                    easing.period: 0.46
                    easing.amplitude: 0.2
                    properties: "anchors.rightMargin"; easing.type: Easing.OutElastic; duration: 2500
                }

                PropertyAnimation {
                    target: cloud2
                    easing.period: 0.65
                    easing.amplitude: 0.1
                    properties: "anchors.rightMargin"; easing.type: Easing.OutElastic; duration: 2000
                }

                SequentialAnimation {
                    PauseAnimation { duration: 1500 }
                    PropertyAnimation {
                        target: cloud3

                        properties: "opacity"; easing.type: Easing.InQuad; duration: 500
                    }
                }
            }
        },

        Transition {
            from: "rain"
            to: ""

            ParallelAnimation {
                PropertyAnimation {
                    properties: "opacity"; easing.type: Easing.Linear; duration: 400
                }

                PropertyAnimation {
                    properties: "anchors.rightMargin"; easing.type: Easing.Linear; duration: 400
                }
            }
        }
    ]
}

