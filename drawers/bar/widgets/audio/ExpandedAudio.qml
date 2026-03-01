import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.globals
import qs.services
import qs.components

Item {
    property var slideHovered: slider.hovered
    property var muteHovered: muteHitbox.containsMouse
    property var slideMicHovered: sliderMic.hovered
    property var muteMicHovered: muteMicHitbox.containsMouse

    implicitWidth: 425
    implicitHeight: layout.implicitHeight + 40

    ColumnLayout {
        id: layout
        spacing: 15

        anchors.fill: parent
        anchors.topMargin: 20
        anchors.leftMargin: 18
        anchors.rightMargin: 18
        anchors.bottomMargin: 20

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Text {
                text: "Master"

                color: !Audio.muted ? Theme.colors.purple : Theme.colors.red
                Behavior on color { ColorAnimation { duration: Configs.bar.widgetsAnimations/3 } }

                font.bold: true
                font.pixelSize: 24
                font.family: "JetBrains Mono NFP"
            }

            Text {
                text: !Audio.muted ? "is on " + (Audio.volume * 100).toFixed(0) + "%" : "is muted"

                color: Theme.colors.primaryText
                font.bold: true
                font.pixelSize: 24
                font.family: "JetBrains Mono NFP"
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 15

            Rectangle {
                radius: 100
                Layout.preferredWidth: 38
                Layout.preferredHeight: 38

                color: muteHitbox.containsMouse ? Theme.colorWithAlpha(Theme.colors.primaryText, "0.1") : "#00000000"

                Text {
                    id: muteIcon
                    visible: opacity > 0

                    text: Audio.muted ? "" : ""
                    
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    //styling
                    color: Theme.colors.primaryText
                    font.bold: true
                    font.pixelSize: 24
                    font.family: "JetBrains Mono NFP"
                }

                MouseArea {
                    id: muteHitbox
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: Audio.toggleSinkMute()
                }
            }

            CustomSlider {
                id: slider
                bgColor: !Audio.muted ? Theme.colors.purple : Theme.colors.red

                value: Audio.volume
                onMoved: Audio.setVolume(value)
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Text {
                text: "Microphone"

                color: !Audio.micMuted ? Theme.colors.purple : Theme.colors.red
                Behavior on color { ColorAnimation { duration: Configs.bar.widgetsAnimations/3 } }

                font.bold: true
                font.pixelSize: 24
                font.family: "JetBrains Mono NFP"
            }

            Text {
                text: !Audio.micMuted ? "is on " + (Audio.micVolume * 100).toFixed(0) + "%" : "is muted"

                color: Theme.colors.primaryText
                font.bold: true
                font.pixelSize: 24
                font.family: "JetBrains Mono NFP"
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 15

            Rectangle {
                radius: 100
                Layout.preferredWidth: 38
                Layout.preferredHeight: 38

                color: muteMicHitbox.containsMouse ? Theme.colorWithAlpha(Theme.colors.primaryText, "0.1") : "#00000000"

                Text {
                    id: muteMicIcon
                    visible: opacity > 0

                    text: !Audio.micMuted ? "󰍬" : "󰍭"
                    
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    //styling
                    color: Theme.colors.primaryText
                    font.bold: true
                    font.pixelSize: 28
                    font.family: "JetBrains Mono NFP"
                }

                MouseArea {
                    id: muteMicHitbox
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: Audio.toggleSourceMute()
                }
            }

            CustomSlider {
                id: sliderMic
                bgColor: !Audio.micMuted ? Theme.colors.purple : Theme.colors.red

                value: Audio.micVolume
                onMoved: Audio.setSourceVolume(value)
            }
        }
    }
}