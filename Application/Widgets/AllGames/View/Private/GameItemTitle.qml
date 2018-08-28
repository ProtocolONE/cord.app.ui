import QtQuick 2.4
import Application.Core 1.0
import Application.Core.Styles 1.0

Column {
    spacing: 2

    property variant serviceItem

    Text {
        font { family: 'Open Sans Regular'; pixelSize: 24 }
        color: Styles.bannerTitleText
        text: serviceItem ? serviceItem.name : 'name'
    }

    Text {
        font { family: 'Open Sans Regular'; pixelSize: 12 }
        color: Styles.bannerInfoText
        text: serviceItem ? serviceItem.shortDescription : 'shortDescription'
    }
}
