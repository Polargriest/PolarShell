import Quickshell
import QtQml
import Quickshell.Io
import QtQuick
import qs.globals

pragma Singleton

Singleton {
    id: root

    property string uptime
    readonly property string wm: Quickshell.env("XDG_CURRENT_DESKTOP") || Quickshell.env("XDG_SESSION_DESKTOP")

    property var kernel
    property var installedKernel
    property var latestKernel
    property var kernelStatus

    property var packageCount
    property var outdatedPackages
    property var packagePercentage: (100 * outdatedPackages / packageCount).toFixed(1)
    property var packageStatus: packagePercentage >= Configs.bar.fetch.outdatedPackagesCritical ? "critical" : (packagePercentage >= Configs.bar.fetch.outdatedPackagesWarning ? "warning" : "ok")

    property string cpuName
    property var cpuUsage: 0
    property var lastCpuTotal: 0
    property var lastCpuIdle: 0
    property var cpuStatus: cpuUsage >= Configs.bar.fetch.cpuUsageCritical ? "critical" : (cpuUsage >= Configs.bar.fetch.cpuUsageWarning ? "warning" : "ok")

    property string gpuName
    property var gpuUsage

    property var memoryTotal
    property string memoryTotalHuman: formatBytes(memoryTotal)
    property var memoryUsed
    property string memoryUsedHuman: formatBytes(memoryUsed)
    property var memoryPercentege
    property var memoryStatus: memoryPercentege >= Configs.bar.fetch.ramUsageCritical ? "critical" : (memoryPercentege >= Configs.bar.fetch.ramUsageWarning ? "warning" : "ok")

    property var diskUsed
    property string diskUsedHuman: formatBytes(diskUsed)
    property var diskTotal
    property string diskTotalHuman: formatBytes(diskTotal)
    property var diskPercentage
    property var diskStatus: diskPercentage >= Configs.bar.fetch.duCritical ? "critical" : (diskPercentage >= Configs.bar.fetch.duWarning ? "warning" : "ok")

    FileView { // ----------------------------------- OS RELEASE (ex. 6.18.9-arch1-2)
        path: "/proc/sys/kernel/osrelease"
        onLoaded: root.kernel = text().trim();
    }

    Process { // ------------------------------------ PACKAGE COUNT
        id: packageCountProc
        running: true
        command: ["sh", "-c", "echo $(( $(pacman -Q | wc -l) + $(flatpak list | wc -l) ))"]
        stdout: StdioCollector {
            onStreamFinished: root.packageCount = text.trim()
        }
    }

    Item {
        id: updateChecker

        property var pacmanOutdatedPackages
        property var flatpakOutdatedPackages

        readonly property int total: pacmanOutdatedPackages + flatpakOutdatedPackages

        Process {
            id: pacmanOutdatedPackagesProc
            running: true
            command: ["sh", "-c", "checkupdates"]
            stdout: StdioCollector { onStreamFinished: {
                let list = text.trim()

                if (list === "") {
                    updateChecker.pacmanOutdatedPackages = 0
                    root.latestKernel = root.installedKernel //if the list is empty, we assume latest kernel is installed one
                    return
                }

                // the number of lines is the number of outdated packages
                let lines = list.split("\n")
                updateChecker.pacmanOutdatedPackages = lines.length

                let kernelLine = lines.find(line => line.startsWith("linux "))
                root.latestKernel = kernelLine ? kernelLine.split(/\s+/)[3] : root.installedKernel

            } }
        }

        Process {
            id: flatpakOutdatedPackagesProc
            running: true
            command: ["sh", "-c", "flatpak remote-ls --updates | wc -l"]
            stdout: SplitParser { onRead: data => { updateChecker.flatpakOutdatedPackages = parseInt(data.trim() || 0); } }
        }

        Process {
            id: installedKernelProc
            running: true
            command: ["sh", "-c", "pacman -Q linux | awk '{print $2}'"]
            stdout: StdioCollector { onStreamFinished: {
                root.installedKernel = text.trim()
            } }
        }

        function refreshOutdatedPackages() {
            // first, change everything to undefined, to detect the "loading" state.
            pacmanOutdatedPackages = undefined
            flatpakOutdatedPackages = undefined
            root.latestKernel = undefined
            root.installedKernel = undefined
            root.kernelStatus = undefined

            // check for updates
            pacmanOutdatedPackagesProc.running = true
            flatpakOutdatedPackagesProc.running = true
            installedKernelProc.running = true
        }

        Binding {
            target: root
            property: "outdatedPackages"
            // only assign the value when both have stopped being undefined
            value: { (updateChecker.pacmanOutdatedPackages !== undefined && updateChecker.flatpakOutdatedPackages !== undefined) ? (updateChecker.pacmanOutdatedPackages + updateChecker.flatpakOutdatedPackages) : undefined }
        }

        Binding {
            target: root
            property: "kernelStatus"
            // only assign the value when both have stopped being undefined
            value: {
                //console.log("Kernel: " + root.kernel + " | Installed Kernel: " + root.installedKernel + " | Latest Kernel: " + root.latestKernel)

                // first, we check if every variable has ended assignment.
                if (root.kernel === undefined || root.installedKernel === undefined || root.latestKernel === undefined) {
                    return undefined // caclulating
                }

                let normRunning = root.kernel.replace(/[\.\-]/g, ".")
                let normInstalled = root.installedKernel.replace(/[\.\-]/g, ".")
                let normLatest = root.latestKernel.replace(/[\.\-]/g, ".")

                if (normLatest !== normInstalled) {
                    return 2 // kernel is outdated. Needs download
                }

                if (normInstalled !== normRunning) {
                    return 1 // kernel is downloaded, but system needs rebooting
                }

                return 0 // kernel is fine
            }
        }
    }

    Timer { // package count updater
        running: true
        repeat: true
        interval: 1800000
        onTriggered: {
            packageCountProc.running = true
            updateChecker.refreshOutdatedPackages()
        }
    }

    FileView { // ----------------------------------- FORMATTED UPTIME (from Caelestia)
        id: fileUptime
        path: "/proc/uptime"

        onLoaded: {
            const up = parseInt(text().split(" ")[0] ?? 0);

            const days = Math.floor(up / 86400);
            const hours = Math.floor((up % 86400) / 3600);
            const minutes = Math.floor((up % 3600) / 60);

            let str = "";
            if (days > 0)
                str += `${days} day${days === 1 ? "" : "s"}`;
            if (hours > 0)
                str += `${str ? ", " : ""}${hours} hour${hours === 1 ? "" : "s"}`;
            if (minutes > 0 || !str)
                str += `${str ? ", " : ""}${minutes} minute${minutes === 1 ? "" : "s"}`;
            root.uptime = str;
        }
    }

    Timer { // uptime updater
        running: true
        repeat: true
        interval: 60000
        onTriggered: fileUptime.reload()
    }

    FileView { // ----------------------------------- CPU
        path: "/proc/cpuinfo"
        onLoaded: {
            const lines = text().split("\n");
            const modelLine = lines.find(line => line.includes("model name"));
            if (modelLine) {
                // Extracts everything after the colon
                root.cpuName = modelLine.split(":")[1].trim();
            }
        }
    }

    Process {
        id: cpuUsageProc
        command: ["sh", "-c", "head -1 /proc/stat"]
        running: true
        stdout: SplitParser { onRead: data => {
            // EXPLANATION ON HOW TO GET CPU USAGE

            // We will run the command `sh -c "head -1 /proc/stat"`. That will get us the first line of the `/proc/stat`
            // file. But what is that file? Basically, it tells you how many USER_HZ (like 1/100ths of a second) has the
            // system spent in different states. This command returns us something like:

                // `cpu  478094 88 124520 15247912 17607 24843 9692 0 0 0`

            // This doesn't mean anything right of the bat. But if we execute it again, we get the difference between
            // times, and this is the meat! One of these numbers (the 4th one) is how many time has the CPU spent in
            // idle mode. If we calculate the relation between idel time and total time every x seconds, we can get
            // how busy is our CPU.

            let times = data.trim().split(/\s+/).slice(1).map(Number) // we split by whitespaces, remove "cpu" word and parse them
                                                               // to Number.
            let idleTime = times[3] // idle time
            let totalTime = times.reduce((a, b) => a + b, 0) // reduce iterates for every item in `times` and sums it.

            if (root.lastCpuTotal > 0) {
                // Formula: 100% * (1 - deltaIdleTime/deltaTotalTime)
                root.cpuUsage = Math.round(100 * (1 - (idleTime - root.lastCpuIdle)/(totalTime - root.lastCpuTotal)))
            }

            // update last CPU times
            root.lastCpuIdle = idleTime
            root.lastCpuTotal = totalTime
        } }
    }

    Component.onCompleted: {
        // run once immediately to get the first "snapshot"
        cpuUsageProc.running = true
        
        // run a second time after a tiny delay so the UI doesn't stay at 0% for the first 5 seconds.
        let startupTimer = Qt.createQmlObject('import QtQuick; Timer { interval: 200; onTriggered: cpuUsageProc.running = true }', root)
        startupTimer.running = true
    }

    Timer { // uptime updater
        running: true
        repeat: true
        interval: Configs.bar.fetch.usageUpdate
        onTriggered: {
            cpuUsageProc.running = true
            ramUsageProc.running = true
        }
    }

    Process { // ----------------------------------- GPU
        id: gpuNameProc
        // This looks for the VGA controller and cleans up the string
        command: ["sh", "-c", "lspci | grep -i vga | cut -d ':' -f3 | sed 's/ (rev .*//'"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.gpuName = gpuNameProc.cleanGpuName(text)
        }

        function cleanGpuName(raw): string {
            return raw
                .replace(/Advanced Micro Devices, Inc. /g, "")
                .replace(/\[AMD\/ATI\]/g, "AMD ATI")
                .replace(/[\[\]]/g, "") // Remove remaining brackets
                .replace(/\(rev.*\)/g, "") // Remove revision
                .trim();
        }
    }

    Process { // ----------------------------------- RAM
        id: ramUsageProc
        // This looks for the VGA controller and cleans up the string
        command: ["sh", "-c", "free | grep Mem"]
        running: true
        stdout: SplitParser { onRead: data => {
            const parts = data.trim().split(/\s+/).slice(1).map(Number)
            
            root.memoryTotal = parts[0]
            root.memoryUsed = parts[1]

            root.memoryPercentege = Math.round(100 * root.memoryUsed/root.memoryTotal)
        } }
    }

    function formatBytes(kb) {
        if (kb <= 0) return "0 B";
        
        // free nos da KB, así que multiplicamos por 1024 para tener bytes base
        let bytes = kb * 1024;
        const sizes = ['B', 'KB', 'MB', 'GB', 'TB'];
        const i = Math.floor(Math.log(bytes) / Math.log(1024));
        
        // Para RAM usualmente queremos 1 o 2 decimales (ej: 8.42 GB)
        return parseFloat((bytes / Math.pow(1024, i)).toFixed(2)) + " " + sizes[i];
    }

    Process { // ----------------------------------- DISK USAGE
        id: diskUsageProc
        // This looks for the VGA controller and cleans up the string
        command: ["sh", "-c", "df -k --output=size,used ~ | tail -1"]
        running: true
        stdout: SplitParser { onRead: data => {
            const parts = data.trim().split(/\s+/);
            // df devuelve bloques de 1K por defecto
            root.diskTotal = parseInt(parts[0]); 
            root.diskUsed = parseInt(parts[1]);

            root.diskPercentage = Math.round(100 * root.diskUsed / root.diskTotal);
        } }
    }
}