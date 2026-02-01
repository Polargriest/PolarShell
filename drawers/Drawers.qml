import Quickshell
import QtQuick
import "bar"

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
            mask: Region {
                width: win.width
                height: bar.height

                // also, the widgets on the bar sometimes opens panels. We need to add them to the mask to make them
                // clickable.
                regions: regions.instances
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

            // we will make as much regions as needed (i. e. for every opened panel)
            Variants {
                id: regions

                model: bar.openedPanels

                Region {
                    required property Item modelData

                    property var rect: win.contentItem.mapFromItem(modelData, 0, 0, modelData.width, modelData.height)

                    x: rect.x
                    y: rect.y
                    width: rect.width
                    height: rect.height
                    intersection: Intersection.Combine
                }
            }

            // ------- WIDGETS DE LOS DRAWERS -------
            Bar {
                id: bar
            }

            Item {
                anchors.fill: parent
                z: 1000 // Ensure it's on top of everything
                visible: false

                MouseArea {
                    id: debugMouse
                    anchors.fill: parent
                    hoverEnabled: true // Necessary to track position without clicking
                }

                Rectangle {
                    x: debugMouse.mouseX + 15
                    y: debugMouse.mouseY + 15
                    width: 100
                    height: 40
                    color: "black"
                    opacity: 0.7
                    radius: 5

                    Text {
                        anchors.centerIn: parent
                        color: "white"
                        font.family: "JetBrains Mono NFP"
                        text: `X: ${Math.round(debugMouse.mouseX)} Y: ${Math.round(debugMouse.mouseY)}`
                    }
                }
            }
        }
    }
}