import QtQuick
import qs.globals
import qs.services

Item {
    id: root
    height: text.height + 10
    width: UPower.onBattery ? Math.max(Configs.bar.fetch.fetchMinWidth, text.width + 24) : text.width + 24

    Loader {
        active: UPower.onBattery && Configs.bar.fetch.showProgressBar
        sourceComponent: Rectangle {
            height: root.height
            width: root.width * UPower.batteryPercentage
            color: Theme.colorWithAlpha("#000000", 0)
            clip: true

            Rectangle {
                height: root.height
                width: root.width
                radius: 100
                color: {
                    if (UPower.isCharging) { return Theme.colorWithAlpha(Theme.colors.green, 0.2) }

                    if (UPower.batteryPercentage*100 <= Configs.bar.fetch.lowBattery) {
                        return Theme.colorWithAlpha(Theme.colors.red, 0.2)
                    } else {
                        return Theme.colorWithAlpha(Theme.colors.secondaryText, 0.2)
                    }
                }

                border.width: 2
                border.color: Theme.colors.bg

                Behavior on color { ColorAnimation { duration: Configs.bar.widgetsAnimations/5 } }
            }
        }
    }

    Text {
        id: text
        visible: opacity > 0

        text: {
            let txt = ""
            
            if (UPower.onBattery && Configs.bar.fetch.showPercentage) {
                return Math.round(UPower.batteryPercentage*100) + (Configs.bar.fetch.showSymbol ? "%" : "")
            }
            
            // CPU Usage
            if (SysInfo.cpuStatus === "warning") {
                txt += "<b><font color='" + Theme.colors.yellow + "'></font></b> "
            } else if (SysInfo.cpuStatus === "critical") {
                txt += "<b><font color='" + Theme.colors.red + "'></font></b> "
            }

            // RAM Usage
            if (SysInfo.memoryStatus === "warning") {
                txt += "<b><font color='" + Theme.colors.yellow + "'></font></b> "
            } else if (SysInfo.memoryStatus === "critical") {
                txt += "<b><font color='" + Theme.colors.red + "'></font></b> "
            }

            // Disk Usage
            if (SysInfo.diskStatus === "warning") {
                txt += "<b><font color='" + Theme.colors.yellow + "'>󰋊</font></b> "
            } else if (SysInfo.diskStatus === "critical") {
                txt += "<b><font color='" + Theme.colors.red + "'>󰋊</font></b> "
            }

            // Kernel Update Availability
            if (SysInfo.kernelStatus === 2) {
                txt += "<b><font color='" + Theme.colors.red + "'>󰣇</font></b> "
            } else if (SysInfo.kernelStatus === 1) {
                txt += "<b><font color='" + Theme.colors.yellow + "'>󰣇</font></b> "
            }

            // Outdated Packages
            if (SysInfo.packageStatus === "warning") {
                txt += "<b><font color='" + Theme.colors.yellow + "'></font></b> "
            } else if (SysInfo.packageStatus === "critical") {
                txt += "<b><font color='" + Theme.colors.red + "'></font></b> "
            }

            if (txt === "") { // all good
                return "<b><font color='" + Theme.colors.green + "'>󰣇</font></b>"
            } else {
                return txt.trim()
            }
        }
        
        // styling
        color: Theme.colors.green
        font.bold: true
        font.pixelSize: 18
        font.family: "JetBrains Mono NFP"

        // layout and margins
        anchors.centerIn: parent
    }
}