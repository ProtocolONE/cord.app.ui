/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 1.1

QtObject {
    id: container

    property bool exclusive: true
    property variant currentOption

    property variant defaultChecked

    function register(newOption) {
        if (newOption.hasOwnProperty('check')
                && newOption.hasOwnProperty('uncheck')) {
            if (newOption.checked) {
                container.currentOption = newOption;
                defaultChecked = container.currentOption;
            }

            newOption.optionClicked.connect(function() {
                onOptionClicked(newOption);
            });
        }
    }

    function onOptionClicked(optData) {
        if (container.currentOption) {
            container.currentOption.uncheck();
        }

        if (optData) {
            container.currentOption = optData;
            container.currentOption.check();
        }
    }

    function reset() {
        onOptionClicked(defaultChecked);
    }
}
