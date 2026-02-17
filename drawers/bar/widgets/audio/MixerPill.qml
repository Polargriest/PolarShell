import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.globals
import qs.services
import ".."

Pill {
    id: pill
    Layout.alignment: Qt.AlignRight

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
                            onClicked: Audio.toggleNodeMute(application.modelData)
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

                        Slider {
                            id: slider
                            Layout.fillWidth: true
                            Layout.preferredHeight: 20

                            value: application.modelData.audio?.volume
                            onMoved: Audio.setNodeVolume(application.modelData, value)
                            hoverEnabled: true

                            background: Item {
                                implicitHeight: 20
                                width: slider.availableWidth
                                height: implicitHeight

                                Item {
                                    id: filled
                                    clip: true
                                    implicitHeight: 20
                                    width: slider.handle.x + slider.handle.width / 2

                                    Rectangle {
                                        implicitHeight: 20
                                        width: slider.width
                                        radius: 100

                                        color: !Audio.getNodeMute(application.modelData) ? Theme.colors.green : Theme.colors.red
                                        Behavior on color { ColorAnimation { duration: Configs.bar.widgetsAnimations/3 } }
                                    }
                                }
                                
                                Rectangle {
                                    implicitHeight: 5
                                    width: parent.width - filled.width
                                    anchors.right: parent.right
                                    anchors.verticalCenter: parent.verticalCenter

                                    radius: 100
                                    color: Theme.colors.primaryText
                                }
                            }

                            handle: Rectangle {
                                x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
                                y: slider.topPadding + slider.availableHeight / 2 - height / 2
                                implicitHeight: 20
                                implicitWidth: 20
                                radius: 100

                                color: Theme.colors.primaryText
                                border.width: 3

                                border.color: !Audio.getNodeMute(application.modelData) ? Theme.colors.green : Theme.colors.red
                                Behavior on border.color { ColorAnimation { duration: Configs.bar.widgetsAnimations/3 } }
                            }

                            wheelEnabled: true
                        }
                    }
                }
            }
        }
    }
}