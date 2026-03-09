import QtQuick
import QtQuick.Layouts
import qs.globals
import qs.services

Item {
    implicitWidth: 520
    implicitHeight: layout.implicitHeight + 40

    RowLayout {
        id: layout
        Layout.alignment: Qt.AlignTop

        spacing: 10

        anchors.fill: parent
        anchors.topMargin: 20
        anchors.leftMargin: 18
        anchors.rightMargin: 18
        anchors.bottomMargin: 20

        Text {
            // TODO: gif and image support here
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
                text: "Alpha InDev 1"
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
                text: "<b><font color='" + Theme.colors.yellow + "'>󰣇 Kernel:</font></b> " + SysInfo.kernel
                horizontalAlignment: Text.AlignRight

                // style
                color: Theme.colors.primaryText
                font.pixelSize: 18
                font.family: "JetBrains Mono NFP"
            }

            Text {
                text: "<b><font color='" + Theme.colors.yellow + "'> Packages:</font></b> " + SysInfo.packageCount
                horizontalAlignment: Text.AlignRight

                // style
                color: Theme.colors.primaryText
                font.pixelSize: 18
                font.family: "JetBrains Mono NFP"
            }

            Text {
                text: "<b><font color='" + Theme.colors.yellow + "'> Uptime:</font></b> " + SysInfo.uptime
                horizontalAlignment: Text.AlignRight

                // style
                color: Theme.colors.primaryText
                font.pixelSize: 18
                font.family: "JetBrains Mono NFP"
            }

            Text {
                text: "<b><font color='" + Theme.colors.yellow + "'> DE:</font></b> " + SysInfo.wm
                horizontalAlignment: Text.AlignRight

                // style
                color: Theme.colors.primaryText
                font.pixelSize: 18
                font.family: "JetBrains Mono NFP"
            }
        }
    }
}