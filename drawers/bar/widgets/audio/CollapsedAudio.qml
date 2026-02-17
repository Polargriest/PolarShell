import QtQuick
import QtQuick.Layouts
import qs.globals
import qs.services

RowLayout {
    anchors.centerIn: parent
    spacing: 10

    width: 85

    Row {
        Layout.alignment: Qt.AlignCenter
        spacing: Audio.muted ? 0 : 15

        Behavior on spacing { NumberAnimation { duration: Configs.bar.widgetsAnimations; easing.type: Easing.OutBack } }

        Text {
            visible: opacity > 0
            horizontalAlignment: Text.AlignHCenter

            width: Audio.muted ? 0 : implicitWidth
            opacity: Audio.muted ? 0.01 : 1
            Behavior on width { NumberAnimation { duration: Configs.bar.widgetsAnimations; easing.type: Easing.OutBack } }
            Behavior on opacity { NumberAnimation { duration: Configs.bar.widgetsAnimations/3 } }

            text: (Audio.volume * 100).toFixed(0) + "%"

            //styling
            color: !Audio.muted ? Theme.colors.purple : Theme.colors.red
            font.bold: true
            font.pixelSize: 18
            font.family: "JetBrains Mono NFP"

            Behavior on color { ColorAnimation { duration: Configs.bar.widgetsAnimations/3 } }
        }

        Text {
            visible: opacity > 0

            text: Audio.muted ? "" : ""

            //styling
            color: !Audio.muted ? Theme.colors.purple : Theme.colors.red
            font.bold: true
            font.pixelSize: 18
            font.family: "JetBrains Mono NFP"

            Behavior on color { ColorAnimation { duration: Configs.bar.widgetsAnimations/3 } }
        }
    }
}