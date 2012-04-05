/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
**
** @author: Nikolay Bondarenko <nikolay.bondarenko@syncopate.ru>
** @since: 2.0
****************************************************************************/

.pragma library

var ToolTip = function() {
    this.holder = null;
}

ToolTip.prototype.setup = function(holder) {
    var validObject = (typeof holder === 'object')
        && holder.hasOwnProperty('entered')
        && holder.hasOwnProperty('exited')
        && holder.hasOwnProperty('item');

    if (!validObject) {
        console.log('FATAL: Invalid tooltip holder object ' + holder);
        return;
    }

    this.holder = holder;
}

ToolTip.prototype.isItemValid = function(item) {
    return (typeof item === 'object')
            && item.toString().indexOf('QML') !== -1
            && item.hasOwnProperty('entered')
            && typeof item.entered === 'function'
            && item.hasOwnProperty('exited')
            && typeof item.exited === 'function'
            && item.hasOwnProperty('toolTip')
            && typeof item.toolTip === 'string';
}

ToolTip.prototype.track = function(item) {
    var self = this;

    if (!this.isItemValid(item)) {
        console.log('FATAL: Invalid tooltip item object ' + item);
        return;
    }

    item.entered.connect(function() {
        if (self.holder) {
            self.holder.entered(item);
        }
    });

    item.exited.connect(function() {
        if (self.holder) {
            self.holder.exited(item);
        }
    });
}

ToolTip.prototype.release = function(item) {
    if (!this.isItemValid(item)) {
        console.log('FATAL: Could not release tooltip item object ' + item);
        return;
    }

    if (this.holder) {
        this.holder.release(item);
    }
}

if (!ToolTip._instance) {
    ToolTip._instance = new ToolTip();
}

function track(item) {
    ToolTip._instance.track(item);
}

function release(item) {
    ToolTip._instance.release(item);
}

function setup(item) {
    ToolTip._instance.setup(item);
}
