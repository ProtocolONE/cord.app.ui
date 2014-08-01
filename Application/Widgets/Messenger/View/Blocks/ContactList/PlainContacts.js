Qt.include('../../../../../../GameNet/Core/lodash.js')
Qt.include('./Jobs/AppendGroupJob.js');
Qt.include('./Jobs/RemoveItemJob.js');
Qt.include('./Jobs/OpenGroupJob.js');
Qt.include('./Jobs/MoveItemJob.js');

var groupsMap = {}
    , sortedGroups = []
    , jobs = [];

function containsGroup(groupId) {
    return groupsMap.hasOwnProperty(groupId);
}

function groupIndexById(groupId) {
    return sortedGroups.indexOf(groupId);
}

function groupById(groupId) {
    return groupsMap[groupId];
}

function itemCount() {
    return sortedGroups.reduce(function(sum, g) {
        var group = groupsMap[g];
        return sum + (group.opened ? group.users.length : 1);
    }, 0);
}

function calculateInsertIndexByIndex(groupIndex) {
    var resultIndex = 0;
    var group, i;
    for (i = 0; i < groupIndex; i++) {
        group = groupsMap[sortedGroups[i]];
        resultIndex += (group.opened ? group.users.length : 1);
    }

    return resultIndex;
}

function calculateInsertIndex(groupId) {
    return calculateInsertIndexByIndex(groupIndexById(groupId));
}

function appendGroup(groupId) {
    groupsMap[groupId] = {
        opened: false,
        users: []
    };

    var insertIndex = _.findIndex(sortedGroups, function(g) {
        return groupId < g;
    });

    if (insertIndex == -1) {
        sortedGroups.push(groupId);
        return -1;
    }

    sortedGroups.splice(insertIndex, 0, groupId);
    return calculateInsertIndexByIndex(insertIndex);
}

function removeGroup(groupId) {
    sortedGroups.splice(groupIndexById(groupId), 1);
    delete groupsMap[groupId];
}

function eachGroup(callback) {
    Object.keys(groupsMap).forEach(callback);
}

function isOpened(groupId) {
    if (!containsGroup(groupId)) {
        return false;
    }

    return groupsMap[groupId].opened;
}

function setGroupOpened(groupId, value) {
    if (!containsGroup(groupId)) {
        return;
    }

    groupsMap[groupId].opened = value;
}


function queueAppendGroupItemJob(index, groupId) {
    jobs.push(new AppendGroupJob(
                  {
                      index: index,
                      groupId: groupId
                  }));
}

function queueAppendAllJob(index, groupId, users, removeHeader) {
    jobs.push(new OpenGroupJob(
                  {
                      index: index,
                      groupId: groupId,
                      users: users,
                      removeHeader: removeHeader
                  }));
}

function queueRemoveItemJob(index, count, appendGroupId) {
    jobs.push(new RemoveItemJob(
                  {
                      index: index,
                      count: count,
                      appendGroupId: appendGroupId
                  }));
}

function queueMoveItemJob(fromIndex, toIndex) {
    jobs.push(new MoveItemJob(
                  {
                      fromIndex: fromIndex,
                      toIndex: toIndex
                  }));
}

function hasJobs() {
    return jobs.length > 0;
}

function currentJob() {
    if (jobs.length > 0) {
        return jobs[0];
    }

    return null;
}

function popJob() {
    jobs.shift();
}

function processJob(groupProxyModel) {
    var job = currentJob();
    if (!job) {
        return;
    }

    if (job.execute(groupProxyModel)) {
        popJob();
    }
}
