import QtQuick
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

    // widgets a la izquierda

    RowLayout {
        Layout.alignment: Qt.AlignLeft
        spacing: 10

        // dejamos de margen los pixeles que se nos indicaron en las configuraciones
        Layout.topMargin: Configs.screen.gaps_out
        Layout.leftMargin: Configs.screen.gaps_out

        // ----- WIDGETS -----
    }

    // widgets a la derecha

    RowLayout {
        Layout.alignment: Qt.AlignRight | Qt.AlignTop
        spacing: 10

        // dejamos de margen los pixeles que se nos indicaron en las configuraciones
        Layout.topMargin: Configs.screen.gaps_out
        Layout.rightMargin: Configs.screen.gaps_out

        // ----- WIDGETS -----

        Widgets.ClockWidget {}
        Widgets.ClockWidget {}
    }
    
}