function MoveItemJob(opt) {
    var self = this;

    this.fromIndex = opt.fromIndex || 0;
    this.toIndex = opt.toIndex || 0;
    this.execute = function(groupProxyModel) {
        groupProxyModel.move(this.fromIndex, this.toIndex, 1);
        return true;
    }
}
