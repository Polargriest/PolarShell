import QtQuick
import qs.globals

Text {
    visible: opacity > 0

    // TODO: get an insight of how is the system doing with icons in the collapsed view
    text: "󰣇"
    
    // styling
    color: Theme.colors.yellow
    font.bold: true
    font.pixelSize: 18
    font.family: "JetBrains Mono NFP"

    // layout and margins
    anchors.centerIn: parent
}