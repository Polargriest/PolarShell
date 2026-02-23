import QtQuick
import QtQuick.Layouts
import qs.globals

Item {
    implicitWidth: layout.implicitWidth + 40
    implicitHeight: layout.implicitHeight + 40

    RowLayout {
        id: layout
        Layout.alignment: Qt.AlignTop

        anchors.fill: parent
        anchors.topMargin: 20
        anchors.leftMargin: 18
        anchors.rightMargin: 18
        anchors.bottomMargin: 20

        Text {
            text: "🦝"

            // style
            color: Theme.colors.yellow
            font.pixelSize: 125
            font.bold: true
            font.family: "JetBrains Mono NFP"
        }

        ColumnLayout {
            spacing: 0

            Text {
                text: "PolarShell"
                horizontalAlignment: Text.AlignRight

                // style
                color: Theme.colors.yellow
                font.pixelSize: 32
                font.bold: true
                font.family: "JetBrains Mono NFP"
            }

            Text {
                text: "Alpha Version 1"
                horizontalAlignment: Text.AlignRight

                font.italic: true

                // style
                color: Theme.colors.secondaryText
                font.pixelSize: 18
                font.bold: true
                font.family: "JetBrains Mono NFP"
            }

            Rectangle { height: 20 } // --------------- divider rectangle ---------------

            Text {
                text: "<b><font color='" + Theme.colors.yellow + "'>󰣇 Kernel:</font></b> Arch version"
                horizontalAlignment: Text.AlignRight

                // style
                color: Theme.colors.primaryText
                font.pixelSize: 18
                font.family: "JetBrains Mono NFP"
            }

            Text {
                text: "<b><font color='" + Theme.colors.yellow + "'> Packages:</font></b> More than 1"
                horizontalAlignment: Text.AlignRight

                // style
                color: Theme.colors.primaryText
                font.pixelSize: 18
                font.family: "JetBrains Mono NFP"
            }

            Text {
                text: "<b><font color='" + Theme.colors.yellow + "'> Uptime:</font></b> 11 hours, 25 mins"
                horizontalAlignment: Text.AlignRight

                // style
                color: Theme.colors.primaryText
                font.pixelSize: 18
                font.family: "JetBrains Mono NFP"
            }

            Text {
                text: "<b><font color='" + Theme.colors.yellow + "'> DE:</font></b> hyprland i think"
                horizontalAlignment: Text.AlignRight

                // style
                color: Theme.colors.primaryText
                font.pixelSize: 18
                font.family: "JetBrains Mono NFP"
            }
        }
    }
}