var sortedUsers = [];
        
function InsertUsers(opt) {
    var self = this;

    this.model = opt.model;

    this.index = opt.index || 0;
    this.currentIndex = this.index;
    this.users = opt.users || [];
    this.isSecondExecute = false;

    this.execute = function() {
        var i,
                batchSize,
                users,
                item;

        batchSize = this.isSecondExecute ? 1000 : 30;
        this.isSecondExecute = true;

        users = this.users.slice(0, batchSize);
        users.forEach(function(user) {
            item = {
                jid: user
            };

            self.model.insert(self.currentIndex, item);
            self.currentIndex++;
        });

        this.users.splice(0, batchSize);
        return this.users.length === 0;
    }
}

function RemoveItemJob(opt) {
    var self = this;

    this.model = opt.model;
    this.index = opt.index || 0;
    this.count = opt.count || 0;

    this.execute = function() {
        var batchSize = 500;
        var b = Math.min(batchSize, this.count);

        for (var i = 0; i < b; i++) {
            self.model.remove(this.index + this.count - 1 - i);
        }

        this.count -= b;

        if (this.count > 0) {
            return false;
        }

        return true;
    }
}

function MoveItemJob(opt) {
    var self = this;

    this.model = opt.model;
    this.fromIndex = opt.fromIndex || 0;
    this.toIndex = opt.toIndex || 0;
    this.execute = function() {
        self.model.move(this.fromIndex, this.toIndex, 1);
        return true;
    }
}
