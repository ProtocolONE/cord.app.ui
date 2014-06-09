/****************************************************************************
 ** This file is a part of Syncopate Limited GameNet Application or it parts.
 **
 ** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
 ** All rights reserved.
 **
 ** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
 ** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
 ****************************************************************************/

var _blocks = {},
    _setBlock;

function setBlockInput(name, value) {
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
