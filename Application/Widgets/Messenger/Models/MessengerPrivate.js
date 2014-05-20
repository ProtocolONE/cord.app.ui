/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
.pragma library

var groupToUser = {}
    , userToGroup = {};

function dumpMaps() {
//    console.log('Group to User :\n', JSON.stringify(groupToUser, null, 2));
//    console.log('User to Group :\n', JSON.stringify(userToGroup, null, 2));
}

function appendUserToGroup(group, user) {
    if (!groupToUser.hasOwnProperty(group)) {
        groupToUser[group] = {};
    }

    if (!userToGroup.hasOwnProperty(user)) {
        userToGroup[user] = {};
    }

    groupToUser[group][user] = 1;
    userToGroup[user][group] = 1;
    dumpMaps();
}

function removeUserFromGroup(group, user) {
    delete groupToUser[group][user];
    delete userToGroup[user][group];
    dumpMaps();
}

function isUserInGroup(group, user) {
    if (!groupToUser.hasOwnProperty(group)) {
        return false;
    }

    if (!groupToUser[group].hasOwnProperty(user)) {
        return false;
    }

    return true;
}

function userGroups(user) {
    if (!userToGroup.hasOwnProperty(user))
        return [];

    return Object.keys(userToGroup[user]);
}

