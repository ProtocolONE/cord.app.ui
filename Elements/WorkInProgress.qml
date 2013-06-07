import QtQuick 1.1
import "../js/Core.js" as Core

Item {
    id: main

    z: 1000
    width: Core.clientWidth
    height: Core.clientHeight
    state: 'closed'
    visible: back.opacity !== 0

    //Интервал, спустя который форма должна отобразиться. Т.к. типичное
    //использование этого окна - это отображение его при выполнении
    //запросов, использование интервала позволит убрать "моргание" этим
    //окном, если запрос выполнится достаточно быстро.
    property int interval: 500

    property bool active: false

    //INFO Прямой биндинг лажает. Связка на state на 11 строке не
    //срабатывает при изминении active из экземпляра контрола.
    onActiveChanged: {
        if (!active) {
            main.state = 'closed';
        } else {
            main.state = 'waiting';
        }
    }

    //Нельзя биндить running от значения текущего state - будет warning на
    //циклический биндинг.
    Timer {
        id: delayTimer
        interval: main.interval
        repeat: false
        onTriggered: state = "opened";
    }

    states: [
        State {
            name: "waiting"
            PropertyChanges { target: delayTimer; running: true }
            PropertyChanges { target: back; opacity: 0 }
        },
        State {
            name: "opened"
            PropertyChanges { target: delayTimer; running: false }
            PropertyChanges { target: back; opacity: 0.75 }
            //Фокус нужно перехватить чтобы выключить поля ввода на форме
            //под эти окном. Если такой эффект не нужен - объекты должны
            //быть в FocusScope / FocusPanel
            PropertyChanges { target: back; focus: true }
        },
        State {
            name: "closed"
            PropertyChanges { target: delayTimer; running: false }
            PropertyChanges { target: back; opacity: 0}
            PropertyChanges { target: back; focus: false }
        }
    ]

    transitions: [
        Transition {
            from: "waiting"; to: "opened"
            PropertyAnimation { target: back; duration: 300; }
        },

        Transition {
            from: "opened"; to: "closed"
            PropertyAnimation { target: back; duration: 300; }
        }
    ]

    Rectangle {
        id: back
        anchors.fill: parent
        color: "#000000"

        MouseArea { anchors.fill: parent; hoverEnabled: true }

        AnimatedImage {
            anchors.centerIn: parent
            playing: main.visible
            source: main.visible ? (installPath + "images/wait_animation.gif") : "";
        }
    }
}
