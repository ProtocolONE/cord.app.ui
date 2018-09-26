var queue = [];

function push(cb, value) {
    queue.push({
                   cb: cb,
                   value: value
               })
}
