import QtQuick
import qs.globals

Text {
    visible: opacity > 0

    text: "󰣇"
    
    // styling
    color: Theme.colors.yellow
    font.bold: true
    font.pixelSize: 18
    font.family: "JetBrains Mono NFP"

    // layout and margins
    anchors.centerIn: parent
}