import QtQuick 2.4
import GameNet.Controls 1.0

Item {
    property string source;
    property real volume;
    property bool autoPlay: true;
    property bool ready: false

    signal playing();
    signal error();
    signal stopped();
    signal finished();
    signal paused();

    function play() {
        if (ready) {
            wrapper.item.play();
        }
    }

    function pause() {
        if (ready) {
            wrapper.item.pause();
        }
    }

    function stop() {
        if (ready) {
            wrapper.item.stop();
        }
    }

    onSourceChanged: {
        if (ready) {
           wrapper.item.source = source;
        }
    }

    onVolumeChanged: {
        if (ready) {
           wrapper.item.volume = volume;
        }
    }

    onAutoPlayChanged: {
        if (ready) {
           wrapper.item.autoPlay = autoPlay;
        }
    }

    TryLoader {
        id: wrapper

        source: "./Player/Wrapper.qml"
        onSuccessed: {
            parent.ready = true;
            item.playing.connect(playing);
            item.error.connect(error);
            item.stopped.connect(stopped);
            item.finished.connect(finished);
            item.paused.connect(paused);
            item.source = parent.source;
            item.autoPlay = parent.autoPlay;
            if (parent.volume !== undefined) {
                item.volume = parent.volume;
            }
        }
    }
}
