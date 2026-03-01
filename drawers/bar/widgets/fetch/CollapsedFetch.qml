import QtQuick
import qs.globals
import qs.services

Text {
    visible: opacity > 0

    text: {
        let txt = ""
        
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