import QtQuick
import qs.services
import qs.globals

Text {
    visible: opacity > 0

    // we grab the time using the SystemTime servece. its saved in a singleton in services/Time.qml
    text: Time.getFormattedTime(false)
    
    // styling
    color: Theme.colors.blue
    font.bold: true
    font.pixelSize: 18
    font.family: "JetBrains Mono NFP"

    // layout and margins
    anchors.centerIn: parent
    topPadding: 5
    bottomPadding: 5
    rightPadding: 12
    leftPadding: 12
}