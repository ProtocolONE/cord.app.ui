.pragma library
/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

var storyLine = [],
    _qml = null;

function add(arr) {
    storyLine = [];
    arr.forEach(function(e) {
        storyLine.push(e);
    });
}

function show() {
    _qml.show();
}

function _drawLines(v1, v2, from, to, dock)
{
    var isLeft = dock.x < from.x,
        isUp = to.y > from.y + from.height;

    if (isLeft) {
        v1.x = dock.x;
        v1.width = from.x - v1.x;
        v1.y = dock.y
        v1.height = 1;
    } else {
        v1.x = from.x + from.width
        v1.width = dock.x - v1.x;
        v1.y = dock.y
        v1.height = 1;
    }

    if (isUp) {
        v2.x = dock.x;
        v2.width = 1;
        v2.y = dock.y;
        v2.height = to.y - v2.y;
    } else {
        v2.x = dock.x;
        v2.width = 1;
        v2.y = to.y + to.height;
        v2.height = dock.y - v2.y;
    }
}
