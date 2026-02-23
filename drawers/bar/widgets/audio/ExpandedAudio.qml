import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.globals
import qs.services

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

            Slider {
                id: slider
                Layout.fillWidth: true
                Layout.preferredHeight: 30

                value: Audio.volume
                onMoved: Audio.setVolume(value)
                hoverEnabled: true

                background: Item {
                    implicitHeight: 30
                    width: slider.availableWidth
                    height: implicitHeight

                    Item {
                        id: filled
                        clip: true
                        implicitHeight: 30
                        width: slider.handle.x + slider.handle.width / 2

                        Rectangle {
                            implicitHeight: 30
                            width: slider.width
                            radius: 100

                            color: !Audio.muted ? Theme.colors.purple : Theme.colors.red
                            Behavior on color { ColorAnimation { duration: Configs.bar.widgetsAnimations/3 } }
                        }
                    }
                    
                    Rectangle {
                        implicitHeight: 10
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
                    implicitHeight: 30
                    implicitWidth: 30
                    radius: 100

                    color: Theme.colors.primaryText
                    border.width: 5

                    border.color: !Audio.muted ? Theme.colors.purple : Theme.colors.red
                    Behavior on border.color { ColorAnimation { duration: Configs.bar.widgetsAnimations/3 } }
                }

                wheelEnabled: true
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

            Slider {
                id: sliderMic
                Layout.fillWidth: true
                Layout.preferredHeight: 30

                value: Audio.micVolume
                onMoved: Audio.setSourceVolume(value)
                hoverEnabled: true

                background: Item {
                    implicitHeight: 30
                    width: slider.availableWidth
                    height: implicitHeight

                    Item {
                        id: filledMic
                        clip: true
                        implicitHeight: 30
                        width: sliderMic.handle.x + sliderMic.handle.width / 2

                        Rectangle {
                            implicitHeight: 30
                            width: slider.width
                            radius: 100

                            color: !Audio.micMuted ? Theme.colors.purple : Theme.colors.red
                            Behavior on color { ColorAnimation { duration: Configs.bar.widgetsAnimations/3 } }
                        }
                    }
                    
                    Rectangle {
                        implicitHeight: 10
                        width: parent.width - filledMic.width
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter

                        radius: 100
                        color: Theme.colors.primaryText
                    }
                }

                handle: Rectangle {
                    x: sliderMic.leftPadding + sliderMic.visualPosition * (sliderMic.availableWidth - width)
                    y: sliderMic.topPadding + sliderMic.availableHeight / 2 - height / 2
                    implicitHeight: 30
                    implicitWidth: 30
                    radius: 100

                    color: Theme.colors.primaryText
                    border.width: 5

                    border.color: !Audio.micMuted ? Theme.colors.purple : Theme.colors.red
                    Behavior on border.color { ColorAnimation { duration: Configs.bar.widgetsAnimations/3 } }
                }

                wheelEnabled: true
            }
        }
    }
}