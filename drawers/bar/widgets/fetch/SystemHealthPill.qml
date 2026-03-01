import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import ".."
import qs.globals
import qs.services

Pill {
    contentComponent: ColumnLayout {
        Text {
            text: "System Health"
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
            Layout.topMargin: 10
            Layout.bottomMargin: 10
            spacing: 10

            Text {
                text: "<b><font color='" + Theme.colors.green + "'> CPU:</font></b> " + SysInfo.cpuName
                color: Theme.colors.primaryText
                font.pixelSize: 18
                font.family: "JetBrains Mono NFP"
                clip: true
            }

            RowLayout {
                spacing: 15

                Slider {
                    id: slider
                    enabled: false

                    Layout.fillWidth: true
                    Layout.preferredHeight: 35

                    value: SysInfo.cpuUsage / 100

                    background: Rectangle {
                        implicitHeight: 35
                        width: slider.availableWidth
                        radius: 7

                        color: Theme.colorWithAlpha(Theme.colors.bgDark, "0.5")

                        Rectangle {
                            // This creates a 6px gap on all sides
                            anchors {
                                left: parent.left
                                top: parent.top
                                bottom: parent.bottom
                                margins: 4 // This is your padding
                            }

                            width: (parent.width - (anchors.margins * 2)) * slider.visualPosition
                            radius: 4

                            anchors.right: undefined

                            color: Theme.colors.green

                            Behavior on width {
                                NumberAnimation {
                                    duration: 500
                                    easing.type: Easing.OutQuad
                                }
                            }
                        }
                    }

                    handle: Item {}
                }

                Text {
                    text: SysInfo.cpuUsage + "%"
                    color: Theme.colors.primaryText
                    Layout.preferredWidth: 55
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 21
                    font.family: "JetBrains Mono NFP"
                    clip: true
                }
            }

            Text {
                text: "<b><font color='" + Theme.colors.green + "'> RAM:</font></b> " + SysInfo.memoryUsedHuman + " / " + SysInfo.memoryTotalHuman
                color: Theme.colors.primaryText
                font.pixelSize: 18
                font.family: "JetBrains Mono NFP"

                Layout.fillWidth: true
                clip: true
            }

            RowLayout {
                spacing: 15

                Slider {
                    id: ramSlider
                    enabled: false

                    Layout.fillWidth: true
                    Layout.preferredHeight: 35

                    value: SysInfo.memoryPercentege / 100

                    background: Rectangle {
                        implicitHeight: 35
                        width: ramSlider.availableWidth
                        radius: 7

                        color: Theme.colorWithAlpha(Theme.colors.bgDark, "0.5")

                        Rectangle {
                            // This creates a 6px gap on all sides
                            anchors {
                                left: parent.left
                                top: parent.top
                                bottom: parent.bottom
                                margins: 4 // This is your padding
                            }

                            width: (parent.width - (anchors.margins * 2)) * ramSlider.visualPosition
                            radius: 4

                            anchors.right: undefined

                            color: Theme.colors.green

                            Behavior on width {
                                NumberAnimation {
                                    duration: 500
                                    easing.type: Easing.OutQuad
                                }
                            }
                        }
                    }

                    handle: Item {}
                }

                Text {
                    text: SysInfo.memoryPercentege + "%"
                    color: Theme.colors.primaryText
                    Layout.preferredWidth: 55
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 21
                    font.family: "JetBrains Mono NFP"
                    clip: true
                }
            }

            Text {
                text: "<b><font color='" + Theme.colors.green + "'>󰋊 Disk space:</font></b> " + SysInfo.diskUsedHuman + " / " + SysInfo.diskTotalHuman
                color: Theme.colors.primaryText
                font.pixelSize: 18
                font.family: "JetBrains Mono NFP"

                Layout.fillWidth: true
                clip: true
            }

            RowLayout {
                spacing: 15

                Slider {
                    id: diskSlider
                    enabled: false

                    Layout.fillWidth: true
                    Layout.preferredHeight: 35

                    value: SysInfo.diskPercentage / 100

                    background: Rectangle {
                        implicitHeight: 35
                        width: diskSlider.availableWidth
                        radius: 7

                        color: Theme.colorWithAlpha(Theme.colors.bgDark, "0.5")

                        Rectangle {
                            // This creates a 6px gap on all sides
                            anchors {
                                left: parent.left
                                top: parent.top
                                bottom: parent.bottom
                                margins: 4 // This is your padding
                            }

                            width: (parent.width - (anchors.margins * 2)) * diskSlider.visualPosition
                            radius: 4

                            anchors.right: undefined

                            color: Theme.colors.green

                            Behavior on width {
                                NumberAnimation {
                                    duration: 500
                                    easing.type: Easing.OutQuad
                                }
                            }
                        }
                    }

                    handle: Item {}
                }

                Text {
                    text: SysInfo.diskPercentage + "%"
                    color: Theme.colors.primaryText
                    Layout.preferredWidth: 55
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 21
                    font.family: "JetBrains Mono NFP"
                    clip: true
                }
            }
        }

        Text {
            text: {
                let color = Theme.colors.green
                let message = "We don't recognize your kernel"

                // if its still calculating, let the user know
                if (SysInfo.kernelStatus === undefined) {
                    message = "Checking for kernel updates..."
                }

                else if (SysInfo.kernelStatus === 2) {
                    color = Theme.colors.red
                    message = "Your kernel <b><font color='" + color + "'>is outdated</font></b> (" + SysInfo.latestKernel + ")"
                }

                else if (SysInfo.kernelStatus === 1) {
                    color = Theme.colors.yellow
                    message = "Your kernel <b><font color='" + color + "'>has pending updates</font></b> (reboot)"
                }

                else if (SysInfo.kernelStatus === 0) {
                    message = "Your kernel <b><font color='" + color + "'>is up to date</font></b>"
                }

                let icon = "<b><font color='" + color + "'>󰣇</font></b> "
                return icon + message
            }
            color: Theme.colors.primaryText
            font.pixelSize: 18
            font.family: "JetBrains Mono NFP"

            Layout.fillWidth: true
            clip: true
        }

        Text {
            text: {
                let icon = "<b><font color='" + Theme.colors.green + "'> </font></b>"

                if (SysInfo.outdatedPackages === undefined) {
                    return icon + "Calculating outdated packages..."
                } else {
                    return icon + "You have <b><font color='" + Theme.colors.green + "'>" + SysInfo.outdatedPackages + "</font></b> outdated packages (" + SysInfo.packagePercentage + "%)"
                }
            }
            color: Theme.colors.primaryText
            font.pixelSize: 18
            font.family: "JetBrains Mono NFP"

            Layout.fillWidth: true
            clip: true
        }
    }
}