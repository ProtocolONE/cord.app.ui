function RemoveItemJob(opt) {
    var self = this;

    this.index = opt.index || 0;
    this.count = opt.count || 0;
    this.appendGroupId = opt.appendGroupId || false;
    this.execute = function(groupProxyModel) {
        var batchSize = 500;
        var b = Math.min(batchSize, this.count);

        for (var i = 0; i < b; i++) {
            groupProxyModel.remove(this.index + this.count - 1 - i);
        }

        this.count -= b;

        if (this.count > 0) {
            return false;
        }


        if (this.appendGroupId) {
            groupProxyModel.insert (this.index, {
                                        isGroupItem: true,
                                        value: this.appendGroupId,
                                        sectionId: "",
                                        groupId: this.appendGroupId,
                                        jid: ""
                                    });
        }

        return true;
    }
}
