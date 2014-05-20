function Group(item, model) {
    var _item = item,
        _model = model,
        self = this;

    this.__defineGetter__("groupId", function() {
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

    this.appendUser = function(jid) {
        _item.users.append({jid: jid});
    }
}

function createRawGroup(group) {
    var result = {
        groupId: group,
        name: (group === '!') ? qsTr('WITHOUT_GROUP_NAME') : group,
        users: [],
        opened: false
    };

    return result;
}
