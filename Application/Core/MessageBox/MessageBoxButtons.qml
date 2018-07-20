import QtQuick 2.4

QtObject {
    readonly property int noButton           : 0x00000000
    readonly property int support            : 0x00000200
    readonly property int ok                 : 0x00000400
    readonly property int save               : 0x00000800
    readonly property int saveAll            : 0x00001000
    readonly property int open               : 0x00002000
    readonly property int yes                : 0x00004000
    readonly property int yesToAll           : 0x00008000
    readonly property int no                 : 0x00010000
    readonly property int noToAll            : 0x00020000
    readonly property int abort              : 0x00040000
    readonly property int retry              : 0x00080000
    readonly property int ignore             : 0x00100000
    readonly property int close              : 0x00200000
    readonly property int cancel             : 0x00400000
    readonly property int discard            : 0x00800000
    readonly property int help               : 0x01000000
    readonly property int apply              : 0x02000000
    readonly property int reset              : 0x04000000
    readonly property int restoreDefaults    : 0x08000000
}
