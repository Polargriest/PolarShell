import Quickshell
import QtQuick

pragma Singleton

Singleton {
    // configuraciones de las ventanas de Hyprland
    readonly property QtObject screen: QtObject {
        // Tamaño de los huecos que hay desde los bordes de la pantalla
        // a las ventanas.
        readonly property int gaps_out: 15
    }

    // tamaño de la barra
    readonly property QtObject bar: QtObject {
        readonly property int height: 50
    }
}