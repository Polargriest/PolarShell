import Quickshell
import QtQuick

pragma Singleton

Singleton {
    // un objeto con todos los colores que normalmente usa. Son los colores de Monokai.
    readonly property QtObject colors: QtObject {
        readonly property color bg: "#2D2A2E" // gray
        readonly property color bgDark: "#232422" // dark gray
        readonly property color red: "#FF6188"
        readonly property color orange: "#FC9867"
        readonly property color yellow: "#FFD866"
        readonly property color green: "#A9DC76"
        readonly property color blue: "#78DCE8"
        readonly property color purple: "#AB9DF2"

        // text colors
        readonly property color primaryText: "#F8F8F2"
        readonly property color secondaryText: "#B9B9B8"
    }

    // esta función devuelve uno de los colores del objeto colors con una opacidad definida
    function colorWithAlpha(color, alpha) {
        return Qt.rgba(color.r, color.g, color.b, alpha)
    }
}