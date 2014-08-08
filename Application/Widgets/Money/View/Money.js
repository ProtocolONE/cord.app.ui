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
    pages = {};

function updatePagesWidth(rootWidth) {
    var w = ((rootWidth - 50) / (Object.keys(pages).length)),
            width = Math.min(w, 250);

    for (var item in pages) {
        pages[item].width = width;
    }
}
