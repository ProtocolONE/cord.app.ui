function OpenGroupJob(opt) {
    var self = this;

    this.index = opt.index || 0;
    this.currentIndex = this.index;
    this.groupId = opt.groupId || "";
    this.users = opt.users || [];
    this.removeHeader = opt.removeHeader || false;
    this.isSecondExecute = false;

    this.execute = function(groupProxyModel) {
        var i,
                batchSize,
                users,
                item;

        batchSize = this.isSecondExecute ? 1000 : 30;
        this.isSecondExecute = true;


        if (this.removeHeader) {
            groupProxyModel.remove(this.index);
            this.removeHeader = false;
        }

        users = this.users.slice(0, batchSize);
        users.forEach(function(user) {
            item = {
                isGroupItem: false,
                value: user,
                sectionId: self.groupId,
                groupId: self.groupId,
                jid: user
            };

            groupProxyModel.insert(self.currentIndex, item);
            self.currentIndex++;
        });


        this.users.splice(0, batchSize);
        return this.users.length === 0;
    }
}
