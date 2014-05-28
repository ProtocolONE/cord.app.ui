var swithQueue = [];

function Item(type, value) {
    this.type = type;
    this.value = value;

    this.isPage = function() {
        return this.type === "page";
    }
}

function pushPage(source) {
    swithQueue.push(new Item("page", source));
}

function pushComponent(component) {
    swithQueue.push(new Item("component", component));
}

function get() {
    if (swithQueue.length <= 0) {
        return null;
    }

    return swithQueue.shift();
}
