/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 2.4
import Dev 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import Application.Core 1.0

Rectangle {
    width: 800
    height: 800
    color: '#EEEEEE'

    WidgetManager {
        id: manager

        Component.onCompleted: {
            manager.registerWidget('Application.Widgets.TrayMenu');
            manager.init();

          User.setCredential("400001000092302250",
                               "86c558d41c1ae4eafc88b529e12650b884d674f5",
                               "WrfVSXKrAkjMYVHNnZhULNEBx3X%2BYYzVWyoXHkicHmeXaDetVSfZ3C7Wtc6SbSfg1GBzBQSl9qAcOqaufJTXiotDVKkeYLwoxwQ1O1QWzTsv58XD%2FNs0IfH22UpBTvqiSU7zMhQT2azWHRhoa85omZTMsPjfv1M1MPiPgFJiL170UI8Ol1KWJhHlhz8hNgiuZpTAuGaV%2F4WGXURM%2B3Ew3WvKXocU%2BDjRhUvqTkeCBcDRLP9SBRRSD6n8HLHzXPUUxDSUNsy%2BzJvypgsjfgzRiPj1OLu7kaQzUgjiIpiSPlIaiU54VuH%2BijD5P0pJqLd%2FuNfLkGntLSqQjefVzmh8kRu%2FB2MRDvzt5ZpotCWJt7FU3jzABLhaTVyRb6OXloRtljoq5I3uH1JtaBuq2DIPGPSM9xlcn0FXbGS7");

        }
    }
}
