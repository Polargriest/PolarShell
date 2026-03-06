import QtQuick
import Quickshell
import QtQuick.Layouts
import qs.globals
import "widgets" as Widgets

// BAR.QML
//
// la barra superior. Se encarga de acomodar los widgets a la izquierda y a la derecha. También tiene un widget
// central que crea un borde arriba de la pantalla en la que se muestra el título de la ventana.

RowLayout {
    width: parent.width // toma todo el espacio vertical
    height: Configs.bar.height // toma el espacio que le dieron en la Config.
    spacing: 0

    // HACK: really bad, but I don't know how to do it i'm so sorry and this is the only idea i had :sob:
    property var openedPanels: [fetch, clock, audio, workspaces]

    // widgets a la izquierda
    RowLayout {
        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
        spacing: 10

        // ----- WIDGETS -----
        Widgets.FetchWidget { id: fetch }
        Widgets.Workspaces { id: workspaces }
        
    }

    // widgets a la derecha
    RowLayout {
        id: right_widgets

        Layout.alignment: Qt.AlignRight | Qt.AlignTop
        layoutDirection: Qt.RightToLeft
        spacing: 10

        // ----- WIDGETS -----

        // TODO: only one widget should be able to be open at a time.
        Widgets.ClockWidget { id: clock }
        Widgets.AudioWidget { id: audio }
    }
    
}