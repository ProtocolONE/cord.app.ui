import QtQuick 1.1
import "../Blocks2/Premium" as Premium

Rectangle {
    width: 630
    height: 375

    Premium.Main {
        onBuy: {
            console.log('buy', money);
        }

        onOpenDetails: {
            console.log('open details');
        }

        onAddMoney: {
            console.log('add money');
        }

    }

}
