import QtQuick 2.4
import ProtocolOne.Controls 1.0

import ProtocolOne.Components.JobWorker 1.0

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

        Rectangle {
            id: uniquePushTest

            width: 350
            height: 150
            color: "gray"

            function singleUniqueJob(id, text) {
                var item = {};
                item.worker = uniqueWorker;
                item.workerName = uniqueWorker.objectName
                item.x = 5;
                item.start = Date.now();
                item.uniqueId = id;
                item.execute = function() {
                    this.worker.statusText = "X: " + this.x + " Start at " + this.start + " Id: " + id + " Text:" + text;
                    console.log(Date.now(), this.workerName, this.x, this.start, id, text);
                    this.x--;
                    return this.x === 0;
                }

                return item;
            }


            JobWorker {
                id: uniqueWorker

                property string statusText: ""

                objectName: "Unique worker"
                interval: 500
            }

            Column {
                anchors { fill: parent; margins: 7 }

                Row {
                    width: parent.width
                    height: 70
                    spacing: 5

                    Column {
                        width: 50
                        spacing: 5

                        Button {
                            width: 50
                            height: 30
                            text: 'Start'
                            onClicked: uniqueWorker.running = true;
                        }

                        Button {
                            width: 50
                            height: 30
                            text: 'Stop'
                            onClicked: uniqueWorker.running = false;
                        }
                    }

                    Column {
                        width: 100
                        spacing: 5

                        Button {
                            width: 100
                            height: 30
                            text: 'Push AA'
                            onClicked: uniqueWorker.push(uniquePushTest.singleUniqueJob("JobA", "AAA"));
                        }


                        Button {
                            width: 100
                            height: 30
                            text: 'Push AB'
                            onClicked: uniqueWorker.push(uniquePushTest.singleUniqueJob("JobA", "BBB"));
                        }
                    }

                    Column {
                        width: 100
                        spacing: 5

                        Button {
                            width: 100
                            height: 30
                            text: 'Push UA'
                            onClicked: uniqueWorker.pushOnce(uniquePushTest.singleUniqueJob("JobU", "AAA"));
                        }

                        Button {
                            width: 100
                            height: 30
                            text: 'Push UB'
                            onClicked: uniqueWorker.pushOnce(uniquePushTest.singleUniqueJob("JobU", "BBB"));
                        }
                    }
                }

                Rectangle {
                    width: 50
                    height: 50
                    color: uniqueWorker.running ? "green" : "red"

                    Text {
                        color: uniqueWorker.running ? "orange" : "chartreuse"
                        text: uniqueWorker.running ? "running" : "stopped"
                        anchors.centerIn: parent
                    }
                }

                Text {
                    width: parent.width
                    height: 30
                    text: uniqueWorker.running ? uniqueWorker.statusText : "stopped"
                }
            }
        }
    }

}
