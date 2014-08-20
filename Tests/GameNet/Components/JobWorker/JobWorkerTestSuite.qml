import QtQuick 1.0
import GameNet.Controls 1.0

import GameNet.Components.JobWorker 1.0

Rectangle {
    width: 1000
    height: 600

    QtObject {
        id: d

        function pushFakeJob(targetWorker) {
            var item = {};
            item.worker = targetWorker;
            item.workerName = targetWorker.objectName
            item.x = 5;
            item.start = Date.now();
            item.execute = function() {
                this.worker.statusText = "X: " + this.x + " Start at " + this.start;
                console.log(Date.now(), this.workerName, this.x, this.start);
                this.x--;
                return this.x === 0;
            }

            targetWorker.push(item);
        }
    }

    Grid {
        anchors { fill: parent; margins: 10 }
        spacing: 10

        Rectangle {
            width: 150
            height: 150
            color: "gray"

            JobWorker {
                id: autoWorker

                property string statusText: ""

                objectName: "Auto managed worker"
                interval: 500
            }

            Column {
                anchors { fill: parent; margins: 7 }
                spacing: 5

                Item {
                    width: parent.width
                    height: 50

                    Row {
                        anchors.fill: parent

                        Button {
                            width: 100
                            height: 30
                            text: 'Feed Auto'
                            onClicked: d.pushFakeJob(autoWorker);
                        }
                    }

                }

                Rectangle {
                    width: 50
                    height: 50
                    color: autoWorker.running ? "green" : "red"

                    Text {
                        color: autoWorker.running ? "orange" : "chartreuse"
                        text: autoWorker.running ? "running" : "stopped"
                        anchors.centerIn: parent
                    }
                }

                Text {
                    width: parent.width
                    height: 30
                    text: autoWorker.running ? autoWorker.statusText : "stopped"
                }
            }
        }

        Rectangle {
            width: 350
            height: 150
            color: "gray"

            JobWorker {
                id: manualWorker

                property string statusText: ""

                objectName: "Manual worker"
                interval: 500
                managed: false
            }

            Column {
                anchors { fill: parent; margins: 7 }

                Row {
                    width: parent.width
                    height: 50
                    spacing: 5

                    Button {
                        width: 100
                        height: 30
                        text: 'Feed Auto'
                        onClicked: d.pushFakeJob(manualWorker);
                    }

                    Button {
                        width: 100
                        height: 30
                        text: 'Start worker'
                        onClicked: manualWorker.running = true;
                    }

                    Button {
                        width: 100
                        height: 30
                        text: 'Stop worker'
                        onClicked: manualWorker.running = false;
                    }
                }

                Rectangle {
                    width: 50
                    height: 50
                    color: manualWorker.running ? "green" : "red"

                    Text {
                        color: manualWorker.running ? "orange" : "chartreuse"
                        text: manualWorker.running ? "running" : "stopped"
                        anchors.centerIn: parent
                    }
                }

                Text {
                    width: parent.width
                    height: 30
                    text: manualWorker.running ? manualWorker.statusText : "stopped"
                }
            }
        }
    }

}
