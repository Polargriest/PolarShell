import Quickshell
import QtQuick

pragma Singleton

Singleton {
    readonly property QtObject colors: Configs.shell.theme

    // un objeto con todos los colores que normalmente usa. Son los colores de Monokai.
    readonly property QtObject monokai: QtObject {
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

    readonly property QtObject catppuccin: QtObject {
        readonly property color bg: "#232332" // gray
        readonly property color bgDark: "#181821" // dark gray
        readonly property color red: "#ea9fab"
        readonly property color orange: "#f6af84"
        readonly property color yellow: '#f9e1ae'
        readonly property color green: "#a5e2a0"
        readonly property color blue: "#88b3fa"
        readonly property color purple: "#caa5f7"

        // text colors
        readonly property color primaryText: "#ccd5f4"
        readonly property color secondaryText: "#9298b1"
    }

    readonly property QtObject synthwave84: QtObject {
        readonly property color bg: "#262335" // gray
        readonly property color bgDark: "#171520" // dark gray
        readonly property color red: "#FE4450"
        readonly property color orange: "#FF8B39"
        readonly property color yellow: '#FEDE5D'
        readonly property color green: "#72F1B8"
        readonly property color blue: "#2EE2FA"
        readonly property color purple: "#FF7EDB"

        // text colors
        readonly property color primaryText: "#d1d0d2"
        readonly property color secondaryText: "#616067"
    }

    // esta función devuelve uno de los colores del objeto colors con una opacidad definida
    function colorWithAlpha(color, alpha) {
        return Qt.rgba(color.r, color.g, color.b, alpha)
    }

    // oh i absolutely vibecoded this i'm sorry.
    function multiplyColor(baseColor, factor) {
        // factor: 1.0 es original, > 1.0 es más oscuro
        // En lugar de ir hacia el negro (#000000), 
        // desplazamos el color hacia un tono más frío y saturado
        
        let h = baseColor.hsvHue;
        let s = Math.min(1.0, baseColor.hsvSaturation * (factor * 1.1)); // Aumenta saturación
        let v = baseColor.hsvValue / factor; // Baja el brillo
        
        // El truco de Krita: Shift de tono (Hue Shift)
        // Los oscuros se ven más vibrantes si viran un poco al azul/púrpura
        let hShift = h;
        if (h > 0.5) hShift += 0.02; // Si es azulado, hazlo más profundo
        else hShift -= 0.02;        // Si es cálido, hazlo más "quemado"

        return Qt.hsva(hShift, s, v, baseColor.a);
    }
}