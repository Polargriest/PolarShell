import Quickshell
import QtQuick

pragma Singleton

Singleton {
    // tamaño de la barra
    readonly property QtObject bar: QtObject {
        readonly property int height: 40
    }
}