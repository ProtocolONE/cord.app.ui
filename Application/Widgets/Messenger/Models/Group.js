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

function Group(item, model) {
    var _item = item,
        _model = model,
        self = this;

    this.__defineGetter__("groupId", function() {
        if (!_item) {
            return "";
        }

        return _item.groupId;
    });

    this.__defineGetter__("name", function() {
        return _item.name;
    });

    this.__defineSetter__("name", function(val) {
        _model.setPropertyById(self.groupId, 'name', val);
    });

    this.__defineGetter__("users", function() {
        return _item.users;
    });

    this.__defineGetter__("opened", function() {
        return _item.opened;
    });

    this.__defineSetter__("opened", function(val) {
        _model.setPropertyById(self.groupId, 'opened', val);
    });

    this.__defineGetter__("isGamenet", function() {
        return _item.isGamenet;
    });

    this.appendUser = function(jid) {
        _item.users.append({jid: jid});
    }

    this.isValid = function() {
        return !!_item && !!_model;
    }
}

function getNoGroupId() {
    return '!';
}

function createRawGroup(group) {
    var result = {
        groupId: group,
        name: (group === getNoGroupId()) ? qsTr('WITHOUT_GROUP_NAME') : group,
        users: [],
        opened: false,
        isGamenet: false
    };

    return result;
}
