var _blocks = {},
    _setBlock;

function setBlockInput(name, value) {
    if (!_setBlock) {
        return;
    }

    var result = 0;

    _blocks[name] = value;

    Object.keys(_blocks).forEach(function(key) {       
        result = result | _blocks[key];
    });

    _setBlock(result);
}

function setBlockFunc(blockFunc) {
    _setBlock = blockFunc;
}
