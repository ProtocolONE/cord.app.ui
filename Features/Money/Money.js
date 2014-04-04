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

var moneyFrame = null,
    moneyFrameInstance = null,
    callback = [],
    pages = {},
    isOverlayEnable = false;

function setCallback(func) {
    callback.push(func);
}

function show(parent, name) {
    if (moneyFrameInstance) {
        moneyFrameInstance.activate();
        return;
    }

    if (!moneyFrame) {
        moneyFrame = Qt.createComponent('./MoneyWindow.qml');
    }

    if (moneyFrame.status !== 1) {
        console.log('FATAL! Can`t create Money.qml component', moneyFrame.status, moneyFrame.errorString());
        return;
    }

    moneyFrameInstance = moneyFrame.createObject(parent);
    moneyFrameInstance.closeRequest.connect(function() {
       moneyFrameInstance = null;
        callback.forEach(function(e) {
            e(false);
        })
    });

    callback.forEach(function(e) {
        e(true);
    })
}

function updatePagesWidth(rootWidth) {
    var w = ((rootWidth - 50) / (Object.keys(pages).length)),
            width = Math.min(w, 250);

    for (var item in pages) {
        pages[item].width = width;
    }
}
