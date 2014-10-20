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

// INFO see Messenger.js
var USER_INFO_FULL = 1;
var USER_INFO_JID = 2;

var DISCONNECTED     = 0;
var CONNECTING       = 1;
var ROSTER_RECEIVING = 2;
var ROSTER_RECEIVED  = 3;
var RECONNECTING     = 4;

var groupToUser = {}
    , userToGroup = {}
    , lastTalkDateMap = {}
    , unreadMessageCountMap;

function reset() {
    groupToUser = {};
    userToGroup = {};
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
}

function removeUserFromGroup(group, user) {
    delete groupToUser[group][user];
    delete userToGroup[user][group];
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

