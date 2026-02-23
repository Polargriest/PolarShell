import QtQuick
import QtQuick.Layouts
import qs.globals
import qs.services
import ".."

Pill {
    id: pill

    contentComponent: ColumnLayout {
        Text {
            text: "Output"
            color: Theme.colors.yellow
            font.bold: true
            font.pixelSize: 24
            font.family: "JetBrains Mono NFP"
        }

        Rectangle {
            Layout.preferredHeight: 1
            Layout.fillWidth: true
            color: Theme.colors.yellow
        } // spacing

        ColumnLayout {
            Layout.topMargin: 5
            Layout.bottomMargin: 5
            spacing: 10 // Espaciado entre cada aplicación

            Repeater {
                model: Audio.sinks

                delegate: Rectangle {
                    id: outputOption
                    required property var modelData

                    Layout.fillWidth: true
                    Layout.preferredHeight: 30
                    color: modelData === Audio.sink ? Theme.colors.yellow : (deviceHitbox.containsMouse ? Theme.colorWithAlpha(Theme.colors.primaryText, 0.1) : "transparent")
                    radius: 6
                    clip: true

                    Text {
                        anchors.fill: parent

                        color: outputOption.modelData === Audio.sink ? Theme.colors.bg : Theme.colors.primaryText
                        font.pixelSize: 18
                        font.family: "JetBrains Mono NFP"

                        verticalAlignment: Text.AlignVCenter
                        padding: 10

                        text: outputOption.modelData.description
                    }

                    MouseArea {
                        id: deviceHitbox
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: {
                            console.log("Output name: " + outputOption.modelData.description)
                            Audio.setDefaultSink(outputOption.modelData)
                        }
                    }
                }
            }
        }
    }
}