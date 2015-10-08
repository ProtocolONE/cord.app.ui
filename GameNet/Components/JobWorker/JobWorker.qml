import QtQuick 2.4
import  "./JobWorker.js" as Js

Item {
    id: root

    property alias interval: worker.interval
    property alias running: worker.running

    // auto start work when appended job and stop when queue is empty.
    property bool managed: true
    property bool paused: false

    // With uniqueId add or replace job.
    // Without uniqueId simple add job to queue.
    function push(job) {
        Js.push(job);
        if (root.managed) {
            worker.start();
        }
    }

    // With uniqueId add only one job with same id.
    // Without uniqueId simple add job to queue.
    function pushOnce(job) {
        Js.pushOnce(job);
        if (root.managed) {
            worker.start();
        }
    }

    function clear() {
        Js.clear();
    }

    QtObject {
        id: d

        function processJob() {
            var job = Js.currentJob();
            if (!job) {
                return;
            }

            if (job.execute()) {
                Js.popJob();
                if (root.managed && !Js.hasJobs()) {
                    worker.stop();
                }
            }
        }
    }

    Timer {
        id: worker

        repeat: true
        onTriggered: {
            if (root.paused) {
                return;
            }
            d.processJob();
        }
    }
}
