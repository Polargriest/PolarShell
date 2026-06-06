import QtQuick
import QtQuick.Layouts
import ".."
import qs.globals
import qs.services
import qs.components

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
            id: components
            Layout.topMargin: 10
            Layout.bottomMargin: 10
            spacing: 10

            property color cpuColor: SysInfo.cpuStatus === "critical" ? Theme.colors.red : (SysInfo.cpuStatus === "warning" ? Theme.colors.yellow : Theme.colors.green)
            Behavior on cpuColor { ColorAnimation { duration: 500 } }

            Text {
                text: "<b><font color='" + components.cpuColor + "'> CPU:</font></b> " + SysInfo.cpuName
                color: Theme.colors.primaryText
                font.pixelSize: 18
                font.family: "JetBrains Mono NFP"
                clip: true
            }

            RowLayout {
                spacing: 15

                StatBar {
                    value: SysInfo.cpuUsage / 100
                    bgColor: components.cpuColor
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

            property color memoryColor: SysInfo.memoryPercentege >= Configs.bar.fetch.ramUsageCritical ? Theme.colors.red : (SysInfo.memoryPercentege >= Configs.bar.fetch.ramUsageWarning ? Theme.colors.yellow : Theme.colors.green)
            Behavior on memoryColor { ColorAnimation { duration: 500 } }

            Text {
                text: "<b><font color='" + components.memoryColor + "'> RAM:</font></b> " + SysInfo.memoryUsedHuman + " / " + SysInfo.memoryTotalHuman
                color: Theme.colors.primaryText
                font.pixelSize: 18
                font.family: "JetBrains Mono NFP"

                Layout.fillWidth: true
                clip: true
            }

            RowLayout {
                spacing: 15

                StatBar {
                    value: SysInfo.memoryPercentege / 100
                    bgColor: components.memoryColor
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

            property color diskColor: SysInfo.diskPercentage >= Configs.bar.fetch.duCritical ? Theme.colors.red : (SysInfo.diskPercentage >= Configs.bar.fetch.duWarning ? Theme.colors.yellow : Theme.colors.green)
            Behavior on diskColor { ColorAnimation { duration: 500 } }

            Text {
                text: "<b><font color='" + components.diskColor + "'>󰋊 Disk space:</font></b> " + SysInfo.diskUsedHuman + " / " + SysInfo.diskTotalHuman
                color: Theme.colors.primaryText
                font.pixelSize: 18
                font.family: "JetBrains Mono NFP"

                Layout.fillWidth: true
                clip: true
            }

            RowLayout {
                spacing: 15

                StatBar {
                    value: SysInfo.diskPercentage / 100
                    bgColor: components.diskColor
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

            property color packagesColor: SysInfo.packagePercentage >= Configs.bar.fetch.outdatedPackagesCritical ? Theme.colors.red : (SysInfo.packagePercentage >= Configs.bar.fetch.outdatedPackagesWarning ? Theme.colors.yellow : Theme.colors.green)
            Behavior on packagesColor { ColorAnimation { duration: 500 } }

            Text {
                text: {
                    let icon = "<b><font color='" + components.packagesColor + "'> </font></b>"

                    if (SysInfo.outdatedPackages === undefined) {
                        return icon + "Calculating outdated packages..."
                    } else {
                        return icon + "You have <b><font color='" + components.packagesColor + "'>" + SysInfo.outdatedPackages + "</font></b> outdated package" + (SysInfo.outdatedPackages === 1 ? "" : "s") + " (" + SysInfo.packagePercentage + "%)"
                    }
                }
                color: Theme.colors.primaryText
                font.pixelSize: 18
                font.family: "JetBrains Mono NFP"

                Layout.fillWidth: true
                clip: true
            }

            Loader {
                active: UPower.onBattery
                sourceComponent: batteryText 
            }

            Component {
                id: batteryText

                Text {
                    property color batteryColor: (UPower.isCharging || UPower.batteryPercentage*100 > Configs.bar.fetch.lowBattery) ? Theme.colors.green : Theme.colors.red
                    Behavior on batteryColor { ColorAnimation { duration: 500 } }

                    text: {
                        let formattedRemaining = UPower.formatCountdown()

                        let txt = "<b><font color='" + batteryColor + "'> </font></b>"
                        txt += UPower.isCharging ? "Charging at " : "Discharging at "
                        txt += "<b><font color='" + batteryColor + "'>" + UPower.batteryPercentage*100 + "%</font></b> "

                        if (!formattedRemaining) {
                            return txt + "(Calculating...)"
                        }

                        return txt + "(" + formattedRemaining + (UPower.isCharging ? " to full)" : " remains)")
                    }
                    color: Theme.colors.primaryText
                    font.pixelSize: 18
                    font.family: "JetBrains Mono NFP"

                    Layout.fillWidth: true
                    clip: true
                }
            }
        }
    }
}