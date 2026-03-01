import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.globals
import qs.services
import qs.components
import ".."

Pill {
    id: pill

    contentComponent: ColumnLayout {

        Text {
            text: "Mixer"
            color: Theme.colors.green
            font.bold: true
            font.pixelSize: 24
            font.family: "JetBrains Mono NFP"
        }

        Rectangle {
            Layout.preferredHeight: 1
            Layout.fillWidth: true
            color: Theme.colors.green
        } // spacing

        ColumnLayout {
            Layout.topMargin: 15
            Layout.bottomMargin: 15
            spacing: 15 // Espaciado entre cada aplicación

            Repeater {
                model: Audio.streams

                delegate: RowLayout {
                    id: application
                    required property var modelData
                    spacing: 10

                    Rectangle {
                        Layout.preferredWidth: 40
                        Layout.preferredHeight: 40

                        radius: 100
                        color: iconHitbox.containsMouse ? Theme.colorWithAlpha(Theme.colors.primaryText, "0.1") : "#00000000"

                        Text { // app icon
                            id: iconText
                            property string appName: application.modelData.properties["application.name"]

                            text: Configs.shell.appIcons[appName] ?? ""
                            font.family: "JetBrainsMono NFP Custom"
                            font.pixelSize: 24

                            color: !Audio.getNodeMute(application.modelData) ? Theme.colors.green : Theme.colors.red
                            Behavior on color { ColorAnimation { duration: Configs.bar.widgetsAnimations/3 } }
                            
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        MouseArea {
                            id: iconHitbox
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                console.log("Application name: " + application.modelData.properties["application.name"])
                                Audio.toggleNodeMute(application.modelData)
                            }
                        }
                    }

                    ColumnLayout {
                        Layout.preferredWidth: 0
                        clip: true

                        spacing: 5

                        Text {
                            text: application.modelData.properties["media.name"]
                            Layout.maximumWidth: 0
                            color: Theme.colors.primaryText
                            font.family: "JetBrains Mono NFP"
                            font.pixelSize: 16
                        }

                        CustomSlider {
                            bgColor: !Audio.getNodeMute(application.modelData) ? Theme.colors.green : Theme.colors.red

                            value: application.modelData.audio?.volume
                            onMoved: Audio.setNodeVolume(application.modelData, value)
                        }
                    }
                }
            }
        }
    }
}