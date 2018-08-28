.pragma library
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
