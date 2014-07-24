Qt.include('../../../../../../GameNet/Core/lodash.js')

var groupsMap = {},
sortedGroups = [];

function containsGroup(groupId) {
    return groupsMap.hasOwnProperty(groupId);
}

function groupIndexById(groupId) {
    return _.findIndex(sortedGroups, function(g) { return g === groupId });
}

function groupById(groupId) {
    return groupsMap[groupId];
}

function itemCount() {
    var resultIndex = 0;
    sortedGroups.forEach(function(g) {
        var group = groupsMap[g];
        resultIndex += (group.opened ? group.users.length : 1);
    });

    return resultIndex;
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

    } else {
        sortedGroups.splice(insertIndex, 0, groupId);
        return calculateInsertIndexByIndex(insertIndex);
    }
}

function removeGroup(groupId) {
    var index = groupIndexById(groupId);
    sortedGroups.splice(index, 1);
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

var jobs = [];

function appendGroupItem(index, groupId) {
    jobs.push({
                  action: "appendGroup",
                  index: index,
                  groupId: groupId
              });
}

function appendAllJob(index, groupId, users, removeHeader) {
    jobs.push({
                  action: "appendAll",
                  index: index,
                  groupId: groupId,
                  users: users,
                  totalUserCount: users.length,
                  removeHeader: removeHeader || false
              });
}

function removeItemJob(index, count, appendGroupId) {
    jobs.push({
                  action: "remove",
                  index: index,
                  count: count,
                  appendGroupId: appendGroupId
              });
}

function jobInProgress() {
    return jobs.length > 0;
}

function currentJob() {
    if (jobs.length > 0) {
        return jobs[0];
    }

    return null;
}

function popJob() {
    if (jobs.length > 0) {
        jobs.shift();
    }
}
