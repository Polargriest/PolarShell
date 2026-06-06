import Quickshell
import QtQuick
import qs.globals
import "bar"

pragma ComponentBehavior: Bound

// queremos crear un Drawer para cada monitor. Para ello usaremos Variants.
// Variants lo que hará es crear una instancia de un componente la cantidad de veces que le digamos.
//
// model: una lista. Cada elemento creará una instancia del delegate.
// delegate: el componente que se clonará.

Variants {
    model: Quickshell.screens // crearemos una instancia por cada "screen" que nos enliste Quickshell.
                              // Quickshell.screens devuelve una lista de ShellScreen's

    // para cada monitor queremos mostrar varias cosas (ej. una ventana, una barra, etc.), pero delegate
    // solo nos deja mostrar una cosa. Por eso, crearemos un Scope: un solo objeto que puede contener children.

    delegate: Scope {
        id: delegate

        required property ShellScreen modelData // la variable en la que se guarda la lista "model" de Variants.

        // para cada monitor queremos crear una ventana de tipo Panel (una ventana que no tiene decoraciones y
        // que se atacha a los bordes de la pantalla).

        PanelWindow {
            id: win

            // anclas del monitor. Poniendo todas en true es básicamente fullscreen. CUIDADO: Esto bloquea el
            // mouse, aunque sea transparente.
            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            // this solves the problem on the previous comment. This makes so the only clickable region is
            // a region that covers the whole bar.
            mask: Regions {
                bar: bar
                win: win
            }

            color: "transparent"

            exclusionMode: ExclusionMode.Ignore // le pedimos a Wayland que no trate de acomodarnos. por ejemplo,
                                                // si lo quitas y tienes waybar abierto, Wayland acomodará Quickshell
                                                // y te lo va a poner abajo de la waybar.

            // Drawers también dibujará las partes que necesitamos que Hyprland excluya (que le aparte espacio). Esto lo
            // que hace es hacer una venta vacía en la parte superior de la ventana.
            Exclusions {
                screen: delegate.modelData
            }

            // ------- WIDGETS DE LOS DRAWERS -------
            Item {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right

                Bar { id: bar }
            }

            MouseArea {
                anchors.fill: parent
                z: -9999999
                enabled: bar.anyPanelOpened
                onClicked: bar.openedPanels.forEach(panel => panel.isOpen = false)
            }
        }
    }
}