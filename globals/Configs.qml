import Quickshell
import QtQuick

pragma Singleton

Singleton {
    // configuraciones de las ventanas
    readonly property QtObject screen: QtObject {
        // Tamaño de los huecos que hay desde los bordes de la pantalla a las ventanas. Este dato está
        // guardado en las configuraciones de Hyprland, y cambia cosas como el márgen que deja Hyprland
        // entre la parte superior de la ventana a la barra.
        readonly property int gaps_out: 15
    }



    // configuraciones de la barra
    readonly property QtObject bar: QtObject {
        // altura que Quickshell reservará para la barra.
        readonly property int height: 50

        // time in ms that every bar widget takes to open/close
        readonly property int widgets_animations: 600


        // ---------- CLOCK WIDGET SETTINGS ----------
        readonly property QtObject clock_widget: QtObject {
            // by default, clock uses 12-hour format. if you want to use 24-hour, set this to false.
            readonly property bool use_12hrs: true
        }
    }
}