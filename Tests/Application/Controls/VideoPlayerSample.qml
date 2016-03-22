import QtQuick 2.0
import Application.Controls 1.0
import Dev 1.0

Item {
    width: 800
    height: 600

    VideoPlayer {
        width: 590
        height: 330
        anchors.centerIn: parent

        //source: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"
        source: 'https://cdn.turbik.tv/094b0fe0e302854af1311afab85b5203ba457a3b/83/11ac77802eb1f1a5e9f62365f8e72c46/0/62bdef61e27a7f504055d3bc2bc9b72bd9bc5544/9d5cd00325b826e550846814a40d3bca027cc30d/dfe4a04d23277109db2344825c38dbfac378f029'
    }
}
