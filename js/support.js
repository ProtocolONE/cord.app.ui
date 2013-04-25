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

var supportFrame = null;
var supportFrameInstance = null;

function show(parent, name) {
    if (supportFrameInstance) {
        return;
    }

    if (!supportFrame) {
        supportFrame = Qt.createComponent('./Support/Support.qml');
    }

    if (supportFrame.status !== 1) {
        console.log('FATAL! Can`t create support.qml component', supportFrame.status, supportFrame.errorString());
        return;
    }

    supportFrameInstance = supportFrame.createObject(parent, {itemName: name || ''});
    supportFrameInstance.beforeClosed.connect(function() {
       supportFrameInstance = null;
    });
}
