import QtQuick
import Quickshell.Widgets
import qs.globals
import qs.services

// CLOCK WIDGET
//
// reloj. Al tocarlo debe de abrir un calendario

WrapperRectangle {
    color: Theme.colorWithAlpha(Theme.colors.bg, 0.6)
    radius: 500
    border.width: 2
    border.color: Theme.colors.bg

    Text {
        // el texto lo agarramos usando el servicio de SystemTime. éste está guardado en un singleton guardado en
        // services/Time.qml
        text: Time.time
        id: texto

        color: Theme.colors.blue
        font.bold: true
        font.pixelSize: 18
        font.family: "JetBrains Mono NFP"

        topPadding: 2
        bottomPadding: 2
        rightPadding: 10
        leftPadding: 10
        
    }
}