function AppendGroupJob(opt) {
    this.index = opt.index || 0;
    this.groupId = opt.groupId || "";

    this.execute = function(groupProxyModel) {
        groupProxyModel.insert(this.index, {
                                   isGroupItem: true,
                                   value: this.groupId,
                                   sectionId: "",
                                   groupId: this.groupId,
                                   jid: ""
                               });
        return true;
    }
}
