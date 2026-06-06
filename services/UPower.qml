import Quickshell.Services.UPower
import Quickshell

pragma Singleton

Singleton {
    readonly property bool onBattery: UPower.displayDevice.isPresent
    readonly property double batteryPercentage: UPower.displayDevice.percentage
    readonly property var isCharging: UPower.displayDevice.state == UPowerDeviceState.Charging
    readonly property real timeRemaining: isCharging ? UPower.displayDevice.timeToFull : UPower.displayDevice.timeToEmpty

    function formatCountdown() {
    const d = Math.floor(timeRemaining / 86400);
    const h = Math.floor((timeRemaining % 86400) / 3600);
    const m = Math.floor((timeRemaining % 3600) / 60);
    const s = timeRemaining % 60;

    return [
        d && `${d}d`,
        h && `${h}h`,
        m && `${m}m`,
        s && `${s}s`,
    ]
        .filter(Boolean)
        .join(" ");
    }
}