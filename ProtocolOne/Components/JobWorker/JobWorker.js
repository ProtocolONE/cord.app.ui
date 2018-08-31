var counter = 0;
var jobMap = {}; // internalId to real job
var uniqueIdMap = {}; // unique job id to internalId
var jobsQueue = []; // contains internalId

function clear() {
    counter = 0;
    jobMap = {}
    uniqueIdMap = {};
    jobsQueue = [];
}

function getInternalId() {
    counter++;
    return counter;
}

function push(job) {
    var uniqueId,
        internalId;

    if (!job
       || !job.hasOwnProperty('execute')
       || typeof job['execute'] !== 'function') {
        return;
    }

    uniqueId = job.uniqueId;
    if (uniqueId && uniqueIdMap.hasOwnProperty(uniqueId)) {
        internalId = uniqueIdMap[uniqueId];
        jobMap[internalId] = job;
        return;
    }

    internalId = getInternalId();
    jobMap[internalId] = job;
    jobsQueue.push(internalId);

    if (uniqueId) {
        uniqueIdMap[uniqueId] = internalId;
    }
}

function pushOnce(job) {
    var uniqueId;

    if (!job) {
        return;
    }

    uniqueId = job.uniqueId;
    if (uniqueId && uniqueIdMap.hasOwnProperty(uniqueId)) {
        return;
    }

    push(job);
}

function hasJobs() {
    return jobsQueue.length > 0;
}

function currentJob() {
    var internalId;
    if (jobsQueue.length == 0) {
        return null;
    }

    internalId = jobsQueue[0];
    return jobMap[internalId]; // тут бы асерт, что джоб не пустой
}

function popJob() {
    var internalId = jobsQueue[0];
    var job = jobMap[internalId];
    var uniqueId = job.uniqueId;
    jobsQueue.shift();
    if (uniqueId) {
        delete uniqueIdMap[uniqueId];
    }
    delete jobMap[internalId];
}

