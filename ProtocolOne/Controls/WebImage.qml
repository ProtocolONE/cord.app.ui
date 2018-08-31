import QtQuick 2.4

Image {
    id: image

    property bool isReady: status == Image.Ready
    property alias background: back.color

    Rectangle {
        id: back

        anchors.fill: parent
        color: "#000000"
        opacity: 1
        visible: opacity > 0

        AnimatedImage {
            id: backImage

            source: installPath + 'Assets/Images/ProtocolOne/Controls/WebImage/loading.gif'
            anchors.centerIn: parent
            cache: true
            opacity: 0
            asynchronous: true
            playing: parent.visible
        }
    }

    StateGroup {
        states: [
            State {
                name: 'Null'
                when: image.status === Image.Null || image.status === Image.Error
                PropertyChanges { target: back; opacity: 1}
            },
            State {
                name: 'Ready'
                when: image.status === Image.Ready
            },
            State {
                name: 'Loading'
                when: image.status !== Image.Ready
                PropertyChanges { target: back; opacity: 1}
            }
        ]
        /*
            //INFO Как оно бывает:
                - C пустоты на Loading - когда не было картинки и она стала
                - C пустоты на Ready - если картинка в кеше
                - С Ready на Loading - при смене сорса
                - С Loading на Ready - при загрущке картинки
        */
        transitions: [
            Transition {
                from: "*"
                to: "Loading"
                SequentialAnimation {
                    PauseAnimation { duration: 250 }
                    PropertyAnimation { target: backImage; property: 'opacity'; from: 0; to: 1; duration: 250}
                }
            },
            Transition {
                from: "*"
                to: "Ready"
                SequentialAnimation {
                    PropertyAnimation { target: back; property: 'opacity'; from: 1; to: 0; duration: 250}
                    PropertyAnimation { target: backImage; property: 'opacity'; from: 1; to: 0; duration: 250}
                }
            }
        ]
    }
}
