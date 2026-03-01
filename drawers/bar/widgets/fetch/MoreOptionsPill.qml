import QtQuick
import QtQuick.Layouts
import qs.globals
import Quickshell.Io
import ".."

Pill {
    required property var widget
    id: pill

    contentComponent: ColumnLayout {
        Layout.alignment: Qt.AlignTop
        Layout.fillWidth: true

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 35
            color: gitHubHitbox.containsMouse ? Theme.colorWithAlpha(Theme.colors.primaryText, "0.1") : "transparent"
            radius: 10

            visible: !Configs.bar.fetch.hideGitHubButton

            Text {
                id: gitHubText
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                padding: 5

                text: "Open GitHub page"
                color: Theme.colors.primaryText
                font.pixelSize: 18
                font.family: "JetBrains Mono NFP"

                Layout.fillWidth: true
                clip: true
            }

            MouseArea {
                id: gitHubHitbox
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    Qt.openUrlExternally("https://github.com/")
                    pill.widget.isOpen = false
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 35
            color: preferencesHitbox.containsMouse ? Theme.colorWithAlpha(Theme.colors.primaryText, "0.1") : "transparent"
            radius: 10

            Text {
                id: preferencesText
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                padding: 5

                text: "Shell preferences"
                color: Theme.colors.primaryText
                font.pixelSize: 18
                font.family: "JetBrains Mono NFP"

                Layout.fillWidth: true
                clip: true
            }

            MouseArea {
                id: preferencesHitbox
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onClicked: pill.widget.isOpen = false
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 35
            color: powerHitbox.containsMouse ? Theme.colorWithAlpha(Theme.colors.red, "0.1") : "transparent"
            radius: 10

            Text {
                id: powerText
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                padding: 5

                text: "Shutdown"
                color: Theme.colors.red
                font.pixelSize: 18
                font.family: "JetBrains Mono NFP"

                Layout.fillWidth: true
                clip: true
            }

            MouseArea {
                Process {
                    id: shutdownProc
                    command: [ "systemctl", "poweroff" ]
                }

                id: powerHitbox
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    pill.widget.isOpen = false
                    shutdownProc.running = true
                }
            }
        }
    }
}