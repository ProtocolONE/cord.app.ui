var model = {}
    , count = 0
    , invalidated = false
    , notifableProperty = {};

var SetPropertyJob = function(id, key, value, itemModel) {
    this.id = id;
    this.key = key;
    this.value = value;
    this.itemModel = itemModel;

    this.execute = function() {
        if (model.hasOwnProperty(this.id)) {
            var item = model[this.id];
            if (item[this.key] != this.value) {
                item[this.key] = this.value;

                if (notifableProperty.hasOwnProperty(this.key)) {
                    this.itemModel.propertyChanged(this.id, this.key);
                }
            }
        }

        return true;
    }
}

var Invalidate = function(root) {
    var target = root;
    this.execute = function() {
        invalidated = false;
        count = Object.keys(model).length;
        target.count = count;
        target.syncdate = Date.now();
        return true;
    }
}