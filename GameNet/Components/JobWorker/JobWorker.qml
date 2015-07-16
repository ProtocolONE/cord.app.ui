import QtQuick 2.4
import  "./JobWorker.js" as Js

Item {
    id: root

    property alias interval: worker.interval
    property alias running: worker.running

    // auto start work when appended job and stop when queue is empty.
    property bool managed: true
    property bool paused: false

    function push(job) {
        if (!job
           || !job.hasOwnProperty('execute')
           || typeof job['execute'] !== 'function') {
            return;
        }

        Js.jobs.push(job);
        if (root.managed) {
            worker.start();
        }
    }

    function clear() {
        Js.jobs = [];
    }

    QtObject {
        id: d

        function hasJobs() {
            return Js.jobs.length > 0;
        }

        function currentJob() {
            if (Js.jobs.length > 0) {
                return Js.jobs[0];
            }

            return null;
        }

        function popJob() {
            Js.jobs.shift();
            if (root.managed && Js.jobs.length === 0) {
                worker.stop();
            }
        }

        function processJob() {
            var job = d.currentJob();
            if (!job) {
                return;
            }

            if (job.execute()) {
                d.popJob();
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
