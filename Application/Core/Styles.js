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

var stylesComponent,
    style;

stylesComponent = Qt.createComponent('./Styles.qml');
if (stylesComponent.status != 1) {
    throw new Error('FATAL: error loading model:' + stylesComponent.errorString());
}

style = stylesComponent.createObject(null);

function init() {
    style.init();
}

function settingsModel() {
    return style.settingsModel;
}

function getCurrentStyle() {
    return style.getCurrentStyle();
}

function setCurrentStyle(value) {
    return style.setCurrentStyle(value);
}

function updateStyle(value) {
    style.updateStyle(value);
}


